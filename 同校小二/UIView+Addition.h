//
//  UIView+Addition.h
//  AnyCheckMobile
//
//  Created by IOS－001 on 14-4-25.
//  Copyright (c) 2014年 xxxxxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Addition.h"

@interface UIView (ViewDraw)

/**
 *  为view设置统一的背景
 */
- (void)drawCommonBackGroundColor;

- (void)drawCommonShadow;

- (void)drawCommonBorderStyle;

- (void)drawBorderStyleWithBorderWidth:(CGFloat)width borderColor:(UIColor *)color cornerRadius:(CGFloat)radius;

- (void)drawBorderColor:(UIColor *)color width:(CGFloat)width;

- (void)drawRandomBorderColorWithWidth:(CGFloat)width;

@end

@interface UIView (convenience)

@property (nonatomic) CGPoint frameOrigin;
@property (nonatomic) CGSize frameSize;
@property (nonatomic) CGFloat frameWidth;
@property (nonatomic) CGFloat frameHeight;
@property (nonatomic) CGFloat frameX;
@property (nonatomic) CGFloat frameY;

@end
