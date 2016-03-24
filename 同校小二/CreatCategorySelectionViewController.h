//
//  CreatCategorySelectionViewController.h
//  TongxiaoXiaoEr
//
//  Created by Navi on 15/3/8.
//  Copyright (c) 2015年 xxx.xxxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FunctionItemModel.h"
#import "CategoryModel.h"

typedef NS_ENUM(NSInteger, SelectionDataType) {
    SelectionDataTypeCategory,
    SelectionDataTypeFunction,
};

@interface CreatCategorySelectionViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *AtableView;

@property (nonatomic , assign) SelectionDataType currentType;

@property (nonatomic , strong) CategoryModel *categoryFetcher;

@property (nonatomic , strong) FunctionItemModel *functionFetcher;

@property (nonatomic , copy) void(^completeSelection)(id selectedObject);

@end
