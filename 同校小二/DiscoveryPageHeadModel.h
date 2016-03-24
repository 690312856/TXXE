//
//  DiscoveryPageHeadModel.h
//  TXXE
//
//  Created by River on 15/6/15.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SchoolModel.h"
#import "BaseFuncionModel.h"

@interface DiscoveryPageHeadModel : NSObject

@property (nonatomic, strong) NSArray *functions;
/**
 *  首页获取热门活动数据
 *
 *  @param school            学校
 *  @param completionHandler 回调
 */
- (void)fetchHomeDataForSchool:(SchoolModel *)school completionHandler:(void(^)(NSError *error,NSArray *hotFunctions))completionHandler;
@end
