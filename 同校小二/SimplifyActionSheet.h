//
//  SimplifyActionSheet.h
//  ShareCommunity
//
//  Created by nofeng on 13-12-3.
//  Copyright (c) 2013年 sf-express. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimplifyActionSheet : NSObject <UIActionSheetDelegate>
+ (void)actionSheetWithTitle:(NSString *)title
           cancelButtonTitle:(NSString *)cancelButtonTitle
                showingStyle:(void(^)(UIActionSheet *actionSheetSelf))showBlock
             operationResult:(void(^)(NSInteger selectedIndex,NSString *selectedButtonTitle))resultBlock
      destructiveButtonTitle:(NSString *)destructiveButtonTitle
           otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

/**
 一次性传入所有的titles
 a. 指定destructiveButton的index
 b. 指定cancelButton的index
 @note 上述a和b中的index必须要在titles数组中合法
 **/
+ (void)actionSheetWithTitle:(NSString *)title
                buttonTitles:(NSArray *)buttonTitles
                showingStyle:(void(^)(UIActionSheet *actionSheetSelf))showBlock
             operationResult:(void(^)(NSInteger selectedIndex,NSString *selectedButtonTitle))resultBlock
      destructiveButtonIndex:(NSInteger)destructiveButtonIndex
           cancelButtonIndex:(NSInteger)cancelButtonIndex;
@end
