//
//  UserCenterMainDataModel.h
//  TXXE
//
//  Created by River on 15/6/27.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserCenterMainDataModel : NSObject

@property (nonatomic , copy) NSString *totalSaleCount;
@property (nonatomic , copy) NSString *totalWantedCount;
@property (nonatomic , copy) NSString *favoriteGoodCount;
@property (nonatomic,copy) NSString *nickName;
@property (nonatomic,copy) NSString *level;
@property (nonatomic,copy) NSString *integrity;
@property (nonatomic,copy) NSString *avatarUrlText;
@property (nonatomic,copy) NSString *school;


@property (nonatomic , strong) NSDictionary *certificationInfoDict;
- (void)fetchUserCenterDataWithCompletionHandler:(void(^)(NSError *error))completionHandler;
@end
