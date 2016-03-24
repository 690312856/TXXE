//
//  GoodCollectionViewCell.h
//  TXXE
//
//  Created by River on 15/6/29.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+WebCache.h>

@interface GoodCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodImg;
@property (weak, nonatomic) IBOutlet UILabel *goodTitle;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UITextView *goodDescription;
@property (weak, nonatomic) IBOutlet UIImageView *isNewImageView;

-(void)refreshWithDic:(NSDictionary*)dic;

@end
