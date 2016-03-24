//
//  MyCreateAskModel.h
//  TXXE
//
//  Created by 李雨龙 on 15/7/26.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyCreateAskModel : NSObject

@property (nonatomic,copy)NSString *askId;
@property (nonatomic,copy)NSString *askTitle;
@property (nonatomic,copy)NSString *askDescription;
@property (nonatomic,copy)NSString *mobile;
@property (nonatomic,copy)NSString *qq;
@property (nonatomic,strong)NSString *mobilePhoneForMoney;
@property (nonatomic,copy)NSString *askPrice;
@property (nonatomic,copy)NSString *status;
@property (nonatomic,strong)NSArray *imageUrlTexts;
@property (nonatomic,copy,readonly)NSString *currentFetcherStatus;
@property (nonatomic,readonly)NSArray *cachedAskList;


@property (nonatomic,strong)NSString *memberId;
- (void)refreshCreatedAskListForBoughtListWithCompletionHandler:(void(^)(NSError *error,NSArray *askList))completionHandler;
- (void)refreshCreatedAskListForPurchasingListWithCompletionHandler:(void (^)(NSError *, NSArray *askList))completionHandler;
- (void)refreshCreatedAskListForSuspendedListWithCompletionHandler:(void(^)(NSError *error,NSArray *askList))completionHandler;


- (void)refreshAskListWithCompletionHandler:(void(^)(NSError *error,NSArray *goodList))completionHandler;
- (void)loadMoreAskListWithCompletionHandler:(void(^)(NSError *error,NSArray *askList))completionHandler;


- (void)loadMoreCreatedAskListWithCompletionHandler:(void(^)(NSError *error,NSArray *askList))completionHandler;

- (void)changeStatusWithCompletionHandler:(void(^)(NSError *error))completionHandler;

- (void)confirmSaleWithCompletionHandler:(void(^)(NSError *error))completionHandler;

- (void)deleteWithCompletionHandler:(void(^)(NSError *error))completionHandler;
@end
