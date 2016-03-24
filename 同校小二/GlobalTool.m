//
//  GlobalTool.m
//  TongxiaoXiaoEr
//
//  Created by IOS－001 on 15/3/1.
//  Copyright (c) 2015年 xxx.xxxx. All rights reserved.
//

#import "GlobalTool.h"
#import <UIKit/UIKit.h>

@interface GlobalTool ()

@property (nonatomic , strong) NSArray *captchaCharaters;

@end

@implementation GlobalTool

+ (NSUInteger)DeviceSystemMajorVersion
{
    static NSUInteger _deviceSystemMajorVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _deviceSystemMajorVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
    });
    return _deviceSystemMajorVersion;
}

+ (void)tipsAlertWithTitle:(NSString *)title message:(NSString *)message cancelBtnTitle:(NSString *)btnTitle
{
    [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:btnTitle otherButtonTitles:nil, nil] show];
}

- (NSArray *)captchaCharaters
{
    if (!_captchaCharaters) {
        _captchaCharaters = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"a",@"b",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"q",@"r",@"t",@"y",@"A",@"B",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"Q",@"R",@"T",@"Y"];
    }
    return _captchaCharaters;
}

- (NSInteger)randomIntegerBetween:(NSInteger)from to:(NSInteger)to
{
    if (from >= to) {
        return -1;
    }
    return arc4random() % (to - from + 1) + from;
}

+ (instancetype)sharedInstance
{
    static GlobalTool *tool_ptr = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool_ptr = [[GlobalTool alloc] init];
    });
    return tool_ptr;
}

+ (NSString *)randomCaptchaCharacters
{
    NSMutableString *targetCaptcha = [NSMutableString string];
    for (NSInteger i = 0; i != 5; i ++) {
        NSInteger index = [[GlobalTool sharedInstance] randomIntegerBetween:0 to:[[GlobalTool sharedInstance] captchaCharaters].count - 1];
        NSString *captcha = [[GlobalTool sharedInstance] captchaCharaters][index];
        [targetCaptcha appendString:captcha];
    }
    return targetCaptcha;
}

@end
