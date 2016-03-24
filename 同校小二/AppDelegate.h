//
//  AppDelegate.h
//  TXXE
//
//  Created by River on 15/6/5.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateGoodModel.h"
#import "CreateAskModel.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) CreateGoodModel *createGoodModel;
@property (nonatomic,strong) CreateAskModel *createAskModel;
@property (nonatomic,strong)NSString *memberId;
@property (nonatomic,strong)NSString *tabmemberId;
@property (nonatomic,strong)NSString *pcode;
@property (nonatomic)long num;
@end

