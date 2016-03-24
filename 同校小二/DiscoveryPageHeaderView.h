//
//  DiscoveryPageHeaderView.h
//  TXXE
//
//  Created by River on 15/6/15.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CycleScrollView.h"
#import "BaseFuncionModel.h"
@interface DiscoveryPageHeaderView : UIView
@property (weak, nonatomic) IBOutlet CycleScrollView *autoSlideScrollView;

@property (nonatomic,copy) void (^FunctionDidTapped)(BaseFuncionModel *tempItem);

@property (nonatomic,strong)NSArray * functionsDataSource;

@end
