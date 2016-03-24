//
//  CreateSucceedPopOutView.h
//  TongxiaoXiaoEr
//
//  Created by IOS－001 on 15/3/9.
//  Copyright (c) 2015年 xxx.xxxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateSucceedPopOutView : UIView

@property (nonatomic , copy) void(^confirmBtnActionBlock)(void);
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
