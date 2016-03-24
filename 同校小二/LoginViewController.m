//
//  LoginViewController.m
//  TXXE
//
//  Created by River on 15/6/28.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "LoginViewController.h"
#import "UITextField+Addition.h"
#import "Constants.h"
#import <MBProgressHUD.h>
#import "UserModel.h"
#import "KIKeyChain.h"
#import "NetController.h"

#import "UMSocialSnsPlatformManager.h"
#import "UMSocialDataService.h"
#import "UMSocialAccountManager.h"

#define kLastLoginUserAccountKey           @"kLastLoginUserAccountKey"

@interface LoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *accoutTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIView *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *findPasswordButton;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.0/255 green:191.0/255 blue:121.0/255 alpha:1.0];
    NSDictionary *lastLoginUser = [self lastLoginUserAccount];
    if (lastLoginUser) {
        self.accoutTextField.text = lastLoginUser[@"kUserName"];
        }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)isValidToLoginWithTipsShow:(BOOL)shouldShow
{
    NSString *tipsText = nil;
    if (self.accoutTextField.text.length == 0) {
        tipsText = @"请先输入用户名再登录";
    }else if (self.passwordTextField.text.length == 0)
    {
        tipsText = @"请输入密码";
    }
    if (shouldShow && tipsText) {
        [[[UIAlertView alloc] initWithTitle:@"登录信息不完整" message:tipsText delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }
    return tipsText? NO:YES;
}

- (void)dismissSelfWithLoginSucceed:(BOOL)isSucceed completion:(void(^)(void))completion
{
    if (!isSucceed) {
        self.loginAuthorizeResult = nil;
    } else
    {
        if (/* DISABLES CODE */ (YES))
        {
            NSDictionary *dict = @{@"kUserName":[UserModel currentUser].account};
            NSData *accountData = [NSKeyedArchiver archivedDataWithRootObject:dict];
            [[NSUserDefaults standardUserDefaults]setObject:accountData forKey:kLastLoginUserAccountKey];
            if (![[NSUserDefaults standardUserDefaults] synchronize])
            {
                NSLog(@"登录成功后用户名保存失败");
            }
            if (![[UserModel currentUser] insertIntoDatabase]) {
                NSLog(@"登录成功，但是存入数据库出错");
            }
        } else
        {
            if ([[self lastLoginUserAccount][@"kUserName"] isEqualToString:self.accoutTextField.text])
            {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:kLastLoginUserAccountKey];
                if (![[NSUserDefaults standardUserDefaults] synchronize])
                {
                    NSLog(@"登陆成功后删除用户名保存失败");
                }
            }

        }
        
    }
    NSLog(@"666666666666yyyyyy%@",[UserModel currentUser].memberId);
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:[UserModel currentUser].memberId,@"memberID", nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"chuanmemberidzhiappdelegate" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    [self dismissViewControllerAnimated:YES completion:completion];
}


-(NSDictionary *)lastLoginUserAccount
{
    NSData *data = [[NSUserDefaults standardUserDefaults]objectForKey:kLastLoginUserAccountKey];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}


#pragma mark - UITextFeildDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.accoutTextField isEqual:textField]) {
        [self.passwordTextField becomeFirstResponder];
    } else if ([self.passwordTextField isEqual:textField]) {
        [self loginBtnAction:nil];
    }
    return YES;
}
- (IBAction)leftCancelBarBtnItemAction:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.loginAuthorizeResult) {
            self.loginAuthorizeResult(NO);
        }
    }];
}
- (IBAction)loginBtnAction:(UIButton *)sender {
    
    if ([self isValidToLoginWithTipsShow:YES]) {
        [self.view endEditing:YES];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        __weak __typeof(self)weakSelf = self;
        [[UserModel currentUser] loginWithAccoutId:self.accoutTextField.text password:self.passwordTextField.text shouldRememberPwd:YES withCompletionHandler:^(NSError *error) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [MBProgressHUD hideAllHUDsForView:strongSelf.view animated:YES];
            if (!error) {
                
                KIKeyChain *key = [KIKeyChain keyChainWithIdentifier:@"default_user"];
                [key setValue:self.accoutTextField.text forKey:@"username"];
                [key setValue:self.passwordTextField.text forKey:@"password"];
                [key setValue:[NSDate date] forKey:@"date"];
                [key write];
                
                [strongSelf dismissSelfWithLoginSucceed:YES completion:^{
                    NSLog(@"44444444");
                    strongSelf.loginAuthorizeResult(YES);
                }];
            } else{
                [[[UIAlertView alloc] initWithTitle:@"登录失败" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                if (self.loginAuthorizeResult) {
                    self.loginAuthorizeResult(NO);
                }
            }
        }];
    }
    
}
- (IBAction)weChatButtonAction:(id)sender {
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            
            [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToWechatSession completion:^(UMSocialResponseEntity *respose){
                NSLog(@"get openid  response is %@",respose);
                
                NSUserDefaults *userDF = [NSUserDefaults standardUserDefaults];
                NSString *First = [userDF objectForKey:@"schoolSelected"];
                NSLog(@"666666666666%@",First);
                
                NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",respose.data[@"access_token"],respose.data[@"openid"]];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSURL *zoneUrl = [NSURL URLWithString:url];
                    NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
                    NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (data) {
                            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                            
                            KIKeyChain *key = [KIKeyChain keyChainWithIdentifier:@"default_wxuser"];
                            [key setValue:[dic objectForKey:@"unionid"] forKey:@"unionid"];
                            [key setValue:[dic objectForKey:@"nickname"] forKey:@"nickname"];
                            [key setValue:[dic objectForKey:@"sex"] forKey:@"sex"];
                            [key setValue:[dic objectForKey:@"headimgurl"] forKey:@"headimgurl"];
                            [key setValue:[NSDate date] forKey:@"date"];
                            [key write];
                            
                            //KIKeyChain *token = [KIKeyChain keyChainWithIdentifier:@"token"];
                            //NSLog(@"ios%@",[token valueForKey:@"token"]);
                            
                            [self registerNewAccountForWeixinWithDict:@{@"unionid":[dic objectForKey:@"unionid"],@"nickname":[dic objectForKey:@"nickname"],@"sex":[dic objectForKey:@"sex"],@"headimgurl":[dic objectForKey:@"headimgurl"],@"schoolId":First}];
                            //@"iosToken":[token valueForKey:@"token"],
                            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        }
                    });
                    
                });
                
            }];
        }
    });
    
}



- (void)registerNewAccountForWeixinWithDict:(NSDictionary *)dict
{
    __weak __typeof(self)weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NetController sharedInstance] postWithAPI:API_Weixin_login parameters:dict completionHandler:^(id responseObject, NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (error) {
            NSLog(@"error = %@",error);
            if (strongSelf.loginAuthorizeResult) {
                strongSelf.loginAuthorizeResult(NO);
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }
        } else {
            [[UserModel currentUser] setValuesForKeysWithDictionary:responseObject[@"data"]];
            //登陆成功
            NSLog(@"hahahha%@",[UserModel currentUser].account);
            [self dismissSelfWithLoginSucceed:YES completion:^{
                if (strongSelf.loginAuthorizeResult) {
                    strongSelf.loginAuthorizeResult(YES);
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                }
            }];
        }
    }];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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
