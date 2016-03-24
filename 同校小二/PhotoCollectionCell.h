//
//  PhotoCollectionCell.h
//  TXXE
//
//  Created by River on 15/6/11.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageModel.h"

typedef void(^clickCallBack)(UIButton *sender);
@interface PhotoCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property(nonatomic,strong)clickCallBack clickBlock;
@property (nonatomic,strong) ImageModel *imageModel;
@end
