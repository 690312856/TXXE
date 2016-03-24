//
//  SchoolModel.m
//  TXXE
//
//  Created by River on 15/6/7.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "SchoolModel.h"
#import "NetController.h"

@implementation SchoolModel

- (NSDictionary *)convertToDictionary
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.schoolID forKey:@"id"];
    [dict setValue:self.schoolName forKey:@"schoolName"];
    return dict;
}

- (BOOL)cacheSelfIntoUserDefault
{
    NSDictionary *schoolDict = [self convertToDictionary];
    [[NSUserDefaults standardUserDefaults] setValue:schoolDict forKey:@"kSelectedScoolInUserDefaultKey"];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)isEqual:(id)object
{
    if (!object || [object isKindOfClass:[NSNull class]]) {
        return NO;
    }
    SchoolModel *anotherSchool = object;
    if ([anotherSchool isKindOfClass:[SchoolModel class]]) {
        if (anotherSchool.schoolID.integerValue == self.schoolID.integerValue) {
            return YES;
        }
    }
    return NO;
}

- (void)setValuesForKeysWithDictionary:(NSDictionary *)keyedValues
{
    self.schoolID = [keyedValues[@"id"]stringValue];
    self.schoolName = keyedValues[@"schoolName"];
}
- (void)fetchSchoolsWithParameter:(NSDictionary *)parameter completionHandler:(void (^)(NSArray *,NSError *))completionHandler
{
    __weak __typeof(self)weakSelf = self;
    [[NetController sharedInstance] postWithAPI:API_school_list parameters:parameter completionHandler:^(id responseObject, NSError *error) {
        if (error) {
            completionHandler(nil,error);
        } else {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dict in responseObject[@"data"][@"hotSchools"]) {
                SchoolModel *tempModel = [[SchoolModel alloc] init];
                [tempModel setValuesForKeysWithDictionary:dict];
                [array addObject:tempModel];
            }
            @autoreleasepool {
                strongSelf.cachedHotSchools = array;
            }
            completionHandler(strongSelf.cachedHotSchools,nil);
        }
    }];
}
- (void)fetchAllHotSchoolsWithCompletionHandler:(void (^)(NSArray *, NSError *))completionHandler
{
    [self fetchSchoolsWithParameter:@{@"searchType":@1} completionHandler:completionHandler];
}

- (void)fetchAllNearBySchoolWithLongitude:(NSNumber *)lng latitude:(NSNumber *)lat completionHandler:(void (^)(NSArray *, NSError *))completionHandler
{
    __weak __typeof(self)weakSelf = self;
    [[NetController sharedInstance] postWithAPI:API_good_JsonDetail parameters:@{@"searchType":@3,@"lng":[lng stringValue],@"lat":[lat stringValue],@"coordType":@"1"} completionHandler:^(id responseObject, NSError *error) {
        if (error) {
            completionHandler(nil,error);
        } else {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dict in responseObject[@"data"][@"nearbySchools"]) {
                SchoolModel *tempModel = [[SchoolModel alloc] init];
                [tempModel setValuesForKeysWithDictionary:dict];
                [array addObject:tempModel];
            }
            @autoreleasepool {
                strongSelf.cachedNearbySchools = array;
            }
            completionHandler(strongSelf.cachedNearbySchools,nil);
        }
    }];
}

- (void)searchForSchoolWithKeyWord:(NSString *)kword completionHandler:(void (^)(NSArray *, NSError *))completionHandler
{
    if (!kword || kword.length == 0) {
        completionHandler(nil,[[NSError alloc]init]);
    }
    
    __weak __typeof(self)weakSelf = self;
    [[NetController sharedInstance] postWithAPI:API_school_list parameters:@{@"searchType":@2,@"kw":kword} completionHandler:^(id responseObject, NSError *error) {
        if (error) {
            completionHandler(nil,error);
        }else {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dict in responseObject[@"data"][@"searchResults"]) {
                SchoolModel *tempModel = [[SchoolModel alloc] init];
                [tempModel setValuesForKeysWithDictionary:dict];
                [array addObject:tempModel];
            }
            @autoreleasepool {
                strongSelf.cachedHotSchools = array;
            }
            completionHandler(strongSelf.cachedHotSchools,nil);
        }
    }];
}





@end
