//
//  AskListTableViewCell.h
//  TXXE
//
//  Created by 李雨龙 on 15/7/24.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageListView.h"
#import "MyCreateAskModel.h"


@interface AskListTableViewCell : UITableViewCell

@property (nonatomic,strong)MyCreateAskModel *myCreateAskModel;

@property (nonatomic,strong)UILabel *askTitle;
@property (nonatomic,strong)UITextView *askDescription;
@property (nonatomic,strong)UILabel *askPrice;
@property (nonatomic,strong)ImageListView *imageListView;
@property (nonatomic,strong)UIButton *deleteBtn;
@property (nonatomic,strong)UIButton *confirmBoughtBtn;
@property (nonatomic,strong)UIButton *changeAskStatusBtn;

@property (nonatomic , copy) void(^editButtonActionBlock)(void);
@property (nonatomic , copy) void(^changeStatusActionBlock)(void);
@property (nonatomic , copy) void(^confirmBoughtActionBlock)(void);
@property (nonatomic , copy) void(^deleteButtonActionBlock)(void);

@end
