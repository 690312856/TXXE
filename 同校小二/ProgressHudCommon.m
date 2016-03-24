//
//  ProgressHudCommon.m
//  TongxiaoXiaoEr
//
//  Created by xueyaoji on 15-3-8.
//  Copyright (c) 2015年 xxx.xxxx. All rights reserved.
//

#import "ProgressHudCommon.h"
#import <MBProgressHUD.h>
#import "Constants.h"
#define curMainWindow [[[[UIApplication sharedApplication] delegate] window] makeKeyWindow]

@implementation ProgressHudCommon

+(void)showHudAndHide:(UIView*)view andNotice:(NSString*)str
{
    [ProgressHudCommon showHUDInView:view andInfo:str andImgName:nil andAutoHide:YES];

}
+(void)showHUDInView:(UIView*)toView andInfo:(NSString*)infoStr andImgName:(NSString*)nameStr andAutoHide:(BOOL)autoHide
{
    
    if ([toView viewWithTag:999]) {
        [[toView viewWithTag:999] removeFromSuperview];
    }
    
    
    MBProgressHUD * hud;
    
    if (toView) {
       hud = [MBProgressHUD showHUDAddedTo:toView animated:YES];
    }
    else
    {
        
         hud = [MBProgressHUD showHUDAddedTo:THE_APP_DELEGATE.window animated:YES] ;
    }
    hud.tag = 999;
    hud.labelText = infoStr;
    hud.removeFromSuperViewOnHide = YES;
    [hud show:YES];
    if(autoHide){
        [hud hide:YES afterDelay:0.5];
    }
}

+(void)hiddenHUD:(UIView*)view
{
    
    if ([view viewWithTag:999]) {
       
        [(MBProgressHUD*)[view viewWithTag:999] hide:YES];
        
    }
    
   
    
}

@end
