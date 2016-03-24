//
//  myCollectionAskModel.h
//  TXXE
//
//  Created by 李雨龙 on 15/7/24.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface myCollectionAskModel : NSObject

@property (nonatomic,copy)NSString *askId;
@property (nonatomic,copy)NSString *memberId;
@property (nonatomic,copy)NSString *askTitle;
@property (nonatomic,copy)NSString *askDescription;
@property (nonatomic,copy)NSString *askPrice;
@property (nonatomic,strong)NSArray *imageUrlTexts;
@property (nonatomic,readonly)NSArray *cachedAskList;

- (void)refreshCollectionAskListWithCompletionHandler:(void(^)(NSError *error,NSArray *askList))completionHandler;
- (void)loadMoreCollectionAskListWithCompletionHandler:(void(^)(NSError *error,NSArray *askList))completionHandler;
- (void)cancelCollectionWithCompletionHandler:(void(^)(NSError *error))completionHandler;
@end
