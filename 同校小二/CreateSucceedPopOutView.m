//
//  CreateSucceedPopOutView.m
//  TongxiaoXiaoEr
//
//  Created by IOS－001 on 15/3/9.
//  Copyright (c) 2015年 xxx.xxxx. All rights reserved.
//

#import "CreateSucceedPopOutView.h"
#import "UIView+Addition.h"
#import "Constants.h"
#import <SDWebImageCompat.h>

@interface CreateSucceedPopOutView ()
@property (weak, nonatomic) IBOutlet UIView *innerContentView;

@end

@implementation CreateSucceedPopOutView

- (void)awakeFromNib
{
    [self.innerContentView drawBorderStyleWithBorderWidth:2 borderColor:APP_MAIN_COLOR cornerRadius:10];
}

- (IBAction)confirmButtonAction:(UIButton *)sender
{
    if (self.confirmBtnActionBlock) {
        dispatch_main_async_safe(self.confirmBtnActionBlock);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
