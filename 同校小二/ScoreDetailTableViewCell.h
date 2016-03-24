//
//  ScoreDetailTableViewCell.h
//  TXXE
//
//  Created by 李雨龙 on 15/7/26.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScoreDetailModel.h"

@interface ScoreDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *createTime;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (nonatomic,strong)ScoreDetailModel *scoreDetailModel;
@end
