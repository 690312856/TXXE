//
//  GoodReportVC.h
//  TongxiaoXiaoEr
//
//  Created by xueyaoji on 15-4-2.
//  Copyright (c) 2015年 com.e-techco. All rights reserved.
//  商品举报页面

#import <UIKit/UIKit.h>


typedef void(^reportBtnBlock)(NSString*str);


@interface GoodReportVC :UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * listTableView;
    NSArray * dataArr;
    NSInteger _curSelectIndex;
}
@property(nonatomic,copy)reportBtnBlock reportCallBack;
-(void)createGoodReportVC;
@end
