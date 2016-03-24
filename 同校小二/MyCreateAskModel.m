//
//  MyCreateAskModel.m
//  TXXE
//
//  Created by 李雨龙 on 15/7/26.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "MyCreateAskModel.h"
#import "NetController.h"
#import "UserModel.h"

static const NSInteger kCreateAskListDataRequestPageSize = 20;

@interface MyCreateAskModel ()

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

@property (nonatomic , copy) NSString *currentFetcherStatus;

@end
@implementation MyCreateAskModel

- (void)setValuesForKeysWithDictionary:(NSDictionary *)keyedValues
{
    self.askId = [keyedValues[@"id"] stringValue];
    self.askTitle = keyedValues[@"title"];
    self.askDescription = keyedValues[@"description"];
    self.askPrice = keyedValues[@"price"];
    self.status = [keyedValues[@"status"] stringValue];
    self.mobile = [keyedValues[@"mobileNumber"] stringValue];
    self.qq = [keyedValues[@"qq"]stringValue];
    NSMutableArray *images = [NSMutableArray array];
    for (NSString *urlText in keyedValues[@"images"]) {
        [images addObject:urlText];
    }
    self.imageUrlTexts = images;
}

- (void)refreshCreatedAskListForPurchasingListWithCompletionHandler:(void (^)(NSError *, NSArray *))completionHandler
{
    [self refreshCreatedAskListForStatus:@"1" completionHandler:completionHandler];
}

- (void)refreshCreatedAskListForSuspendedListWithCompletionHandler:(void (^)(NSError *, NSArray *))completionHandler
{
    [self refreshCreatedAskListForStatus:@"3" completionHandler:completionHandler];
}

- (void)refreshCreatedAskListForBoughtListWithCompletionHandler:(void (^)(NSError *, NSArray *))completionHandler
{
    [self refreshCreatedAskListForStatus:@"2" completionHandler:completionHandler];
}

- (void)refreshCreatedAskListForStatus:(NSString *)status completionHandler:(void (^)(NSError *, NSArray *))completionHandler
{
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setValue:@(self.currentPageCount = 1) forKey:@"page"];
    [postDict setValue:@(kCreateAskListDataRequestPageSize) forKey:@"pageSize"];
    [postDict setValue:[UserModel currentUser].memberId forKey:@"memberId"];
    [postDict setValue:(self.currentFetcherStatus = status) forKey:@"status"];
    __weak __typeof(self)weakSelf = self;
    /////api
    [[NetController sharedInstance]postWithAPI:API_ask_my_ask parameters:postDict completionHandler:^(id responseObject, NSError *error) {
        if (error) {
            completionHandler(error,nil);
        }else{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (responseObject[@"pagination"] && ![responseObject[@"pagination"] isKindOfClass:[NSNull class]]) {
                strongSelf.totalPageCount = [responseObject[@"pagination"][@"pageTotal"] integerValue];
            }
            NSMutableArray *array = [NSMutableArray array];
           // if(responseObject["data"])
            for (NSDictionary *dict in responseObject[@"data"]) {
                MyCreateAskModel *tempModel = [[MyCreateAskModel alloc] init];
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

- (void)loadMoreCreatedAskListWithCompletionHandler:(void (^)(NSError *, NSArray *))completionHandler
{
    if (++self.currentPageCount > self.totalPageCount) {
        //木有更多分页了，不用加载
        NSError *error = [NSError errorWithDomain:@"kNoMoreDataAppliedDomain" code:-10 userInfo:@{NSLocalizedDescriptionKey:@"没有更多的分页数据"}];
        completionHandler(error,nil);
        return;
    }
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setValue:@(self.currentPageCount) forKey:@"page"];
    [postDict setValue:@(kCreateAskListDataRequestPageSize) forKey:@"pageSize"];
    [postDict setValue:[UserModel currentUser].memberId forKey:@"memberId"];
    [postDict setValue:self.status forKey:@"status"];
    
    __weak __typeof(self)weakSelf = self;
    /////////api
    [[NetController sharedInstance] postWithAPI:API_ask_my_ask parameters:postDict completionHandler:^(id responseObject, NSError *error) {
        if (error) {
            completionHandler(error,nil);
        } else {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (responseObject[@"pagination"] && ![responseObject[@"pagination"] isKindOfClass:[NSNull class]]) {
                strongSelf.totalPageCount = [responseObject[@"pagination"][@"pageTotal"] integerValue];
            }
            NSMutableArray *array = [NSMutableArray arrayWithArray:strongSelf.cachedAskList];
            for (NSDictionary *dict in responseObject[@"data"]) {
                MyCreateAskModel *tempModel = [[MyCreateAskModel alloc] init];
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
- (void)refreshAskListWithCompletionHandler:(void(^)(NSError *error,NSArray *goodList))completionHandler
{
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setValue:@(self.currentPageCount = 1) forKey:@"page"];
    [postDict setValue:@(kCreateAskListDataRequestPageSize) forKey:@"pageSize"];
    [postDict setValue:self.memberId forKey:@"memberId"];
    [postDict setValue:@(1) forKey:@"status"];
    __weak __typeof(self)weakSelf = self;
    /////api
    [[NetController sharedInstance]postWithAPI:API_ask_my_ask parameters:postDict completionHandler:^(id responseObject, NSError *error) {
        if (error) {
            completionHandler(error,nil);
        }else{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (responseObject[@"pagination"] && ![responseObject[@"pagination"] isKindOfClass:[NSNull class]]) {
                strongSelf.totalPageCount = [responseObject[@"pagination"][@"pageTotal"] integerValue];
            }
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dict in responseObject[@"data"]) {
                MyCreateAskModel *tempModel = [[MyCreateAskModel alloc] init];
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
- (void)loadMoreAskListWithCompletionHandler:(void(^)(NSError *error,NSArray *askList))completionHandler
{
    if (++self.currentPageCount > self.totalPageCount) {
        //木有更多分页了，不用加载
        NSError *error = [NSError errorWithDomain:@"kNoMoreDataAppliedDomain" code:-10 userInfo:@{NSLocalizedDescriptionKey:@"没有更多的分页数据"}];
        completionHandler(error,nil);
        return;
    }
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setValue:@(self.currentPageCount) forKey:@"page"];
    [postDict setValue:@(kCreateAskListDataRequestPageSize) forKey:@"pageSize"];
    [postDict setValue:self.memberId forKey:@"memberId"];
    [postDict setValue:self.status forKey:@"status"];
    
    __weak __typeof(self)weakSelf = self;
    /////////api
    [[NetController sharedInstance] postWithAPI:API_ask_my_ask parameters:postDict completionHandler:^(id responseObject, NSError *error) {
        if (error) {
            completionHandler(error,nil);
        } else {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (responseObject[@"pagination"] && ![responseObject[@"pagination"] isKindOfClass:[NSNull class]]) {
                strongSelf.totalPageCount = [responseObject[@"pagination"][@"pageTotal"] integerValue];
            }
            NSMutableArray *array = [NSMutableArray arrayWithArray:strongSelf.cachedAskList];
            for (NSDictionary *dict in responseObject[@"data"]) {
                MyCreateAskModel *tempModel = [[MyCreateAskModel alloc] init];
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
- (void)changeStatusWithCompletionHandler:(void (^)(NSError *))completionHandler
{
    NSLog(@"%ld",(long)self.currentFetcherStatus.integerValue);
    
    if (self.status.integerValue == 1) {
        NSLog(@"1");
        [[NetController sharedInstance]postWithAPI:API_ask_change_bought_status parameters:@{@"memberId":[UserModel currentUser].memberId,@"goodsInNeedId":self.askId,@"status":@"3"} completionHandler:^(id responseObject, NSError *error) {
            completionHandler(error);
        }];
        
    }else if (self.status.integerValue == 3)
    {
        NSLog(@"3");
        [[NetController sharedInstance]postWithAPI:API_ask_change_bought_status parameters:@{@"memberId":[UserModel currentUser].memberId,@"goodsInNeedId":self.askId,@"status":@"1"} completionHandler:^(id responseObject, NSError *error) {
            completionHandler(error);
        }];
    }
}

- (void)confirmSaleWithCompletionHandler:(void (^)(NSError *))completionHandler
{
    [[NetController sharedInstance]postWithAPI:API_ask_change_bought_status parameters:@{@"memberId":[UserModel currentUser].memberId,@"goodsInNeedId":self.askId,@"status":@"2"} completionHandler:^(id responseObject, NSError *error) {
        completionHandler(error);
    }];
}

- (void)deleteWithCompletionHandler:(void(^)(NSError *error))completionHandler
{
    [[NetController sharedInstance]postWithAPI:API_ask_delete_create parameters:@{@"goodsInNeedId":self.askId} completionHandler:^(id responseObject, NSError *error) {
        completionHandler(error);
    }];
}

@end
