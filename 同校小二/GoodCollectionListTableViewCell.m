//
//  GoodCollectionListTableViewCell.m
//  TXXE
//
//  Created by 李雨龙 on 15/7/24.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "GoodCollectionListTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "Constants.h"

@implementation GoodCollectionListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createGoodCollectionCell];
    }
    return self;
    
}

- (void)createGoodCollectionCell
{
    
    self.goodTitle = [[UILabel alloc]initWithFrame:CGRectMake(130, 5, 200, 30)];
    self.goodDescription = [[UITextView alloc]initWithFrame:CGRectMake(130, 40, 240, 40)];
    self.goodDescription.editable = NO;
    self.goodPrice = [[UILabel alloc]initWithFrame:CGRectMake(300, 5, 80, 20)];
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 120, 100)];
    [imageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds  = YES;
    self.cancelCollectionBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 115, self.frame.size.width-10, 30)];
    self.cancelCollectionBtn.backgroundColor = [UIColor greenColor];
    [self.contentView addSubview:imageView];
    [self.contentView addSubview:self.goodTitle];
    [self.contentView addSubview:self.goodDescription];
    [self.contentView addSubview:self.goodPrice];
    
     
    
}
- (void)setMyCollectionGoodModel:(myCollectionGoodModel *)myCollectionGoodModel
{
    if (_myCollectionGoodModel != myCollectionGoodModel) {
        _myCollectionGoodModel = myCollectionGoodModel;
        
        for (UIView *view in self.contentView.subviews) {
            
            if ([view class] == [UIButton class]) {
                [view removeFromSuperview];
                
            }
            if ([view class] == [UIView class]) {
                [view removeFromSuperview];
                
            }
        }
        self.cancelCollectionBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 115, self.frame.size.width-10, 19)];
        [self.cancelCollectionBtn setTitleColor:[UIColor colorWithRed:200.0/255 green:199.0/255 blue:204.0/255 alpha:1.0] forState:UIControlStateNormal];
        self.cancelCollectionBtn.titleLabel.font = [UIFont systemFontOfSize: 10];
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
        NSLog(@"0000000000000000%@",_myCollectionGoodModel.imageUrlTexts.firstObject);
        NSURL *url = [NSURL URLWithString:_myCollectionGoodModel.imageUrlTexts.firstObject];
        [imageView sd_setImageWithURL:url placeholderImage:nil];
        NSLog(@"%@",_myCollectionGoodModel.goodTitle);
        self.goodTitle.text = _myCollectionGoodModel.goodTitle;
        self.goodDescription.text = _myCollectionGoodModel.goodDescription;
        self.goodPrice.text = _myCollectionGoodModel.goodPrice;
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
