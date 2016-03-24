//
//  SelectLikeCategoryViewController.h
//  TXXE
//
//  Created by 李雨龙 on 15/7/24.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectLikeCategoryViewController : UIViewController

{
    BOOL btn1isSelected;
    BOOL btn2isSelected;
    BOOL btn3isSelected;
    BOOL btn4isSelected;
    BOOL btn5isSelected;
    BOOL btn6isSelected;
}

@property (nonatomic,strong)NSString *preference;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;
@property (weak, nonatomic) IBOutlet UIButton *btn5;
@property (weak, nonatomic) IBOutlet UIButton *btn6;

@property (nonatomic,copy) void(^finishedLikeCategoryPickBlock)(NSString *pickedCategory);
@end
