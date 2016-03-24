//
//  GoodListTableViewCell.m
//  TXXE
//
//  Created by 李雨龙 on 15/7/20.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "GoodListTableViewCell.h"
#import "UIView+Addition.h"
#import "Constants.h"
#import <UIImageView+WebCache.h>

@implementation GoodListTableViewCell

- (void)awakeFromNib {
    // Initialization code
    for (UIView *view in @[self.changeSaleStatusBtn,self.confirmSaleBtn]) {
        [view drawBorderStyleWithBorderWidth:1 borderColor:RGB_COLOR(124, 124, 124, 1) cornerRadius:2];
    }
}

- (void)setMyCreateGoodModel:(MyCreateGoodModel *)myCreateGoodModel
{
    if (_myCreateGoodModel != myCreateGoodModel) {
        _myCreateGoodModel = myCreateGoodModel;
        
        for (UIView *view in self.contentView.subviews) {
            if ([view class] == [UIView class]) {
                [view removeFromSuperview];
            }
        }
        if (_myCreateGoodModel.imageUrlTexts.count != 0) {
            NSURL *url = [NSURL URLWithString:_myCreateGoodModel.imageUrlTexts.firstObject];
            [self.goodImageView sd_setImageWithURL:url placeholderImage:nil];
        }
        self.goodTitleLabel.text = _myCreateGoodModel.goodTitle;
        self.goodDescriptionLabel.text = _myCreateGoodModel.goodDescription;
        self.goodPriceLabel.text = _myCreateGoodModel.goodPrice;
        
        
        [self.changeSaleStatusBtn setTitleColor:RGB_COLOR(155, 155, 155, 1.0) forState:UIControlStateNormal];
        [self.changeSaleStatusBtn.layer setBorderColor:(__bridge CGColorRef)([UIColor whiteColor])];
        [self.confirmSaleBtn setTitleColor:RGB_COLOR(155, 155, 155, 1.0) forState:UIControlStateNormal];
        [self.confirmSaleBtn.layer setBorderColor:(__bridge CGColorRef)([UIColor whiteColor])];
        [self.deleteBtn setTitleColor:RGB_COLOR(155, 155, 155, 1.0) forState:UIControlStateNormal];
        if (_myCreateGoodModel.status.integerValue == 1) {
            //NSLog(@"00000000000");
            [self.changeSaleStatusBtn setTitle:@"下架" forState:UIControlStateNormal];
            [self.confirmSaleBtn setTitle:@"已售出" forState:UIControlStateNormal];
            self.deleteBtn.hidden = YES;
            self.changeSaleStatusBtn.hidden = NO;
            self.confirmSaleBtn.hidden = NO;
            self.leadingA.constant = 0;
            self.leadingB.constant = -((self.frameWidth-20)/2.0+4);
            self.widthb.constant = (self.frameWidth-20)/2.0;
            self.widthc.constant = (self.frameWidth-20)/2.0;
            
            for (int j = 1; j <= 1; j++) {
             UIView *view = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width-1)/2.0, self.confirmSaleBtn.frame.origin.y+2, 1, 15)];
             view.backgroundColor = [UIColor colorWithRed:200.0/255 green:199.0/255 blue:204.0/255 alpha:1.0];
             [self.contentView addSubview:view];
             }
             UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, self.confirmSaleBtn.frame.origin.y, self.frame.size.width, 1)];
             topLine.backgroundColor = [UIColor colorWithRed:200.0/255 green:199.0/255 blue:204.0/255 alpha:1.0];
             UIView *footLine = [[UIView alloc]initWithFrame:CGRectMake(0, self.confirmSaleBtn.frame.origin.y+19, self.frame.size.width, 1)];
             footLine.backgroundColor = [UIColor colorWithRed:200.0/255 green:199.0/255 blue:204.0/255 alpha:1.0];
             
             [self.contentView addSubview:topLine];
             [self.contentView addSubview:footLine];
            
        } else if (_myCreateGoodModel.status.integerValue == 3) {
            //NSLog(@"11111111111");
            [self.changeSaleStatusBtn setTitle:@"上架" forState:UIControlStateNormal];
            [self.confirmSaleBtn setTitle:@"编辑" forState:UIControlStateNormal];
            self.changeSaleStatusBtn.hidden = NO;
            self.confirmSaleBtn.hidden = NO;
            self.deleteBtn.hidden = NO;
            self.leadingA.constant = (self.frameWidth-24)/3.0+4;
            self.leadingB.constant = -((self.frameWidth-24)/3.0+4);
            self.widtha.constant = (self.frameWidth-24)/3.0;
            self.widthb.constant = (self.frameWidth-24)/3.0;
            self.widthc.constant = (self.frameWidth-24)/3.0;
            
            for (int j = 1; j <= 2; j++) {
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width-2)*j/3.0+0.66*j, self.confirmSaleBtn.frame.origin.y+2, 1, 15)];
                view.backgroundColor = [UIColor colorWithRed:200.0/255 green:199.0/255 blue:204.0/255 alpha:1.0];
                [self.contentView addSubview:view];
            }
            UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, self.confirmSaleBtn.frame.origin.y, self.frame.size.width, 1)];
            topLine.backgroundColor = [UIColor colorWithRed:200.0/255 green:199.0/255 blue:204.0/255 alpha:1.0];
            UIView *footLine = [[UIView alloc]initWithFrame:CGRectMake(0, self.confirmSaleBtn.frame.origin.y+19, self.frame.size.width, 1)];
            footLine.backgroundColor = [UIColor colorWithRed:200.0/255 green:199.0/255 blue:204.0/255 alpha:1.0];
            
            [self.contentView addSubview:topLine];
            [self.contentView addSubview:footLine];
            
        } else if (_myCreateGoodModel.status.integerValue == 2) {
            //NSLog(@"222222222222");
            self.changeSaleStatusBtn.hidden = YES;
            self.confirmSaleBtn.hidden = YES;
            self.deleteBtn.hidden = NO;
            self.widtha.constant = self.frameWidth-16;
            
            UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, self.confirmSaleBtn.frame.origin.y, self.frame.size.width, 1)];
            topLine.backgroundColor = [UIColor colorWithRed:200.0/255 green:199.0/255 blue:204.0/255 alpha:1.0];
            UIView *footLine = [[UIView alloc]initWithFrame:CGRectMake(0, self.confirmSaleBtn.frame.origin.y+19, self.frame.size.width, 1)];
            footLine.backgroundColor = [UIColor colorWithRed:200.0/255 green:199.0/255 blue:204.0/255 alpha:1.0];
            
            [self.contentView addSubview:topLine];
            [self.contentView addSubview:footLine];
        }
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)deleteButtonAction:(id)sender {
    if (self.deleteButtonActionBlock) {
        dispatch_main_async_safe(self.deleteButtonActionBlock);
    }
}
- (IBAction)changeStatusButtonAction:(UIButton *)sender {
    if (self.changeStatusActionBlock) {
        dispatch_main_async_safe(self.changeStatusActionBlock);
    }
}
- (IBAction)confirmSaleBtn:(UIButton *)sender {
    if ([sender.titleLabel.text  isEqual: @"编辑"]) {
        if (self.editButtonActionBlock) {
            dispatch_main_async_safe(self.editButtonActionBlock);
        }
    }else if([sender.titleLabel.text isEqual:@"已售出"])
    {
        if (self.confirmSaleActionBlock) {
            dispatch_main_async_safe(self.confirmSaleActionBlock);
        }
    }
    
}

@end
