//
//  CreateAskModel.h
//  TXXE
//
//  Created by River on 15/7/18.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "BaseAskItemModel.h"
#import "ImageModel.h"
#import "CategoryModel.h"
#import "SchoolModel.h"

@interface CreateAskModel : BaseAskItemModel

@property (nonatomic,copy)NSString *askPrice;
@property (nonatomic,copy)NSString *askDescription;
@property (nonatomic,copy,readonly)NSString *startTimeText;
@property (nonatomic,copy,readonly)NSString *endTimeText;
@property (nonatomic,strong)SchoolModel *selectedSchool;

@property (nonatomic,strong)NSDate *startTimeDate;
@property (nonatomic)long isNew;
@property (nonatomic,strong)NSDate *endTimeDate;
@property (nonatomic,strong)NSMutableArray *localImageModels;
@property (nonatomic,strong)CategoryModel *selectedCategory;
@property (nonatomic,copy)NSString *tradeLocation;
@property (nonatomic,copy)NSString *mobileNumber;
@property (nonatomic,copy)NSString *qqNumber;
@property (nonatomic,strong)NSArray *netImageUrlTexts;

- (void)updateAskWithCompletionHandler:(void(^)(NSError *error))completionHandler;
- (void)startCreateAskWithCompletionHandler:(void(^)(NSError *error))completionHandler;
- (void)fetchDetailWithCompletionHandler:(void(^)(NSError *error))completionHandler;
@end
