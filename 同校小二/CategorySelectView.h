//
//  CategorySelectView.h
//  TXXE
//
//  Created by River on 15/6/29.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^rightCellCallBack)(NSMutableDictionary*dic);

@interface CategorySelectView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *leftTableView;
    UITableView *rightTableView;
    int lastSelectIndex;
    int curSelectIndex;
    
    NSMutableDictionary * leftTempDic;
}

@property (nonatomic,strong)rightCellCallBack cellCallBack;
@property (nonatomic,copy)NSMutableArray *leftArr;
@property (nonatomic,copy)NSMutableArray *rightArr;
@property (nonatomic,strong)NSMutableArray *allRightArr;

@end
