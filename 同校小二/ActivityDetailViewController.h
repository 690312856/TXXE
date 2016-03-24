//
//  ActivityDetailViewController.h
//  TXXE
//
//  Created by 李雨龙 on 15/9/21.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityDetailViewController : UIViewController<UIWebViewDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic,strong)NSString *activityUrl;
@end
