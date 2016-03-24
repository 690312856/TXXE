//
//  NSDate+String.m
//  TXXE
//
//  Created by River on 15/6/10.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "NSDate+String.h"

@implementation NSDate (ConvertString)

- (NSString *)convertToStringWithFormat:(NSString *)formatString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.locale = [NSLocale currentLocale];
    formatter.timeZone = [NSTimeZone localTimeZone];
    [formatter setDateFormat:formatString];
    
    return [formatter stringFromDate:self];
}

- (NSString *)minuteDescription
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    NSString *theDay = [dateFormatter stringFromDate:self];
    NSString *currentDay = [dateFormatter stringFromDate:[NSDate date]];
    if ([theDay isEqualToString:currentDay]) {
        [dateFormatter setDateFormat:@"ah:mm"];
        return [dateFormatter stringFromDate:self];
    }else if ([[dateFormatter dateFromString:currentDay]timeIntervalSinceDate:[dateFormatter dateFromString:theDay]]==86400)
    {
        [dateFormatter setDateFormat:@"ah:mm"];
        return [NSString stringWithFormat:@"昨天%@",[dateFormatter stringFromDate:self]];
    }else if ([[dateFormatter dateFromString:currentDay]timeIntervalSinceDate:[dateFormatter dateFromString:theDay]]< 86400*7)
    {
        [dateFormatter setDateFormat:@"EEEE ah:mm"];
        return [dateFormatter stringFromDate:self];
    }else
    {
        NSString *theYear = [theDay componentsSeparatedByString:@"-"][0];
        NSString *curYear = [currentDay componentsSeparatedByString:@"-"][0];
        if ([theYear isEqual:curYear]) {
            [dateFormatter setDateFormat:@"MM-dd ah:mm"];
        }else{
            [dateFormatter setDateFormat:@"yyyy-MM-dd ah:mm"];
        }
        return [dateFormatter stringFromDate:self];
    }
}
@end
