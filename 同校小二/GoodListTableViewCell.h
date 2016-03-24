//
//  GoodListTableViewCell.h
//  TXXE
//
//  Created by 李雨龙 on 15/7/20.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCreateGoodModel.h"

@interface GoodListTableViewCell : UITableViewCell

@property (nonatomic,strong)MyCreateGoodModel *myCreateGoodModel;
@property (weak, nonatomic) IBOutlet UIButton *changeSaleStatusBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmSaleBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIImageView *goodImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodPriceLabel;
@property (weak, nonatomic) IBOutlet UITextView *goodDescriptionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingA;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widtha;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthc;



@property (nonatomic , copy) void(^editButtonActionBlock)(void);
@property (nonatomic , copy) void(^changeStatusActionBlock)(void);
@property (nonatomic , copy) void(^confirmSaleActionBlock)(void);
@property (nonatomic , copy) void(^deleteButtonActionBlock)(void);
@end
