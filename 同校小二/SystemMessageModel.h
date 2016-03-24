//
//  SystemMessageModel.h
//  TXXE
//
//  Created by 李雨龙 on 15/7/23.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemMessageModel : NSObject

@property (nonatomic,copy) NSString *sMessageId;
@property (nonatomic,copy) NSString *sMessageType;
@property (nonatomic,assign) BOOL didRead;
@property (nonatomic,copy)NSString *createTime;
@property (nonatomic,strong) NSDictionary *messageBodyDict;

@property (nonatomic,readonly)NSArray *kcachedMessageList;

- (void)refreshSystemMessageListWithCompletionHandler:(void(^)(NSError *error,NSArray *messageList))completionHandler;
- (void)loadMoreSystemMessageWithCompletionHandler:(void(^)(NSError *error,NSArray *messageList))completionHandler;
- (void)labelHadReadSystemMessageWithCompletionHandler:(void(^)(NSError *error))completionHandler;

@end
