//
//  CategoryView.h
//  TXXE
//
//  Created by River on 15/6/28.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^categorySearch) (UIButton *sender);

@interface CategoryView : UIView
{
    float height;
    NSMutableArray * _normalCategoryArr;
}
@property (nonatomic,strong)categorySearch categorySearchCallBack;

@end
