//
//  CategoryTableViewCell.m
//  TXXE
//
//  Created by River on 15/6/9.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "CategoryTableViewCell.h"
#import "Constants.h"
#import "NSString+Addition.h"

@implementation CategoryTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        [self createCategoryTableViewCell];
    }
    return self;
}

-(void)createCategoryTableViewCell
{
    float kSpace = 15;
    
    self.leftIconImg = [[UIImageView alloc] initWithFrame:CGRectMake(kSpace, 10, 40, 40)];
    [self.contentView addSubview:self.leftIconImg];
    
    self.leftTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(self.leftIconImg.frame.origin.x+self.leftIconImg.frame.size.width+10, 10, KScreenWidth/2.0-kSpace-40-15, 20)];
    self.leftMarkLab.textColor = [UIColor greenColor];
    self.leftMarkLab.font = [UIFont systemFontOfSize:18.0];
    [self.contentView addSubview:self.leftTitleLab];
    
    self.leftMarkLab = [[UILabel alloc]initWithFrame:CGRectMake(self.leftIconImg.frame.origin.x+self.leftIconImg.frame.size.width+10, 30, KScreenWidth/2.0-kSpace-40-15, 20)];
    self.leftMarkLab.font = [UIFont systemFontOfSize:14.0];
    self.leftMarkLab.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.leftMarkLab];
    
    self.leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth/2.0-0.5, 80)];
    [self.leftBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.leftBtn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(KScreenWidth/2.0-0.5, 0, 1, 60)];
    [lineView setBackgroundColor:lineGrayColor];
    [self.contentView addSubview:lineView];
    
    self.rightIconImg = [[UIImageView alloc] initWithFrame:CGRectMake(kSpace+KScreenWidth/2-1, 10, 40, 40)];
    [self.contentView addSubview:self.rightIconImg];
    
    
    
    self.rightTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(self.rightIconImg.frame.origin.x+self.rightIconImg.frame.size.width+10, 10, KScreenWidth/2-kSpace-40-15, 20)];
    self.rightTitleLab.font = [UIFont systemFontOfSize:18.0];
    self.rightTitleLab.textColor = GreenFontColor;
    [self.contentView addSubview:self.rightTitleLab];
    
    
    
    self.rightMarkLab = [[UILabel alloc] initWithFrame:CGRectMake(self.rightIconImg.frame.origin.x+self.rightIconImg.frame.size.width+10, 30, KScreenWidth/2-kSpace-40-15, 20)];
    self.rightMarkLab.textColor = [UIColor grayColor];
    self.rightMarkLab.font = [UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:self.rightMarkLab];
    
    
    self.rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(KScreenWidth/2+0.5, 0, KScreenWidth/2-0.5, 80)];
    [self.rightBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.rightBtn];
    
    
    self.bottomlineView = [[UIView alloc] initWithFrame:CGRectMake(10, 59, KScreenWidth-10*2, 1)];
    self.bottomlineView.backgroundColor = lineGrayColor;
    [self.contentView addSubview:self.bottomlineView];
}

- (void)refreshWithLeftDic:(NSMutableDictionary *)leftdic andRightDic:(NSMutableDictionary *)rightdic
{
    if ([[NSString realForString:leftdic[@"icon"]]isEqualToString:@""])
    {
        [self.leftIconImg setImage:defaultImg];
    }else{
        [self.leftIconImg sd_setImageWithURL:[NSURL URLWithString:leftdic[@"icon"]]placeholderImage:defaultImg];
    }
    
    self.leftTitleLab.text = leftdic[@"name"];
    NSMutableString *tempStr = [NSMutableString stringWithString:@""];
    NSArray *tempArr = leftdic[@"subCategories"];
    
    for (int i = 0;i < [tempArr count];i++)
    {
        if (i<3){
            [tempStr appendString:[NSString stringWithFormat:@"%@",[tempArr objectAtIndex:i][@"name"]]];
        }
    }
    self.leftMarkLab.text = tempStr;
    
    if (rightdic){
        [self.rightIconImg setHidden:NO];
        [self.rightTitleLab setHidden:NO];
        [self.rightMarkLab setHidden:NO];
        
        if ([[NSString realForString:rightdic[@"icon"]] isEqualToString:@""]){
            [self.rightIconImg setImage:defaultImg];
        }else{
            [self.rightIconImg sd_setImageWithURL:[NSURL URLWithString:rightdic[@"icon"]] placeholderImage:defaultImg];
        }
        self.rightTitleLab.text = rightdic[@"name"];
        tempStr = [NSMutableString stringWithString:@""];
        tempArr = rightdic[@"subCategories"];
        for (int i = 0; i < [tempArr count];i++)
        {
            if (i<3)
            {
                [tempStr appendString:[NSString stringWithFormat:@"%@",[tempArr objectAtIndex:i][@"name"]]];
            }
        }
        self.rightMarkLab.text = tempStr;
    }
    else{
        [self.rightIconImg setHidden:YES];
        [self.rightTitleLab setHidden:YES];
        [self.rightMarkLab setHidden:YES];
    }
}

- (void)clickBtn:(UIButton *)sender
{
    if(self.clickBlock)
    {
        self.clickBlock(sender.tag);
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
