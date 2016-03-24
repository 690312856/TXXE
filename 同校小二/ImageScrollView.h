//
//  ImageScrollView.h
//  TXXE
//
//  Created by 李雨龙 on 15/7/21.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageScrollViewDelegate <NSObject>

- (void) tapImageViewTappedWithObject:(id) sender;

@end

@interface ImageScrollView : UIScrollView

@property (weak) id<ImageScrollViewDelegate>i_delegate;

- (void) setContentWithFrame:(CGRect)rect;
- (void) setImage:(UIImage *)image;
- (void) setAnimationRect;
- (void) rechangeInitRect;
@end
