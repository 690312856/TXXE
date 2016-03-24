
//
//  BaseAskItemModel.m
//  TXXE
//
//  Created by River on 15/7/18.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "BaseAskItemModel.h"

@implementation BaseAskItemModel

- (void)setValuesForKeysWithDictionary:(NSDictionary *)keyedValues
{
    /////////////////////////key值
    self.askId = [keyedValues[@"id"]stringValue];
    self.askTitle = keyedValues[@"title"];
    self.createTime = keyedValues[@"createTime"];
    
    if (keyedValues[@"wantedInfo"] && ![keyedValues[@"wantedInfo"] isKindOfClass:[NSNull class]]) {
        UserModel *tempUser = [[UserModel alloc]init];
        [tempUser setValuesForKeysWithDictionary:keyedValues[@"wantedInfo"]];
        self.wantedUser = tempUser;
    }
}
@end
