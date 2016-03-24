//
//  ScoreDetailModel.m
//  TXXE
//
//  Created by 李雨龙 on 15/7/26.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "ScoreDetailModel.h"
#import "NetController.h"
#import "UserModel.h"

static const NSInteger kScoreDetailListDataRequestPageSize = 20;

@interface ScoreDetailModel()

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
@property (nonatomic , strong) NSArray *cachedScoreDetailList;

@end
@implementation ScoreDetailModel

- (void)setValuesForKeysWithDictionary:(NSDictionary *)keyedValues
{
    self.scoreDetailDict = keyedValues;
}

- (void)refreshScoreDetailListWithCompletionHandler:(void (^)(NSError *, NSArray *))completionHandler
{
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setValue:@(self.currentPageCount = 1) forKey:@"page"];
    [postDict setValue:@(kScoreDetailListDataRequestPageSize) forKey:@"pageSize"];
    [postDict setValue:[UserModel currentUser].memberId forKey:@"memberId"];
    
    __weak __typeof(self)weakSelf = self;
    
    ///////api
    [[NetController sharedInstance] postWithAPI:API_get_myscore parameters:postDict completionHandler:^(id responseObject, NSError *error) {
        if (error) {
            completionHandler(error,nil);
        }else
        {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (responseObject[@"pagination"] && ![responseObject[@"pagination"] isKindOfClass:[NSNull class]]) {
                strongSelf.totalPageCount = [responseObject[@"pagination"][@"pageTotal"]integerValue];
            }
            
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dict in responseObject[@"data"]) {
                ScoreDetailModel *tempModel = [[ScoreDetailModel alloc]init];
                NSLog(@"YYYYYYYY%@",dict);
                [tempModel setValuesForKeysWithDictionary:dict];
                [array addObject:tempModel];
            }
            @autoreleasepool {
                strongSelf.cachedScoreDetailList = array;
            }
            completionHandler(nil,strongSelf.cachedScoreDetailList);
        }
    }];
}

- (void)loadMoreScoreDetailListWithCompletionHandler:(void (^)(NSError *, NSArray *))completionHandler
{
    if (++self.currentPageCount > self.totalPageCount) {
        NSError *error = [NSError errorWithDomain:@"kNoMoreDataAppliedDomain" code:-10 userInfo:@{NSLocalizedDescriptionKey:@"没有更多的分页数据"}];
        completionHandler(error,nil);
        return;
    }
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setValue:@(self.currentPageCount) forKey:@"page"];
    [postDict setValue:@(kScoreDetailListDataRequestPageSize) forKey:@"pageSize"];
    [postDict setValue:[UserModel currentUser].memberId forKey:@"memberId"];
    
    __weak __typeof(self)weakSelf = self;
    
    ////////api
    [[NetController sharedInstance]postWithAPI:API_get_myscore parameters:postDict completionHandler:^(id responseObject, NSError *error) {
        if (error) {
            completionHandler(error,nil);
        }else{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (responseObject[@"pagination"] && ![responseObject[@"pagination"] isKindOfClass:[NSNull class]]) {
                strongSelf.totalPageCount = [responseObject[@"pagination"][@"pageTotal"]integerValue];
            }
            
            NSMutableArray *array = [NSMutableArray arrayWithArray:strongSelf.cachedScoreDetailList];
            for (NSDictionary *dict in responseObject[@"data"]) {
                ScoreDetailModel *tempModel = [[ScoreDetailModel alloc]init];
                [tempModel setValuesForKeysWithDictionary:dict];
                [array addObject:tempModel];
            }
            @autoreleasepool {
                strongSelf.cachedScoreDetailList = array;
            }
            completionHandler(nil,strongSelf.cachedScoreDetailList);
        }
    }];
}
@end
