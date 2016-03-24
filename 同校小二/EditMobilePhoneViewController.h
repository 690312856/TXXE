//
//  EditMobilePhoneViewController.h
//  TXXE
//
//  Created by 李雨龙 on 15/7/27.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditMobilePhoneViewController : UIViewController
@property (nonatomic,copy) void(^finishedMobilePhonePickBlock)(NSString *pickedMobilePhone);
@end
