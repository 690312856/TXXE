//
//  UserIdentificationView.h
//  TongxiaoXiaoEr
//
//  Created by IOS－001 on 15/3/12.
//  Copyright (c) 2015年 com.xxxxxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserIdentificationView : UIView

@property (nonatomic , copy) void(^confirmBtnActionBlock)(BOOL isSucceed);
@property (weak, nonatomic) IBOutlet UIButton *confirmbBtn;

@end
