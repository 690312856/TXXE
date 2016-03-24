//
//  AskItemsHeaderView.m
//  TXXE
//
//  Created by 李雨龙 on 15/7/29.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "AskItemsHeaderView.h"
#import "NSString+Addition.h"
#import <UIImageView+WebCache.h>
#import "UIView+Addition.h"
#import "Constants.h"

@implementation AskItemsHeaderView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    return self;
    
}

-(void)refreshWithDic:(NSDictionary*)dic
{
    for (UIView *view in self.subviews) {
        if ([view class] == [ImageListView class]) {
            [view removeFromSuperview];
        }
        if ([view class] == [UIButton class]) {
            [view removeFromSuperview];
        }
        if ([view class] == [UILabel class]) {
            [view removeFromSuperview];
        }
        if ([view class] == [UITextView class]) {
            [view removeFromSuperview];
        }
        if ([view class] == [UIImageView class]) {
            [view removeFromSuperview];
        }
        if ([view class] == [UIView class]) {
            [view removeFromSuperview];
        }
    }
    
    UIView *partition = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 5)];
    partition.backgroundColor = tableWhitColor;
    [self addSubview:partition];
    self.isOpen = NO;
    self.photo = [[UIImageView alloc]initWithFrame:CGRectMake(15, 8, 65, 65)];
    //self.photo.backgroundColor = [UIColor redColor];
    self.photo.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoTapped:)];
    [self.photo addGestureRecognizer:singleTap];
    [self.photo sd_setImageWithURL:[NSURL URLWithString:[[dic objectForKey:@"sellerInfo"] objectForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"个人详情头像-默认.png"]];
    [self.photo drawBorderStyleWithBorderWidth:0 borderColor:[UIColor clearColor] cornerRadius:self.photo.frame.size.height * 0.5];
    
    self.nickName = [[UILabel alloc]initWithFrame:CGRectMake(95, 15, 90, 30)];
    self.nickName.backgroundColor = [UIColor clearColor];
    [self.nickName setFont:[UIFont fontWithName:@"HeiTi SC" size:17.0]];
    self.nickName.text = [NSString realForString:[[dic objectForKey:@"sellerInfo"] objectForKey:@"nickName"]];
    
    self.level = [[UILabel alloc]initWithFrame:CGRectMake(200,15, 60, 30)];
    self.level.backgroundColor = [UIColor clearColor];
    //self.level.text = [NSString realForString:[[dic objectForKey:@"sellerInfo"] objectForKey:@"level"]];
    self.level.text = [NSString stringWithFormat:@"LV%@",[NSString realForString:[[dic objectForKey:@"sellerInfo"] objectForKey:@"level"]]];
    [self.level setFont:[UIFont systemFontOfSize:12]];
    [self.level setTintColor:RGB_COLOR(74, 144, 226, 1.0)];
    self.showBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width-50, 10, 20, 10)];
    //self.showBtn.backgroundColor = [UIColor yellowColor];
    [self.showBtn setBackgroundImage:[UIImage imageNamed:@"求购箭头"] forState:UIControlStateNormal];
    [self.showBtn addTarget:self action:@selector(showBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.reportBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width-70, 25, 60, 30)];
    [self.reportBtn setBackgroundImage:[UIImage imageNamed:@"求购-举报按钮"] forState:UIControlStateNormal];
    //self.reportBtn.backgroundColor = [UIColor yellowColor];
    //[self.reportBtn setTitle:@"举报" forState:UIControlStateNormal];
    self.reportBtn.titleLabel.tintColor = [UIColor blackColor];
    [self.reportBtn setHidden:YES];
    [self.reportBtn addTarget:self action:@selector(reportBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.AskName = [[UILabel alloc]initWithFrame:CGRectMake(15, 75, 150, 30)];
    self.AskName.backgroundColor = [UIColor clearColor];
    [self.AskName setFont:[UIFont fontWithName:@"HeiTi SC" size:16.0]];
    self.AskName.text = [NSString realForString:[dic objectForKey:@"title"]];
    
    self.descriptionTextView = [[UITextView alloc]initWithFrame:CGRectMake(15, 110, 300, 50)];
    self.descriptionTextView.text = [NSString realForString:[dic objectForKey:@"description"]];
    [self.descriptionTextView setEditable:NO];
    [self.descriptionTextView setSelectable:NO];
    if ([[dic objectForKey:@"images"] count] == 0) {
        
        self.schoolLogo = [[UIImageView alloc]initWithFrame:CGRectMake(10, 165+7, 8, 12)];
        self.schoolLogo.image = [UIImage imageNamed:@"交易学校-图标"];
        //self.schoolLogo.backgroundColor = [UIColor greenColor];
        self.schoolName = [[UILabel alloc] initWithFrame:CGRectMake(25, 165+5, 200, 20)];
        self.schoolName.text = [NSString realForString:[dic objectForKey:@"jyLocation"]];
        self.schoolName.backgroundColor = [UIColor clearColor];
        [self.schoolName setFont: [UIFont systemFontOfSize: 10.0]];
        [self.schoolName setTintColor:[UIColor colorWithRed:200.0/255 green:199.0/255 blue:204.0/255 alpha:1.0]];
        self.price = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width - 90, 165+5, 80, 20)];
        self.price.backgroundColor = [UIColor clearColor];
        [self.price setFont: [UIFont systemFontOfSize: 15.0]];
        [self.price setTintColor:[UIColor blackColor]];
        self.price.text = [NSString stringWithFormat:@"￥%@",[NSString realForString:[dic objectForKey:@"price"]]];
        
        self.collectionBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 165+30, (self.frame.size.width-3)/3.0, 19)];
        self.collectionBtn.backgroundColor = [UIColor whiteColor];
        [self.collectionBtn addTarget:self action:@selector(collectionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [self.collectionBtn setTitle:@"收藏" forState:UIControlStateNormal];
        
        
        
        [self.collectionBtn.titleLabel setFont: [UIFont systemFontOfSize: 10.0]];
        [self.collectionBtn setTitleColor:[UIColor colorWithRed:200.0/255 green:199.0/255 blue:204.0/255 alpha:1.0] forState:UIControlStateNormal];
        self.commentBtn = [[UIButton alloc] initWithFrame:CGRectMake((self.frame.size.width-3)/3.0+1, 165+30, (self.frame.size.width-3)/3.0, 19)];
        self.commentBtn.backgroundColor = [UIColor whiteColor];
        [self.commentBtn addTarget:self action:@selector(commentBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.commentBtn setTitle:@"评论" forState:UIControlStateNormal];
        [self.commentBtn.titleLabel setFont: [UIFont systemFontOfSize: 10.0]];
        self.commentBtn.tag = 0;
        [self.commentBtn setTitleColor:[UIColor colorWithRed:200.0/255 green:199.0/255 blue:204.0/255 alpha:1.0] forState:UIControlStateNormal];
        self.contactBtn = [[UIButton alloc] initWithFrame:CGRectMake((self.frame.size.width-3)*2/3.0+2, 165+30, (self.frame.size.width-3)/3.0, 19)];
        self.contactBtn.backgroundColor = [UIColor whiteColor];
        [self.contactBtn addTarget:self action:@selector(contactBtnAction:) forControlEvents:
         UIControlEventTouchUpInside];
        [self.contactBtn setTitle:@"联系买家" forState:UIControlStateNormal];
        [self.contactBtn.titleLabel setFont: [UIFont systemFontOfSize: 10.0]];
        [self.contactBtn setTitleColor:[UIColor colorWithRed:200.0/255 green:199.0/255 blue:204.0/255 alpha:1.0] forState:UIControlStateNormal];
        /*UIView *partition = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-5, self.frame.size.width, 5)];
        partition.backgroundColor = [UIColor grayColor];*/
        
        [self addSubview:self.photo];
        [self addSubview:self.nickName];
        [self addSubview:self.level];
        [self addSubview:self.AskName];
        [self addSubview:self.descriptionTextView];
        [self addSubview:self.schoolName];
        [self addSubview:self.price];
        [self addSubview:self.showBtn];
        [self addSubview:self.reportBtn];
        [self addSubview:self.collectionBtn];
        [self addSubview:self.commentBtn];
        [self addSubview:self.contactBtn];
        [self addSubview:self.schoolLogo];
        //[self addSubview:partition];
        for (int j = 1; j <= 2; j++) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width-3)*j/3.0+j,165+30+2, 1, 15)];
            view.backgroundColor = [UIColor colorWithRed:200.0/255 green:199.0/255 blue:204.0/255 alpha:1.0];
            [self addSubview:view];
        }
        UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 165+30, self.frame.size.width, 1)];
        topLine.backgroundColor = [UIColor colorWithRed:200.0/255 green:199.0/255 blue:204.0/255 alpha:1.0];
        UIView *footLine = [[UIView alloc]initWithFrame:CGRectMake(0, 165+30+19, self.frame.size.width, 1)];
        footLine.backgroundColor = [UIColor colorWithRed:200.0/255 green:199.0/255 blue:204.0/255 alpha:1.0];
        
        [self addSubview:topLine];
        [self addSubview:footLine];
        
        self.backgroundColor = [UIColor whiteColor];
        self.askGoodId = [NSString realForString:[dic objectForKey:@"id"]];
        self.memberId = [NSString realForString:[[dic objectForKey:@"sellerInfo"] objectForKey:@"memberId"]];
        AskDic = dic;
    }else{

        CGSize imageSize = [ImageListView sizeofViewWithImageCount:[[dic objectForKey:@"images"] count]];
        self.imageListView = [[ImageListView alloc]initWithFrame:(CGRect){{15.0,165.0},imageSize}];
        self.imageListView.imageList = [dic objectForKey:@"images"];
        
        self.schoolLogo = [[UIImageView alloc]initWithFrame:CGRectMake(10, 165+imageSize.height+7, 8, 12)];
        self.schoolLogo.image = [UIImage imageNamed:@"交易学校-图标"];
        //self.schoolLogo.backgroundColor = [UIColor greenColor];
        self.schoolName = [[UILabel alloc] initWithFrame:CGRectMake(25, 165+imageSize.height+5, 200, 20)];
        self.schoolName.text = [NSString realForString:[dic objectForKey:@"jyLocation"]];
        self.schoolName.backgroundColor = [UIColor clearColor];
        [self.schoolName setFont: [UIFont systemFontOfSize: 10.0]];
        [self.schoolName setTintColor:[UIColor colorWithRed:200.0/255 green:199.0/255 blue:204.0/255 alpha:1.0]];
        self.price = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width - 90, 165+imageSize.height+5, 80, 20)];
        self.price.backgroundColor = [UIColor clearColor];
        [self.price setFont: [UIFont systemFontOfSize: 15.0]];
        [self.price setTintColor:[UIColor blackColor]];
        self.price.text = [NSString stringWithFormat:@"￥%@",[NSString realForString:[dic objectForKey:@"price"]]];
        
        self.collectionBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 165+imageSize.height+30, (self.frame.size.width-3)/3.0, 19)];
        self.collectionBtn.backgroundColor = [UIColor whiteColor];
        [self.collectionBtn addTarget:self action:@selector(collectionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.collectionBtn setTitle:@"收藏" forState:UIControlStateNormal];
        [self.collectionBtn.titleLabel setFont: [UIFont systemFontOfSize: 10.0]];
        [self.collectionBtn setTitleColor:[UIColor colorWithRed:200.0/255 green:199.0/255 blue:204.0/255 alpha:1.0]forState:UIControlStateNormal];
        self.commentBtn = [[UIButton alloc] initWithFrame:CGRectMake((self.frame.size.width-3)/3.0+1, 165+imageSize.height+30, (self.frame.size.width-3)/3.0, 19)];
        self.commentBtn.backgroundColor = [UIColor whiteColor];
        [self.commentBtn addTarget:self action:@selector(commentBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.commentBtn setTitle:@"评论" forState:UIControlStateNormal];
        [self.commentBtn.titleLabel setFont: [UIFont systemFontOfSize: 10.0]];
        [self.commentBtn setTitleColor:[UIColor colorWithRed:200.0/255 green:199.0/255 blue:204.0/255 alpha:1.0]forState:UIControlStateNormal];
        self.contactBtn = [[UIButton alloc] initWithFrame:CGRectMake((self.frame.size.width-3)*2/3.0+2, 165+imageSize.height+30, (self.frame.size.width-3)/3.0, 19)];
        self.contactBtn.backgroundColor = [UIColor whiteColor];
        [self.contactBtn addTarget:self action:@selector(contactBtnAction:) forControlEvents:
         UIControlEventTouchUpInside];
        [self.contactBtn setTitle:@"联系买家" forState:UIControlStateNormal];
        [self.contactBtn.titleLabel setFont: [UIFont systemFontOfSize: 10.0]];
        [self.contactBtn setTitleColor:[UIColor colorWithRed:200.0/255 green:199.0/255 blue:204.0/255 alpha:1.0]forState:UIControlStateNormal];
        //UIView *partition = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-5, self.frame.size.width, 5)];
       // partition.backgroundColor = [UIColor grayColor];
        
        [self addSubview:self.photo];
        [self addSubview:self.nickName];
        [self addSubview:self.level];
        [self addSubview:self.AskName];
        [self addSubview:self.descriptionTextView];
        [self addSubview:self.imageListView];
        [self addSubview:self.schoolName];
        [self addSubview:self.price];
        [self addSubview:self.showBtn];
        [self addSubview:self.reportBtn];
        [self addSubview:self.collectionBtn];
        [self addSubview:self.commentBtn];
        [self addSubview:self.contactBtn];
        [self addSubview:self.schoolLogo];
        //[self addSubview:partition];
        for (int j = 1; j <= 2; j++) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width-3)*j/3.0+j,165+imageSize.height+30+2, 1, 15)];
            view.backgroundColor = [UIColor colorWithRed:200.0/255 green:199.0/255 blue:204.0/255 alpha:1.0];
            [self addSubview:view];
        }
        UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 165+imageSize.height+30, self.frame.size.width, 1)];
        topLine.backgroundColor = [UIColor colorWithRed:200.0/255 green:199.0/255 blue:204.0/255 alpha:1.0];
        UIView *footLine = [[UIView alloc]initWithFrame:CGRectMake(0, 165+imageSize.height+30+19, self.frame.size.width, 1)];
        footLine.backgroundColor = [UIColor colorWithRed:200.0/255 green:199.0/255 blue:204.0/255 alpha:1.0];
        
        [self addSubview:topLine];
        [self addSubview:footLine];
        
        self.backgroundColor = [UIColor whiteColor];
        self.askGoodId = [NSString realForString:[dic objectForKey:@"id"]];
        self.memberId = [NSString realForString:[[dic objectForKey:@"sellerInfo"] objectForKey:@"memberId"]];
        AskDic = dic;
    }
    
    UITapGestureRecognizer *Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Tapped:)];
    [self addGestureRecognizer:Tap];
    /*if ([[NSString realForString: [[dic objectForKey:@"images"] firstObject]] isEqualToString:@""]) {
        //self.goodImg.image = defaultImg;
    }
    else
    {
        NSLog(@"");
        [self.goodImage sd_setImageWithURL:[NSURL URLWithString:[[dic objectForKey:@"images"]firstObject]] placeholderImage:nil];
    }*/
    /*[self.goodImage setContentMode:UIViewContentModeScaleAspectFill];
    self.goodImage.clipsToBounds = YES;
    [self.photo sd_setImageWithURL:[NSURL URLWithString:[[dic objectForKey:@"sellerInfo"] objectForKey:@"avatar"]] placeholderImage:nil];
    self.nickName.text = [NSString realForString:[[dic objectForKey:@"sellerInfo"] objectForKey:@"nickName"]];
    //self.level.text = [NSString realForString:[dic objectForKey:]]
    self.descriptionTextView.text = [NSString realForString:[dic objectForKey:@"description"]];
    self.price.text = [NSString realForString:[dic objectForKey:@"price"]];
    self.askGoodId = [NSString realForString:[dic objectForKey:@"id"]];
    self.schoolName.text = [NSString realForString:[[dic objectForKey:@"sellerInfo"] objectForKey:@"schoolName"]];*/
}

- (void)commentBtnAction:(UIButton *)sender
{
    if (self.commClickBlock) {
        self.commClickBlock(sender);
    }
}

- (void)collectionBtnAction:(id)sender {
    if (self.collClickBlock) {
        self.collClickBlock(sender,self.askGoodId);
    }
}
- (void)contactBtnAction:(id)sender {
    if (self.contClickBlock) {
        self.contClickBlock(sender,AskDic);
    }
}

- (void)showBtnAction:(id)sender{
    [self.reportBtn setHidden:!self.reportBtn.isHidden];
}

- (void)reportBtnAction:(id)sender{
    if (self.repoClickBlock) {
        self.repoClickBlock(sender,self.askGoodId);
    }
}

- (void)photoTapped:(UITapGestureRecognizer *)sender
{
    NSLog(@"sdfasdfa");
    if (self.tapBlock) {
        NSLog(@"sdfasdfa%@",self.memberId);
        self.tapBlock(sender,self.memberId);
    }
}

- (void)Tapped:(UITapGestureRecognizer *)sender
{
    NSLog(@"sdfasdfa");
    if (self.tapBackBlock) {
        self.tapBackBlock(sender);
    }
}

@end
