//
//  TapImageView.m
//  TXXE
//
//  Created by 李雨龙 on 15/7/21.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "TapImageView.h"

@implementation TapImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.userInteractionEnabled = YES;
    }
    return self;
}



@end
