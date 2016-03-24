//
//  NetController.h
//  TXXE
//
//  Created by River on 15/6/7.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetConnectionAPI_Map.h"
#import <AFNetworking.h>

@interface NetController : NSObject

@property (nonatomic, readonly) AFHTTPRequestOperationManager *httpClient;
@property (nonatomic, readonly) AFNetworkReachabilityManager *serverReachability;

+ (NetController *)sharedInstance;

- (AFHTTPRequestOperation *)postWithAPI:(API_InterfaceType)netAPI
                             parameters:(NSDictionary *)parameters
                      completionHandler:(void (^)(id responseObject,NSError *error))finish;
@end
