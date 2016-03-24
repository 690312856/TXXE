//
//  NSTimer+Addition.h
//  StepCounter
//
//  Created by IOS－001 on 14-5-23.
//  Copyright (c) 2014年 xxxxxx Information Technologies Co., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Addition)

- (void)pauseTimer;
- (void)resumeTimer;
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval;

@end
