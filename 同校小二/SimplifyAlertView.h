//
//  SimplifyAlertView.h
//  ShareCommunity
//
//  Created by nofeng on 13-8-9.
//  Copyright (c) 2013年 sf-express. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AlertViewResultBlock)(NSInteger selectedIndex);

@interface SimplifyAlertView : NSObject <UIAlertViewDelegate>

+ (void)alertWithTitle:(NSString *)title
               message:(NSString *)message
       operationResult:(AlertViewResultBlock)resultBlock
     cancelButtonTitle:(NSString *)cancelButtonTitle
     otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

- (void)alertWithTitle:(NSString *)title
               message:(NSString *)message
       operationResult:(AlertViewResultBlock)resultBlock
     cancelButtonTitle:(NSString *)cancelButtonTitle
     otherButtonTitles:(NSString *)otherButtonTitles;
@end
