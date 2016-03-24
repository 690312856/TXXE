//
//  EditMobilePhoneViewController.m
//  TXXE
//
//  Created by 李雨龙 on 15/7/27.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "EditMobilePhoneViewController.h"
#import "NSString+Addition.h"
#import "NetController.h"
#import "GlobalTool.h"


static const NSTimeInterval kCaptchaRefreshSeconds = 60;
@interface EditMobilePhoneViewController ()<UITextFieldDelegate>
{
    NSTimeInterval leftSeconds;
}

@property (nonatomic , strong) NSDictionary *callback;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *identifyCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *getIdentifyingCodeBtn;

@property (nonatomic , strong) NSTimer *timer;
//@property (nonatomic,strong)NSString *memberId;
@property (nonatomic,strong)NSString *pcode;

@end

@implementation EditMobilePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStyleBordered target:self action:@selector(changeConfirm)];
    rightButton.tintColor=[UIColor colorWithRed:0.0/255 green:191.0/255 blue:121.0/255 alpha:1.0];
    self.navigationItem.rightBarButtonItem = rightButton;
    leftSeconds = kCaptchaRefreshSeconds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)fetchIdentifyingCodeBtnAction:(UIButton *)sender
{
    if (self.mobileTextField.text && [self.mobileTextField.text isMobilePhoneNumber]) {
        if (!_timer) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerTick) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        }
        sender.enabled = NO;
        [self.timer setFireDate:[NSDate date]];
        [[NetController sharedInstance] postWithAPI:API_phone_captcha parameters:@{@"mobileNumber":self.mobileTextField.text} completionHandler:^(id responseObject, NSError *error) {
            if (error) {
                [[[UIAlertView alloc] initWithTitle:@"" message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
            } else {
                self.callback = responseObject[@"data"];
                [[[UIAlertView alloc] initWithTitle:@"" message:@"验证码已经发送到您的手机，请注意查收。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
            }
        }];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"" message:@"请收入完整的手机号码" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
    }
}

- (void)timerTick
{
    NSString *titleText = nil;
    if (leftSeconds == 0) {
        [self.timer setFireDate:[NSDate distantFuture]];
        titleText = @"获取验证码";
        self.getIdentifyingCodeBtn.enabled = YES;
        leftSeconds = kCaptchaRefreshSeconds;
        [self.getIdentifyingCodeBtn setTitle:titleText forState:UIControlStateNormal];
    } else {
        titleText = [NSString stringWithFormat:@"重发（%@）",@(leftSeconds)];
        leftSeconds --;
        [self.getIdentifyingCodeBtn setTitle:titleText forState:UIControlStateDisabled];
    }
}
- (BOOL)isValidToSubmit
{
    NSString *tip = nil;
    if (self.mobileTextField.text.length == 0 || ![self.mobileTextField.text isMobilePhoneNumber]) {
        tip = @"手机号码不能为空或者输入的不是手机号码！";
    }else if (!self.callback)
    {
        tip = @"请点击按钮获取验证码";
    }else if (self.identifyCodeTextField.text.length == 0) {
        tip = @"请输入验证码";
    } else if (![self.identifyCodeTextField.text isEqualToString:self.callback[@"verifyCode"]]) {
        tip = @"验证码输入不正确";
    }
    if (tip) {
        [GlobalTool tipsAlertWithTitle:@"信息不完整" message:tip cancelBtnTitle:@"确定"];
    }
    return tip == nil;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 100) {
        NSString *currentString = [NSString stringWithFormat:@"%@%@",textField.text,string];
        if (range.length == 1) {
            currentString = [currentString substringToIndex:[currentString length] - 1];
        }
        [self.getIdentifyingCodeBtn setEnabled:[currentString isMobilePhoneNumber]];
    }
    return YES;
}

- (void)changeConfirm
{
    if ([self isValidToSubmit]) {
        [self.view endEditing:YES];
        
        if (self.finishedMobilePhonePickBlock) {
            self.finishedMobilePhonePickBlock(self.mobileTextField.text);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
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
