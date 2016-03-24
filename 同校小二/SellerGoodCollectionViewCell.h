//
//  SellerGoodCollectionViewCell.h
//  TXXE
//
//  Created by 李雨龙 on 15/7/31.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCreateGoodModel.h"

@interface SellerGoodCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIImageView *isNewImageView;
@property (weak, nonatomic) IBOutlet UITextView *gooddescription;

@property (nonatomic,strong)MyCreateGoodModel *myGoodItem;
- (void)setMyGoodItem:(MyCreateGoodModel *)myGoodItem;
@end
