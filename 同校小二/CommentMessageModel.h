//
//  CommentMessageModel.h
//  TXXE
//
//  Created by 李雨龙 on 15/7/23.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentMessageModel : NSObject

@property (nonatomic,copy) NSString *goodOrAskId;
@property (nonatomic,copy) NSString *cMessageId;
@property (nonatomic,copy) NSString *cMessageType;
@property (nonatomic,copy) NSString *cGoodsType;
@property (nonatomic,copy) NSString *createMemberId;
@property (nonatomic,assign) BOOL didRead;
@property (nonatomic,copy)NSString *createTime;
@property (nonatomic,strong) NSDictionary *messageBodyDict;
@property (nonatomic,strong) NSDictionary *autorDict;
@property (nonatomic,readonly)NSArray *cachedMessageList;

- (void)refreshCommentMessageListWithCompletionHandler:(void(^)(NSError *error,NSArray *messageList))completionHandler;
- (void)loadMoreCommentMessageWithCompletionHandler:(void(^)(NSError *error,NSArray *messageList))completionHandler;
- (void)labelHadReadCommentMessageWithCompletionHandler:(void(^)(NSError *error))completionHandler;
@end
