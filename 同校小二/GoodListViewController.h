//
//  GoodListViewController.h
//  TXXE
//
//  Created by 李雨龙 on 15/7/19.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodListViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,assign)long distance;


@end
