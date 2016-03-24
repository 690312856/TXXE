//
//  PersonalPageTableViewCell.h
//  TXXE
//
//  Created by River on 15/6/27.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalPageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *menuTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *verifyButton;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;


@property (nonatomic ,copy) void(^verifyButtonAction)(void);
@end
