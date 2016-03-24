//
//  ActivityDetailViewController.m
//  TXXE
//
//  Created by 李雨龙 on 15/9/21.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import "Constants.h"
@interface ActivityDetailViewController ()

@end

@implementation ActivityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.0/255 green:191.0/255 blue:121.0/255 alpha:1.0];
    self.title = @"活动详情";
    [self requestHtml];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    for (UIView *view in self.parentViewController.tabBarController.view.subviews) {
        if (view.tag == 100) {
            view.hidden = YES;
        }
    }
}
-(void)requestHtml
{
    _webView.delegate = self;
    _webView.scrollView.delegate = self;
    [_webView.scrollView setBounces:NO];
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.activityUrl]]];
    
    [self.view  addSubview:_webView];
    _webView.scalesPageToFit = YES;
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
