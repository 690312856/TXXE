//
//  CommentInputView.h
//  TXXE
//
//  Created by River on 15/6/30.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^submitCallBack)(NSString *str);
@interface CommentInputView : UIView<UITextFieldDelegate>

@property (nonatomic,strong)submitCallBack subCallBack;
@property (nonatomic,strong)UITextField *inputTextField;
@property (nonatomic,strong)UIButton *submitButton;

@end
