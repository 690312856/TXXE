//
//  UserModel.m
//  TXXE
//
//  Created by River on 15/6/7.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "UserModel.h"
#import "NetController.h"
#import "ACDBManager.h"
#import "Constants.h"
#import "LoginViewController.h"
#import "GlobalTool.h"
#import "KIKeyChain.h"

@implementation UserModel

- (SchoolModel *)currentSelectSchool
{
    if (!_currentSelectSchool) {
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults]dictionaryForKey:@"kSelectedScoolInUserDefaultKey"];
        if (dict.count != 0) {
            SchoolModel *tempSchool = [[SchoolModel alloc]init];
            [tempSchool setValuesForKeysWithDictionary:dict];
            return _currentSelectSchool = tempSchool;
        } else{
            return nil;
        }
    }else {
        return _currentSelectSchool;
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        self.normalCategoryArr = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

+ (instancetype)currentUser
{
    static UserModel *user_ptr = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        user_ptr = [[UserModel alloc]init];
    });
    return user_ptr;
}

- (BOOL)isCurrentUserValid
{
    NSLog(@"222");
    return (self.memberId.length != 0);
}
- (NSString *)memberId
{
    if (!_memberId) {
        if ([[NetController sharedInstance] serverReachability].reachable) {
            UserModel *user = [[self class] lastLoginUserInDatabase];
            if (user) {
                [self setValuesForKeysWithDictionary:[user convertToDictionary]];
            }
        }
    }
    return _memberId;
}

- (NSURL *)avatarUrl
{
    if (self.avatarUrlText.length == 0) {
        return nil;
    } else {
        return [NSURL URLWithString:self.avatarUrlText];
    }
}

- (void)setValuesForKeysWithDictionary:(NSDictionary *)keyedValues
{
    if ([keyedValues allKeys].count!=0){
        self.memberId = [keyedValues[@"memberId"] stringValue];
        self.account = [keyedValues[@"account"] stringValue];
        SchoolModel *tempSchoolModel = [[SchoolModel alloc] init];
        tempSchoolModel.schoolID = [keyedValues[@"schoolId"] stringValue];
        tempSchoolModel.schoolName = [keyedValues[@"schoolName"] stringValue];
        self.school = tempSchoolModel;
        self.nickName = keyedValues[@"nickName"];
        self.avatarUrlText = keyedValues[@"avatar"];
        self.mobileNumber = keyedValues[@"mobileNumber"];
        self.qq = keyedValues[@"qq"];
        self.preferences = keyedValues[@"preferences"];
        //NSLog(@"ppppppppp%@",self.preferences);
        self.alipayAccount = keyedValues[@"alipay"];
        NSLog(@"ppppppppp%@",self.alipayAccount);
        self.level = keyedValues[@"level"] ;
        self.integrity = [keyedValues[@"completetion"] stringValue];
        self.score = [keyedValues[@"score"] stringValue];
        
    }
}

- (NSDictionary *)convertToDictionary
{
    NSMutableDictionary *dictionay = [NSMutableDictionary dictionary];
    
    [dictionay setValue:self.memberId forKey:@"memberId"];
    [dictionay setValue:self.account forKey:@"account"];
    [dictionay setValue:self.school.schoolID forKey:@"schoolId"];
    [dictionay setValue:self.school.schoolName forKey:@"schoolName"];
    [dictionay setValue:self.nickName forKey:@"nickName"];
    [dictionay setValue:self.avatarUrlText forKey:@"avatar"];
    [dictionay setValue:self.mobileNumber forKey:@"mobileNumber"];
    [dictionay setValue:self.qq forKey:@"qq"];
    [dictionay setValue:self.preferences forKey:@"preferences"];
    [dictionay setValue:self.alipayAccount forKey:@"alipay"];
    [dictionay setValue:self.level forKey:@"level"];
    [dictionay setValue:self.integrity forKey:@"completetion"];
    [dictionay setValue:self.score forKey:@"score"];
    return dictionay;
}

- (NSString *)description
{
    return [self convertToDictionary].description;
}

+ (NSString *)tableName
{
    return @"T_User";
}

- (NSString *)tableName
{
    return [[self class] tableName];
}

- (BOOL)insertIntoDatabase
{
    if ([[self class] deleteAllInDatabase]) {
        return [[ACDBManager sharedInstance] insertIntoTable:[self tableName] withAttribute:[self convertToDictionary]];
    } else {
        return NO;
    }
}

- (BOOL)updateInDatabase
{
    NSString *condition = [NSString stringWithFormat:@"where memberId='%@'",self.memberId];
    return [[ACDBManager sharedInstance] updateForTable:[self tableName] withAttribute:[self convertToDictionary] withSQLCondition:condition];
}


- (BOOL)deleteInDatabase
{
    NSString *condition = [NSString stringWithFormat:@"where memberId='%@'",self.memberId];
    return [[ACDBManager sharedInstance] deleteInTable:[self tableName] withSQLCondition:condition];
}

+ (BOOL)deleteAllInDatabase
{
    return [[ACDBManager sharedInstance] deleteInTable:[self tableName] withSQLCondition:nil];
}

+ (UserModel *)lastLoginUserInDatabase
{
    NSArray *result = [[ACDBManager sharedInstance] queryTable:[self tableName] withSQLCondition:nil];
    if (result.count != 0) {
        NSDictionary *dict = [result lastObject];
        UserModel *tempModel = [[UserModel alloc] init];
        [tempModel setValuesForKeysWithDictionary:dict];
        return tempModel;
    } else {
        return nil;
    }
}

- (BOOL)isValidToSubmit
{
    NSString *tip = nil;
    if(self.qq.length<5 && self.qq.length>0)
    {
        tip = @"请输入有效qq号";
    }else if(self.alipayAccount.length != 0)
    {
        if ([self.alipayAccount isMobilePhoneNumber]) {
        }else if ([self.alipayAccount isE_Mail]){
        }else{
            tip = @"请输入有效支付宝帐号";
        }
        
    }
    
    if (tip) {
        [GlobalTool tipsAlertWithTitle:@"注册信息不完整" message:tip cancelBtnTitle:@"确定"];
    }
    return tip == nil;
}
- (void)updateProfileInfoWithCompletionHandler:(void (^)(NSError *))completionHandler
{
    //[self isValidToSubmit];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[self convertToDictionary]];
    NSArray *keys = [dict allKeys];
    for (NSString *key in keys) {
        NSString *value = dict[key];
        if (!value || ![value isKindOfClass:[NSString class]] || value.length == 0) {
            [dict removeObjectForKey:key];
        }
    }
    //
    [[NetController sharedInstance] postWithAPI:API_Profile_update parameters:dict completionHandler:^(id responseObject, NSError *error) {
        if (error) {
            completionHandler(error);
        } else {
            completionHandler(nil);
        }
    }];
}

- (void)loginWithAccoutId:(NSString *)accoutId password:(NSString *)password shouldRememberPwd:(BOOL)shouldRemember withCompletionHandler:(void (^)(NSError *))completionHandler
{
    //KIKeyChain *token = [KIKeyChain keyChainWithIdentifier:@"token"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setValue:accoutId forKey:@"account"];
    [postDict setValue:password forKey:@"passwd"];
   // [postDict setValue:[token valueForKey:@"token"] forKey:@"iosToken"];
    __weak __typeof(self)weakSelf = self;
    [[NetController sharedInstance] postWithAPI:API_user_login parameters:postDict completionHandler:^(id responseObject, NSError *error) {
        if (error) {
            completionHandler(error);
        } else {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf setValuesForKeysWithDictionary:responseObject[@"data"]];
            completionHandler(nil);
        }
    }];
}

- (void)operationAuthorizeWithCompletionHandler:(void (^)(BOOL))completionHandler
{
    if (![self isCurrentUserValid]) {
        [self presentModalLoginViewControllerWithCompletionHandler:completionHandler];
    } else {
        completionHandler(YES);
    }
}

- (void)presentModalLoginViewControllerWithCompletionHandler:(void (^)(BOOL isSucceed))completionHandler
{
    UINavigationController *loginNav = [[UIStoryboard storyboardWithName:@"UserLoginAndRegister" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
    LoginViewController *loginVC = (LoginViewController *)loginNav.topViewController;
    NSLog(@"3333");
    loginVC.loginAuthorizeResult = completionHandler;
        [[self getCurrentVC] presentViewController:loginNav animated:YES completion:^{}];
}

- (void)logout
{
    //TODO:补充完整
    [[NSNotificationCenter defaultCenter] postNotificationName:kUserLogoutNotification object:nil];
    //    取消第三方授权
    /*for (NSString *platformType in @[UMShareToSina,UMShareToRenren,UMShareToQQ,UMShareToWechatSession]) {
        [[UMSocialDataService defaultDataService] requestUnOauthWithType:platformType completion:^(UMSocialResponseEntity *response) {
            NSLog(@"%@ unOauth response is %@",platformType,response);
        }];
    }*/
    
    self.currentSelectSchool = nil;
    if (![self deleteInDatabase]) {
        NSLog(@"退出登录，在数据库中删除失败");
    }
    _memberId = nil;
    [self setValue:nil forKey:@"memberId"];
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
