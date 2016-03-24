//
//  FeedBackViewController.m
//  TXXE
//
//  Created by 李雨龙 on 15/9/5.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "FeedBackViewController.h"
#import <MBProgressHUD.h>
#import "NetController.h"
#import "UserModel.h"
#import "GlobalTool.h"

@interface FeedBackViewController ()<UITextViewDelegate,UIAlertViewDelegate>

@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"意见反馈";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemAction)];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.0/255 green:191.0/255 blue:121.0/255 alpha:1.0];
    [self.textView becomeFirstResponder];
    [self.textView.layer setCornerRadius:10];
    self.modalPresentationCapturesStatusBarAppearance = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textViewDidChange:(UITextView *)textView
{
    self.tucao =  textView.text;
    if (textView.text.length == 0) {
        self.label.text = @"你的吐槽就是小二前进的动力";
    }else{
        self.label.text = @"";
    }
}

- (void)rightBarButtonItemAction
{
    if (self.tucao.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写意见再提交" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
        return;
    }else
    {
        __weak __typeof(self)weakSelf = self;
        [[NetController sharedInstance]postWithAPI:API_feed_back parameters:@{@"memberId":[UserModel currentUser].memberId,@"title":@"意见反馈",@"contents":self.tucao} completionHandler:^(id responseObject, NSError *error) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (error) {
                [GlobalTool tipsAlertWithTitle:@"意见反馈出错" message:[error localizedDescription] cancelBtnTitle:@"确定"];
            }else {
                [GlobalTool tipsAlertWithTitle:@"意见反馈成功" message:[error localizedDescription] cancelBtnTitle:@"确定"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            
            
        }];
    }
}

@end
