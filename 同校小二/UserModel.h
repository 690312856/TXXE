//
//  UserModel.h
//  TXXE
//
//  Created by River on 15/6/7.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SchoolModel.h"

@interface UserModel : NSObject

@property (nonatomic,copy) NSString *memberId;
@property (nonatomic,copy) NSString *account;
@property (nonatomic,strong) SchoolModel *school;
@property (nonatomic,copy) NSString *nickName;
@property (nonatomic,copy) NSString *level;
@property (nonatomic,copy) NSString *integrity;
@property (nonatomic,copy) NSString *avatarUrlText;
@property (nonatomic,readonly) NSURL *avatarUrl;
@property (nonatomic,copy) NSString *mobileNumber;
@property (nonatomic,copy) NSString *qq;
@property (nonatomic,copy) NSString *alipayAccount;
@property (nonatomic,copy) NSString *preferences;
@property (nonatomic,copy) NSString *score;
@property (nonatomic,strong) NSMutableArray *normalCategoryArr;
@property (nonatomic,strong) SchoolModel *currentSelectSchool;

+ (instancetype)currentUser;

- (BOOL)isCurrentUserValid;

- (NSDictionary *)convertToDictionary;

- (void)logout;

- (BOOL)isValidToSubmit;
/**
 *  登陆
 *
 *  @param accoutId          用户名
 *  @param password          密码
 *  @param shouldRemember    是否记住用户名
 *  @param completionHandler 回调
 */
- (void)loginWithAccoutId:(NSString *)accoutId password:(NSString *)password shouldRememberPwd:(BOOL)shouldRemember withCompletionHandler:(void(^)(NSError *error))completionHandler;

- (void)operationAuthorizeWithCompletionHandler:(void(^)(BOOL isValidUser))completionHandler;

- (void)updateProfileInfoWithCompletionHandler:(void(^)(NSError *error))completionHandler;

- (BOOL)insertIntoDatabase;
- (BOOL)updateInDatabase;
- (BOOL)deleteInDatabase;
+ (BOOL)deleteAllInDatabase;
+ (UserModel *)lastLoginUserInDatabase;
@end




































