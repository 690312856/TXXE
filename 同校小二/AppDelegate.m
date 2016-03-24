//
//  AppDelegate.m
//  TXXE
//
//  Created by River on 15/6/5.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "AppDelegate.h"
#import "UserModel.h"
#import "KIKeyChain.h"
#import "NetController.h"
#import "GoodDetailViewController.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaHandler.h"

@interface AppDelegate ()
@property (nonatomic) BOOL isLaunchedByNotification;
@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    if([[[UIDevice currentDevice]systemVersion]floatValue] >=8.0)
        
    {
        
        [[UIApplication sharedApplication]registerUserNotificationSettings:[UIUserNotificationSettings
                                                                            
                                                                            settingsForTypes:(UIUserNotificationTypeSound|UIUserNotificationTypeAlert|UIUserNotificationTypeBadge)
                                                                            
                                                                            categories:nil]];
        
        [[UIApplication sharedApplication]registerForRemoteNotifications];
        
    }else{
        
        //这里还是原来的代码
        
        //注册启用push
        
        [[UIApplication sharedApplication]registerForRemoteNotificationTypes:
         
         (UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge)];
        
    }
    
   /* NSDictionary* remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotification != nil) {
        self.isLaunchedByNotification = YES;
        
    }*/

    KIKeyChain *key1 = [KIKeyChain keyChainWithIdentifier:@"default_user"];
    KIKeyChain *key2 = [KIKeyChain keyChainWithIdentifier:@"default_wxuser"];
    NSLog(@"1111111%@",[key1 valueForKey:@"date"]);
    NSLog(@"2222222%@",[key2 valueForKey:@"date"]);
    
    if ([key1 valueForKey:@"date"]== nil && [key2 valueForKey:@"date"]==nil) {

    }else if ([key1 valueForKey:@"date"]!= nil && [key2 valueForKey:@"date"]==nil)
    {
        [[UserModel currentUser] loginWithAccoutId:[key1 valueForKey:@"username"] password:[key1 valueForKey:@"password"] shouldRememberPwd:YES withCompletionHandler:^(NSError *error) {
            if (!error) {
                NSLog(@"44444444");
                NSLog(@"hahahha%@",[UserModel currentUser].memberId);
                self.tabmemberId = [UserModel currentUser].memberId;
            } else{
                
            }
        }];
    }else if ([key1 valueForKey:@"date"]== nil && [key2 valueForKey:@"date"]!=nil)
    {
        NSLog(@"222222");
        
        [[NetController sharedInstance] postWithAPI:API_Weixin_login parameters:@{@"unionid":[key2 valueForKey:@"unionid"],
                                                                                  @"nickname":[key2 valueForKey:@"nickname"],
                                                                                  @"sex":[key2 valueForKey:@"sex"],
                                                                                  @"headimgurl":[key2 valueForKey:@"headimgurl"]} completionHandler:^(id responseObject, NSError *error) {
                                                                                     
                                                                                      if (error) {
                                                                                          NSLog(@"error = %@",error);
                                                                                
                                                                                      } else {
                                                                                          [[UserModel currentUser] setValuesForKeysWithDictionary:responseObject[@"data"]];
                                                                                          //登陆成功
                                                                                          NSLog(@"hahahha%@",[UserModel currentUser].account);
                                                                                          NSLog(@"hahahha%@",[UserModel currentUser].memberId);
                                                                                          self.tabmemberId = [UserModel currentUser].memberId;
                                                                                      }
                                                                                  }];
    }else if ([key1 valueForKey:@"date"]!= nil && [key2 valueForKey:@"date"]!=nil)
    {
        if ([[key1 valueForKey:@"date"] timeIntervalSince1970]*1-[[key2 valueForKey:@"date"] timeIntervalSince1970]*1 > 0) {
            [[UserModel currentUser] loginWithAccoutId:[key1 valueForKey:@"username"] password:[key1 valueForKey:@"password"] shouldRememberPwd:YES withCompletionHandler:^(NSError *error) {
                if (!error) {
                    NSLog(@"44444444");
                    NSLog(@"hahahha%@",[UserModel currentUser].memberId);
                    self.tabmemberId = [UserModel currentUser].memberId;
                } else{
                    
                }
            }];
        }else
        {
            //__weak __typeof(self)weakSelf = self;
            //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [[NetController sharedInstance] postWithAPI:API_Weixin_login parameters:@{@"unionid":[key2 valueForKey:@"unionid"],
                                                                                      @"nickname":[key2 valueForKey:@"nickname"],
                                                                                      @"sex":[key2 valueForKey:@"sex"],
                                                                                      @"headimgurl":[key2 valueForKey:@"headimgurl"]} completionHandler:^(id responseObject, NSError *error) {
                                                                                          // __strong __typeof(weakSelf)strongSelf = weakSelf;
                                                                                          //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                                                                          if (error) {
                                                                                              NSLog(@"error = %@",error);
                                                                                              //if (strongSelf.loginAuthorizeResult) {
                                                                                              //  strongSelf.loginAuthorizeResult(NO);
                                                                                              //}
                                                                                          } else {
                                                                                              [[UserModel currentUser] setValuesForKeysWithDictionary:responseObject[@"data"]];
                                                                                              //登陆成功
                                                                                              NSLog(@"hahahha%@",[UserModel currentUser].account);
                                                                                              NSLog(@"hahahha%@",[UserModel currentUser].memberId);
                                                                                              self.tabmemberId = [UserModel currentUser].memberId;
                                                                                              //[self dismissSelfWithLoginSucceed:YES completion:^{
                                                                                              //   if (strongSelf.loginAuthorizeResult) {
                                                                                              //   strongSelf.loginAuthorizeResult(YES);
                                                                                              //   }
                                                                                              // }];
                                                                                          }
                                                                                      }];
        }
    }
    
    
    
    
    
    
    
    

    
    
    
    
    
    
    NSUserDefaults *userDF = [NSUserDefaults standardUserDefaults];
    BOOL isFirst = [userDF boolForKey:@"isFirst"];
    NSLog(@"isFirst is:%d", isFirst);
    
    if (! isFirst) {
        self.window.rootViewController = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"leadVC"];
    } else {
        self.window.rootViewController = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"appVC"];
        NSLog(@"isFirst is:%d", isFirst);
    }
    
    
    // Override point for customization after application launch.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getGoodModel:) name:@"transGoodModel" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAskModel:) name:@"transAskModel" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMemberIdAndPcode:) name:@"getMemberIdAndPcode" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chuanmemberidzhiappdelegate:) name:@"chuanmemberidzhiappdelegate" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutandmemberid:) name:@"logoutandmemberid" object:nil];
    self.num = 0;
    //Umeng
    [UMSocialData setAppKey:@"550cd62656240b082e0005db"];
    
    //微信
    [UMSocialWechatHandler setWXAppId:@"wxd6c0ad2e88a9f0cd" appSecret:@"4691bf7c8aa5fac861624f2e6a5ba936" url:@"http://www.umeng.com/social"];
    //QQ同校小二
    [UMSocialQQHandler setQQWithAppId:@"1104337560" appKey:@"46UWdsdu21Iku0RT" url:@"http://www.umeng.com/social"];
    [UMSocialQQHandler setSupportWebView:YES];
    
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - callback

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url];
}

- (void)getGoodModel:(NSNotification *)text{
    self.createGoodModel = text.userInfo[@"goodModel"];
}

- (void)getAskModel:(NSNotification *)text{
    self.createAskModel = text.userInfo[@"askModel"];
}

- (void)getMemberIdAndPcode:(NSNotification *)text{
    NSLog(@"%@",text.userInfo[@"memberId"]);
    self.memberId = text.userInfo[@"memberId"];
    self.pcode = text.userInfo[@"pcode"];
}

- (void)chuanmemberidzhiappdelegate:(NSNotification *)text{
    self.tabmemberId = text.userInfo[@"memberID"];
}

- (void)logoutandmemberid:(NSNotification *)text{
    self.tabmemberId = nil;
}


- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
   /* NSLog(@"My token is: %@", deviceToken);
    NSString *token = [NSString stringWithFormat:@"%@",deviceToken];
    NSLog(@"token is: %@",token);
    NSString *t = @"";
    for (int i = 0; i < 8; i++) {
       NSLog(@"##%@",[token substringWithRange:NSMakeRange((i+1)+8*i,8)]);
        t=[t stringByAppendingString:[token substringWithRange:NSMakeRange((i+1)+8*i,8)]];
    }*/
   // KIKeyChain *key = [KIKeyChain keyChainWithIdentifier:@"token"];
    //[key setValue:t forKey:@"token"];
   // [key write];
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{

    NSLog(@"7777777");
}

/*- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"PresentView" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}*/

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
}


















@end
