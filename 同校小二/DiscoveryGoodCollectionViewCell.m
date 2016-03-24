//
//  DiscoveryGoodCollectionViewCell.m
//  TXXE
//
//  Created by River on 15/6/7.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "DiscoveryGoodCollectionViewCell.h"
#import <UIImageView+WebCache.h>

@implementation DiscoveryGoodCollectionViewCell

- (void)setGoodItem:(DiscoveryGoodItemModel *)goodItem
{
    if (_goodItem != goodItem) {
        _goodItem = goodItem;
        NSURL *url = [NSURL URLWithString:_goodItem.goodImageUrlTexts.firstObject];
        [self.imgView sd_setImageWithURL:url placeholderImage:nil];
        [self.imgView setContentScaleFactor:[[UIScreen mainScreen] scale]];
        self.imgView.contentMode = UIViewContentModeScaleAspectFill;
        self.imgView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.imgView.clipsToBounds  = YES;
        self.nameLabel.text = _goodItem.goodTitle;
        self.priceLabel.text = [NSString stringWithFormat:@"￥%@",_goodItem.price];
        self.gooddescription.text = _goodItem.goodDescription;
        [self.isNewImageView setImage:[UIImage imageNamed:@"tag"]];
        if (_goodItem.isNew == YES) {
            
            [self.isNewImageView setHidden:NO];
        }else
        {
            [self.isNewImageView setHidden:YES];
        }
        NSLog(@"@@@@@@@@@@@");
        NSLog(@"%@",_goodItem.sellerUser.school.schoolName);
        self.addressLabel.text = _goodItem.tradeLocation;
        self.addressLabel.textColor = [UIColor colorWithRed:155.0/255 green:155.0/255 blue:155.0/255 alpha:1.0];
        
    }
}

/*- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    //[super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}*/

















@end
