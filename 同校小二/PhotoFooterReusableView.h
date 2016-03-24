//
//  PhotoFooterReusableView.h
//  TXXE
//
//  Created by River on 15/6/11.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoFooterReusableView : UICollectionReusableView

@property (nonatomic, copy) void (^addPhotoButtonAction)(void);

@end
