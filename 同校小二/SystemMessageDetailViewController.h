//
//  SystemMessageDetailViewController.h
//  TXXE
//
//  Created by 李雨龙 on 15/7/30.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SystemMessageDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *messageDetail;
@property (nonatomic,assign)NSString *detail;
@end
