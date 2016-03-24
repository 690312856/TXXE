//
//  UITextField+Addition.h
//  TongxiaoXiaoEr
//
//  Created by IOS－001 on 15/2/28.
//  Copyright (c) 2015年 xxx.xxxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Addition)

/**
 *  设置UITextField文字左右边距
 *
 *  @param leftLength  左边距
 *  @param leftView    左view
 *  @param rightLength 右边距
 *  @param rightView   右view
 */
- (void)setTextCapLeftViewLength:(CGFloat)leftLength leftView:(UIView *)leftView  rightViewLength:(CGFloat)rightLength rightView:(UIView *)rightView;

@end
