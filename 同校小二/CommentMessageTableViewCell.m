//
//  CommentMessageTableViewCell.m
//  TXXE
//
//  Created by 李雨龙 on 15/7/23.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "CommentMessageTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "UIView+Addition.h"

@interface CommentMessageTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *createTime;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIImageView *goodImageView;


@end
@implementation CommentMessageTableViewCell

- (void)awakeFromNib {
    // Initialization code

}

- (void)setMessageModel:(CommentMessageModel *)messageModel
{
    //[self.badge drawBorderStyleWithBorderWidth:0 borderColor:[UIColor clearColor] cornerRadius:self.avatarImageView.frame.size.height * 0.25];
    if (_messageModel != messageModel) {
        _messageModel = messageModel;
        NSString *type = _messageModel.cMessageType;
        
        if ([type  isEqual: @"1"]) {
            if ([_messageModel.cGoodsType isEqualToString:@"0"]) {
                self.typeLabel.text = @"评论了您的商品";
            }else
            {
                self.typeLabel.text = @"评论了您的求购";
            }
        }else
        {
            self.typeLabel.text = @"回复了您的评论";
        }
        if (_messageModel.didRead == YES) {
            //[self.badge setHidden:YES];
            [self.RedPoint setHidden:YES];
        }else
        {
            //[self.badge setHidden:NO];
            [self.RedPoint setHidden:NO];
        }
        NSURL *url = [NSURL URLWithString:_messageModel.autorDict[@"avatar"]];
        [self.avatarImageView sd_setImageWithURL:url placeholderImage:nil];
        ///////////url
        url = [NSURL URLWithString:[_messageModel.messageBodyDict[@"goodsImages"] firstObject]];
        NSLog(@"tttttt%@",url);
        if (![[_messageModel.messageBodyDict[@"goodsImages"] firstObject]  isEqual: @"http://www.txxer.com/resources/"]) {
            [self.goodImageView sd_setImageWithURL:url placeholderImage:nil];
        }else
        {
            self.goodImageView.hidden=YES;
        }
        
        self.nickName.text = _messageModel.autorDict[@"nickName"];
        self.content.text =_messageModel.messageBodyDict[@"contents"];
        self.createTime.text = _messageModel.createTime;
        [self.avatarImageView drawBorderStyleWithBorderWidth:0 borderColor:[UIColor clearColor] cornerRadius:self.avatarImageView.frame.size.height * 0.5];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
