//
//  NSDate+String.h
//  TXXE
//
//  Created by River on 15/6/10.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSDate (ConvertString)

- (NSString *)convertToStringWithFormat:(NSString *)formatString;

- (NSString *)minuteDescription;

@end
