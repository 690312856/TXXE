//
//  CommentInputView.m
//  TXXE
//
//  Created by River on 15/6/30.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "CommentInputView.h"
#import "Constants.h"
#import "NSString+Addition.h"

@implementation CommentInputView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createCommentInputView];
    }
    return self;
}

-(void)createCommentInputView
{
    UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
    topLineView.backgroundColor = lineGrayColor;
    [self addSubview:topLineView];
    float screenWidth = [[UIScreen mainScreen]bounds].size.width;
    self.inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 10, ((screenWidth-30)-5)*0.7, 40)];
    self.inputTextField.text = @"";
    self.inputTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.inputTextField.placeholder = @"填写评论";
    [self addSubview:self.inputTextField];
    
    self.submitButton = [[UIButton alloc]initWithFrame:CGRectMake(self.inputTextField.frame.origin.x+self.inputTextField.frame.size.width+5, (self.frame.size.height-30)/2, ((screenWidth-30)-5)*0.3, 30)];
    [self.submitButton addTarget:self action:@selector(clickSubmit:) forControlEvents:UIControlEventTouchUpInside];
    [self.submitButton setTitle:@"提交" forState:0];
    [self.submitButton setTitleColor:[UIColor whiteColor] forState:0];
    [self.submitButton.layer setCornerRadius:5.0];
    [self.submitButton.layer setMasksToBounds:YES];
    [self.submitButton setBackgroundColor:GreenFontColor];
    [self addSubview:self.submitButton];
}

-(void)clickSubmit:(UIButton *)sender
{
    if (self.subCallBack) {
        [self.inputTextField resignFirstResponder];
        self.subCallBack([NSString realForString:self.inputTextField.text]);
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
