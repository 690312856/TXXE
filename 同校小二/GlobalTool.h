//
//  GlobalTool.h
//  TongxiaoXiaoEr
//
//  Created by IOS－001 on 15/3/1.
//  Copyright (c) 2015年 xxx.xxxx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalTool : NSObject

+ (NSUInteger)DeviceSystemMajorVersion;

+ (void)tipsAlertWithTitle:(NSString *)title message:(NSString *)message cancelBtnTitle:(NSString *)btnTitle;

+ (instancetype)sharedInstance;

+ (NSString *)randomCaptchaCharacters;

- (NSInteger)randomIntegerBetween:(NSInteger)from to:(NSInteger)to;

@end
