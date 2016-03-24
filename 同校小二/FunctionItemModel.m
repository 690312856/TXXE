//
//  FunctionItemModel.m
//  TongxiaoXiaoEr
//
//  Created by IOS－001 on 15/3/3.
//  Copyright (c) 2015年 xxx.xxxx. All rights reserved.
//

#import "FunctionItemModel.h"
#import "NetController.h"
#import "NSString+Addition.h"
#import "UserModel.h"

static const NSInteger kFunctionListDataRequestPageSize = 20;

@interface FunctionItemModel ()

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
@property (nonatomic , strong) NSArray *cachedFunctionList;

@end

@implementation FunctionItemModel

- (void)setValuesForKeysWithDictionary:(NSDictionary *)keyedValues
{
    self.functionId = [keyedValues[@"id"] stringValue];
    self.functionName = keyedValues[@"name"];
    self.functionDescription = keyedValues[@"description"];
    NSMutableArray *imageArray = [NSMutableArray array];
    for (NSString *string in keyedValues[@"images"]) {
        [imageArray addObject:string];
    }
    self.imageUrlTexts = imageArray;
    self.startTime = keyedValues[@"startTime"];
    self.endTime = keyedValues[@"endTime"];
    self.isHot = [keyedValues[@"isHot"] boolValue];
    self.createTime = keyedValues[@"createTime"];
    self.status = [keyedValues[@"status"] stringValue];
}

- (void)refreshFunctionListWithCompletionHandler:(void (^)(NSError *, NSArray *))completionHandler
{
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setValue:[[UserModel currentUser] currentSelectSchool].schoolID forKey:@"schoolId"];
    [postDict setValue:@(self.currentPageCount = 1) forKey:@"page"];
    [postDict setValue:@(kFunctionListDataRequestPageSize) forKey:@"pageSize"];
    
    __weak __typeof(self)weakSelf = self;
    [[NetController sharedInstance] postWithAPI:API_good_JsonDetail parameters:postDict completionHandler:^(id responseObject, NSError *error) {
        if (error) {
            completionHandler(error,nil);
        } else {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (responseObject[@"pagination"] && ![responseObject[@"pagination"] isKindOfClass:[NSNull class]]) {
                strongSelf.totalPageCount = [responseObject[@"pagination"][@"pageTotal"] integerValue];
            }
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dict in responseObject[@"data"]) {
                FunctionItemModel *tempModel = [[FunctionItemModel alloc] init];
                [tempModel setValuesForKeysWithDictionary:dict];
                [array addObject:tempModel];
            }
            @autoreleasepool {
                strongSelf.cachedFunctionList = array;
            }
            completionHandler(nil,strongSelf.cachedFunctionList);
        }
    }];
}

- (void)loadMoreFunctionListWithCompletionHandler:(void (^)(NSError *, NSArray *))completionHandler
{
    if (++self.currentPageCount > self.totalPageCount) {
        //木有更多分页了，不用加载
        NSError *error = [NSError errorWithDomain:@"kNoMoreDataAppliedDomain" code:-10 userInfo:@{NSLocalizedDescriptionKey:@"没有更多的分页数据"}];
        completionHandler(error,nil);
        return;
    }
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setValue:@(self.currentPageCount) forKey:@"page"];
    [postDict setValue:[[UserModel currentUser] currentSelectSchool].schoolID forKey:@"schoolId"];
    [postDict setValue:@(kFunctionListDataRequestPageSize) forKey:@"pageSize"];
    
    __weak __typeof(self)weakSelf = self;
    [[NetController sharedInstance] postWithAPI:API_good_JsonDetail parameters:postDict completionHandler:^(id responseObject, NSError *error) {
        if (error) {
            completionHandler(error,nil);
        } else {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (responseObject[@"pagination"] && ![responseObject[@"pagination"] isKindOfClass:[NSNull class]]) {
                strongSelf.totalPageCount = [responseObject[@"pagination"][@"pageTotal"] integerValue];
            }
            NSMutableArray *array = [NSMutableArray arrayWithArray:strongSelf.cachedFunctionList];
            for (NSDictionary *dict in responseObject[@"data"]) {
                FunctionItemModel *tempModel = [[FunctionItemModel alloc] init];
                [tempModel setValuesForKeysWithDictionary:dict];
                [array addObject:tempModel];
            }
            @autoreleasepool {
                strongSelf.cachedFunctionList = array;
            }
            completionHandler(nil,strongSelf.cachedFunctionList);
        }
    }];
}

@end
