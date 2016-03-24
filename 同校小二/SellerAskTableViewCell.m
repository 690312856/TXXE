//
//  SellerAskTableViewCell.m
//  TXXE
//
//  Created by 李雨龙 on 15/7/31.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "SellerAskTableViewCell.h"
#import <SDWebImageCompat.h>

@implementation SellerAskTableViewCell

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
        }
        CGSize imageSize = [ImageListView sizeofViewWithImageCount:_myCreateAskModel.imageUrlTexts.count];
        self.imageListView = [[ImageListView alloc]initWithFrame:(CGRect){{25.0,105.0},imageSize}];
        self.imageListView.imageList = _myCreateAskModel.imageUrlTexts;
        [self.contentView addSubview:self.imageListView];
        self.askTitle.text = _myCreateAskModel.askTitle;
        self.askDescription.text = _myCreateAskModel.askDescription;
        
        self.askPrice.text = _myCreateAskModel.askPrice;
        
        self.collectionBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 115+imageSize.height, (self.frame.size.width-2)/3.0, 19)];
        self.collectionBtn.backgroundColor = [UIColor greenColor];
        [self.collectionBtn setTitle:@"收藏" forState:UIControlStateNormal];
        [self.collectionBtn addTarget:self action:@selector(collectionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
        self.commentBtn = [[UIButton alloc] initWithFrame:CGRectMake((self.frame.size.width-2)/3.0+1, 115+imageSize.height, (self.frame.size.width-2)/3.0, 19)];
        self.commentBtn.backgroundColor = [UIColor greenColor];
        [self.commentBtn addTarget:self action:@selector(commentBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.commentBtn setTitle:@"评论" forState:UIControlStateNormal];
        
        
        self.contactBtn = [[UIButton alloc] initWithFrame:CGRectMake((self.frame.size.width-2)*2/3.0+2, 115+imageSize.height,(self.frame.size.width-2)/3.0, 19)];
        self.contactBtn.backgroundColor = [UIColor greenColor];
        [self.contactBtn setTitle:@"联系买家" forState:UIControlStateNormal];
        [self.contactBtn addTarget:self action:@selector(contactAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.collectionBtn];
        [self.contentView addSubview:self.commentBtn];
        [self.contentView addSubview:self.contactBtn];
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)collectionBtnAction:(UIButton *)sender
{
    if (self.collectionButtonActionBlock) {
        dispatch_main_async_safe(self.collectionButtonActionBlock);
    }
}

- (void)contactAction:(UIButton *)sender
{
    if (self.contactButtonActionBlock) {
        dispatch_main_async_safe(self.contactButtonActionBlock);
    }
}



@end
