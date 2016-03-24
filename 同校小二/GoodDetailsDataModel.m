//
//  GoodDetailsDataModel.m
//  TXXE
//
//  Created by River on 15/7/1.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "GoodDetailsDataModel.h"
#import "NetController.h"

@implementation GoodDetailsDataModel

- (void)loadGoodDetailsDataWithID:(NSString *)goodId CompletionHandler:(void(^)(NSError *error,NSDictionary *goodDic,NSArray *cachedCommentList))completionHandler
{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [paramDic setValue:goodId forKey:@"id"];
    __weak __typeof(self)weakSelf = self;
    [[NetController sharedInstance] postWithAPI:API_good_JsonDetaill parameters:paramDic completionHandler:^(id responseObject, NSError *error) {
        if (error) {
            completionHandler(error,nil,nil);
        }else
        {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.goodDic = [[NSDictionary alloc] initWithDictionary:responseObject];
            NSLog(@"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%@",strongSelf.goodDic);
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dict in responseObject[@"data"][@"reviews"]) {
                GoodDetailsDataModel *tempModel = [[GoodDetailsDataModel alloc] init];
                [tempModel setValuesForKeysWithDictionary:dict];
                [array addObject:tempModel];
            }
            @autoreleasepool {
                strongSelf.cachedCommentList = array;
            }
            completionHandler(nil,strongSelf.goodDic,strongSelf.cachedCommentList);
        }
    }];
}

- (void)setValuesForKeysWithDictionary:(NSDictionary *)keyedValues
{
    [super setValuesForKeysWithDictionary:keyedValues];
    self.senderID = keyedValues[@"memberId"];
    self.ToID = keyedValues[@"targetMemberId"];
    self.contents = keyedValues[@"contents"];
    self.createTime = keyedValues[@"createTime"];
    self.senderNickName = keyedValues[@"nickName"];
    self.toNickName = keyedValues[@"realName"];
    self.avatarUrl = keyedValues[@"avatar"];
    
}
@end
