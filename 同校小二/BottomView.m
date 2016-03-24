//
//  BottomView.m
//  TongxiaoXiaoEr
//
//  Created by xueyaoji on 15-3-7.
//  Copyright (c) 2015年 xxx.xxxx. All rights reserved.
//

#import "BottomView.h"
#import "Constants.h"
@implementation BottomView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createBottomView];
    }
    return self;

}
-(void)createBottomView
{

    self.backgroundColor = [UIColor whiteColor];
    
    
    UIView * topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
    topLineView.backgroundColor = lineGrayColor;
    [self addSubview:topLineView];
    
    
    
    UIButton * commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, (self.frame.size.height-44/2)/2, 37/2, 44/2)];
    [commentBtn setBackgroundImage:[UIImage imageNamed:@"btn03"] forState:0];
    commentBtn.backgroundColor = [UIColor blackColor];
    [commentBtn addTarget:self action:@selector(clickCommBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:commentBtn];
    

    UIButton * bigBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,0, 60, self.frame.size.height)];
    [bigBtn addTarget:self action:@selector(clickCommBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:bigBtn];
    
    
    
    
    UIButton * contactBtn = [[UIButton alloc] initWithFrame:CGRectMake((KScreenWidth-144/2)-20, (self.frame.size.height-56/2)/2, 144/2, 56/2)];
    [contactBtn setBackgroundImage:[UIImage imageNamed:@"Contact_the_seller"] forState:0];
    contactBtn.backgroundColor = [UIColor blackColor];
    [contactBtn addTarget:self action:@selector(clickContactBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:contactBtn];
    

    
    self.collectBtn = [[UIButton alloc] initWithFrame:CGRectMake(60, (self.frame.size.height-45/2)/2, 43/2, 45/2)];
    [self.collectBtn setBackgroundImage:[UIImage imageNamed:@"btn05"] forState:0];
    self.collectBtn.backgroundColor = [UIColor blackColor];
    [self.collectBtn addTarget:self action:@selector(clickCollectBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.collectBtn];
    
    
    UIButton * bigBtn2 = [[UIButton alloc] initWithFrame:CGRectMake(60, 0, 60, KScreenWidth/2-60)];
   
    [bigBtn2 addTarget:self action:@selector(clickCollectBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:bigBtn2];
    

}
-(void)clickCommBtn:(UIButton*)sender
{
    if (self.commentCallBack) {
        self.commentCallBack(sender);
    }


}
-(void)clickContactBtn:(UIButton*)sender
{
    if (self.contactCallBack) {
        self.contactCallBack(sender);
    }

}
-(void)clickCollectBtn:(UIButton*)sender
{
    if (self.collectCallBack) {
        self.collectCallBack(sender);
    }
}
@end
