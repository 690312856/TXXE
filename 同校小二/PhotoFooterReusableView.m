//
//  PhotoFooterReusableView.m
//  TXXE
//
//  Created by River on 15/6/11.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "PhotoFooterReusableView.h"
#import <SDWebImageCompat.h>
@implementation PhotoFooterReusableView

- (void)awakeFromNib {
    // Initialization code
}

- (IBAction)addPhotoButtonAction:(UIButton *)sender
{
    if (self.addPhotoButtonAction) {
        dispatch_main_async_safe(self.addPhotoButtonAction);
    }
}
@end
