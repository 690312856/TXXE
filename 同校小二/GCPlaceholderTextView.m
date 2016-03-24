//
//  GCPlaceholderTextView.m
//  TXXE
//
//  Created by River on 15/6/11.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "GCPlaceholderTextView.h"

@interface GCPlaceholderTextView ()

@property (nonatomic, strong) UIFont* realTextFont;
@property (nonatomic, strong) NSString* realText;


- (void) beginEditing:(NSNotification*) notification;
- (void) endEditing:(NSNotification*) notification;

@end

@implementation GCPlaceholderTextView

@synthesize realTextColor;
@synthesize placeholder;
@synthesize placeholderColor;

#pragma mark -
#pragma mark Initialisation


- (id) initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginEditing:) name:UITextViewTextDidBeginEditingNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endEditing:) name:UITextViewTextDidEndEditingNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changedEditing:) name:UITextViewTextDidChangeNotification object:self];
    
    self.realTextColor = self.textColor;
    self.placeholderColor = [UIColor lightGrayColor];
    self.realTextFont = self.font;
    self.placeHolderFont = self.realTextFont;
    
    
}

#pragma mark -
#pragma mark Setter/Getters


- (void) setPlaceholder:(NSString *)aPlaceholder {
    if ([_realText length] == 0 && ![self isFirstResponder]) {
        super.font = self.placeholderFont;
        super.text = aPlaceholder;
    }
    if (aPlaceholder != placeholder) {
        placeholder = aPlaceholder;
    }
    
    [self endEditing:nil];
}

- (void)setPlaceholderColor:(UIColor *)aPlaceholderColor {
    placeholderColor = aPlaceholderColor;
    
    if ([_realText length] == 0) {
        super.textColor = self.placeholderColor;
        super.font = self.placeholderFont;
    }
}

- (void) setPlaceHolderFont:(UIFont *)placeHolderFont {
    _placeholderFont = placeHolderFont;
    if ([_realText length] == 0) {
        super.font = self.placeholderFont;
    }
}

-(NSString *) text {
    return _realText;
}

- (void) setText:(NSString *)text {
    if ([text length] == 0 && ![self isFirstResponder]) {
        super.text = self.placeholder;
        super.textColor = self.placeholderColor;
        super.font = self.placeholderFont;
    } else {
        super.text = text;
        super.textColor = self.realTextColor;
        super.font = self.realTextFont;
    }
    _realText = text;
}








- (void) beginEditing:(NSNotification*) notification {
    if ([_realText length] == 0) {
        super.text = nil;
        super.textColor = self.realTextColor;
        super.font = self.realTextFont;
    }
}

- (void) endEditing:(NSNotification*) notification {
    if ([_realText length] == 0) {
        super.text = self.placeholder;
        super.textColor = self.placeholderColor;
        super.font = self.placeholderFont;
    }
}



- (void) changedEditing:(NSNotification*) notification {
    _realText = super.text;
    if ([_realText length] == 0 && ![self isFirstResponder]) {
        super.text = self.placeholder;
        super.textColor = self.placeholderColor;
        super.font = self.placeholderFont;
    }
    
    // call delegate again
    if ([self.delegate respondsToSelector:@selector(textViewDidChange:)]) {
        [self.delegate textViewDidChange:self];
    }
}

- (void) setTextColor:(UIColor *)textColor {
    if ([_realText length] == 0) {
        self.realTextColor = textColor;
    } else {
        self.realTextColor = textColor;
        [super setTextColor:textColor];
    }
}

#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

@end

