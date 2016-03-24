//
//  SchoolModel.h
//  TXXE
//
//  Created by River on 15/6/7.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SchoolModel : NSObject

@property (nonatomic,copy) NSString *schoolID;
@property (nonatomic,copy) NSString *schoolName;

- (NSDictionary *)convertToDictionary;

- (bool)cacheSelfIntoUserDefault;

@property (nonatomic,strong) NSArray *cachedHotSchools;
@property (nonatomic,strong) NSArray *cachedNearbySchools;

/**
 *  获取所有热门学校
 *
 *  @param completionHandler 数据返回（同时将数据保存到cachedSchools）
 */
- (void)fetchAllHotSchoolsWithCompletionHandler:(void(^)(NSArray *allSchools,NSError *error))completionHandler;

/**
 *  按照经纬度搜索附近热门学校
 *
 *  @param lng               经度
 *  @param lat               纬度
 *  @param completionHandler 数据返回（同时将数据保存到cachedSchools）
 */
- (void)fetchAllNearBySchoolWithLongitude:(NSNumber *)lng latitude:(NSNumber *)lat completionHandler:(void(^)(NSArray *allSchools,NSError *error))completionHandler;

/**
 *  按照关键字搜索学校
 *
 *  @param kword             关键字
 *  @param completionHandler 数据返回（同时将数据保存到cachedSchools）
 */
- (void)searchForSchoolWithKeyWord:(NSString *)kword completionHandler:(void(^)(NSArray *allSchools,NSError *error))completionHandler;
@end
