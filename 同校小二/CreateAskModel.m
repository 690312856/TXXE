//
//  CreateAskModel.m
//  TXXE
//
//  Created by River on 15/7/18.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "CreateAskModel.h"
#import "NetController.h"
#import "UserModel.h"
#import <SDWebImageCompat.h>
#import "NSString+Addition.h"
#import "NSDate+String.h"

@interface CreateAskModel ()

@property (nonatomic , copy) NSString *startTimeText;
@property (nonatomic , copy) NSString *endTimeText;

@end
@implementation CreateAskModel

- (void) setValuesForKeysWithDictionary:(NSDictionary *)keyedValues
{
    self.askTitle = keyedValues[@"title"];
    self.askPrice = [keyedValues[@"price"]stringValue];
    self.askDescription = keyedValues[@"description"];
    self.askId = [keyedValues[@"id"]stringValue];
    self.isNew =(long)keyedValues[@"isNew"];
    NSMutableArray *a =[NSMutableArray array];
    for (NSString *u in keyedValues[@"images"]) {
        [a addObject:u];
    }
    self.netImageUrlTexts = a ;
    if (keyedValues[@"categoryId"]) {
        self.selectedCategory = [[CategoryModel alloc] init];
        self.selectedCategory.categoryName = keyedValues[@"cName"];
        self.selectedCategory.categoryId = [keyedValues[@"categoryId"] stringValue];
    }
    
    UserModel *temp = [[UserModel alloc] init];
    self.mobileNumber = temp.mobileNumber = [keyedValues[@"mobileNumber"] stringValue];
    self.qqNumber = temp.qq = [keyedValues[@"qq"] stringValue];
    temp.school = [[SchoolModel alloc] init];
    temp.school.schoolID = [keyedValues[@"schoolId"] stringValue];
    temp.school.schoolName = [keyedValues[@"schoolName"] stringValue];
    temp.memberId = [keyedValues[@"sellerId"] stringValue];
    self.wantedUser = temp;
    self.tradeLocation = keyedValues[@"jyLocation"];
}

- (NSMutableArray *)localImageModels
{
    if (!_localImageModels) {
        _localImageModels = [NSMutableArray array];
    }
    return _localImageModels;
}

- (NSDictionary *)convertToDictionary
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.askTitle forKey:@"goodTitle"];
    [dict setValue:self.askPrice forKey:@"goodPrice"];
    [dict setValue:self.askDescription forKey:@"goodDescription"];
    [dict setValue:self.startTimeDate forKey:@"startTimeDate"];
    [dict setValue:self.endTimeDate forKey:@"endTimeDate"];
    [dict setValue:self.localImageModels forKey:@"localImageModels"];
    [dict setValue:self.selectedCategory.categoryName forKey:@"selectedCategory"];
    [dict setValue:@(self.isNew) forKey:@"isNew"];
    [dict setValue:self.tradeLocation forKey:@"tradeLocation"];
    [dict setValue:self.mobileNumber forKey:@"mobileNumber"];
    [dict setValue:self.qqNumber forKey:@"qqNumber"];
    return dict;
}

- (NSString *)description
{
    return [[self convertToDictionary]description];
}

- (void)startCreateAskWithCompletionHandler:(void (^)(NSError *))completionHandler
{
    __weak __typeof(self)weakSelf = self;
    [ImageModel uploadForLocalImages:self.localImageModels completionHandler:^(NSError *error, NSArray *imageUrlTexts) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (error) {
            completionHandler(error);
        }else{
            dispatch_main_async_safe(^(){
                [strongSelf continueCreateAskWithImageUrlTexts:imageUrlTexts completionHandler:completionHandler];
            });
        }
    }];
}
- (void)continueCreateAskWithImageUrlTexts:(NSArray *)imageUrlTexts completionHandler:(void (^)(NSError *))completionHandler
{
    NSLog(@"hahahhhahaha");
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setValue:[UserModel currentUser].memberId forKey:@"memberId"];
    [postDict setValue:self.askTitle forKey:@"title"];
    [postDict setValue:@(1) forKey:@"type"];
    [postDict setValue:@(self.isNew) forKey:@"isNew"];
    [postDict setValue:[imageUrlTexts componentsJoinedByString:@","] forKey:@"images"];
    [postDict setValue:self.askPrice forKey:@"price"];
    [postDict setValue:self.tradeLocation forKey:@"jyLocation"];
    [postDict setValue:self.selectedSchool.schoolID forKey:@"jySchoolId"];
    [postDict setValue:self.askDescription forKey:@"description"];
    [postDict setValue:self.selectedCategory.categoryId forKey:@"categoryIds"];
    [postDict setValue:self.mobileNumber forKey:@"mobileNumber"];
    [postDict setValue:[self.startTimeDate convertToStringWithFormat:@"yyyy-MM-dd HH-mm"] forKey:@"startTime"];
    [postDict setValue:[self.endTimeDate convertToStringWithFormat:@"yyyy-MM-dd HH-mm"] forKey:@"endTime"];
    [postDict setValue:self.qqNumber forKey:@"qq"];
    
    
    [[NetController sharedInstance] postWithAPI:API_ask_create parameters:postDict completionHandler:^(id responseObject, NSError *error) {
        if (error) {
            completionHandler(error);
        } else {
            NSLog(@"respone = %@",responseObject);
            completionHandler(nil);
        }
    }];
}

- (void)updateAskWithCompletionHandler:(void (^)(NSError *))completionHandler
{
    __weak __typeof(self)weakSelf = self;
    [ImageModel uploadForLocalImages:self.localImageModels completionHandler:^(NSError *error, NSArray *imageUrlTexts) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (error) {
            completionHandler(error);
        }else{
            dispatch_main_async_safe(^(){
                [strongSelf continueUpdateAskWithImageUrlTexts:imageUrlTexts completionHandler:completionHandler];
            });
        }
    }];
}

- (void)continueUpdateAskWithImageUrlTexts:(NSArray *)imageUrlTexts completionHandler:(void (^)(NSError *))completionHandler
{
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setValue:[UserModel currentUser].memberId forKey:@"memberId"];
    [postDict setValue:self.askTitle forKey:@"title"];
    [postDict setValue:self.askId forKey:@"id"];
    [postDict setValue:@(1) forKey:@"type"];
    [postDict setValue:@(self.isNew) forKey:@"isNew"];
    [postDict setValue:[imageUrlTexts componentsJoinedByString:@","] forKey:@"images"];
    [postDict setValue:self.askPrice forKey:@"price"];
    [postDict setValue:self.tradeLocation forKey:@"jyLocation"];
    [postDict setValue:self.askDescription forKey:@"description"];
    [postDict setValue:self.selectedCategory.categoryId forKey:@"categoryIds"];
    [postDict setValue:self.mobileNumber forKey:@"mobileNumber"];
    [postDict setValue:[self.startTimeDate convertToStringWithFormat:@"yyyy-MM-dd HH-mm"] forKey:@"startTime"];
    [postDict setValue:[self.endTimeDate convertToStringWithFormat:@"yyyy-MM-dd HH-mm"] forKey:@"endTime"];
    [postDict setValue:self.qqNumber forKey:@"qq"];
    
    
    [[NetController sharedInstance] postWithAPI:API_ask_update parameters:postDict completionHandler:^(id responseObject, NSError *error) {
        if (error) {
            completionHandler(error);
        } else {
            NSLog(@"respone = %@",responseObject);
            completionHandler(nil);
        }
    }];
}

- (void)fetchDetailWithCompletionHandler:(void (^)(NSError *))completionHandler
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.askId forKey:@"id"];
    [[NetController sharedInstance] postWithAPI:API_ask_JsonDetail parameters:dict completionHandler:^(id responseObject, NSError *error) {
        if (error) {
            completionHandler(error);
        } else {
            [self setValuesForKeysWithDictionary:responseObject[@"data"]];
            completionHandler(nil);
        }
    }];
}
@end
