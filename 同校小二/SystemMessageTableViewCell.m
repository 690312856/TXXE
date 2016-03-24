//
//  SystemMessageTableViewCell.m
//  TXXE
//
//  Created by 李雨龙 on 15/7/23.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "SystemMessageTableViewCell.h"
#import "UIView+Addition.h"

@interface SystemMessageTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *Title;
@property (weak, nonatomic) IBOutlet UILabel *createTime;
@property (weak, nonatomic) IBOutlet UILabel *content;

@end
@implementation SystemMessageTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    /*self.badge.shine = NO;
    self.badge.shadow = NO;
    self.badge.hidden = YES;*/
    [self.RedPoint setImage:[UIImage imageNamed:@"消息提醒标识"]];
}

- (void)setMessageModel:(SystemMessageModel *)messageModel
{
    //[self.badge drawBorderStyleWithBorderWidth:0 borderColor:[UIColor clearColor] cornerRadius:self.avatarImageView.frame.size.height * 0.25];
    if (_messageModel != messageModel) {
        _messageModel = messageModel;
        NSString *type = _messageModel.sMessageType;
        if ([type  isEqual: @"0"]) {
            //[self.avatarImageView setImage:[UIImage imageNamed:@"0.png"]];
        }else
        {
            //[self.avatarImageView setImage:[UIImage imageNamed:@"1.png"]];
        }
        if (_messageModel.didRead == YES) {
            //[self.badge setHidden:YES];
            [self.RedPoint setHidden:YES];
            
        }else
        {
            //[self.badge setHidden:NO];
            [self.RedPoint setHidden:NO];
        }
        NSLog(@"4545435435");
        self.Title.text = _messageModel.messageBodyDict[@"title"];
        self.content.text =_messageModel.messageBodyDict[@"contents"];
        self.createTime.text = _messageModel.createTime;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
