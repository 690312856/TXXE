//
//  GoodCollectionListTableViewCell.h
//  TXXE
//
//  Created by 李雨龙 on 15/7/24.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myCollectionGoodModel.h"

@interface GoodCollectionListTableViewCell : UITableViewCell
{
    UIImageView *imageView;
}
@property (nonatomic,strong)myCollectionGoodModel *myCollectionGoodModel;
@property (nonatomic,strong)UILabel *goodTitle;
@property (nonatomic,strong)UITextView *goodDescription;
@property (nonatomic,strong)UILabel *goodPrice;
@property (nonatomic,strong)UIButton *cancelCollectionBtn;

@property (nonatomic , copy) void(^cancelCollectedButtonActionBlock)(void);
@end
