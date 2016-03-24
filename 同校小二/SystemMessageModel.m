//
//  SystemMessageModel.m
//  TXXE
//
//  Created by 李雨龙 on 15/7/23.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "SystemMessageModel.h"
#import "NetController.h"
#import "UserModel.h"

static const NSInteger kMessageListDataRequestPageSize = 20;

@interface SystemMessageModel()

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
@property (nonatomic , strong) NSArray *kcachedMessageList;

@end

@implementation SystemMessageModel

- (void)setValuesForKeysWithDictionary:(NSDictionary *)keyedValues
{
    self.sMessageId = [keyedValues[@"id"] stringValue];
    self.sMessageType = [keyedValues[@"messageType"] stringValue];
    self.didRead = [keyedValues[@"isRead"] boolValue];
    self.createTime = keyedValues[@"createTime"];
    self.messageBodyDict = keyedValues[@"messageBody"];
}

- (void)refreshSystemMessageListWithCompletionHandler:(void (^)(NSError *, NSArray *))completionHandler
{
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setValue:@(self.currentPageCount = 1) forKey:@"page"];
    [postDict setValue:@(kMessageListDataRequestPageSize) forKey:@"pageSize"];
    [postDict setValue:[UserModel currentUser].memberId forKey:@"userId"];
    
    __weak __typeof(self)weakSelf = self;
    ////////api
    [[NetController sharedInstance] postWithAPI:API_system_message parameters:postDict completionHandler:^(id responseObject, NSError *error) {
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
                SystemMessageModel *tempModel = [[SystemMessageModel alloc]init];
                [tempModel setValuesForKeysWithDictionary:dict];
                [array addObject:tempModel];
            }
            @autoreleasepool {
                strongSelf.kcachedMessageList = array;
            }
            NSLog(@"5555555");
            completionHandler(nil,strongSelf.kcachedMessageList);
        }
    }];
}

- (void)loadMoreSystemMessageWithCompletionHandler:(void (^)(NSError *, NSArray *))completionHandler
{
    if (++self.currentPageCount > self.totalPageCount) {
        NSError *error = [NSError errorWithDomain:@"kNoMoreDataAppliedDomain" code:-10 userInfo:@{NSLocalizedDescriptionKey:@"没有更多的分页数据"}];
        completionHandler(error,nil);
        return;
    }
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setValue:@(self.currentPageCount) forKey:@"page"];
    [postDict setValue:@(kMessageListDataRequestPageSize) forKey:@"pageSize"];
    [postDict setValue:[UserModel currentUser].memberId forKey:@"userId"];
    
    __weak __typeof(self)weakSelf = self;
    /////////api
    [[NetController sharedInstance]postWithAPI:API_system_message parameters:postDict completionHandler:^(id responseObject, NSError *error) {
        if (error) {
            completionHandler(error,nil);
        }else{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (responseObject[@"pagination"] && ![responseObject[@"pagination"] isKindOfClass:[NSNull class]]) {
                strongSelf.totalPageCount = [responseObject[@"pagination"][@"pageTotal"]integerValue];
            }
            
            NSMutableArray *array = [NSMutableArray arrayWithArray:strongSelf.kcachedMessageList];
            for (NSDictionary *dict in responseObject[@"data"]) {
                SystemMessageModel *tempModel = [[SystemMessageModel alloc]init];
                [tempModel setValuesForKeysWithDictionary:dict];
                [array addObject:tempModel];
            }
            @autoreleasepool {
                strongSelf.kcachedMessageList = array;
            }
            completionHandler(nil,strongSelf.kcachedMessageList);
        }
    }];
}


- (void)labelHadReadSystemMessageWithCompletionHandler:(void(^)(NSError *error))completionHandler
{
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setValue:self.sMessageId forKey:@"ids"];
    [postDict setValue:[UserModel currentUser].memberId forKey:@"memberId"];
    
    [[NetController sharedInstance] postWithAPI:API_systemMessage_hadRead parameters:postDict completionHandler:^(id responseObject, NSError *error) {
            completionHandler(error);
    }];

}













@end
