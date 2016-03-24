//
//  SimplifyAlertView.m
//  ShareCommunity
//
//  Created by nofeng on 13-8-9.
//  Copyright (c) 2013年 sf-express. All rights reserved.
//

#import "SimplifyAlertView.h"
#include <objc/runtime.h>

static NSString const*const kAlertViewNewPropertyBlockKey = @"kAlertViewNewPropertyKey";

@interface UIAlertView (extraVariable)

@property (nonatomic , copy)AlertViewResultBlock resultBlock;

@end

@implementation UIAlertView (extraVariable)

@dynamic resultBlock;

- (void)setResultBlock:(AlertViewResultBlock)resultBlock
{
    objc_setAssociatedObject(self,kAlertViewNewPropertyBlockKey,resultBlock,OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (AlertViewResultBlock)resultBlock
{
    return objc_getAssociatedObject(self, kAlertViewNewPropertyBlockKey);

}

@end

@interface SimplifyAlertView ()

@end

@implementation SimplifyAlertView

- (void)dealloc
{
    [super dealloc];
}

+ (instancetype)shared
{
    static SimplifyAlertView *zombieAlertView_ptr = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        zombieAlertView_ptr = [[SimplifyAlertView alloc] init];
    });
    return zombieAlertView_ptr;
}

- (void)alertWithTitle:(NSString *)title
               message:(NSString *)message
       operationResult:(AlertViewResultBlock)resultBlock
     cancelButtonTitle:(NSString *)cancelButtonTitle
     otherButtonTitles:(NSString *)otherButtonTitles
{
//    va_list argumentList;//保存函数参数的结构
//    id eachObject;//存放的字符串参数
//    va_start(argumentList, otherButtonTitles);
//    NSMutableArray *argumentArray = [NSMutableArray array];
//    if ([otherButtonTitles isKindOfClass:[NSString class]]) {
//        [argumentArray addObject:otherButtonTitles];
//    }
//    while (true) {
//        eachObject = va_arg(argumentList, id);
//        //        NSLog(@"参数:%@,类型:%@,是不是字符串:%d",eachObject,[eachObject class],[eachObject isKindOfClass:[NSString class]]);
//        if (!eachObject) {
//            break;
//        } else {
//            if ([otherButtonTitles isKindOfClass:[NSString class]]) {
//                [argumentArray addObject:eachObject];
//            }
//        }
//    }
//    va_end(argumentList);
//    
    //显示ALertView
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:[SimplifyAlertView shared] cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];

    alertView.resultBlock = resultBlock;
    alertView.delegate = [SimplifyAlertView shared];
    [alertView show];
    [alertView release];
}

+ (void)alertWithTitle:(NSString *)title
               message:(NSString *)message
       operationResult:(AlertViewResultBlock)resultBlock
     cancelButtonTitle:(NSString *)cancelButtonTitle
     otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    va_list argumentList;//保存函数参数的结构
    id eachObject;//存放的字符串参数
    va_start(argumentList, otherButtonTitles);
    NSMutableArray *argumentArray = [NSMutableArray array];
    if ([otherButtonTitles isKindOfClass:[NSString class]]) {
        [argumentArray addObject:otherButtonTitles];
    }
    while (true) {
        eachObject = va_arg(argumentList, id);
//        NSLog(@"参数:%@,类型:%@,是不是字符串:%d",eachObject,[eachObject class],[eachObject isKindOfClass:[NSString class]]);
        if (!eachObject) {
            break;
        } else {
            if ([otherButtonTitles isKindOfClass:[NSString class]]) {
                [argumentArray addObject:eachObject];
            }
        }
    }
    va_end(argumentList);

    //显示ALertView
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:[SimplifyAlertView shared] cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil, nil];
    for (NSString *titleString in argumentArray) {
        [alertView addButtonWithTitle:titleString];
    }
    alertView.resultBlock = resultBlock;
    alertView.delegate = [SimplifyAlertView shared];
    [alertView show];
    [alertView release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    NSLog(@"点击了%d",buttonIndex);
    if (alertView.resultBlock) {
        alertView.resultBlock(buttonIndex);
        alertView.resultBlock = nil;
    }
}

@end
