//
//  GoodDetailsDataModel.h
//  TXXE
//
//  Created by River on 15/7/1.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodDetailsDataModel : NSObject

@property (nonatomic,copy) NSString *senderID;
@property (nonatomic,copy) NSString *ToID;
@property (nonatomic,copy) NSString *contents;
@property (nonatomic,copy) NSString *createTime;
@property (nonatomic,copy) NSString *senderNickName;
@property (nonatomic,copy) NSString *toNickName;
@property (nonatomic,strong) NSString *avatarUrl;

@property (nonatomic,strong) NSArray *cachedCommentList;
@property (nonatomic,strong) NSDictionary *goodDic;

- (void)loadGoodDetailsDataWithID:(NSString *)goodId CompletionHandler:(void(^)(NSError *error,NSDictionary *goodDic,NSArray *cachedCommentList))completionHandler;
@end
