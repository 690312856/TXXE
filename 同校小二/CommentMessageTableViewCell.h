//
//  CommentMessageTableViewCell.h
//  TXXE
//
//  Created by 李雨龙 on 15/7/23.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentMessageModel.h"
#import "MKNumberBadgeView.h"

@interface CommentMessageTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *RedPoint;
@property (nonatomic,strong)CommentMessageModel *messageModel;
@end
