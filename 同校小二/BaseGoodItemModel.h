//
//  BaseGoodItemModel.h
//  TXXE
//
//  Created by River on 15/6/7.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+Addition.h"
#import "UserModel.h"

@interface BaseGoodItemModel : NSObject

@property (nonatomic,copy) NSString *goodId;
@property (nonatomic,copy) NSString *goodTitle;
@property (nonatomic,strong) UserModel *sellerUser;
@property (nonatomic,copy) NSString *createTime;

@end
