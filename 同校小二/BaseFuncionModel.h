//
//  BaseFuncionModel.h
//  TongxiaoXiaoEr
//
//  Created by IOS－001 on 15/3/1.
//  Copyright (c) 2015年 xxx.xxxx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseFuncionModel : NSObject

@property (nonatomic , copy) NSString *functionId;
@property (nonatomic , copy) NSString *functionName;
@property (nonatomic , copy) NSString *imageUrlText;

@property (nonatomic , readonly) NSURL *imageUrl;

@end
