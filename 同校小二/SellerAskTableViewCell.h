//
//  SellerAskTableViewCell.h
//  TXXE
//
//  Created by 李雨龙 on 15/7/31.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageListView.h"
#import "MyCreateAskModel.h"

@interface SellerAskTableViewCell : UITableViewCell

@property (nonatomic,strong)MyCreateAskModel *myCreateAskModel;

@property (nonatomic,strong)UILabel *askTitle;
@property (nonatomic,strong)UITextView *askDescription;
@property (nonatomic,strong)UILabel *askPrice;
@property (nonatomic,strong)ImageListView *imageListView;
@property (nonatomic,strong)UIButton *collectionBtn;
@property (nonatomic,strong)UIButton *contactBtn;
@property (nonatomic,strong)UIButton *commentBtn;


@property (nonatomic,copy) void(^collectionButtonActionBlock)(void);
@property (nonatomic,copy) void(^contactButtonActionBlock)(void);
@end
