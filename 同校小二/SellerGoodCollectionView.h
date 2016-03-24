//
//  SellerGoodCollectionView.h
//  TXXE
//
//  Created by 李雨龙 on 15/7/26.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCreateGoodModel.h"

@interface SellerGoodCollectionView : UICollectionView
@property (nonatomic,strong)NSString *memberId;

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout withMemberId:(NSString *)memberId;
@end
