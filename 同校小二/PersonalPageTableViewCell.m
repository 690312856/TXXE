//
//  PersonalPageTableViewCell.m
//  TXXE
//
//  Created by River on 15/6/27.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "PersonalPageTableViewCell.h"
#import <SDWebImageCompat.h>
@implementation PersonalPageTableViewCell

- (void)awakeFromNib{
}
- (IBAction)verifyButtonAction:(UIButton *)sender {
    if (self.verifyButtonAction) {
        dispatch_main_async_safe(self.verifyButtonAction);
    }
}
@end
