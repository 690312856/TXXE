//
//  SchoolSelectViewController.h
//  TXXE
//
//  Created by River on 15/7/15.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "BaseViewController.h"
#import "SchoolModel.h"

@interface SchoolSelectViewController :BaseViewController

@property (nonatomic,copy) void(^finishedSchoolPickBlock)(SchoolModel *pickedSchool);
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;
@property (nonatomic,assign)long distance;
@property (nonatomic,assign) BOOL shouldCacheSelection;
@end
