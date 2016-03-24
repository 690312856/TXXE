//
//  InputNewPwdViewController.m
//  TXXE
//
//  Created by River on 15/6/28.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "InputNewPwdViewController.h"
#import "NSString+Addition.h"
#import "GlobalTool.h"
#import <MBProgressHUD.h>
#import "NetController.h"
#import "AppDelegate.h"

@interface InputNewPwdViewController ()
@property (weak, nonatomic) IBOutlet UITextField *passwordInputTextField;
@property (nonatomic,strong)NSString *memberId;
@property (nonatomic,strong)NSString *pcode;
@end

@implementation InputNewPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc]initWithTitle:@"确认" style:UIBarButtonItemStyleBordered target:self action:@selector(verify)];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.0/255 green:191.0/255 blue:121.0/255 alpha:1.0];
    rightButton.tintColor=[UIColor colorWithRed:0.0/255 green:191.0/255 blue:121.0/255 alpha:1.0];
    self.navigationItem.rightBarButtonItem = rightButton;
    AppDelegate *appDelegate=[[UIApplication sharedApplication] delegate];
    self.memberId = appDelegate.memberId;
    self.pcode = appDelegate.pcode;
    NSLog(@"!!!!!!!!%@",self.memberId);
    NSLog(@"?????????%@",self.pcode);
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)verify
{
    if ([self isValidToSubmit]) {
        [self.view endEditing:YES];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        __weak __typeof(self)weakSelf = self;
        //api
        [[NetController sharedInstance]postWithAPI:API_passwordReset parameters:@{@"memberId":self.memberId,@"passwd":self.passwordInputTextField.text,@"passwdConfirm":self.passwordInputTextField.text,@"pcode":self.pcode} completionHandler:^(id responseObject, NSError *error) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (error) {
                [GlobalTool tipsAlertWithTitle:@"修改密码出错" message:[error localizedDescription] cancelBtnTitle:@"确定"];
            }else {
                [GlobalTool tipsAlertWithTitle:@"修改密码成功" message:@"请重新登录" cancelBtnTitle:@"确定"];
                [strongSelf dismissViewControllerAnimated:YES completion:nil];
            }
            
            [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
        }];
    }
}

- (BOOL)isValidToSubmit
{
    NSString *tip = nil;
    if (self.passwordInputTextField.text.length == 0) {
        tip = @"手机号码不能为空或者输入的不是手机号码！";
    }
    if (tip) {
        [GlobalTool tipsAlertWithTitle:@"信息不完整" message:tip cancelBtnTitle:@"确定"];
    }
    return tip == nil;
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
