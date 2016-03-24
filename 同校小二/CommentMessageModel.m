//
//  CommentMessageModel.m
//  TXXE
//
//  Created by 李雨龙 on 15/7/23.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "CommentMessageModel.h"
#import "NetController.h"
#import "UserModel.h"


static const NSInteger kMessageListDataRequestPageSize = 20;

@interface CommentMessageModel()

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
@property (nonatomic , strong) NSArray *cachedMessageList;

@end

@implementation CommentMessageModel

- (void)setValuesForKeysWithDictionary:(NSDictionary *)keyedValues
{
    self.cMessageId = [keyedValues[@"id"] stringValue];
    self.goodOrAskId = [keyedValues[@"assocId"] stringValue];
    self.cMessageType = [keyedValues[@"messageType"] stringValue];
    self.didRead = [keyedValues[@"hasRead"] boolValue];
    self.createTime = keyedValues[@"createTime"];
    self.messageBodyDict = keyedValues[@"messageBody"];
    self.autorDict = keyedValues[@"author"];
    self.cGoodsType = [keyedValues[@"goodsType"] stringValue];
    self.createMemberId = keyedValues[@"messageBody"][@"createMemberId"];
}

- (void)refreshCommentMessageListWithCompletionHandler:(void (^)(NSError *, NSArray *))completionHandler
{
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setValue:@(self.currentPageCount = 1) forKey:@"page"];
    [postDict setValue:@(kMessageListDataRequestPageSize) forKey:@"pageSize"];
    [postDict setValue:[UserModel currentUser].memberId forKey:@"userId"];
    
    __weak __typeof(self)weakSelf = self;
    ////////api
    [[NetController sharedInstance] postWithAPI:API_comment_message parameters:postDict completionHandler:^(id responseObject, NSError *error) {
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
                CommentMessageModel *tempModel = [[CommentMessageModel alloc]init];
                [tempModel setValuesForKeysWithDictionary:dict];
                [array addObject:tempModel];
            }
            @autoreleasepool {
                strongSelf.cachedMessageList = array;
            }
            completionHandler(nil,strongSelf.cachedMessageList);
        }
    }];
}

- (void)loadMoreCommentMessageWithCompletionHandler:(void (^)(NSError *, NSArray *))completionHandler
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
    [[NetController sharedInstance]postWithAPI:API_comment_message parameters:postDict completionHandler:^(id responseObject, NSError *error) {
        if (error) {
            completionHandler(error,nil);
        }else{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (responseObject[@"pagination"] && ![responseObject[@"pagination"] isKindOfClass:[NSNull class]]) {
                strongSelf.totalPageCount = [responseObject[@"pagination"][@"pageTotal"]integerValue];
            }
            
            NSMutableArray *array = [NSMutableArray arrayWithArray:strongSelf.cachedMessageList];
            for (NSDictionary *dict in responseObject[@"data"]) {
                CommentMessageModel *tempModel = [[CommentMessageModel alloc]init];
                [tempModel setValuesForKeysWithDictionary:dict];
                [array addObject:tempModel];
            }
            @autoreleasepool {
                strongSelf.cachedMessageList = array;
            }
            completionHandler(nil,strongSelf.cachedMessageList);
        }
    }];
}


- (void)labelHadReadCommentMessageWithCompletionHandler:(void(^)(NSError *error))completionHandler
{
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setValue:self.cMessageId forKey:@"messageId"];
    [postDict setValue:[UserModel currentUser].memberId forKey:@"memberId"];
    
    [[NetController sharedInstance] postWithAPI:API_commentMessage_hadRead parameters:postDict completionHandler:^(id responseObject, NSError *error) {
        completionHandler(error);
    }];
}
@end
