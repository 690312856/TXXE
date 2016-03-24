//
//  UITextField+Addition.m
//  TongxiaoXiaoEr
//
//  Created by IOS－001 on 15/2/28.
//  Copyright (c) 2015年 xxx.xxxx. All rights reserved.
//

#import "UITextField+Addition.h"
#import "UIView+Addition.h"

@implementation UITextField (Addition)

- (void)setTextCapLeftViewLength:(CGFloat)leftLength leftView:(UIView *)leftView rightViewLength:(CGFloat)rightLength rightView:(UIView *)rightView
{
    if (leftLength > 0) {
        self.leftViewMode = UITextFieldViewModeAlways;
        if (leftView) {
            self.leftView = leftView;
        } else {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, leftLength, self.frameHeight)];
            label.backgroundColor = [UIColor whiteColor];
            self.leftView = label;
        }
    }
    if (rightLength > 0) {
        self.rightViewMode = UITextFieldViewModeAlways;
        if (rightView) {
            self.rightView = rightView;
        } else {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.frameWidth - rightLength, 0, rightLength, self.frameHeight)];
            label.backgroundColor = [UIColor whiteColor];
            self.rightView = label;
        }
    }
}

@end
