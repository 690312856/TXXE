//
//  AskGoodItemModel.h
//  TXXE
//
//  Created by River on 15/7/7.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "BaseGoodItemModel.h"

@interface AskGoodItemModel : BaseGoodItemModel

@property (nonatomic,copy) NSString *price;
@property (nonatomic,copy) NSString *schoolName;
@property (nonatomic,strong) NSArray *askGoodImageUrlTexts;
@property (nonatomic,strong) NSArray *cachedGoodList;

- (void)refreshAskGoodListWithCompletionHandler:(void(^)(NSError *error,NSArray *goodList))completionHandler;

- (void)loadMoreAskGoodListWithCompletionHandler:(void(^)(NSError *error,NSArray *goodList))completionHandler;
@end
