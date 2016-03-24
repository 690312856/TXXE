//
//  AskListTableViewCell.m
//  TXXE
//
//  Created by 李雨龙 on 15/7/24.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "AskListTableViewCell.h"
#import <SDWebImageCompat.h>
#import "Constants.h"

@implementation AskListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createAskListTableCell];
    }
    return self;
}

- (void)createAskListTableCell
{
    self.askTitle = [[UILabel alloc]initWithFrame:CGRectMake(25, 5, 100, 30)];
    self.askDescription = [[UITextView alloc]initWithFrame:CGRectMake(25, 40, 320, 60)];
    self.askPrice = [[UILabel alloc]initWithFrame:CGRectMake(self.contentView.frame.size.width-60, self.contentView.frame.size.height-30, 60, 30)];
    
    
    [self.contentView addSubview:self.askPrice];
    [self.contentView addSubview:self.askTitle];
    [self.contentView addSubview:self.askDescription];
    
}

- (void)setMyCreateAskModel:(MyCreateAskModel *)myCreateAskModel
{
    if (_myCreateAskModel != myCreateAskModel) {
        _myCreateAskModel = myCreateAskModel;
        for (UIView *view in self.contentView.subviews) {
            if ([view class] == [ImageListView class]) {
                [view removeFromSuperview];
            }
            if ([view class] == [UIButton class]) {
                [view removeFromSuperview];
            }
            if ([view class] == [UIView class]) {
                [view removeFromSuperview];
            }
        }
        CGSize imageSize = [ImageListView sizeofViewWithImageCount:_myCreateAskModel.imageUrlTexts.count];
        self.imageListView = [[ImageListView alloc]initWithFrame:(CGRect){{25.0,105.0},imageSize}];
        self.imageListView.imageList = _myCreateAskModel.imageUrlTexts;
        [self.contentView addSubview:self.imageListView];
        self.askTitle.text = _myCreateAskModel.askTitle;
        self.askDescription.text = _myCreateAskModel.askDescription;
        self.askDescription.editable = NO;
        self.askPrice.text = _myCreateAskModel.askPrice;
        
        self.deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(8, 115+imageSize.height+5, (self.frame.size.width-24)/3.0, 19)];
        self.deleteBtn.backgroundColor = [UIColor whiteColor];
        [self.deleteBtn setTitleColor:[UIColor colorWithRed:200.0/255 green:199.0/255 blue:204.0/255 alpha:1.0] forState:UIControlStateNormal];
        self.deleteBtn.titleLabel.font = [UIFont systemFontOfSize: 10];
        [self.deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        self.changeAskStatusBtn = [[UIButton alloc] initWithFrame:CGRectMake(8+4+(self.frame.size.width-24)/3.0, 115+imageSize.height+5, (self.frame.size.width-24)/3.0, 19)];
        [self.changeAskStatusBtn setTitleColor:[UIColor colorWithRed:200.0/255 green:199.0/255 blue:204.0/255 alpha:1.0] forState:UIControlStateNormal];
        self.changeAskStatusBtn.titleLabel.font = [UIFont systemFontOfSize: 10];
        self.changeAskStatusBtn.backgroundColor = [UIColor whiteColor];
        [self.changeAskStatusBtn addTarget:self action:@selector(changeAskStatusAction:) forControlEvents:UIControlEventTouchUpInside];
        self.confirmBoughtBtn = [[UIButton alloc] initWithFrame:CGRectMake(8+4*2+(self.frame.size.width-24)*2/3.0, 115+imageSize.height+5, (self.frame.size.width-24)/3.0, 19)];
        [self.confirmBoughtBtn setTitleColor:[UIColor colorWithRed:200.0/255 green:199.0/255 blue:204.0/255 alpha:1.0] forState:UIControlStateNormal];
        self.confirmBoughtBtn.titleLabel.font = [UIFont systemFontOfSize: 10];
        self.confirmBoughtBtn.backgroundColor = [UIColor whiteColor];
        [self.confirmBoughtBtn addTarget:self action:@selector(confirmBoughtAction:) forControlEvents:UIControlEventTouchUpInside];
        NSLog(@"llllllllll%@",_myCreateAskModel.status);
        if (_myCreateAskModel.status.integerValue == 1) {
            [self.changeAskStatusBtn setTitle:@"中止" forState:UIControlStateNormal];
            [self.confirmBoughtBtn setTitle:@"已买到" forState:UIControlStateNormal];
            self.deleteBtn.hidden = YES;
            self.changeAskStatusBtn.hidden = NO;
            self.changeAskStatusBtn.frame = CGRectMake(8, 115+imageSize.height+5, (self.frame.size.width-20)/2.0, 19);
            self.confirmBoughtBtn.hidden = NO;
            self.confirmBoughtBtn.frame = CGRectMake(8+4+(self.frame.size.width-20)/2.0, 115+imageSize.height+5, (self.frame.size.width-20)/2.0, 19);
            
            for (int j = 1; j <= 1; j++) {
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width-1)/2.0-j*0.5,115+imageSize.height+7, 1, 15)];
                view.backgroundColor = [UIColor colorWithRed:200.0/255 green:199.0/255 blue:204.0/255 alpha:1.0];
                [self.contentView addSubview:view];
            }
            UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 115+imageSize.height+4, self.frame.size.width, 1)];
            topLine.backgroundColor = [UIColor colorWithRed:200.0/255 green:199.0/255 blue:204.0/255 alpha:1.0];
            UIView *footLine = [[UIView alloc]initWithFrame:CGRectMake(0, 115+imageSize.height+25, self.frame.size.width, 1)];
            footLine.backgroundColor = [UIColor colorWithRed:200.0/255 green:199.0/255 blue:204.0/255 alpha:1.0];
            
            [self.contentView addSubview:topLine];
            [self.contentView addSubview:footLine];
        }else if (_myCreateAskModel.status.integerValue == 3)
        {
            [self.changeAskStatusBtn setTitle:@"继续求购" forState:UIControlStateNormal];
            [self.confirmBoughtBtn setTitle:@"编辑" forState:UIControlStateNormal];
            [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
            self.changeAskStatusBtn.hidden = NO;
            self.confirmBoughtBtn.hidden = NO;
            self.deleteBtn.hidden = NO;
            
            for (int j = 1; j < 3; j++) {
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width-2)/3.0*j+(j-1)*1,115+imageSize.height+7, 1, 15)];
                NSLog(@"66666%f",(self.frame.size.width-2)/3.0*j+j*0.66);
                view.backgroundColor = [UIColor colorWithRed:200.0/255 green:199.0/255 blue:204.0/255 alpha:1.0];
                [self.contentView addSubview:view];
            }
            UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 115+imageSize.height+4, self.frame.size.width, 1)];
            topLine.backgroundColor = [UIColor colorWithRed:200.0/255 green:199.0/255 blue:204.0/255 alpha:1.0];
            UIView *footLine = [[UIView alloc]initWithFrame:CGRectMake(0, 115+imageSize.height+25, self.frame.size.width, 1)];
            footLine.backgroundColor = [UIColor colorWithRed:200.0/255 green:199.0/255 blue:204.0/255 alpha:1.0];
            
            [self.contentView addSubview:topLine];
            [self.contentView addSubview:footLine];
        }else if (_myCreateAskModel.status.integerValue == 2)
        {
            self.changeAskStatusBtn.hidden = YES;
            self.confirmBoughtBtn.hidden = YES;
            [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
            self.deleteBtn.hidden = NO;
            self.deleteBtn.frame = CGRectMake(8, 115+imageSize.height+5,self.frame.size.width-16, 19);
            UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 115+imageSize.height+4, self.frame.size.width, 1)];
            topLine.backgroundColor = [UIColor colorWithRed:200.0/255 green:199.0/255 blue:204.0/255 alpha:1.0];
            UIView *footLine = [[UIView alloc]initWithFrame:CGRectMake(0, 115+imageSize.height+24, self.frame.size.width, 1)];
            footLine.backgroundColor = [UIColor colorWithRed:200.0/255 green:199.0/255 blue:204.0/255 alpha:1.0];
            
            [self.contentView addSubview:topLine];
            [self.contentView addSubview:footLine];

        }
        [self.contentView addSubview:self.deleteBtn];
        [self.contentView addSubview:self.changeAskStatusBtn];
        [self.contentView addSubview:self.confirmBoughtBtn];

    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)deleteAction:(UIButton *)sender
{
    if (self.deleteButtonActionBlock) {
        dispatch_main_async_safe(self.deleteButtonActionBlock);
    }
}

- (void)changeAskStatusAction:(UIButton *)sender
{
    if (self.changeStatusActionBlock) {
        dispatch_main_async_safe(self.changeStatusActionBlock);
    }
}

- (void)confirmBoughtAction:(UIButton *)sender
{
    if ([sender.titleLabel.text  isEqual: @"编辑"]) {
        if (self.editButtonActionBlock) {
            dispatch_main_async_safe(self.editButtonActionBlock);
        }
    }else if([sender.titleLabel.text isEqual:@"已买到"])
    {
        if (self.confirmBoughtActionBlock) {
            dispatch_main_async_safe(self.confirmBoughtActionBlock);
        }
    }
}


@end
