//
//  FeedBackViewController.h
//  TXXE
//
//  Created by 李雨龙 on 15/9/5.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedBackViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (strong,nonatomic) NSString *tucao;
@end
