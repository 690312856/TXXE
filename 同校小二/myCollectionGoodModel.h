//
//  myCollectionGoodModel.h
//  TXXE
//
//  Created by 李雨龙 on 15/7/25.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface myCollectionGoodModel : NSObject
@property (nonatomic,copy)NSString *goodId;
@property (nonatomic,copy)NSString *goodTitle;
@property (nonatomic,copy)NSString *goodDescription;
@property (nonatomic,copy)NSString *goodPrice;
@property (nonatomic,strong)NSArray *imageUrlTexts;
@property (nonatomic,readonly)NSArray *cachedGoodList;

- (void)refreshCollectionGoodListWithCompletionHandler:(void(^)(NSError *error,NSArray *goodList))completionHandler;
- (void)loadMoreCollectionGoodListWithCompletionHandler:(void(^)(NSError *error,NSArray *goodList))completionHandler;
- (void)cancelCollectionWithCompletionHandler:(void(^)(NSError *error))completionHandler;
@end
