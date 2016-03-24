//
//  SelectLikeCategoryViewController.m
//  TXXE
//
//  Created by 李雨龙 on 15/7/24.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "SelectLikeCategoryViewController.h"

@interface SelectLikeCategoryViewController ()

@end

@implementation SelectLikeCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(save)];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.0/255 green:191.0/255 blue:121.0/255 alpha:1.0];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    btn1isSelected = NO;
    btn2isSelected = NO;
    btn3isSelected = NO;
    btn4isSelected = NO;
    btn5isSelected = NO;
    btn6isSelected = NO;
    [self.btn1 setBackgroundImage:[UIImage imageNamed:@"Mask1"] forState:UIControlStateNormal];
    [self.btn2 setBackgroundImage:[UIImage imageNamed:@"Mask2"] forState:UIControlStateNormal];
    [self.btn3 setBackgroundImage:[UIImage imageNamed:@"Mask3"] forState:UIControlStateNormal];
    [self.btn4 setBackgroundImage:[UIImage imageNamed:@"Mask4"] forState:UIControlStateNormal];
    [self.btn5 setBackgroundImage:[UIImage imageNamed:@"Mask5"] forState:UIControlStateNormal];
    [self.btn6 setBackgroundImage:[UIImage imageNamed:@"Mask6"] forState:UIControlStateNormal];
    if (![self.preference isEqualToString:@""]) {
        NSArray *list = [self.preference componentsSeparatedByString:@","];
        for (NSString *string in list) {
            if ([string isEqualToString:@"5"]) {
                btn1isSelected = YES;
                [self.btn1 setBackgroundImage:[UIImage imageNamed:@"Mask1-1"] forState:UIControlStateNormal];
            }else if ([string isEqualToString:@"4"])
            {
                btn2isSelected = YES;
                [self.btn2 setBackgroundImage:[UIImage imageNamed:@"Mask2-1"] forState:UIControlStateNormal];
            }
            else if ([string isEqualToString:@"7"])
            {
                btn3isSelected = YES;
                [self.btn3 setBackgroundImage:[UIImage imageNamed:@"Mask3-1"] forState:UIControlStateNormal];
            }
            else if ([string isEqualToString:@"2"])
            {
                btn4isSelected = YES;
                [self.btn4 setBackgroundImage:[UIImage imageNamed:@"Mask4-1"] forState:UIControlStateNormal];
            }
            else if ([string isEqualToString:@"6"])
            {
                btn5isSelected = YES;
                [self.btn5 setBackgroundImage:[UIImage imageNamed:@"Mask5-1"] forState:UIControlStateNormal];
            }else
            {
                btn6isSelected = YES;
                [self.btn6 setBackgroundImage:[UIImage imageNamed:@"Mask6-1"] forState:UIControlStateNormal];
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)changeBtn1:(UIButton *)sender {
    btn1isSelected = !btn1isSelected;
   // self.btn1.backgroundColor = [self changeColor:btn1isSelected];
    [self.btn1 setBackgroundImage:[self changeImage:btn1isSelected on:self.btn1] forState:UIControlStateNormal];
}
- (IBAction)changeBtn2:(UIButton *)sender {
    btn2isSelected = !btn2isSelected;
    //self.btn2.backgroundColor = [self changeColor:btn2isSelected];
    [self.btn2 setBackgroundImage:[self changeImage:btn2isSelected on:self.btn2] forState:UIControlStateNormal];
}
- (IBAction)changeBtn3:(UIButton *)sender {
    btn3isSelected = !btn3isSelected;
    //self.btn3.backgroundColor = [self changeColor:btn3isSelected];
    [self.btn3 setBackgroundImage:[self changeImage:btn3isSelected on:self.btn3] forState:UIControlStateNormal];
}
- (IBAction)changeBtn4:(UIButton *)sender {
    btn4isSelected = !btn4isSelected;
    //self.btn4.backgroundColor = [self changeColor:btn4isSelected];
    [self.btn4 setBackgroundImage:[self changeImage:btn4isSelected on:self.btn4] forState:UIControlStateNormal];
}
- (IBAction)changeBtn5:(UIButton *)sender {
    btn5isSelected = !btn5isSelected;
    //self.btn5.backgroundColor = [self changeColor:btn5isSelected];
    [self.btn5 setBackgroundImage:[self changeImage:btn5isSelected on:self.btn5] forState:UIControlStateNormal];
}
- (IBAction)changeBtn6:(UIButton *)sender {
    btn6isSelected = !btn6isSelected;
    //self.btn6.backgroundColor = [self changeColor:btn6isSelected];
    [self.btn6 setBackgroundImage:[self changeImage:btn6isSelected on:self.btn6] forState:UIControlStateNormal];
}

-(UIImage *)changeImage:(BOOL)isSelected on:(UIButton *)btn
{
    UIImage * image  = [[UIImage alloc]init];
    if (btn.tag == 0) {
        
        if (isSelected == YES) {
            image = [UIImage imageNamed:@"Mask1-1"];
        }else
        {
            image = [UIImage imageNamed:@"Mask1"];
        }
    }else if(btn.tag == 1)
    {
        if (isSelected == YES) {
            image = [UIImage imageNamed:@"Mask2-1"];
        }else
        {
            image = [UIImage imageNamed:@"Mask2"];
        }
    }else if(btn.tag == 2)
    {
        if (isSelected == YES) {
            image = [UIImage imageNamed:@"Mask3-1"];
        }else
        {
            image = [UIImage imageNamed:@"Mask3"];
        }
    }else if(btn.tag == 3)
    {
        if (isSelected == YES) {
            image = [UIImage imageNamed:@"Mask4-1"];
        }else
        {
            image = [UIImage imageNamed:@"Mask4"];
        }
    }else if(btn.tag == 4)
    {
        if (isSelected == YES) {
            image = [UIImage imageNamed:@"Mask5-1"];
        }else
        {
            image = [UIImage imageNamed:@"Mask5"];
        }
    }else if(btn.tag == 5)
    {
        if (isSelected == YES) {
            image = [UIImage imageNamed:@"Mask6-1"];
        }else
        {
            image = [UIImage imageNamed:@"Mask6"];
        }
    }
    
    return image;
}
- (UIColor *)changeColor:(BOOL)isSelected
{
    if (isSelected == YES) {
        return [UIColor redColor];
    }else
    {
        return [UIColor greenColor];
    }
}

- (void)save
{
    NSMutableString *string =[[NSMutableString alloc]init];
    if (btn1isSelected == YES) {
        [string appendString:@"5,"];
    }
    if (btn2isSelected == YES) {
        [string appendString:@"4,"];
    }
    if (btn3isSelected == YES) {
        [string appendString:@"7,"];
    }
    if (btn4isSelected == YES) {
        [string appendString:@"2,"];
    }
    if (btn5isSelected == YES) {
        [string appendString:@"6,"];
    }
    if (btn6isSelected == YES) {
        [string appendString:@"13,"];
    }
    NSLog(@"%@",string);
    if (string.length>1) {
        NSString *backString = [string substringToIndex:string.length-1];
        if (self.finishedLikeCategoryPickBlock) {
            self.finishedLikeCategoryPickBlock(backString);
        }
    }else{
        NSString *backString = string;
        if (self.finishedLikeCategoryPickBlock) {
            self.finishedLikeCategoryPickBlock(backString);
        }
    }
    
    /*if (self.finishedLikeCategoryPickBlock) {
        self.finishedLikeCategoryPickBlock(backString);
    }*/
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
