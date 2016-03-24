//
//  AskItemHeaderView.m
//  TXXE
//
//  Created by River on 15/7/3.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "AskItemHeaderView.h"
#import "NSString+Addition.h"
#import <UIImageView+WebCache.h>

@implementation AskItemHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)refreshWithDic:(NSDictionary*)dic
{
    AskDic = dic;
    if ([[NSString realForString: [[dic objectForKey:@"images"] firstObject]] isEqualToString:@""]) {
        //self.goodImg.image = defaultImg;
    }
    else
    {
        NSLog(@"");
        [self.goodImage sd_setImageWithURL:[NSURL URLWithString:[[dic objectForKey:@"images"]firstObject]] placeholderImage:nil];
    }
    [self.goodImage setContentMode:UIViewContentModeScaleAspectFill];
    self.goodImage.clipsToBounds = YES;
    [self.photo sd_setImageWithURL:[NSURL URLWithString:[[dic objectForKey:@"sellerInfo"] objectForKey:@"avatar"]] placeholderImage:nil];
    self.nickName.text = [NSString realForString:[[dic objectForKey:@"sellerInfo"] objectForKey:@"nickName"]];
    //self.level.text = [NSString realForString:[dic objectForKey:]]
    self.descriptionTextView.text = [NSString realForString:[dic objectForKey:@"description"]];
    self.price.text = [NSString realForString:[dic objectForKey:@"price"]];
    self.askGoodId = [NSString realForString:[dic objectForKey:@"id"]];
    self.schoolName.text = [NSString realForString:[[dic objectForKey:@"sellerInfo"] objectForKey:@"schoolName"]];
}
-(void)refreshWithDicWith:(long)num
{
    self.schoolName.text = [NSString stringWithFormat:@"%ld",num];
}
- (IBAction)commentBtnAction:(id)sender
{
    if (self.commClickBlock) {
        self.commClickBlock(sender);
    }
}
- (IBAction)collectionBtnAction:(id)sender {
    if (self.collClickBlock) {
        self.collClickBlock(sender,self.askGoodId);
    }
}
- (IBAction)contactBtnAction:(id)sender {
    if (self.contClickBlock) {
        self.contClickBlock(sender,AskDic);
    }
}
@end
