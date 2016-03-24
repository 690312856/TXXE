//
//  RuleDetailTableViewCell.m
//  TXXE
//
//  Created by 李雨龙 on 15/9/5.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "RuleDetailTableViewCell.h"

@implementation RuleDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)refreshWithDic:(NSDictionary*)dic
{
    switch ([dic[@"id"] integerValue]) {
        case 1:
            self.numLabel.text = @"每天登录";
            break;
        case 2:
            self.numLabel.text = @"发布商品/求购";
            break;
        case 3:
            self.numLabel.text = @"售出商品求购成功";
            break;
        case 4:
            self.numLabel.text = @"个人信息完成度达到100%";
            break;
        case 5:
            self.numLabel.text = @"学生证认证";
            break;
        case 6:
            self.numLabel.text = @"分享商品/求购";
            break;
        default:
            break;
    }
   // self.numLabel.text = dic[@"id"];
    self.detailLabel.text = [NSString stringWithFormat:@"+%@",dic[@"score"]];
    
    self.score.text = dic[@"detail"];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
