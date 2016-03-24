//
//  BaseGoodItemModel.m
//  TXXE
//
//  Created by River on 15/6/7.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "BaseGoodItemModel.h"

@implementation BaseGoodItemModel

- (void)setValuesForKeysWithDictionary:(NSDictionary *)keyedValues
{
    self.goodId = [keyedValues[@"id"]stringValue];
    self.goodTitle = keyedValues[@"title"];
    self.createTime = keyedValues[@"createTime"];
    
    if (keyedValues[@"sellerInfo"] && ![keyedValues[@"sellerInfo"] isKindOfClass:[NSNull class]]) {
        UserModel *tempUser = [[UserModel alloc] init];
        [tempUser setValuesForKeysWithDictionary:keyedValues[@"sellerInfo"]];
        self.sellerUser = tempUser;
    }
}

@end
