//
//  RegisterViewController.h
//  TXXE
//
//  Created by River on 15/6/28.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "BaseViewController.h"

@interface RegisterViewController : BaseViewController

@property (nonatomic ,copy) void (^loginAuthorizeResult)(BOOL isSucceed);
@end
