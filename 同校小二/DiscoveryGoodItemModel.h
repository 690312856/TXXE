//
//  DiscoveryGoodItemModel.h
//  TXXE
//
//  Created by River on 15/6/8.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "BaseGoodItemModel.h"
#import "SchoolModel.h"

@interface DiscoveryGoodItemModel : BaseGoodItemModel

@property (nonatomic,copy) NSString *price;
@property (nonatomic,copy) NSString *tradeLocation;
@property (nonatomic)BOOL isNew;
@property (nonatomic,copy) NSString *goodDescription;
@property (nonatomic,strong) NSArray *goodImageUrlTexts;
@property (nonatomic,strong) NSArray *cachedGoodList;

@property (nonatomic,strong) NSString *functionId;

- (void)refreshNormalGoodListWithCompletionHandler:(void(^)(NSError *error,NSArray *goodList))completionHandler;

- (void)loadMoreNormalGoodListWithCompletionHandler:(void(^)(NSError *error,NSArray *goodList))completionHandler;


- (void)refreshFunctionGoodListWithCompletionHandler:(void(^)(NSError *error,NSArray *goodList))completionHandler;

- (void)loadMoreFunctionGoodListWithCompletionHandler:(void(^)(NSError *error,NSArray *goodList))completionHandler;
@end
