//
//  UIView+Addition.m
//  AnyCheckMobile
//
//  Created by IOS－001 on 14-4-25.
//  Copyright (c) 2014年 xxxxxx. All rights reserved.
//

#import "UIView+Addition.h"
#import "Constants.h"

@implementation UIView (ViewDraw)

- (void)drawCommonBackGroundColor
{
    self.backgroundColor = APP_MAIN_COLOR;
}

- (void)drawCommonShadow
{
    self.layer.shadowOpacity = 1.0;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowRadius = 3;
}

- (void)drawCommonBorderStyle
{
    [self.layer setBorderWidth:1];
    [self.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.layer setCornerRadius:3.0];
    [self.layer setMasksToBounds:YES];
}

- (void)drawBorderStyleWithBorderWidth:(CGFloat)width borderColor:(UIColor *)color cornerRadius:(CGFloat)radius
{
    [self.layer setBorderWidth:width];
    [self.layer setBorderColor:color.CGColor];
    [self.layer setCornerRadius:radius];
    [self.layer setMasksToBounds:YES];
}

- (void)drawBorderColor:(UIColor *)color width:(CGFloat)width
{
    [self.layer setBorderColor:color.CGColor];
    [self.layer setBorderWidth:width];
}

- (void)drawRandomBorderColorWithWidth:(CGFloat)width
{
    [self drawBorderColor:[UIColor brightRandomColor] width:width];
}

@end

@implementation UIView (convenience)

- (CGPoint)frameOrigin
{
    return self.frame.origin;
}

- (void)setFrameOrigin:(CGPoint)newOrigin
{
    self.frame = CGRectMake(newOrigin.x, newOrigin.y, self.frame.size.width, self.frame.size.height);
}

- (CGSize)frameSize
{
    return self.frame.size;
}

- (void)setFrameSize:(CGSize)frameSize
{
    self.frame = (CGRect){self.frame.origin,frameSize};
}

- (CGFloat)frameWidth
{
    return self.frame.size.width;
}

- (void)setFrameWidth:(CGFloat)frameWidth
{
    self.frame = (CGRect){self.frame.origin,CGSizeMake(frameWidth, self.frame.size.height)};
}

- (CGFloat)frameHeight
{
    return self.frame.size.height;
}

- (void)setFrameHeight:(CGFloat)frameHeight
{
    self.frame = (CGRect){self.frame.origin,CGSizeMake(self.frame.size.width, frameHeight)};
}

- (CGFloat)frameX {
	return self.frame.origin.x;
}

- (void)setFrameX:(CGFloat)newX {
	self.frame = CGRectMake(newX, self.frame.origin.y,
							self.frame.size.width, self.frame.size.height);
}

- (CGFloat)frameY {
	return self.frame.origin.y;
}

- (void)setFrameY:(CGFloat)newY {
	self.frame = CGRectMake(self.frame.origin.x, newY,
							self.frame.size.width, self.frame.size.height);
}

@end

