//
//  CommentTableViewCell.m
//  TXXE
//
//  Created by River on 15/7/1.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "NSDate+String.h"
#import "NSString+Addition.h"
#import "UIView+Addition.h"
#import <UIImageView+WebCache.h>
#import "Constants.h"
@implementation CommentTableViewCell

- (void)awakeFromNib {
    // Initialization code
    /*CGSize itemSize =CGSizeMake(15, 15);
    UIGraphicsBeginImageContext(itemSize);
    CGRect imageRect = CGRectMake(0, 0, itemSize.width, itemSize.height);
    [self.photo.image drawAsPatternInRect:imageRect];
    self.photo.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();*/
    [self.photo drawBorderStyleWithBorderWidth:0 borderColor:[UIColor clearColor] cornerRadius:self.photo.frame.size.height * 0.5];
    self.photo.layer.masksToBounds = YES;
    [self.photo.layer setBorderColor:APP_MAIN_COLOR.CGColor];
    [self.photo.layer setBorderWidth:10];
    [self.photo drawBorderStyleWithBorderWidth:0 borderColor:[UIColor clearColor] cornerRadius:self.photo.frame.size.height * 0.5];
    [self.photo setContentScaleFactor:[[UIScreen mainScreen] scale]];
    self.photo.contentMode = UIViewContentModeScaleAspectFill;
    self.photo.clipsToBounds  = YES;
    
    /*self.photo.layer.masksToBounds = YES;
    self.photo.layer.cornerRadius = self.photo.bounds.size.width*0.5;
    self.photo.layer.borderWidth = 2.0;
    self.photo.layer.borderColor = [UIColor whiteColor].CGColor;*/
}
-(void)refreshWithDic:(NSDictionary*)dic
{
    NSLog(@"4545435435");
    NSURL *url = [NSURL URLWithString:dic[@"reviews"][@"avatar"]];
    NSLog(@"%@",dic[@"reviews"][@"avatar"]);
    [self.photo sd_setImageWithURL:url placeholderImage:nil];
    [self.photo drawBorderStyleWithBorderWidth:0 borderColor:[UIColor clearColor] cornerRadius:self.photo.frame.size.height * 0.5];
    self.photo.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoTapped:)];
    [self.photo addGestureRecognizer:singleTap];
    
    self.senderName.text = dic[@"reviews"][@"nickName"];
    self.toName.text = dic[@"reviews"][@"targetNickName"];
    self.midText.text = @"回复:";
    self.Contents.text = dic[@"reviews"][@"contents"];
    self.time.text = dic[@"reviews"][@"createTime"];
}

-(void)refreshDic:(NSDictionary*)dic
{
    NSLog(@"4545435435");
    NSURL *url = [NSURL URLWithString:dic[@"avatar"]];
    [self.photo sd_setImageWithURL:url placeholderImage:nil];
    [self.photo drawBorderStyleWithBorderWidth:0 borderColor:[UIColor clearColor] cornerRadius:self.photo.frame.size.height * 0.5];
    self.photo.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoTapped:)];
    [self.photo addGestureRecognizer:singleTap];
    self.senderName.text = dic[@"nickName"];
    self.toName.text = dic[@"targetNickName"];
    self.midText.text = @"回复:";
    self.Contents.text = dic[@"contents"];
    self.time.text = dic[@"createTime"];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)photoTapped:(UITapGestureRecognizer *)sender
{
    NSLog(@"2341234123");
    if (self.tapBlock) {
        self.tapBlock(sender);
    }
}

@end
