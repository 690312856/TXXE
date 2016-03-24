//
//  Constants.h
//  TXXE
//
//  Created by River on 15/6/7.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//
#import "AppDelegate.h"

#ifndef TXXE_Constants_h
#define TXXE_Constants_h

/*----------------网络-------------*/
//#define kServerHttpBaseURLString    @"http://120.24.58.30:8001"  //开发地址
////1
//#define kServerHttpBaseURLString    @"http://112.74.101.122:8080/txwaiter"
////2
//#define kServerHttpBaseURLString    @"http://116.56.143.152:8080/txxer/"  //正式地址
//#define kServerHttpBaseURLString    @"http://192.168.1.108/txwaiter"
#define kServerHttpBaseURLString    @"http://www.txxer.com"
//#define kServerHttpBaseURLString    @"http://www.txxer.cn:8080"
#define kReachabilityHostName       @"www.baidu.com"

#define kACErrorCodeBusinessErrorDomain     @"kACErrorCodeBusinessErrorDomain"
#define kACErrorCodeNetWorkErrorDomain      @"kACErrorCodeNetWorkErrorDomain"
#define kACSTKeyLoginUserServiceName        @"kACSTKeyLoginUserServiceName"

#define kUserLogoutNotification             @"kUserLogoutNotification"


#define PATH_OF_DOCUMENT            [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define THE_APP_DELEGATE            ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define RGB_COLOR(r, g, b, a)       ([UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a])
#define APP_MAIN_COLOR              RGB_COLOR(0, 191, 121, 1.0)

//统一的文字缩进单位
static const CGFloat kCommonTextCapForTextField = 15;

#define OSVersionIsAtLeastiOS7      (([[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0)?YES:NO)
#define OSVersionIsAtLeastiOS8      (([[[UIDevice currentDevice]systemVersion] floatValue] >= 8.0)?YES:NO)

#define SCREEN_WIDTH                (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation) ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height)
#define SCREEN_HEIGHT               (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation) ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width)

#define DISPATCH_MAIN(block)        (dispatch_async(dispatch_get_main_queue(),(block)))

#define KScreenWidth    [[UIScreen mainScreen] bounds].size.width
#define KScreenHeight   [[UIScreen mainScreen] bounds].size.height
#define KViewHeight     self.view.frame.size.height
#define KViewWidth      self.view.frame.size.width
#define kStatusBarHeight 20.0f
#define kNavigationBarHeight 44.0f
#define kNavigationBarLandscapeHeight 33.0f
#define kTabBarHeight 49.0f
#define kContentViewHeight (KScreenHeight - kStatusBarHeight - kNavigationBarHeight)
#define KContentViewHasTabBar (KScreenHeight - kStatusBarHeight - kNavigationBarHeight-kTabBarHeight)
#define tableBgColor   [UIColor colorWithRed:235.0/255 green:235.0/255 blue:235.0/255 alpha:1.0]
#define tableWhitColor [UIColor colorWithRed:247.0/255 green:247.0/255 blue:247.0/255 alpha:1.0]
#define defaultImg     [UIImage imageNamed:@"txxrdefault"]

#define GreenFontColor      [UIColor colorWithRed:24.0/255 green:181.0/255 blue:97.0/255 alpha:1.0]
#define  lineGrayColor   [UIColor colorWithRed:228.0/255 green:228.0/255 blue:228.0/255 alpha:1.0]

#define lightBlackColor  [UIColor colorWithRed:108.0/255 green:108.0/255 blue:108.0/255 alpha:1.0]

#define isIOS7 ([[[UIDevice currentDevice] systemVersion] floatValue]<=8.0)
#define historySearchData   @"historySearch"

#endif
