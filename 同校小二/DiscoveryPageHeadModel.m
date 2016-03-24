//
//  DiscoveryPageHeadModel.m
//  TXXE
//
//  Created by River on 15/6/15.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "DiscoveryPageHeadModel.h"
#import "NetController.h"

@implementation DiscoveryPageHeadModel

-(void)fetchHomeDataForSchool:(SchoolModel *)school completionHandler:(void (^)(NSError *, NSArray *))completionHandler
{
    __weak __typeof(self)weakSelf = self;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dict setValue:school.schoolID forKey:@"schoolId"];
    [[NetController sharedInstance] postWithAPI:API_function_list parameters:dict completionHandler:^(id responseObject, NSError *error) {
        if (error) {
            completionHandler(error,nil);
        }else{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            NSMutableArray *functions = [NSMutableArray array];
            for (NSDictionary *dict in responseObject[@"data"]) {
                BaseFuncionModel *tempModel = [[BaseFuncionModel alloc]init];
                [tempModel setValuesForKeysWithDictionary:dict];
                [functions addObject:tempModel];
            }
            @autoreleasepool {
                strongSelf.functions = functions;
            }
            completionHandler(nil,strongSelf.functions);
        }
    }];
}
@end
