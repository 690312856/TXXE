//
//  DiscoveryGoodCollectionViewCell.h
//  TXXE
//
//  Created by River on 15/6/7.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiscoveryGoodItemModel.h"

@interface DiscoveryGoodCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIImageView *isNewImageView;
@property (weak, nonatomic) IBOutlet UITextView *gooddescription;

@property (nonatomic,strong) DiscoveryGoodItemModel *goodItem;

@end
