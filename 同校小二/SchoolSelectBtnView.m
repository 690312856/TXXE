//
//  SchoolSelectBtnView.m
//  TXXE
//
//  Created by River on 15/6/29.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "SchoolSelectBtnView.h"
#import "Constants.h"

@implementation SchoolSelectBtnView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        lastSelectIndex = 0;
        schoolButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth/4, 40)];
        [schoolButton setTitle:@"外校" forState:0];
        schoolButton.backgroundColor = tableBgColor;
        //schoolButton.titleLabel.tintColor = [UIColor colorWithRed:64.0/255 green:64.0/255 blue:64.0/255 alpha:1.0];
        [schoolButton setTitleColor:[UIColor colorWithRed:64.0/255 green:64.0/255 blue:64.0/255 alpha:1.0] forState:UIControlStateNormal];
        schoolButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [schoolButton addTarget:self action:@selector(schoolButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:schoolButton];
    }
    return self;
}

-(void)schoolButtonClicked:(UIButton *)sender
{
    if (lastSelectIndex == 0) {
        if (self.BCallBack) {
            self.BCallBack(-1);
            lastSelectIndex = -1;
            [schoolButton setTitle:@"本校" forState:0];
        }
    }else
    {
        if (self.BCallBack) {
            self.BCallBack(0);
            lastSelectIndex = 0;
            [schoolButton setTitle:@"外校" forState:0];
        }
    }
}
@end
