//
//  TapImageView.h
//  TXXE
//
//  Created by 李雨龙 on 15/7/21.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TapImageViewDelegate <NSObject>

- (void)tappedWithObject:(id) sender;

@end

@interface TapImageView : UIImageView

@property (nonatomic, strong) id identifier;
@property (weak) id<TapImageViewDelegate> t_delegate;
@end
