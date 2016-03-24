//
//  SearchConditionView.m
//  TXXE
//
//  Created by River on 15/6/29.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "SearchConditionView.h"
#import "Constants.h"

@implementation ConditionBtn

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        isChange = 2;
        Img = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 20, 15, 7, 9)];
        [self addSubview:Img];
        [self addTarget:self action:@selector(clickSelf:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)clickSelf:(UIButton*)sender
{
    
    isChange = (isChange+1)%3;
    if (isChange == 0) {
        Img.hidden = NO;
        Img.image = [UIImage imageNamed:@"sx"];
        Img.transform = CGAffineTransformMakeRotation(M_PI*(isChange+1));
        [self setTitleColor:lightBlackColor forState:0];
    }
    else if(isChange == 1) {
        Img.hidden = NO;
        Img.image = [UIImage imageNamed:@"sx"];
        Img.transform = CGAffineTransformMakeRotation(M_PI*(isChange+1));
        [self setTitleColor:lightBlackColor forState:0];
    }else
    {
        Img.hidden = YES;
        [self setTitleColor:lightBlackColor forState:0];
    }
    
    if (self.callBack) {
        self.callBack(isChange,sender);
    }
}
@end

@implementation SearchConditionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSearchConditionView];
    }
    return self;
}

-(void)createSearchConditionView
{
    NSArray *titleArr = [NSArray arrayWithObjects:@"本校",@"价格",@"分类",@"信用度",nil];
    for (int j = 1; j <= 3; j++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake((KScreenWidth-3)*j/4.0+j, 5, 1, 30)];
        view.backgroundColor = [UIColor blackColor];
        
        [self addSubview:view];
    }
        for (int i = 0; i < [titleArr count]; i++) {
        if(i == 0)
        {
            UIButton *schoolBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, (KScreenWidth-3)/4.0, 40)];
            schoolBtn.backgroundColor = tableWhitColor;
            [schoolBtn setTitleColor:lightBlackColor forState:0];
            [schoolBtn setTitle:[titleArr objectAtIndex:i] forState:0];
            schoolBtn.tag = i+100;
            schoolBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
            [schoolBtn addTarget:self action:@selector(clickSchoolBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:schoolBtn];
        }else if (i == 2)
        {
            UIButton *classBtn = [[UIButton alloc] initWithFrame:CGRectMake((KScreenWidth-3)*2/4.0+2, 0, (KScreenWidth-3)/4.0, 40)];
            classBtn.backgroundColor = tableWhitColor;
            [classBtn setTitleColor:lightBlackColor forState:0];
            [classBtn setTitle:[titleArr objectAtIndex:i] forState:0];
            classBtn.tag = i+100;
            classBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
            [classBtn addTarget:self action:@selector(clickClassBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:classBtn];
        }else
        {
            ConditionBtn * btn = [[ConditionBtn alloc] initWithFrame:CGRectMake((KScreenWidth-3)/4.0*i+i, 0, (KScreenWidth-3)/4.0, 40)];
            btn.backgroundColor = tableWhitColor;
            [btn setTitleColor:lightBlackColor forState:0];
            [btn setTitle:[titleArr objectAtIndex:i] forState:0];
            btn.tag = i+100;
            btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
            btn.callBack = ^(int isAsc,UIButton* sender)
            {
                
                if (self.aCallBack) {
                    
                    [(UIButton*)[self viewWithTag:1+100] setTitleColor:lightBlackColor forState:0];
                    [(UIButton*)[self viewWithTag:3+100] setTitleColor:lightBlackColor forState:0];
                    
                    //[sender setTitleColor:GreenFontColor forState:0];
                    self.aCallBack(isAsc,sender);
                }
                
            };
            [self addSubview:btn];
        }
    }
}

- (void)clickSchoolBtn:(UIButton*)sender
{
    if (self.sCallBack) {
        self.sCallBack(sender);
    }
}

- (void)clickClassBtn:(UIButton*)sender
{
    if (self.cCallBack) {
        self.cCallBack(sender);
    }
}






























@end
