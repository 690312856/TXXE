//
//  ACGlobalLocationModel.m
//  AnyCheckMobile
//
//  Created by IOS－001 on 15/1/27.
//  Copyright (c) 2015年 xxxxxx. All rights reserved.
//

#import "ACGlobalLocationModel.h"
#import "Constants.h"

@interface ACGlobalLocationModel () <CLLocationManagerDelegate>

@property (nonatomic , strong) CLLocationManager *locationManager;
@property (nonatomic , copy) void (^innerCompletionHandler)(NSError*,CLLocationCoordinate2D);
@property (nonatomic , assign) CLLocationCoordinate2D location;

@end

@implementation ACGlobalLocationModel

- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    return _locationManager;
}

+ (instancetype)sharedInstance
{
    static ACGlobalLocationModel *static_ptr = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        static_ptr = [[self alloc] init];
        static_ptr.location = (CLLocationCoordinate2D){-1,-1};
    });
    return static_ptr;
}

- (void)startApplyUserLocationWithTipsOn:(BOOL)tipsIsOn completionHandler:(void (^)(NSError*,CLLocationCoordinate2D))completionHandler
{
    self.innerCompletionHandler = completionHandler;
    [self requestForLocationWithAlertShow:tipsIsOn];
}

- (void)requestForLocationWithAlertShow:(BOOL)isShow
{
    if ([CLLocationManager locationServicesEnabled]) {

        switch ([CLLocationManager authorizationStatus]) {
            case kCLAuthorizationStatusAuthorized://ios8里面kCLAuthorizationStatusAuthorizedAlways
                //此应用程序被授权使用定位服务。
                [self.locationManager startUpdatingLocation];
                break;
            case kCLAuthorizationStatusDenied:
                //用户明确否认目前设置禁用此应用程序或位置服务的使用位置服务。
                NSLog(@"系统定位服务不可用,");
                if (isShow && !OSVersionIsAtLeastiOS8) {
//                    [ACDataHelper tipsAlertWithTitle:@"定位服务不可用" message:@"请在系统设置中允许安测健康获取您的位置" cancelBtnTitle:@"确认"];
                }
                break;
            case kCLAuthorizationStatusNotDetermined:
                //用户尚未做出了选择，对于这个应用程序是否可以使用位置服务。
                if (OSVersionIsAtLeastiOS8) {
                    [self.locationManager requestWhenInUseAuthorization];
                } else {
                    [self.locationManager startUpdatingLocation];
                }
                break;
            case kCLAuthorizationStatusRestricted:
                //此应用程序没有授权使用位置服务。用户可以不改变应用程序的状态，可能是由于活跃的限制，如家长控制到位。
                if (isShow) {
                    [[[UIAlertView alloc] initWithTitle:@"定位服务不可用" message:@"由于某些限制，如家长控制、活跃限制等，暂不能获取您的位置。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                }
                break;
            case kCLAuthorizationStatusAuthorizedWhenInUse://iOS8
            {
                NSLog(@"kCLAuthorizationStatusAuthorizedWhenInUse");
                [self.locationManager startUpdatingLocation];
            }
                break;
            default:
                break;
        }
    } else {
        if ( isShow) {
//            [ACDataHelper tipsAlertWithTitle:@"定位服务不可用" message:@"请在设置->隐私中打开定位服务。" cancelBtnTitle:@"确认"];
        }
    }
}

#pragma mark -
#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
            {
                [self.locationManager requestWhenInUseAuthorization];
//                [self.locationManager startUpdatingLocation];
            }
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
                [self.locationManager startUpdatingLocation];
            break;
        default:
            break;
    }
//    NSLog(@"%s",__PRETTY_FUNCTION__);
//    if (status == kCLAuthorizationStatusAuthorized || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
//        
//    }
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
        NSLog(@"%s",__PRETTY_FUNCTION__);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
        NSLog(@"%s",__PRETTY_FUNCTION__);
    if (self.innerCompletionHandler) {
        [self.locationManager stopUpdatingLocation];
        self.innerCompletionHandler(error,(CLLocationCoordinate2D){-1,-1});
    }
}

- (void)locationManager:(CLLocationManager *)manager didFinishDeferredUpdatesWithError:(NSError *)error
{
        NSLog(@"%s",__PRETTY_FUNCTION__);
}

//- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
//{
//    
//}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
        NSLog(@"%s",__PRETTY_FUNCTION__);
    if (locations.lastObject) {
//        NSLog(@"%@",locations.lastObject);
        [self.locationManager stopUpdatingLocation];
        if (self.innerCompletionHandler) {
            self.location = ((CLLocation *)locations.lastObject).coordinate;
            self.innerCompletionHandler(nil,self.location);
//            self.innerCompletionHandler = nil;
        }
    }
}

- (void)locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager
{
        NSLog(@"%s",__PRETTY_FUNCTION__);
}

- (void)locationManagerDidResumeLocationUpdates:(CLLocationManager *)manager
{
        NSLog(@"%s",__PRETTY_FUNCTION__);
}

@end
