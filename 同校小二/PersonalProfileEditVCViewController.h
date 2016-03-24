//
//  PersonalProfileEditVCViewController.h
//  TXXE
//
//  Created by 李雨龙 on 15/7/19.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalProfileEditVCViewController : UIViewController
{
    NSString *preference;
}

@property (nonatomic,assign)NSString *avatarText;
@property (nonatomic,assign)NSString *nickName;
@end
