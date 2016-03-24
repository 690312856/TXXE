//
//  myCollectionAskModel.m
//  TXXE
//
//  Created by 李雨龙 on 15/7/24.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "myCollectionAskModel.h"
#import "NetController.h"
#import "UserModel.h"

static const NSInteger kMyCollectionAskRequestPageSize = 20;

@interface myCollectionAskModel ()

/**
 *  分页总数，由服务器返回
 */
@property (nonatomic , assign) NSInteger totalPageCount;
/**
 *  每次分页获取的当前页码
 */
@property (nonatomic , assign) NSInteger currentPageCount;
/**
 *  每次block返回来的值都在这里
 */
@property (nonatomic , strong) NSArray *cachedAskList;

@end
@implementation myCollectionAskModel

- (void)setValuesForKeysWithDictionary:(NSDictionary *)keyedValues
{
    self.askId = [keyedValues[@"id"] stringValue];
    NSLog(@"%@",self.askId);
    self.askTitle = keyedValues[@"title"];
    self.askDescription = keyedValues[@"description"];
    self.askPrice = keyedValues[@"price"];
    self.memberId = [keyedValues[@"sellerInfo"][@"memberId"] stringValue];
    NSMutableArray *images = [NSMutableArray array];
    for (NSString *urlText in keyedValues[@"images"]) {
        [images addObject:urlText];
    }
    self.imageUrlTexts = images;
}
- (void)refreshCollectionAskListWithCompletionHandler:(void(^)(NSError *error,NSArray *askList))completionHandler
{
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setValue:@(self.currentPageCount = 1) forKey:@"page"];
    [postDict setValue:@(kMyCollectionAskRequestPageSize) forKey:@"pageSize"];
    [postDict setValue:[UserModel currentUser].memberId forKey:@"memberId"];
    [postDict setValue:@(2) forKey:@"favoriteType"];
    __weak __typeof(self)weakSelf = self;
    /////api
    [[NetController sharedInstance]postWithAPI:API_user_my_favorites parameters:postDict completionHandler:^(id responseObject, NSError *error) {
        if (error) {
            completionHandler(error,nil);
        }else{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (responseObject[@"pagination"] && ![responseObject[@"pagination"] isKindOfClass:[NSNull class]]) {
                strongSelf.totalPageCount = [responseObject[@"pagination"][@"pageTotal"] integerValue];
            }
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dict in responseObject[@"data"]) {
                myCollectionAskModel *tempModel = [[myCollectionAskModel alloc] init];
                [tempModel setValuesForKeysWithDictionary:dict];
                [array addObject:tempModel];
            }
            @autoreleasepool {
                strongSelf.cachedAskList = array;
            }
            completionHandler(nil,strongSelf.cachedAskList);
        }
    }];
}
- (void)loadMoreCollectionAskListWithCompletionHandler:(void(^)(NSError *error,NSArray *askList))completionHandler
{
    if (++self.currentPageCount > self.totalPageCount) {
        //木有更多分页了，不用加载
        NSError *error = [NSError errorWithDomain:@"kNoMoreDataAppliedDomain" code:-10 userInfo:@{NSLocalizedDescriptionKey:@"没有更多的分页数据"}];
        completionHandler(error,nil);
        return;
    }
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setValue:@(self.currentPageCount) forKey:@"page"];
    [postDict setValue:@(kMyCollectionAskRequestPageSize) forKey:@"pageSize"];
    [postDict setValue:[UserModel currentUser].memberId forKey:@"memberId"];
    [postDict setValue:@(2) forKey:@"favoriteType"];
    __weak __typeof(self)weakSelf = self;
    /////////api
    [[NetController sharedInstance] postWithAPI:API_user_my_favorites parameters:postDict completionHandler:^(id responseObject, NSError *error) {
        if (error) {
            completionHandler(error,nil);
        } else {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (responseObject[@"pagination"] && ![responseObject[@"pagination"] isKindOfClass:[NSNull class]]) {
                strongSelf.totalPageCount = [responseObject[@"pagination"][@"pageTotal"] integerValue];
            }
            NSMutableArray *array = [NSMutableArray arrayWithArray:strongSelf.cachedAskList];
            for (NSDictionary *dict in responseObject[@"data"]) {
                myCollectionAskModel *tempModel = [[myCollectionAskModel alloc] init];
                [tempModel setValuesForKeysWithDictionary:dict];
                [array addObject:tempModel];
            }
            @autoreleasepool {
                strongSelf.cachedAskList = array;
            }
            completionHandler(nil,strongSelf.cachedAskList);
        }
    }];
}

- (void)cancelCollectionWithCompletionHandler:(void(^)(NSError *error))completionHandler
{
    [[NetController sharedInstance]postWithAPI:API_favorite_remove parameters:@{@"memberId":[UserModel currentUser].memberId,@"assocId":self.askId,@"favoriteType":@"2"} completionHandler:^(id responseObject, NSError *error) {
        completionHandler(error);
    }];
}
@end
