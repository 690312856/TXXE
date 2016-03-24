//
//  BaseFuncionModel.m
//  TongxiaoXiaoEr
//
//  Created by IOS－001 on 15/3/1.
//  Copyright (c) 2015年 xxx.xxxx. All rights reserved.
//

#import "BaseFuncionModel.h"

@implementation BaseFuncionModel

- (void)setValuesForKeysWithDictionary:(NSDictionary *)keyedValues
{
    self.functionId = [keyedValues[@"id"] stringValue];
    NSLog(@"%@",self.functionId);
    self.functionName = [keyedValues[@"name"] stringValue];
    NSLog(@"%@",self.functionName);
    self.imageUrlText = [keyedValues[@"images"] firstObject];
    NSLog(@"%@",self.imageUrlText);
}

- (NSURL *)imageUrl
{
    if (self.imageUrlText.length == 0) {
        return nil;
    } else {
        return [NSURL URLWithString:self.imageUrlText];
    }
}

@end
