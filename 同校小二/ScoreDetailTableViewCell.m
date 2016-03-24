//
//  ScoreDetailTableViewCell.m
//  TXXE
//
//  Created by 李雨龙 on 15/7/26.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "ScoreDetailTableViewCell.h"

@implementation ScoreDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setScoreDetailModel:(ScoreDetailModel *)scoreDetailModel
{
    if (_scoreDetailModel != scoreDetailModel) {
        _scoreDetailModel = scoreDetailModel;
        
        self.createTime.text = _scoreDetailModel.scoreDetailDict[@"createTime"];
        self.scoreLabel.text = [NSString stringWithFormat:@"+%@",_scoreDetailModel.scoreDetailDict[@"score"]];
        self.descriptionLabel.text = _scoreDetailModel.scoreDetailDict[@"ruleName"];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
