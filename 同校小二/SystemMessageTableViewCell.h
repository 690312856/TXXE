//
//  SystemMessageTableViewCell.h
//  TXXE
//
//  Created by 李雨龙 on 15/7/23.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SystemMessageModel.h"
#import "MKNumberBadgeView.h"

@interface SystemMessageTableViewCell : UITableViewCell

@property (nonatomic,strong) SystemMessageModel *messageModel;
@property (weak, nonatomic) IBOutlet UIImageView *RedPoint;



@end
