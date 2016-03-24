//
//  SimplifyActionSheet.m
//  ShareCommunity
//
//  Created by nofeng on 13-12-3.
//  Copyright (c) 2013年 sf-express. All rights reserved.
//

#import "SimplifyActionSheet.h"
#include <objc/runtime.h>

typedef void(^tempBlock)(NSInteger selectedIndex,NSString *selectedButtonTitle);

static NSString const*const kActionSheetNewPropertyBlockKey = @"kActionSheetNewPropertyBlockKey";

@interface UIActionSheet (SimplifyExtraVariable)
@property (nonatomic , copy)void(^resultBlock)(NSInteger selectedIndex,NSString *selectedButtonTitle);
@end

@implementation UIActionSheet (SimplifyExtraVariable)
@dynamic resultBlock;

- (void)setResultBlock:(void(^)(NSInteger selectedIndex,NSString *selectedButtonTitle))resultBlock
{
    objc_setAssociatedObject(self,(__bridge const void *)(kActionSheetNewPropertyBlockKey),resultBlock,OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (tempBlock)resultBlock
{
    return objc_getAssociatedObject(self, (__bridge const void *)(kActionSheetNewPropertyBlockKey));
    
}

@end

@implementation SimplifyActionSheet

+ (instancetype)shared
{
    static SimplifyActionSheet *zombieActionSheet_ptr = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        zombieActionSheet_ptr = [[SimplifyActionSheet alloc] init];
    });
    return zombieActionSheet_ptr;
}

+ (void)actionSheetWithTitle:(NSString *)title
           cancelButtonTitle:(NSString *)cancelButtonTitle
                showingStyle:(void(^)(UIActionSheet *actionSheetSelf))showBlock
             operationResult:(void (^)(NSInteger selectedIndex,NSString *selectedButtonTitle))resultBlock
      destructiveButtonTitle:(NSString *)destructiveButtonTitle
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
    //显示ActionSheet
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title
                                                             delegate:[SimplifyActionSheet shared]
                                                    cancelButtonTitle:cancelButtonTitle
                                               destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:nil, nil];
    for (NSString *titleString in argumentArray) {
        [actionSheet addButtonWithTitle:titleString];
    }
    actionSheet.resultBlock = resultBlock;
    showBlock(actionSheet);
}

+ (void)actionSheetWithTitle:(NSString *)title
                buttonTitles:(NSArray *)buttonTitles
                showingStyle:(void (^)(UIActionSheet *))showBlock
             operationResult:(void (^)(NSInteger, NSString *))resultBlock
      destructiveButtonIndex:(NSInteger)destructiveButtonIndex
           cancelButtonIndex:(NSInteger)cancelButtonIndex
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title
                                                             delegate:[SimplifyActionSheet shared]
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil, nil];
    for (NSString *titleString in buttonTitles) {
        [actionSheet addButtonWithTitle:titleString];
    }
    actionSheet.destructiveButtonIndex = destructiveButtonIndex;
    actionSheet.cancelButtonIndex = cancelButtonIndex;
    actionSheet.resultBlock = resultBlock;
    showBlock(actionSheet);
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.resultBlock) {
        actionSheet.resultBlock(buttonIndex,[actionSheet buttonTitleAtIndex:buttonIndex]);
        actionSheet.resultBlock = nil;
    }
}

@end
