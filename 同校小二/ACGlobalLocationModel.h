//
//  ACGlobalLocationModel.h
//  AnyCheckMobile
//
//  Created by IOS－001 on 15/1/27.
//  Copyright (c) 2015年 xxxxxx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface ACGlobalLocationModel : NSObject

@property (nonatomic , assign , readonly) CLLocationCoordinate2D location;

+ (instancetype)sharedInstance;

- (void)startApplyUserLocationWithTipsOn:(BOOL)tipsIsOn completionHandler:(void(^)(NSError *error, CLLocationCoordinate2D location))completionHandler;

@end
