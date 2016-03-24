//
//  GCPlaceholderTextView.h
//  TXXE
//
//  Created by River on 15/6/11.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCPlaceholderTextView : UITextView

@property (nonatomic,strong)NSString *placeholder;
@property (nonatomic,strong)UIColor *realTextColor UI_APPEARANCE_SELECTOR;
@property (nonatomic,strong)UIColor *placeholderColor UI_APPEARANCE_SELECTOR;
@property (nonatomic,strong)UIFont *placeholderFont UI_APPEARANCE_SELECTOR;
@end
