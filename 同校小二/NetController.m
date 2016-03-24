//
//  NetController.m
//  TXXE
//
//  Created by River on 15/6/7.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <objc/runtime.h>
#import <UIKit/UIKit.h>
#import "NetController.h"
#import "NSString+Addition.h"


static NSString const *const kAFHTTPRequestOperationPropertyBlockKey = @"kAFHTTPRequestOperationPropertyBlockKey";

@interface AFHTTPRequestOperation (extraVariable)

@property (nonatomic,assign)API_InterfaceType currentType;

@end

@implementation AFHTTPRequestOperation (extraVariable)

@dynamic currentType;

- (void)setCurrentType:(API_InterfaceType)currentType
{
    objc_setAssociatedObject(self, (__bridge const void *)(kAFHTTPRequestOperationPropertyBlockKey), @(currentType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (API_InterfaceType)currentType
{
    return [objc_getAssociatedObject(self, (__bridge const void *)(kAFHTTPRequestOperationPropertyBlockKey))integerValue];
}

@end

#import "Constants.h"

@interface NetController ()

@property (nonatomic,strong) AFHTTPRequestOperationManager *httpClient;
@property (nonatomic,strong) AFNetworkReachabilityManager *serverReachability;
@property (nonatomic,strong) NSArray *url_rootMaps;

@end

@implementation NetController

- (NSArray *)url_rootMaps
{
    if (!_url_rootMaps) {
        _url_rootMaps = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"NetConnectionAPI_Map" ofType:@"plist"]];
    }
    return _url_rootMaps;
}

- (AFNetworkReachabilityManager *)serverReachability
{
    if (!_serverReachability) {
        _serverReachability = [AFNetworkReachabilityManager managerForDomain:kReachabilityHostName];
        [_serverReachability startMonitoring];
        [_serverReachability setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            if (status == AFNetworkReachabilityStatusUnknown) {
                NSLog(@"网络主机:%@,状态:AFNetworkReachabilityStatusUnknown",kReachabilityHostName);
            }else if (status == AFNetworkReachabilityStatusNotReachable){
                NSLog(@"网络主机：%@，状态：AFNetworkReachabilityStatusNotReachable",kReachabilityHostName);
            } else if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
                NSLog(@"网络主机：%@，状态：AFNetworkReachabilityStatusReachableViaWiFi",kReachabilityHostName);
            } else if (status == AFNetworkReachabilityStatusReachableViaWWAN) {
                NSLog(@"网络主机：%@，状态：AFNetworkReachabilityStatusReachableViaWWAN",kReachabilityHostName);
            }
        }];
    }
    return _serverReachability;
}

+ (NetController *)sharedInstance
{
    static NetController *netController_ptr = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        netController_ptr = [[NetController alloc]init];
        [netController_ptr serverReachability];
    });
    return netController_ptr;
}

- (instancetype)init
{
    if (self = [super init]) {
        NSURL *httpbaseUrl = [NSURL URLWithString:kServerHttpBaseURLString];
        self.httpClient = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:httpbaseUrl];
    }
    return self;
}

- (void)separateErrorTypeForOperation:(AFHTTPRequestOperation *)operation response:(id)responseObject finish:(void (^)(id ,NSError *))finish
{
    NSLog(@"\n------------------------------------------------------------------\n完成的请求:%@\n解析完成的数据:\n%@\n------------------------------------------------------------------",operation.request,responseObject);
    
    if ([responseObject isKindOfClass:[NSError class]]) {
        NSError *error = (NSError *)responseObject;
        if ([error.domain isEqualToString:NSCocoaErrorDomain] && error.code == 3840) {
            NSError *requestError = [NSError errorWithDomain:NSCocoaErrorDomain code:3840 userInfo:@{NSLocalizedDescriptionKey:@"服务器内部错误，请稍后重试。"}];
            finish(responseObject,requestError);
        } else {
            finish(responseObject,responseObject);
        }
    } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
        NSInteger resultNo = [responseObject[@"errno"] integerValue];
        NSError *error = nil;
        if (resultNo != 0) {
            NSString *errorDescription = [NSString realForString:responseObject[@"error"]];
            error = [NSError errorWithDomain:kACErrorCodeBusinessErrorDomain code:resultNo userInfo:@{NSLocalizedDescriptionKey:errorDescription}];
        }
        finish(responseObject,error);
    }
}

- (NSString *)fetchTotalURLPathWithAPIType:(API_InterfaceType)type baseUrl:(NSString *)baseUrl
{
    NSDictionary *tempDict = self.url_rootMaps[type];
    NSString *urlPostfix = tempDict[@"url"];
    NSString *totalUrl = [NSString stringWithFormat:@"%@/%@",baseUrl,urlPostfix];
    return totalUrl;
}

- (AFHTTPRequestOperation *)postWithAPI:(API_InterfaceType)netAPI parameters:(NSDictionary *)parameters completionHandler:(void (^)(id, NSError *))finish
{
    NSError *error = nil;
    NSString *urlPostfix = [self fetchTotalURLPathWithAPIType:netAPI baseUrl:kServerHttpBaseURLString];
    NSMutableURLRequest *request = [[self.httpClient requestSerializer] requestWithMethod:@"POST" URLString:urlPostfix parameters:parameters error:&error];
    if (!request) {
        NSLog(@"返回NSMutableURLRequest发生error = %@",error);
        return nil;
    }
    AFHTTPRequestOperation *connection = [self.httpClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self separateErrorTypeForOperation:operation response:responseObject finish:finish];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self separateErrorTypeForOperation:operation response:error finish:finish];
    }];
    connection.currentType = netAPI;
    [[self.httpClient operationQueue] addOperation:connection];
    NSLog(@"\n------------------------------------------------------------------\n即将开始的http请求:%@\n参数:\n%@\n------------------------------------------------------------------",request,parameters);
    return connection;
    
}































@end
