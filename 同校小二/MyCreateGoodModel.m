//
//  MyCreateGoodModel.m
//  TXXE
//
//  Created by 李雨龙 on 15/7/19.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "MyCreateGoodModel.h"
#import "NetController.h"
#import "UserModel.h"

static const NSInteger kCreateGoodListDataRequestPageSize = 20;

@interface MyCreateGoodModel ()

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
@property (nonatomic , strong) NSArray *cachedGoodList;

@property (nonatomic , copy) NSString *currentFetcherStatus;

@end
@implementation MyCreateGoodModel

- (void)setValuesForKeysWithDictionary:(NSDictionary *)keyedValues
{
    
    self.goodId = [keyedValues[@"id"] stringValue];
    self.goodTitle = keyedValues[@"title"];
    self.goodDescription = keyedValues[@"description"];
    self.goodPrice = keyedValues[@"price"];
    self.status = [keyedValues[@"status"] stringValue];
    NSMutableArray *images = [NSMutableArray array];
    for (NSString *urlText in keyedValues[@"images"]) {
        [images addObject:urlText];
    }
    self.isNew = [keyedValues[@"isNew"] boolValue];
    self.imageUrlTexts = images;
    self.school = keyedValues[@"jyLocation"];
}

- (void)refreshCreatedGoodListForOnSalingListWithCompletionHandler:(void (^)(NSError *, NSArray *))completionHandler
{
    [self refreshCreatedGoodListForStatus:@"1" completionHandler:completionHandler];
}

- (void)refreshCreatedGoodListForUndercarriageListWithCompletionHandler:(void (^)(NSError *, NSArray *))completionHandler
{
    [self refreshCreatedGoodListForStatus:@"3" completionHandler:completionHandler];
}

- (void)refreshCreatedGoodListForSoldListWithCompletionHandler:(void (^)(NSError *, NSArray *))completionHandler
{
    [self refreshCreatedGoodListForStatus:@"2" completionHandler:completionHandler];
}

- (void)refreshCreatedGoodListForStatus:(NSString *)status completionHandler:(void (^)(NSError *, NSArray *))completionHandler
{
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setValue:@(self.currentPageCount = 1) forKey:@"page"];
    [postDict setValue:@(kCreateGoodListDataRequestPageSize) forKey:@"pageSize"];
    [postDict setValue:[UserModel currentUser].memberId forKey:@"memberId"];
    [postDict setValue:(self.currentFetcherStatus = status) forKey:@"status"];
    NSLog(@"%@",self.currentFetcherStatus);
    
    __weak __typeof(self)weakSelf = self;
    /////api
    [[NetController sharedInstance]postWithAPI:API_good_my_goods parameters:postDict completionHandler:^(id responseObject, NSError *error) {
        if (error) {
            completionHandler(error,nil);
        }else{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (responseObject[@"pagination"] && ![responseObject[@"pagination"] isKindOfClass:[NSNull class]]) {
                strongSelf.totalPageCount = [responseObject[@"pagination"][@"pageTotal"] integerValue];
            }
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dict in responseObject[@"data"]) {
                MyCreateGoodModel *tempModel = [[MyCreateGoodModel alloc] init];
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

- (void)refreshGoodListWithCompletionHandler:(void (^)(NSError *, NSArray *))completionHandler
{
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setValue:@(self.currentPageCount = 1) forKey:@"page"];
    [postDict setValue:@(kCreateGoodListDataRequestPageSize) forKey:@"pageSize"];
    [postDict setValue:self.memberId forKey:@"memberId"];
    [postDict setValue:@(1) forKey:@"status"];
    NSLog(@"%@",self.currentFetcherStatus);
    
    __weak __typeof(self)weakSelf = self;
    /////api
    [[NetController sharedInstance]postWithAPI:API_good_my_goods parameters:postDict completionHandler:^(id responseObject, NSError *error) {
        if (error) {
            completionHandler(error,nil);
        }else{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (responseObject[@"pagination"] && ![responseObject[@"pagination"] isKindOfClass:[NSNull class]]) {
                strongSelf.totalPageCount = [responseObject[@"pagination"][@"pageTotal"] integerValue];
            }
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dict in responseObject[@"data"]) {
                MyCreateGoodModel *tempModel = [[MyCreateGoodModel alloc] init];
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


- (void)loadMoreCreatedGoodListWithCompletionHandler:(void (^)(NSError *, NSArray *))completionHandler
{
    if (++self.currentPageCount > self.totalPageCount) {
        //木有更多分页了，不用加载
        NSError *error = [NSError errorWithDomain:@"kNoMoreDataAppliedDomain" code:-10 userInfo:@{NSLocalizedDescriptionKey:@"没有更多的分页数据"}];
        completionHandler(error,nil);
        return;
    }
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setValue:@(self.currentPageCount) forKey:@"page"];
    [postDict setValue:@(kCreateGoodListDataRequestPageSize) forKey:@"pageSize"];
    [postDict setValue:[UserModel currentUser].memberId forKey:@"memberId"];
    [postDict setValue:self.status forKey:@"status"];
    
    __weak __typeof(self)weakSelf = self;
    /////////api
    [[NetController sharedInstance] postWithAPI:API_good_my_goods parameters:postDict completionHandler:^(id responseObject, NSError *error) {
        if (error) {
            completionHandler(error,nil);
        } else {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (responseObject[@"pagination"] && ![responseObject[@"pagination"] isKindOfClass:[NSNull class]]) {
                strongSelf.totalPageCount = [responseObject[@"pagination"][@"pageTotal"] integerValue];
            }
            NSMutableArray *array = [NSMutableArray arrayWithArray:strongSelf.cachedGoodList];
            for (NSDictionary *dict in responseObject[@"data"]) {
                MyCreateGoodModel *tempModel = [[MyCreateGoodModel alloc] init];
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


- (void)loadMoreGoodListWithCompletionHandler:(void(^)(NSError *error,NSArray *goodList))completionHandler
{
    if (++self.currentPageCount > self.totalPageCount) {
        //木有更多分页了，不用加载
        NSError *error = [NSError errorWithDomain:@"kNoMoreDataAppliedDomain" code:-10 userInfo:@{NSLocalizedDescriptionKey:@"没有更多的分页数据"}];
        completionHandler(error,nil);
        return;
    }
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setValue:@(self.currentPageCount) forKey:@"page"];
    [postDict setValue:@(kCreateGoodListDataRequestPageSize) forKey:@"pageSize"];
    [postDict setValue:self.memberId forKey:@"memberId"];
    [postDict setValue:self.status forKey:@"status"];
    
    __weak __typeof(self)weakSelf = self;
    /////////api
    [[NetController sharedInstance] postWithAPI:API_good_my_goods parameters:postDict completionHandler:^(id responseObject, NSError *error) {
        if (error) {
            completionHandler(error,nil);
        } else {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (responseObject[@"pagination"] && ![responseObject[@"pagination"] isKindOfClass:[NSNull class]]) {
                strongSelf.totalPageCount = [responseObject[@"pagination"][@"pageTotal"] integerValue];
            }
            NSMutableArray *array = [NSMutableArray arrayWithArray:strongSelf.cachedGoodList];
            for (NSDictionary *dict in responseObject[@"data"]) {
                MyCreateGoodModel *tempModel = [[MyCreateGoodModel alloc] init];
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
- (void)changeStatusWithCompletionHandler:(void(^)(NSError *error))completionHandler
{
    NSLog(@"%ld",(long)self.currentFetcherStatus.integerValue);
    
    if (self.status.integerValue == 1) {
        NSLog(@"1");
        [[NetController sharedInstance]postWithAPI:API_good_change_sale_status parameters:@{@"memberId":[UserModel currentUser].memberId,@"goodsId":self.goodId,@"status":@"3"} completionHandler:^(id responseObject, NSError *error) {
            completionHandler(error);
        }];

    }else if (self.status.integerValue == 3)
    {
        NSLog(@"3");
        [[NetController sharedInstance]postWithAPI:API_good_change_sale_status parameters:@{@"memberId":[UserModel currentUser].memberId,@"goodsId":self.goodId,@"status":@"1"} completionHandler:^(id responseObject, NSError *error) {
            completionHandler(error);
        }];
    }
    
}

- (void)confirmSaleWithCompletionHandler:(void(^)(NSError *error))completionHandler
{
    /////////api
    NSLog(@".....%@",self.mobilePhoneForMoney);
    [[NetController sharedInstance]postWithAPI:API_good_change_sale_status parameters:@{@"memberId":[UserModel currentUser].memberId,@"goodsId":self.goodId,@"status":@"2"} completionHandler:^(id responseObject, NSError *error) {
        completionHandler(error);
    }];
}

- (void)deleteWithCompletionHandler:(void(^)(NSError *error))completionHandler
{
    [[NetController sharedInstance]postWithAPI:API_good_delete_create parameters:@{@"goodsId":self.goodId} completionHandler:^(id responseObject, NSError *error) {
        completionHandler(error);
    }];
}























@end
