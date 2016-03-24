//
//  DiscoveryViewController.h
//  TXXE
//
//  Created by River on 15/6/6.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
//两个切换页面
#import "DiscoveryGoodColletionView.h"
#import "CategoryView.h"

@interface DiscoveryViewController : UIViewController<UISearchBarDelegate>

@property (strong, nonatomic)UISegmentedControl *segment;
@property (nonatomic,strong)DiscoveryGoodColletionView *collectionView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong,nonatomic)UIView *greenCategory;
@property (strong,nonatomic)UIView *greenDiscover;
@property (strong,nonatomic)UIButton *categoryBtn;
@property (strong,nonatomic)UIButton *discoverBtn;
@property (nonatomic,strong)CategoryView *categoryView;

@end
