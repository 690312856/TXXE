//
//  ImageListView.h
//  TXXE
//
//  Created by 李雨龙 on 15/7/24.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageListView : UIView

@property (nonatomic,strong)NSArray *imageList;

+(CGSize) sizeofViewWithImageCount:(NSInteger)count;

@end
