//
//  BLActionSheet.m
//  SheetDemo
//
//  Created by llbt_ych on 15/3/3.
//  Copyright (c) 2015年 keyborder. All rights reserved.
//

#import "BLActionSheet.h"
#import "Constants.h"
#define BordColor  [UIColor colorWithRed:176.0/255 green:255.0/255 blue:171.0/255 alpha:1]
#define GreenColor [UIColor colorWithRed:29.0/255 green:107.0/255 blue:93.0/255 alpha:1]
#define blueColor [UIColor colorWithRed:19.0/255 green:76.0/255 blue:162.0/255 alpha:1]

@implementation BLActionSheet
-(id)initWithFrame:(CGRect)frame andTitles:(NSArray*)arr
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        
        float Kscreen = [[UIScreen mainScreen] bounds].size.width;
        
        
        bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Kscreen, ([arr count]+1)*50+40)];
        [self addSubview:bgImgView];
        bgImgView.backgroundColor = [UIColor whiteColor];
        [self sendSubviewToBack:bgImgView];
        
        
        float btnWith = 240;//按钮宽度
        
        for (int i =0; i<[arr count]; i++) {
            
            UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake((Kscreen-btnWith)/2, 20+50*i, btnWith, 40)];
            btn.tag = i;
            
          
            [btn.layer setBorderColor:lightBlackColor.CGColor];
            [btn.layer setBorderWidth:1];
            [btn setTitleColor:lightBlackColor forState:0];
           // [btn setBackgroundColor:GreenColor];
            [btn setTitle:[arr objectAtIndex:i] forState:0];
            [btn.layer setCornerRadius:5.0];
            [btn.layer masksToBounds];
            [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            
            
            if (i==([arr count]-1)) {
                UIButton * cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake((Kscreen-btnWith)/2, 20+50*(i+1), btnWith, 40)];
                cancleBtn.tag = i+1;
                //[cancleBtn.layer setBorderColor:BordColor.CGColor];
               // [cancleBtn.layer setBorderWidth:1];
                [cancleBtn.layer setCornerRadius:5.0];
                [cancleBtn.layer masksToBounds];
                [cancleBtn setBackgroundColor:GreenFontColor];
                [cancleBtn setTitle:@"取消" forState:0];
                [cancleBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:cancleBtn];
                
                
                
                
                [self setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height,Kscreen ,cancleBtn.frame.origin.y+ cancleBtn.frame.size.height+20)];
                
            }
        }
        
       
        
        
    }
    return self;


}

-(void)showInView:(UIView *)view
{

    grayView = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, view.superview.bounds.size.width, view.superview.bounds.size.height)];
    [grayView addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchDown];
    grayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    [view.superview addSubview:grayView];
    [view.superview addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^()
    {
        
        [self setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-self.frame.size.height, self.frame.size.width, self.frame.size.height)];
        
     }];
    
    
    
    
}
-(void)clickBtn:(UIButton*)sender
{
    
    
    
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(actionBLSheet:clickedButtonAtIndex:)]) {
        
        
        
        [self.delegate actionBLSheet:self clickedButtonAtIndex:sender.tag];
        [grayView setAlpha:0];
        [UIView animateWithDuration:0.3 animations:^(){
        
            [self setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-self.frame.size.height, self.frame.size.width, self.frame.size.height)];
        
        } completion:^(BOOL isFinish){
        
            [grayView removeFromSuperview];
            [self removeFromSuperview];
        
        }];
        
    }


}
-(void)setBgColor:(UIColor *)bgColor
{
    bgImgView.backgroundColor = bgColor;

}
-(void)setBgImg:(UIImage *)bgImg
{
    bgImgView.image = bgImg;

}
-(void)tap:(UIControl*)con
{

    [self dismiss];

}
-(void)dismiss
{
    [grayView setAlpha:0];
    [UIView animateWithDuration:0.3 animations:^(){
        
        [self setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.frame.size.width, self.frame.size.height)];
        
    } completion:^(BOOL isFinish){
        NSNotification *notification =[NSNotification notificationWithName:@"tanchu" object:nil userInfo:nil];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        [grayView removeFromSuperview];
        
        [self removeFromSuperview];
        
    }];

}

- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

@end
