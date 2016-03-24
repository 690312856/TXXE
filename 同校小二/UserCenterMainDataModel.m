//
//  UserCenterMainDataModel.m
//  TXXE
//
//  Created by River on 15/6/27.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "UserCenterMainDataModel.h"
#import "NetController.h"
#import "UserModel.h"
#import "NSString+Addition.h"

@interface UserCenterMainDataModel ()

@end

@implementation UserCenterMainDataModel

- (NSString *)favoriteGoodCount
{
    return [NSString realNumberForString:_favoriteGoodCount];
}

- (NSString *)totalWantedCount
{
    return [NSString realNumberForString:_totalWantedCount];
}

- (NSString *)totalSaleCount
{
    return [NSString realNumberForString:_totalSaleCount];
}

- (void)setValuesForKeysWithDictionary:(NSDictionary *)keyedValues
{
    self.totalSaleCount = [keyedValues[@"cntGoods"] stringValue];
    self.totalWantedCount = [keyedValues[@"cntSales"] stringValue];
    self.favoriteGoodCount = [keyedValues[@"cntFavorites"] stringValue];
    self.certificationInfoDict = keyedValues[@"certInfo"];
    self.nickName = keyedValues[@"certInfo"][@"nickName"];
    self.avatarUrlText = keyedValues[@"certInfo"][@"avatar"];
    self.level = keyedValues[@"certInfo"][@"level"];
    self.school = keyedValues[@"certInfo"][@"schoolName"];
    self.integrity = [keyedValues[@"certInfo"][@"completion"][@"integrity"] stringValue];
}

- (void)fetchUserCenterDataWithCompletionHandler:(void (^)(NSError *))completionHandler
{
    __weak __typeof(self)weakSelf = self;
    [[NetController sharedInstance] postWithAPI:API_user_center_data parameters:@{@"memberId":[UserModel currentUser].memberId} completionHandler:^(id responseObject, NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (error) {
            completionHandler(error);
        } else {
            [strongSelf setValuesForKeysWithDictionary:responseObject[@"data"]];
            completionHandler(nil);
        }
    }];
}
@end
