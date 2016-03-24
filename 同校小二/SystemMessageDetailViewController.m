//
//  SystemMessageDetailViewController.m
//  TXXE
//
//  Created by 李雨龙 on 15/7/30.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "SystemMessageDetailViewController.h"

@interface SystemMessageDetailViewController ()

@end

@implementation SystemMessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.0/255 green:191.0/255 blue:121.0/255 alpha:1.0];
    self.title = @"系统通知";
    self.modalPresentationCapturesStatusBarAppearance = NO;
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    //self.extendedLayoutIncludesOpaqueBars = NO;
    self.messageDetail.text = self.detail;
    for (UIView *view in self.parentViewController.tabBarController.view.subviews) {
        if (view.tag == 100) {
            view.hidden = YES;
        }
    }
    [self.messageDetail setFont:[UIFont systemFontOfSize:17.0]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
