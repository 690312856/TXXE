//
//  ReasonCell.m
//  TongxiaoXiaoEr
//
//  Created by xueyaoji on 15-4-4.
//  Copyright (c) 2015年 com.e-techco. All rights reserved.
//

#import "ReasonCell.h"
#import "Constants.h"
#import "NSString+Addition.h"
@implementation ReasonCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createReasonCell];
    }
    
    return self;

}

-(void)createReasonCell
{
    
    self.reasonLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    self.reasonLab.textColor = [UIColor colorWithRed:143.0/255 green:143.0/255 blue:143.0/255 alpha:0.7];
    [self.contentView addSubview:self.reasonLab];
    
    
    
    
    self.lineView = [[UIView  alloc] initWithFrame:CGRectMake(0, 39, KScreenWidth-60, 1)];
    self.lineView.backgroundColor  =  [UIColor colorWithRed:143.0/255 green:143.0/255 blue:143.0/255 alpha:0.7];
    [self.contentView addSubview:self.lineView];

    
    
    
    self.choseImg = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth-60-40, (40-25)/2, 25, 25)];
    self.choseImg.tag = 999;
    [self.choseImg setImage:[UIImage imageNamed:@"reasonChose"]];
    [self.contentView addSubview:self.choseImg];
    self.choseImg.hidden = YES;
    
    self.backgroundColor = [UIColor clearColor];
    
   
}
-(void)refreshWithStr:(NSString*)str
{
      self.reasonLab.text = [NSString realForString:str];
    
}
@end
