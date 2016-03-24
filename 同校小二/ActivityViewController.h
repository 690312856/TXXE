//
//  ActivityViewController.h
//  TXXE
//
//  Created by 李雨龙 on 15/8/2.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *ActivityDescriptionView;
@property (weak, nonatomic) IBOutlet UICollectionView *goodCollectionView;
@property (nonatomic,strong)NSString *activityId;
@end
