//
//  SellerGoodCollectionViewCell.m
//  TXXE
//
//  Created by 李雨龙 on 15/7/31.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "SellerGoodCollectionViewCell.h"
#import <UIImageView+WebCache.h>

@implementation SellerGoodCollectionViewCell

- (void)setMyGoodItem:(MyCreateGoodModel *)myGoodItem
{
    if (_myGoodItem!= myGoodItem) {
        _myGoodItem =myGoodItem;
        NSURL *url = [NSURL URLWithString:_myGoodItem.imageUrlTexts.firstObject];
        [self.imgView sd_setImageWithURL:url placeholderImage:nil];
        [self.imgView setContentScaleFactor:[[UIScreen mainScreen] scale]];
        self.imgView.contentMode = UIViewContentModeScaleAspectFill;
        self.imgView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.imgView.clipsToBounds  = YES;
        self.nameLabel.text = _myGoodItem.goodTitle;
        self.priceLabel.text = [NSString stringWithFormat:@"￥%@",_myGoodItem.goodPrice];
        NSLog(@"@@@@@@@@@@@");
        self.gooddescription.text = _myGoodItem.goodDescription;
        [self.isNewImageView setImage:[UIImage imageNamed:@"tag"]];
        if (_myGoodItem.isNew == YES) {
            
            [self.isNewImageView setHidden:NO];
        }else
        {
            [self.isNewImageView setHidden:YES];
        }
       self.addressLabel.text = _myGoodItem.school;
        self.addressLabel.textColor = [UIColor colorWithRed:155.0/255 green:155.0/255 blue:155.0/255 alpha:1.0];
    }
}




@end
