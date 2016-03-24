//
//  SellerAskCollectionView.h
//  TXXE
//
//  Created by 李雨龙 on 15/7/31.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
///////////
#import "MyCreateAskModel.h"

@interface SellerAskCollectionView : UITableView

@property (nonatomic,strong)NSString *memberId;
@property (nonatomic,strong)NSString *askId;
@property (nonatomic,assign)MyCreateAskModel *AskModel;
@property(nonatomic,assign)BOOL isFavorited;
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style withMemberId:(NSString *)memberId;
@end
