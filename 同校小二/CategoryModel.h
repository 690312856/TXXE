//
//  CategoryModel.h
//  TXXE
//
//  Created by River on 15/6/10.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryModel : NSObject

@property (nonatomic,copy) NSString *categoryId;
@property (nonatomic,copy) NSString *categoryName;
@property (nonatomic,copy) NSString *categoryIcon;

@property (nonatomic,strong) NSArray *subCategories;
@property (nonatomic,strong) NSArray *cachedCategoryList;

- (void)loadAllCategoryListWithCompletionHandler:(void(^)(NSError *error))completionHandler;

@end
