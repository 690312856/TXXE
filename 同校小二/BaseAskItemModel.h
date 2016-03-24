//
//  BaseAskItemModel.h
//  TXXE
//
//  Created by River on 15/7/18.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+Addition.h"
#import "UserModel.h"

@interface BaseAskItemModel : NSObject

@property (nonatomic,copy)NSString *askId;
@property (nonatomic,copy)NSString *askTitle;
@property (nonatomic,strong)UserModel *wantedUser;
@property (nonatomic,copy)NSString *createTime;

@end
