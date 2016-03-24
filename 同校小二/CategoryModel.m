//
//  CategoryModel.m
//  TXXE
//
//  Created by River on 15/6/10.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "CategoryModel.h"
#import "NetController.h"

@implementation CategoryModel

- (void)setValuesForKeysWithDictionary:(NSDictionary *)keyedValues
{
    self.categoryId = [keyedValues[@"id"] stringValue];
    self.categoryName = keyedValues[@"name"];
    NSLog(@"%@",self.categoryName);
    self.categoryIcon = keyedValues[@"icon"];
    if (keyedValues[@"subCategories"] && [keyedValues[@"subCategories"]count] != 0) {
        NSMutableArray *subs = [NSMutableArray array];
        for (NSDictionary*dict in keyedValues[@"subCategories"]) {
            CategoryModel *tempModel = [[CategoryModel alloc]init];
            [tempModel setValuesForKeysWithDictionary:dict];
            [subs addObject:tempModel];
        }
        self.subCategories = subs;
    }
}

- (void)loadAllCategoryListWithCompletionHandler:(void (^)(NSError *))completionHandler
{
    __weak __typeof(self)weakSelf = self;
    //api
    [[NetController sharedInstance]postWithAPI:API_category_list parameters:[NSMutableDictionary dictionaryWithCapacity:0] completionHandler:^(id responseObject, NSError *error) {
        __strong __typeof(self)strongSelf = weakSelf;
        if (error) {
            completionHandler(error);
        }else{
            NSMutableArray *categories = [NSMutableArray array];
            for (NSDictionary *dict in responseObject[@"data"][@"normalCategories"]) {
                CategoryModel *tempModel = [[CategoryModel alloc]init];
                [tempModel setValuesForKeysWithDictionary:dict];
                [categories addObject:tempModel];
                NSLog(@"cccccccccccc%lu",(unsigned long)categories.count);
            }
            @autoreleasepool {
                strongSelf.cachedCategoryList = categories;
            }
            completionHandler(nil);
        }
    }];
}

@end
