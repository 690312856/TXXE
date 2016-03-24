//
//  CreatCategorySelectionViewController.m
//  TongxiaoXiaoEr
//
//  Created by Navi on 15/3/8.
//  Copyright (c) 2015年 xxx.xxxx. All rights reserved.
//

#import "CreatCategorySelectionViewController.h"
#import "CategoryModel.h"
#import <MJRefresh.h>
#import <MBProgressHUD.h>
#import <SDWebImageCompat.h>

@interface CreatCategorySelectionViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic , strong) NSArray *firstLevelCategories;

@end

@implementation CreatCategorySelectionViewController

- (void)setCurrentType:(SelectionDataType)currentType
{
    if (_currentType != currentType) {
        NSLog(@"%ld",(long)_currentType);
        _currentType = currentType;
        if (_currentType == SelectionDataTypeCategory) {
            [self.AtableView removeHeader];
            [self.AtableView removeFooter];
            if (self.firstLevelCategories.count == 0) {
                __weak __typeof(self)weakSelf = self;
                //[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                __weak __typeof(CategoryModel*)weakModel = self.categoryFetcher;
                [self.categoryFetcher loadAllCategoryListWithCompletionHandler:^(NSError *error) {
                    __strong __typeof(weakSelf)strongSelf = weakSelf;
                    if (error) {
                        NSLog(@"categoryListerror = %@",error);
                    } else {
                        dispatch_main_async_safe(^(){
                            __strong __typeof(CategoryModel*)strongModel = weakModel;
                            strongSelf.firstLevelCategories = strongModel.cachedCategoryList;
                            [strongSelf.AtableView reloadData];
                        });
                    }
                    //[MBProgressHUD hideAllHUDsForView:strongSelf.navigationController.view animated:YES];
                }];
            } else {
                self.categoryFetcher.cachedCategoryList = self.firstLevelCategories;
                [self.AtableView reloadData];
            }
        } else if (_currentType == SelectionDataTypeFunction) {
            __weak __typeof(self)weakSelf = self;
            [self.AtableView addFooterWithCallback:^{
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                [strongSelf loadMoreData];
            }];
            
            [self.AtableView addHeaderWithCallback:^{
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                [strongSelf refresData];
            }];
            if (self.functionFetcher.cachedFunctionList.count == 0) {
                [self.AtableView headerBeginRefreshing];
            } else {
                [self.AtableView reloadData];
            }
        }
    } else if (currentType == SelectionDataTypeCategory) {
        self.categoryFetcher.cachedCategoryList = self.firstLevelCategories;
        [self.AtableView reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.AtableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"kSelectionTableViewCellReuseKey"];
    self.currentType = -1;
    //[self.AtableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - Inner

- (void)loadMoreData
{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    __weak __typeof(self)weakSelf = self;
    [self.functionFetcher loadMoreFunctionListWithCompletionHandler:^(NSError *error, NSArray *functionList) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (error) {
            //            [self showTopMessage:[error localizedDescription]];
        } else {
            dispatch_main_async_safe(^(){
                [strongSelf.AtableView reloadData];
            });
        }
        [strongSelf loadDataEndForFooter:YES];
    }];
}

- (void)refresData
{
    //[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    __weak __typeof(self)weakSelf = self;
    [self.functionFetcher refreshFunctionListWithCompletionHandler:^(NSError *error, NSArray *functionList) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (error) {
            //            [self showTopMessage:[error localizedDescription]];
        } else {
            dispatch_main_async_safe(^(){
                [strongSelf.AtableView reloadData];
            });
        }
        [self loadDataEndForFooter:NO];
    }];
}

- (void)loadDataEndForFooter:(BOOL)isFooter
{
    __weak __typeof(self)weakSelf = self;
    dispatch_main_async_safe(^(){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideAllHUDsForView:strongSelf.navigationController.view animated:YES];
        if (isFooter) {
            [strongSelf.AtableView footerEndRefreshing];
        } else {
            [strongSelf.AtableView headerEndRefreshing];
        }
    });
}

#pragma mark -
#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.currentType == SelectionDataTypeCategory) {
         NSLog(@"%lu",(unsigned long)self.categoryFetcher.cachedCategoryList.count);
        return self.categoryFetcher.cachedCategoryList.count;
    } else if (self.currentType == SelectionDataTypeFunction) {
        return self.functionFetcher.cachedFunctionList.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"kSelectionTableViewCellReuseKey" forIndexPath:indexPath];
    if (self.currentType == SelectionDataTypeCategory) {
        CategoryModel *categoryModel = self.categoryFetcher.cachedCategoryList[indexPath.row];
        NSLog(@"123456789%@",categoryModel.categoryName);
        cell.textLabel.text = categoryModel.categoryName;
    } else if (self.currentType == SelectionDataTypeFunction) {
        FunctionItemModel *functionModel = self.functionFetcher.cachedFunctionList[indexPath.row];
        cell.textLabel.text = functionModel.functionName;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.completeSelection) {
        if (self.currentType == SelectionDataTypeCategory) {
            CategoryModel *categoryModel = self.categoryFetcher.cachedCategoryList[indexPath.row];
            if (categoryModel.subCategories.count != 0) {
                //选择二级分类
                self.categoryFetcher.cachedCategoryList = categoryModel.subCategories;
                [self.AtableView reloadData];
            } else {
                NSLog(@"!!!!!!!!%@",categoryModel.categoryName);
                self.completeSelection(categoryModel);
            }
        } else if (self.currentType == SelectionDataTypeFunction) {
            FunctionItemModel *functionModel = self.functionFetcher.cachedFunctionList[indexPath.row];
            self.completeSelection(functionModel);
        }
    }
}
@end
