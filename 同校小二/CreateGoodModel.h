//
//  CreateGoodModel.h
//  TXXE
//
//  Created by River on 15/6/10.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "BaseGoodItemModel.h"
#import "ImageModel.h"
#import "CategoryModel.h"
#import "SchoolModel.h"

@interface CreateGoodModel : BaseGoodItemModel

@property (nonatomic,copy) NSString *goodPrice;
@property (nonatomic,copy) NSString *goodDescription;

@property (nonatomic,copy,readonly) NSString *startTimeText;
@property (nonatomic,copy,readonly) NSString *endTimeText;
@property (nonatomic,strong)SchoolModel *selectedSchool;
@property (nonatomic,strong) NSDate *startTimeDate;
@property (nonatomic,strong) NSDate *endTimeDate;
@property (nonatomic)long isNew;
@property (nonatomic,strong) NSMutableArray *localImageModels;
@property (nonatomic,strong) CategoryModel *selectedCategory;
@property (nonatomic,copy) NSString *tradeLocation;
@property (nonatomic,copy) NSString *mobileNumber;
@property (nonatomic,copy) NSString *qqNumber;
//网络图片的url,为“编辑”功能准备
@property (nonatomic,strong) NSArray *netImageUrlTexts;

- (void)updateGoodWithCompletionHandler:(void(^)(NSError *error))completionHandler;

- (void)startCreateGoodWithCompletionHandler:(void(^)(NSError *error))completionHandler;

- (void)fetchDetailWithCompletionHandler:(void(^)(NSError *error))completionHandler;


@end
