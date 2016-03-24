//
//  LengthLimitedInputView.h
//  LengthLimitedInputView
//
//  Created by IOS－001 on 14-5-9.
//  Copyright (c) 2014年 xxxxxx.com Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCPlaceholderTextView.h"

typedef NS_ENUM(NSInteger, InputViewType) {
    InputViewTypeTextField,
    InputViewTypeTextView
};

@interface LengthLimitedInputView : UIView

/**
 *  如果选择的是textField模式，inputEareView返回来的就是UITextField
 *  如果选择的是textView模式，inputEareView返回来的就是带placeholder功能的UITextView
 */
@property (nonatomic , readonly) UIView *inputEareView;
@property (nonatomic , copy) NSString *placeholder;
@property (nonatomic , assign) InputViewType currentType;
@property (nonatomic , assign) NSInteger maxLengthOfInputText;
@property (nonatomic , copy) void (^outOfLimitBlock)(id);
@property (nonatomic , strong) UIFont *font;
@property (nonatomic , copy) NSString *text;

/**
 *  初始化
 *
 *  @param frame      输入框的大小
 *  @param inputType  是UITextField还是UITextView
 *  @param maxLength  最大长度的文字
 *  @param limitBlock 如果超出限制，执行的block。如果选择的是textField模式，inputEareView返回来的就是UITextField；如果选择的是textView模式，inputEareView返回来的就是UITextView
 *
 *  @return “输入框”
 */
- (id)initWithFrame:(CGRect)frame inputType:(InputViewType)inputType maxLengthOfInputText:(NSInteger)maxLength outOfLimitBlock:(void(^)(id inputEareView))limitBlock;

@end
