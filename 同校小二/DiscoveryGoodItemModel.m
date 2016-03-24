//
//  DiscoveryGoodItemModel.m
//  TXXE
//
//  Created by River on 15/6/8.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "DiscoveryGoodItemModel.h"
#import "NetController.h"
#import "NSString+Addition.h"
static const NSInteger kDiscoveryGoodListDataRequestPageSize = 20;

@interface DiscoveryGoodItemModel()

/**
 *  分页总数，由服务器返回
 */
@property (nonatomic , assign) NSInteger totalPageCount;
/**
 *  每次分页获取的当前页码
 */
@property (nonatomic , assign) NSInteger currentPageCount;

@end
@implementation DiscoveryGoodItemModel

- (void) setValuesForKeysWithDictionary:(NSDictionary *)keyedValues
{
    [super setValuesForKeysWithDictionary:keyedValues];
    self.price = keyedValues[@"price"];
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *string in keyedValues[@"images"]) {
        [array addObject:string];
    }
    self.isNew = [keyedValues[@"isNew"] boolValue];
    self.goodImageUrlTexts = array;
    self.tradeLocation = keyedValues[@"jyLocation"];
    self.goodDescription = keyedValues[@"description"];
}

- (void)refreshNormalGoodListWithCompletionHandler:(void (^)(NSError *, NSArray *))completionHandler
{
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setValue:@(self.currentPageCount = 1) forKey:@"page"];
    [postDict setValue:@("") forKey:@"isInSchool"];
    [postDict setValue:@(kDiscoveryGoodListDataRequestPageSize) forKey:@"pageSize"];
    [postDict setValue:[UserModel currentUser].currentSelectSchool.schoolID forKey:@"schoolId"];
    
    __weak __typeof(self)weakSelf = self;
    [[NetController sharedInstance] postWithAPI:API_good_list parameters:postDict completionHandler:^(id responseObject, NSError *error) {
        if (error) {
            completionHandler(error,nil);
        } else {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (responseObject[@"pagination"] && ![responseObject[@"pagination"] isKindOfClass:[NSNull class]]) {
                strongSelf.totalPageCount = [responseObject[@"pagination"][@"pageTotal"] integerValue];
            }
            NSMutableArray *array= [NSMutableArray array];
            for (NSDictionary *dict in responseObject[@"data"]) {
                DiscoveryGoodItemModel *tempModel = [[DiscoveryGoodItemModel alloc]init];
                [tempModel setValuesForKeysWithDictionary:dict];
                [array addObject:tempModel];
            }
            @autoreleasepool {
                strongSelf.cachedGoodList = array;
            }
            completionHandler(nil,strongSelf.cachedGoodList);
        }
    }];
}

- (void)loadMoreNormalGoodListWithCompletionHandler:(void (^)(NSError *, NSArray *))completionHandler
{
    if (++self.currentPageCount > self.totalPageCount) {
        NSError *error = [NSError errorWithDomain:@"kNoMoreDataAppliedDomin" code:-10 userInfo:@{NSLocalizedDescriptionKey:@"没有更多地分页数据"}];
        completionHandler(error,nil);
        return;
    }
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setValue:@(self.currentPageCount) forKey:@"page"];
    [postDict setValue:@(kDiscoveryGoodListDataRequestPageSize) forKey:@"pageSize"];
    [postDict setValue:[UserModel currentUser].currentSelectSchool.schoolID forKey:@"schoolId"];
    __weak __typeof(self)weakSelf = self;
    [[NetController sharedInstance] postWithAPI:API_good_list parameters:postDict completionHandler:^(id responseObject, NSError *error) {
        if (error) {
            completionHandler(error,nil);
        }else{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (responseObject[@"pagination"] && ![responseObject[@"pagination"] isKindOfClass:[NSNull class]]) {
                strongSelf.totalPageCount = [responseObject[@"pagination"][@"pageTotal"] integerValue];
            }
            NSMutableArray *array = [NSMutableArray arrayWithArray:strongSelf.cachedGoodList];
            for (NSDictionary *dict in responseObject[@"data"]) {
                DiscoveryGoodItemModel *tempModel = [[DiscoveryGoodItemModel alloc] init];
                [tempModel setValuesForKeysWithDictionary:dict];
                [array addObject:tempModel];
            }
            @autoreleasepool {
                strongSelf.cachedGoodList = array;
            }
            completionHandler(nil,strongSelf.cachedGoodList);
        }
    }];
}


- (void)refreshFunctionGoodListWithCompletionHandler:(void(^)(NSError *error,NSArray *goodList))completionHandler
{
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setValue:@(self.currentPageCount = 1) forKey:@"page"];
    [postDict setValue:@(kDiscoveryGoodListDataRequestPageSize) forKey:@"pageSize"];
    [postDict setValue:self.functionId forKey:@"functionId"];
    
    __weak __typeof(self)weakSelf = self;
    [[NetController sharedInstance] postWithAPI:API_good_list parameters:postDict completionHandler:^(id responseObject, NSError *error) {
        if (error) {
            completionHandler(error,nil);
        } else {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (responseObject[@"pagination"] && ![responseObject[@"pagination"] isKindOfClass:[NSNull class]]) {
                strongSelf.totalPageCount = [responseObject[@"pagination"][@"pageTotal"] integerValue];
            }
            NSMutableArray *array= [NSMutableArray array];
            for (NSDictionary *dict in responseObject[@"data"]) {
                DiscoveryGoodItemModel *tempModel = [[DiscoveryGoodItemModel alloc]init];
                [tempModel setValuesForKeysWithDictionary:dict];
                [array addObject:tempModel];
            }
            @autoreleasepool {
                strongSelf.cachedGoodList = array;
            }
            completionHandler(nil,strongSelf.cachedGoodList);
        }
    }];
}

- (void)loadMoreFunctionGoodListWithCompletionHandler:(void(^)(NSError *error,NSArray *goodList))completionHandler
{
    if (++self.currentPageCount > self.totalPageCount) {
        NSError *error = [NSError errorWithDomain:@"kNoMoreDataAppliedDomin" code:-10 userInfo:@{NSLocalizedDescriptionKey:@"没有更多地分页数据"}];
        completionHandler(error,nil);
        return;
    }
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setValue:@(self.currentPageCount) forKey:@"page"];
    [postDict setValue:@(kDiscoveryGoodListDataRequestPageSize) forKey:@"pageSize"];
    [postDict setValue:self.functionId forKey:@"functionId"];
    __weak __typeof(self)weakSelf = self;
    [[NetController sharedInstance] postWithAPI:API_good_list parameters:postDict completionHandler:^(id responseObject, NSError *error) {
        if (error) {
            completionHandler(error,nil);
        }else{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (responseObject[@"pagination"] && ![responseObject[@"pagination"] isKindOfClass:[NSNull class]]) {
                strongSelf.totalPageCount = [responseObject[@"pagination"][@"pageTotal"] integerValue];
            }
            NSMutableArray *array = [NSMutableArray arrayWithArray:strongSelf.cachedGoodList];
            for (NSDictionary *dict in responseObject[@"data"]) {
                DiscoveryGoodItemModel *tempModel = [[DiscoveryGoodItemModel alloc] init];
                [tempModel setValuesForKeysWithDictionary:dict];
                [array addObject:tempModel];
            }
            @autoreleasepool {
                strongSelf.cachedGoodList = array;
            }
            completionHandler(nil,strongSelf.cachedGoodList);
        }
    }];
}
@end
