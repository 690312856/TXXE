//
//  ProgressHudCommon.h
//  TongxiaoXiaoEr
//
//  Created by xueyaoji on 15-3-8.
//  Copyright (c) 2015年 xxx.xxxx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ProgressHudCommon : NSObject
{
    
}

+(void)showHUDInView:(UIView*)toView andInfo:(NSString*)infoStr andImgName:(NSString*)nameStr andAutoHide:(BOOL)autoHide;
+(void)hiddenHUD:(UIView*)view;

+(void)showHudAndHide:(UIView*)view andNotice:(NSString*)str;

@end
