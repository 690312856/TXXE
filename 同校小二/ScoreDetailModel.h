//
//  ScoreDetailModel.h
//  TXXE
//
//  Created by 李雨龙 on 15/7/26.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScoreDetailModel : NSObject

@property (nonatomic,strong)NSDictionary *scoreDetailDict;
@property (nonatomic,readonly) NSArray *cachedScoreDetailList;

- (void)refreshScoreDetailListWithCompletionHandler:(void(^)(NSError *error,NSArray *scoreDetailList))completionHandler;

- (void)loadMoreScoreDetailListWithCompletionHandler:(void(^)(NSError *error,NSArray *scoreDetailList))completionHandler;

@end
