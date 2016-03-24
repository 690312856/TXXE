//
//  FunctionItemModel.h
//  TongxiaoXiaoEr
//
//  Created by IOS－001 on 15/3/3.
//  Copyright (c) 2015年 xxx.xxxx. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  活动Model
 */
@interface FunctionItemModel : NSObject

@property (nonatomic , copy) NSString *functionId;
@property (nonatomic , copy) NSString *functionName;
@property (nonatomic , copy) NSString *functionDescription;
@property (nonatomic , strong) NSArray *imageUrlTexts;
@property (nonatomic , copy) NSString *startTime;
@property (nonatomic , copy) NSString *endTime;
@property (nonatomic , assign) BOOL isHot;
@property (nonatomic , copy) NSString *status;
@property (nonatomic , copy) NSString *createTime;


@property (nonatomic , readonly) NSArray *cachedFunctionList;

- (void)refreshFunctionListWithCompletionHandler:(void(^)(NSError *error,NSArray *functionList))completionHandler;

- (void)loadMoreFunctionListWithCompletionHandler:(void(^)(NSError *error,NSArray *functionList))completionHandler;

@end
