//
//  RuleDetailTableViewCell.h
//  TXXE
//
//  Created by 李雨龙 on 15/9/5.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RuleDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *score;

-(void)refreshWithDic:(NSDictionary*)dic;
@end
