//
//  ProfileEditingTableViewCell.m
//  TXXE
//
//  Created by 李雨龙 on 15/7/19.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "ProfileEditingTableViewCell.h"
#import "UIView+Addition.h"
#import "Constants.h"

@implementation ProfileEditingTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.profileItemTextField.delegate = self;
    self.profileItemTextField.borderStyle = UITextBorderStyleNone;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tuichubianji:) name:@"tuichubianji" object:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *currentString = [NSString stringWithFormat:@"%@%@",textField.text,string];
    if (range.length == 1) {
        currentString = [currentString substringToIndex:[currentString length] - 1];
    }
    if (self.textFieldValueChanged) {
        DISPATCH_MAIN(^(){
            self.textFieldValueChanged(currentString);
        });
        
    }
    return YES;
}

- (void)tuichubianji:(NSNotification *)text{
    
    [self.profileItemTextField resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField drawBorderStyleWithBorderWidth:1 borderColor:RGB_COLOR(244, 244, 244, 1.) cornerRadius:0];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField drawBorderStyleWithBorderWidth:0 borderColor:RGB_COLOR(244, 244, 244, 1.) cornerRadius:0];
    if (self.textFieldValueChanged) {
        DISPATCH_MAIN(^(){
            self.textFieldValueChanged(textField.text);
        });
    }
}
@end
