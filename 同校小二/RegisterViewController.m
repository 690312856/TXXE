//
//  RegisterViewController.m
//  TXXE
//
//  Created by River on 15/6/28.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "RegisterViewController.h"
#import <CMPopTipView.h>
#import "UserModel.h"
#import "SchoolModel.h"
#import <MBProgressHUD.h>
#import "UIView+Addition.h"
#import "SimplifyAlertView.h"
#import "UITextField+Addition.h"
#import "NSString+Addition.h"
#import "GlobalTool.h"
#import "Constants.h"
#import "NetController.h"
#import "SchoolSelectViewController.h"
static const NSTimeInterval kCaptchaRefreshSenconds = 60;
@interface RegisterViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    SchoolModel *selectedSchool;
    NSTimeInterval leftSeconds;
}

@property (nonatomic,strong)NSDictionary *callback;
@property (weak, nonatomic) IBOutlet UIButton *schoolSelectBtn;
@property (weak, nonatomic) IBOutlet UIButton *goRegisterBtn;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *identifyCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;
@property (weak, nonatomic) IBOutlet UIButton *getIdentifyingCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *showPasswordBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *mianScrollView;
@property (nonatomic,strong)SchoolModel *schoolFetcher;
@property (nonatomic,strong)CMPopTipView *popTipView;
@property (nonatomic,strong)UITableView *popTipContentView;
@property (nonatomic,strong)NSTimer *timer;


@end

@implementation RegisterViewController

/*- (UIButton *)getIdentifyingCodeBtn
{
    if (!_getIdentifyingCodeBtn) {
        _getIdentifyingCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _getIdentifyingCodeBtn.frame = CGRectMake(0, 0, 80, 30);
        [_getIdentifyingCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        _getIdentifyingCodeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_getIdentifyingCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_getIdentifyingCodeBtn addTarget:self action:@selector(fetchIdentifyingCodeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_getIdentifyingCodeBtn setBackgroundColor:[UIColor greenColor]];
//        [_getIdentifyingCodeBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    return _getIdentifyingCodeBtn;
}*/

- (CMPopTipView *)popTipView
{
    if (!_popTipView) {
        _popTipView = [[CMPopTipView alloc] initWithCustomView:self.popTipContentView];
        _popTipView.animation = CMPopTipAnimationSlide;
        _popTipView.borderColor = [UIColor clearColor];
        _popTipView.cornerRadius = 0.0;
        _popTipView.pointerSize = 0;
        _popTipView.sidePadding = 8;
        _popTipView.topMargin = 0;
        _popTipView.maxWidth = 100;
        _popTipView.borderWidth = 0;
        _popTipView.dismissTapAnywhere = YES;
        _popTipView.has3DStyle = NO;
        _popTipView.hasGradientBackground = NO;
    }
    return _popTipView;
}

- (UITableView *)popTipContentView
{
    if (!_popTipContentView) {
        _popTipContentView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.schoolSelectBtn.frame.size.width , 120) style:UITableViewStylePlain];
        _popTipContentView.delegate = self;
        _popTipContentView.dataSource = self;
        [_popTipContentView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"kPopTipViewContentViewReuseKey"];
        if ([_popTipContentView respondsToSelector:@selector(setSeparatorInset:)]) {
            _popTipContentView.separatorInset = UIEdgeInsetsZero;
        }
    }
    return _popTipContentView;
}

- (SchoolModel *)schoolFetcher
{
    if (!_schoolFetcher) {
        _schoolFetcher = [[SchoolModel alloc] init];
    }
    return _schoolFetcher;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mianScrollView.frameWidth = SCREEN_WIDTH;
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.0/255 green:191.0/255 blue:121.0/255 alpha:1.0];
    [self.showPasswordBtn setBackgroundImage:[UIImage imageNamed:@"显示密码-选中"] forState:UIControlStateNormal];
    self.showPasswordBtn.tag = 100;
    [self.schoolFetcher fetchAllHotSchoolsWithCompletionHandler:^(NSArray *allSchools, NSError *error) {
        if (error) {
            [GlobalTool tipsAlertWithTitle:@"" message:@"获取学校列表出错" cancelBtnTitle:@"确定"];
        }
    }];
    leftSeconds = kCaptchaRefreshSenconds;
}


#pragma mark -
#pragma mark - Inner

- (void)timerTick
{
    NSString *titleText = nil;
    if (leftSeconds == 0) {
        [self.timer setFireDate:[NSDate distantFuture]];
        titleText = @"获取验证码";
        self.getIdentifyingCodeBtn.enabled = YES;
        leftSeconds = kCaptchaRefreshSenconds;
        [self.getIdentifyingCodeBtn setTitle:titleText forState:UIControlStateNormal];
    } else {
        titleText = [NSString stringWithFormat:@"重发（%@）",@(leftSeconds)];
        leftSeconds --;
        [self.getIdentifyingCodeBtn setTitle:titleText forState:UIControlStateDisabled];
    }
}

- (void)loginWithCompletionHandler:(void(^)(BOOL isSucceed))completionHandler
{
    NSString *userName = self.mobileTextField.text;
    NSString *pwd = self.passWordTextField.text;
    __weak __typeof(self)weakSelf = self;
    [[UserModel currentUser] loginWithAccoutId:userName password:pwd shouldRememberPwd:YES withCompletionHandler:^(NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideAllHUDsForView:strongSelf.view animated:YES];
        if (error) {
            if (completionHandler) {
                completionHandler(NO);
            }
        } else {
            [SimplifyAlertView alertWithTitle:@"注册成功" message:@"恭喜您注册成为同校小二" operationResult:^(NSInteger selectedIndex) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completionHandler) {
                        completionHandler(YES);
                    }
                    [strongSelf dismissViewControllerAnimated:YES completion:NULL];
                });
            } cancelButtonTitle:@"开始体验" otherButtonTitles:nil, nil];
        }
    }];
}

- (BOOL)isValidToSubmit
{
    NSString *tip = nil;
    if (!selectedSchool) {
        tip = @"请选择学校";
    } else if (self.mobileTextField.text.length == 0 || ![self.mobileTextField.text isMobilePhoneNumber]) {
        tip = @"手机号码不能为空或者输入的不是手机号码！";
    } else if (!self.callback) {
        tip = @"请点击按钮获取验证码";
    } else if (self.identifyCodeTextField.text.length == 0) {
        tip = @"请输入验证码";
    } else if (![self.identifyCodeTextField.text isEqualToString:self.callback[@"verifyCode"]]) {
        tip = @"验证码输入不正确";
    } else if (self.passWordTextField.text.length < 6 ) {
        tip = @"请输入六位以上的密码";
    }
    if (tip) {
        [GlobalTool tipsAlertWithTitle:@"注册信息不完整" message:tip cancelBtnTitle:@"确定"];
    }
    return tip == nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.schoolFetcher.cachedHotSchools.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kPopTipViewContentViewReuseKey"   forIndexPath:indexPath];
    SchoolModel *tempModel = self.schoolFetcher.cachedHotSchools[indexPath.row];
    cell.textLabel.text = tempModel.schoolName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SchoolModel *tempModel = self.schoolFetcher.cachedHotSchools[indexPath.row];
    [self.schoolSelectBtn setTitle:tempModel.schoolName forState:UIControlStateNormal];
    selectedSchool = tempModel;
    
    [self.popTipView dismissAnimated:YES];
}

#pragma mark -
#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 100) {
        [(UITextField *)[self.view viewWithTag:200] becomeFirstResponder];
    } else if (textField.tag == 200) {
        [(UITextField *)[self.view viewWithTag:300] becomeFirstResponder];
    } else if (textField.tag == 300) {
        [(UITextField *)[self.view viewWithTag:400] becomeFirstResponder];
    } else if (textField.tag == 400) {
        [self.view endEditing:YES];
        [self goRegisterBtnAction:nil];
    }
    return YES;
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

#pragma mark -
#pragma mark - Action

- (IBAction)schoolSelectAction:(UIButton *)sender {
    /*if (self.schoolFetcher.cachedHotSchools.count == 0) {
        return;
    }
    sender.selected = YES;
    [self.popTipContentView reloadData];
    [self.popTipView presentPointingAtView:sender inView:self.view animated:YES];*/
    SchoolSelectViewController *schoolSelectVC = [[SchoolSelectViewController alloc] init];
    schoolSelectVC.shouldCacheSelection = NO;
    schoolSelectVC.finishedSchoolPickBlock = ^(SchoolModel *pickedSchool){
        selectedSchool = pickedSchool;
        DISPATCH_MAIN(^(){
            self.schoolSelectBtn.titleLabel.text =  selectedSchool.schoolName;
        });
    };
    [self.navigationController pushViewController:schoolSelectVC animated:YES];
}
- (IBAction)goRegisterBtnAction:(UIButton *)sender {
    NSLog(@"mmmmmmm%@nnnnnnnnn%@",selectedSchool.schoolID,selectedSchool.schoolName);
    if ([self isValidToSubmit]) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        __weak __typeof(self)weakSelf = self;
        [[NetController sharedInstance]postWithAPI:API_user_register parameters:@{@"schoolId":selectedSchool.schoolID,@"mobileNumber":self.mobileTextField.text,@"passwd":self.passWordTextField.text,@"passwdConfirm":self.passWordTextField.text} completionHandler:^(id responseObject, NSError *error) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (error) {
                [GlobalTool tipsAlertWithTitle:@"注册出错" message:[error localizedDescription] cancelBtnTitle:@"确定"];
            }else {
                [strongSelf loginWithCompletionHandler:strongSelf.loginAuthorizeResult];
            }
            
            [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
        }];
    }
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
            }else{
                self.callback = responseObject[@"data"];
                [[[UIAlertView alloc] initWithTitle:@"" message:@"验证码已经发送到您的手机，请注意查收" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
            }
        }];
    } else{
        [[[UIAlertView alloc] initWithTitle:@"" message:@"请收入完整的手机号码" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
    }
}


- (IBAction)hidePassword:(id)sender {
    if (self.showPasswordBtn.tag == 100) {
        [self.showPasswordBtn setBackgroundImage:[UIImage imageNamed:@"显示密码-未选中"] forState:UIControlStateNormal];
        self.showPasswordBtn.tag = 200;
        
    }else
    {
        [self.showPasswordBtn setBackgroundImage:[UIImage imageNamed:@"显示密码-选中"] forState:UIControlStateNormal];
        self.showPasswordBtn.tag = 100;
    }
    self.passWordTextField.secureTextEntry = !self.passWordTextField.secureTextEntry;
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
