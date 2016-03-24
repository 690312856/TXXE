//
//  AskCollectionListTableViewCell.h
//  TXXE
//
//  Created by 李雨龙 on 15/7/24.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageListView.h"
#import "myCollectionAskModel.h"

@interface AskCollectionListTableViewCell : UITableViewCell
@property (nonatomic,strong)myCollectionAskModel *myCollectionAskModel;

@property (nonatomic,strong)UILabel * askTitle;
@property (nonatomic,strong)UITextView *askDescription;
@property (nonatomic,strong)UILabel *askPrice;
@property (nonatomic,strong)ImageListView *imageListView;
@property (nonatomic,strong)UIButton *cancelCollectionBtn;

@property (nonatomic , copy) void(^cancelCollectedButtonActionBlock)(void);
@end
