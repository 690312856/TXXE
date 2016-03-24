//
//  AskCollectionListTableViewCell.m
//  TXXE
//
//  Created by 李雨龙 on 15/7/24.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "AskCollectionListTableViewCell.h"
#import <SDWebImageCompat.h>
#import "Constants.h"

@implementation AskCollectionListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createAskCollectionCell];
    }
    return self;
}

- (void)createAskCollectionCell
{
    self.askTitle = [[UILabel alloc]initWithFrame:CGRectMake(25, 5, 100, 30)];
    self.askDescription = [[UITextView alloc]initWithFrame:CGRectMake(25, 40, 320, 60)];
    self.askDescription.editable = NO;
    self.askPrice = [[UILabel alloc]initWithFrame:CGRectMake(self.contentView.frame.size.width-60, self.contentView.frame.size.height-30, 60, 30)];
    [self.contentView addSubview:self.askPrice];
    [self.contentView addSubview:self.askDescription];
    [self.contentView addSubview:self.askTitle];
}
- (void)setMyCollectionAskModel:(myCollectionAskModel *)myCollectionAskModel
{
    if (_myCollectionAskModel != myCollectionAskModel) {
        _myCollectionAskModel = myCollectionAskModel;
        
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
        
        if (_myCollectionAskModel.imageUrlTexts.count == 0) {
            self.cancelCollectionBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 115, self.frame.size.width-10, 19)];
            [self.cancelCollectionBtn setTitleColor:[UIColor colorWithRed:200.0/255 green:199.0/255 blue:204.0/255 alpha:1.0] forState:UIControlStateNormal];
            self.cancelCollectionBtn.titleLabel.font = [UIFont systemFontOfSize: 13];
            self.cancelCollectionBtn.backgroundColor = [UIColor whiteColor];
            [self.cancelCollectionBtn addTarget:self action:@selector(cancelCollectionAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.cancelCollectionBtn setTitle:@"取消收藏" forState:UIControlStateNormal];
            [self.contentView addSubview:self.cancelCollectionBtn];
            UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 114, self.frame.size.width, 1)];
            topLine.backgroundColor = [UIColor colorWithRed:200.0/255 green:199.0/255 blue:204.0/255 alpha:1.0];
            UIView *footLine = [[UIView alloc]initWithFrame:CGRectMake(0, 115+19, self.frame.size.width, 1)];
            footLine.backgroundColor = [UIColor colorWithRed:200.0/255 green:199.0/255 blue:204.0/255 alpha:1.0];
            
            [self.contentView addSubview:topLine];
            [self.contentView addSubview:footLine];

            self.askTitle.text = _myCollectionAskModel.askTitle;
            self.askDescription.text = _myCollectionAskModel.askDescription;
            self.askPrice.text = _myCollectionAskModel.askPrice;
        }else{
    
        CGSize imageSize = [ImageListView sizeofViewWithImageCount:_myCollectionAskModel.imageUrlTexts.count];
        self.imageListView = [[ImageListView alloc]initWithFrame:(CGRect){{25.0,105.0},imageSize}];
        self.imageListView.imageList = _myCollectionAskModel.imageUrlTexts;
        [self.contentView addSubview:self.imageListView];
        self.cancelCollectionBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 115+imageSize.height, self.frame.size.width-10, 19)];
        [self.cancelCollectionBtn setTitleColor:[UIColor colorWithRed:200.0/255 green:199.0/255 blue:204.0/255 alpha:1.0] forState:UIControlStateNormal];
        self.cancelCollectionBtn.titleLabel.font = [UIFont systemFontOfSize: 10];
        self.cancelCollectionBtn.backgroundColor = [UIColor whiteColor];
        [self.cancelCollectionBtn addTarget:self action:@selector(cancelCollectionAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.cancelCollectionBtn setTitle:@"取消收藏" forState:UIControlStateNormal];
        [self.contentView addSubview:self.cancelCollectionBtn];
        
        UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 114+imageSize.height, self.frame.size.width, 1)];
        topLine.backgroundColor = [UIColor colorWithRed:200.0/255 green:199.0/255 blue:204.0/255 alpha:1.0];
        UIView *footLine = [[UIView alloc]initWithFrame:CGRectMake(0, 115+imageSize.height+19, self.frame.size.width, 1)];
        footLine.backgroundColor = [UIColor colorWithRed:200.0/255 green:199.0/255 blue:204.0/255 alpha:1.0];
        
        [self.contentView addSubview:topLine];
        [self.contentView addSubview:footLine];
        self.askTitle.text = _myCollectionAskModel.askTitle;
        self.askDescription.text = _myCollectionAskModel.askDescription;
        self.askPrice.text = _myCollectionAskModel.askPrice;
        }
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)cancelCollectionAction:(UIButton *)sender
{
    if (self.cancelCollectedButtonActionBlock) {
        dispatch_main_async_safe(self.cancelCollectedButtonActionBlock);
    }
}

@end
