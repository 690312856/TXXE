//
//  MyCreateGoodModel.h
//  TXXE
//
//  Created by 李雨龙 on 15/7/19.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyCreateGoodModel : NSObject

@property (nonatomic,copy)NSString *goodId;
@property (nonatomic,copy)NSString *goodTitle;
@property (nonatomic,copy)NSString *goodDescription;
@property (nonatomic,copy)NSString *school;
@property (nonatomic,strong)NSString *mobilePhoneForMoney;
@property (nonatomic,copy)NSString *goodPrice;
@property (nonatomic , copy) NSString *status;
@property (nonatomic)BOOL isNew;
@property (nonatomic,strong)NSArray *imageUrlTexts;
@property (nonatomic,copy,readonly)NSString *currentFetcherStatus;
@property (nonatomic,readonly)NSArray *cachedGoodList;

@property (nonatomic,strong)NSString *memberId;
- (void)refreshCreatedGoodListForSoldListWithCompletionHandler:(void(^)(NSError *error,NSArray *goodList))completionHandler;
- (void)refreshCreatedGoodListForOnSalingListWithCompletionHandler:(void (^)(NSError *, NSArray *goodList))completionHandler;
- (void)refreshCreatedGoodListForUndercarriageListWithCompletionHandler:(void(^)(NSError *error,NSArray *goodList))completionHandler;


- (void)refreshGoodListWithCompletionHandler:(void(^)(NSError *error,NSArray *goodList))completionHandler;
- (void)loadMoreGoodListWithCompletionHandler:(void(^)(NSError *error,NSArray *goodList))completionHandler;


- (void)loadMoreCreatedGoodListWithCompletionHandler:(void(^)(NSError *error,NSArray *goodList))completionHandler;
- (void)changeStatusWithCompletionHandler:(void(^)(NSError *error))completionHandler;
- (void)confirmSaleWithCompletionHandler:(void(^)(NSError *error))completionHandler;
- (void)deleteWithCompletionHandler:(void(^)(NSError *error))completionHandler;
@end
