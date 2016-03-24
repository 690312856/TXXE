//
//  CategoryTableViewCell.h
//  TXXE
//
//  Created by River on 15/6/9.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

typedef void (^clickCallBack)(int index);

@interface CategoryTableViewCell : UITableViewCell

@property (nonatomic,strong) clickCallBack clickBlock;

@property (nonatomic,strong) UIImageView *leftIconImg;
@property (nonatomic,strong) UILabel *leftTitleLab;
@property (nonatomic,strong) UILabel *leftMarkLab;
@property (nonatomic,strong) UIButton *leftBtn;

@property (nonatomic,strong) UIImageView *rightIconImg;
@property (nonatomic,strong) UILabel *rightTitleLab;
@property (nonatomic,strong) UILabel *rightMarkLab;
@property (nonatomic,strong) UIButton *rightBtn;

@property (nonatomic,strong) UIView *bottomlineView;

-(void)refreshWithLeftDic:(NSMutableDictionary*)dic andRightDic:(NSMutableDictionary*)dic;


@end
