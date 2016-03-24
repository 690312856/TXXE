//
//  ProfileEditingTableViewCell.h
//  TXXE
//
//  Created by 李雨龙 on 15/7/19.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileEditingTableViewCell : UITableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *profileItemLabel;
@property (weak, nonatomic) IBOutlet UITextField *profileItemTextField;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (nonatomic , copy) void(^textFieldValueChanged)(NSString *text);
@end
