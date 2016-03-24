//
//  CustomTabBarController.m
//  TXXE
//
//  Created by River on 15/6/6.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "CustomTabBarController.h"
#import "CreateGoodViewController.h"
#import "CreateAskViewController.h"
#import "AskGoodViewController.h"
#import "UIView+Addition.h"
#import "NetController.h"
#import "UserModel.h"
#import "AppDelegate.h"

@interface CustomTabBarController ()

@property (strong,nonatomic)UIView *tabBarView;
@property (strong,nonatomic)UIView *popView;
@property (nonatomic,assign)long *isReadeda;
@property (nonatomic,assign)long *isReadedb;
@end

@implementation CustomTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    currItem = 0;
    self.tabBar.hidden = YES;
    UIScreen *s = [UIScreen mainScreen];
    CGFloat width = [s bounds].size.width;
    CGFloat height = [s bounds].size.height;
    self.tabBarView = [[UIView alloc]initWithFrame:CGRectMake(0, height-48, width, 48)];
    self.tabBarView.backgroundColor = [UIColor whiteColor];
    self.tabBarView.tag = 100;
    [self.view addSubview:self.tabBarView];
    [self configTabBarView];
    [self configPopView];
    [self changeTabBarItemImage:currItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tuichu) name:@"logout" object:nil];
    //订阅展示视图消息，将直接打开某个分支视图
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentView:) name:@"PresentView" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestData
{
    __weak __typeof(self)weakSelf = self;
    ////////api
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    //NSLog(@"5555555555555555555555555555555%@",appDelegate.tabmemberId);
    if (appDelegate.tabmemberId != nil) {
        [[NetController sharedInstance] postWithAPI:API_check_message parameters:@{@"memberId":appDelegate.tabmemberId} completionHandler:^(id responseObject, NSError *error) {
            if (error) {
            }else
            {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                strongSelf.isReadeda = [responseObject[@"data"][@"cntNewMessages"] boolValue];
                strongSelf.isReadedb = [responseObject[@"data"][@"cntNewSysMessages"] boolValue];
            }
        }];
    }else
    {
        self.isReadeda = 0;
        self.isReadedb = 0;
    }
    
}

#pragma mark - tabBarView
- (void)configTabBarView
{
    //self.tabBar.hidden = YES;
    UIScreen *s = [UIScreen mainScreen];
    CGFloat width = [s bounds].size.width;
    //CGFloat height = [s bounds].size.height;
    for (UIView *view in self.tabBarView.subviews) {
        if ([view class] == [UIButton class]) {
            [view removeFromSuperview];
        }
    }
    UIButton *lineBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,width,0.5)];
    lineBtn.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:199.0/255.0 blue:204.0/255.0 alpha:1];
    lineBtn.userInteractionEnabled = NO;
    [self.tabBarView addSubview:lineBtn];
    for (int i = 0; i < 5; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*width/5.0, 0, width/5.0, 48);
        if (i==3) {
            if (self.isReadeda || self.isReadedb) {
                UIImage *image = [UIImage imageNamed:@"动态有提示-灰"];
                [button setImage:image forState:UIControlStateNormal];
                button.tag = i;
                [button addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
                [self.tabBarView addSubview:button];
            }else
            {
                UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i]];
                [button setImage:image forState:UIControlStateNormal];
                button.tag = i;
                [button addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
                [self.tabBarView addSubview:button];
            }
        }else
        {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i]];
        [button setImage:image forState:UIControlStateNormal];
        button.tag = i;
        [button addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabBarView addSubview:button];
        }
    }
}

#pragma mark - popView
- (void)configPopView
{
    UIScreen *s = [UIScreen mainScreen];
    CGFloat width = [s bounds].size.width;
    CGFloat height = [s bounds].size.height;
    
    self.popView = [[UIView alloc]initWithFrame:CGRectMake(0, height/2.0, width, height/2.0)];
    self.popView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.95];
    
    UIButton *fabu = [UIButton buttonWithType:UIButtonTypeCustom];
    fabu.layer.cornerRadius = width/8.0;
    fabu.frame = CGRectMake(width/12.0, width/5.0, width/3.0, width/3.0);
    [fabu setBackgroundImage:[UIImage imageNamed:@"发布商品"] forState:UIControlStateNormal];
    fabu.backgroundColor = [UIColor clearColor];
    [fabu addTarget:self action:@selector(tapFabu) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *qiugou = [UIButton buttonWithType:UIButtonTypeCustom];
    qiugou.layer.cornerRadius = width/8.0;
    qiugou.frame = CGRectMake(width*7/12.0, width/5.0, width/3.0, width/3.0);
    [qiugou setBackgroundImage:[UIImage imageNamed:@"发布求购"] forState:UIControlStateNormal];
    qiugou.backgroundColor = [UIColor clearColor];
    [qiugou addTarget:self action:@selector(tapQiugou) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
    close.frame = CGRectMake(0, height/2.0-48, width, 48);
    [close setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    close.backgroundColor =[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.95];
    [close setTitle:@"取消" forState:UIControlStateNormal];
    [close setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [close setTintColor:[UIColor blackColor]];
    [close addTarget:self action:@selector(tapClose) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, height/2.0-48, width, 1)];
    view.backgroundColor = [UIColor blackColor];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popViewTapped:)];
    [self.popView addGestureRecognizer:singleTap];
    
    [self.popView addSubview:view];
    [self.popView addSubview:fabu];
    [self.popView addSubview:qiugou];
    [self.popView addSubview:close];
}

#pragma mark - 点击自定义tabbar按钮
- (void)tapButton:(UIButton *)button
{
    [self requestData];
    [self configTabBarView];
    if (button.tag == 2) {
        if ([UserModel currentUser].isCurrentUserValid) {
            NSLog(@"pppppp");
            [UIView animateWithDuration:0.5 animations:^{
                [self.view addSubview:self.popView];
            }];
        } else {
            [[UserModel currentUser] operationAuthorizeWithCompletionHandler:^(BOOL isValidUser) {
                if (isValidUser) {
                    [UIView animateWithDuration:0.5 animations:^{
                        [self.view addSubview:self.popView];
                    }];
                }
            }];
        }
    }else if (button.tag == 3)
    {
        if ([UserModel currentUser].isCurrentUserValid) {
            NSLog(@"pppppp");
            [self setSelectedIndex:button.tag-1];
            currItem = 3;
        } else {
            [[UserModel currentUser] operationAuthorizeWithCompletionHandler:^(BOOL isValidUser) {
                if (isValidUser) {
                    NSLog(@"QQQQQQQ");
                [self setSelectedIndex:button.tag-1];
                currItem = 3;
                [self changeTabBarItemImage:currItem];
                }
            }];
        }
        
        [self changeTabBarItemImage:currItem];
    }else if (button.tag == 4)
    {
        if ([UserModel currentUser].isCurrentUserValid) {
            NSLog(@"pppppp");
            [self setSelectedIndex:button.tag-1];
            currItem = 4;
            [self changeTabBarItemImage:currItem];
        } else {
            
            [[UserModel currentUser] operationAuthorizeWithCompletionHandler:^(BOOL isValidUser) {
                if (isValidUser) {
                    //NSLog(@"QQQQQQQ%@",isValidUser);
                    
                    currItem = 4;
                    [self changeTabBarItemImage:currItem];
                    [self setSelectedIndex:button.tag-1];
                }
            }];
            
        }
        
    }else if (button.tag == 0){
        [self setSelectedIndex:button.tag];
        currItem = 0;
        [self changeTabBarItemImage:currItem];
    }else if (button.tag == 1)
    {
        [self setSelectedIndex:button.tag];
        currItem = 1;
        [self changeTabBarItemImage:currItem];
    }
    
}

#pragma mark -点击fabu
- (void)tapFabu
{
    UIViewController *createGoodVC = [[UIStoryboard storyboardWithName:@"CreateGoodViewController" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
    [self presentViewController:createGoodVC animated:YES completion:NULL];
    [self.popView removeFromSuperview];
}

#pragma mark -点击qiugou
- (void)tapQiugou
{
    UIViewController *askGoodVC = [[UIStoryboard storyboardWithName:@"CreateAskViewController" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
    [self presentViewController:askGoodVC animated:YES completion:NULL];
    [self.popView removeFromSuperview];
}

#pragma mark -点击close
- (void)tapClose
{
    [self.popView removeFromSuperview];
}


- (void)changeTabBarItemImage:(int)curItem
{
    for (UIButton *btn in self.tabBarView.subviews) {
        if (btn.tag != 2) {
            if (btn.tag == curItem) {
                if (curItem == 3) {
                    if (self.isReadedb || self.isReadeda) {
                        [btn setImage:[UIImage imageNamed:@"动态有提示-绿"] forState:UIControlStateNormal];
                    }else{
                        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"s%d",curItem]] forState:UIControlStateNormal];
                    }
                }else
                {
                [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"s%d",curItem]] forState:UIControlStateNormal];
                }
            }else
            {
                if (btn.tag==3) {
                    if (self.isReadeda || self.isReadedb) {
                        [btn setImage:[UIImage imageNamed:@"动态有提示-灰"] forState:UIControlStateNormal];
                        
                    }else
                    {
                        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%ld",(long)btn.tag]] forState:UIControlStateNormal];
                    }
                }else
                {
                    [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%ld",(long)btn.tag]] forState:UIControlStateNormal];
                }
            }
        }
        
    }
}

- (void)tuichu
{
    [self setSelectedIndex:0];
    [self changeTabBarItemImage:0];
    
}


- (void)popViewTapped:(UITapGestureRecognizer *)sender
{
    [self.popView removeFromSuperview];
}


- (void)presentView:(NSNotification *)text
{
    NSLog(@"123455");
}
























/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
