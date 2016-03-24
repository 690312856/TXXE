//
//  SchoolSelectViewController.m
//  TXXE
//
//  Created by River on 15/7/15.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "SchoolSelectViewController.h"
#import "ACGlobalLocationModel.h"
#import <MBProgressHUD.h>
#import "GlobalTool.h"
#import "Constants.h"
#import "UserModel.h"
@interface SchoolSelectViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    BOOL isCurrentSearchResult;
}
@property (nonatomic , strong) SchoolModel *schoolDataFetcher;
@property (weak, nonatomic) IBOutlet UITableView *showTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


@end
@implementation SchoolSelectViewController

-(SchoolModel *)schoolDataFetcher
{
    if (!_schoolDataFetcher) {
        _schoolDataFetcher = [[SchoolModel alloc]init];
    }
    return _schoolDataFetcher;
}

- (void)viewDidLoad
{
    self.title = @"选择学校";
    self.navigationController.navigationBarHidden = NO;
    if (self.distance == 1) {
    self.height.constant = self.height.constant-64;
    }
    NSUserDefaults *userDF = [NSUserDefaults standardUserDefaults];
    BOOL isFirst = [userDF boolForKey:@"schoolIsFirst"];
    NSLog(@"isFirst is:%d", isFirst);
    self.searchBar.tintColor = [UIColor colorWithRed:0.0/255 green:191.0/255 blue:121.0/255 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.0/255 green:191.0/255 blue:121.0/255 alpha:1.0];
    self.searchBar.placeholder = @"请输入关键字";

    [self.showTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"kSchoolSelectTableViewReuseKey"];
    isCurrentSearchResult = NO;
    [self startFetchHotSchoolData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    for (UIView *view in self.parentViewController.tabBarController.view.subviews) {
        if (view.tag == 100) {
            view.hidden = YES;
        }
    }
    self.navigationController.navigationBarHidden = NO;
}


- (void)startFetchHotSchoolData
{
    isCurrentSearchResult = NO;
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    __weak __typeof(self)weakSelf = self;
    [self.schoolDataFetcher fetchAllHotSchoolsWithCompletionHandler:^(NSArray *allSchools, NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (error) {
            [GlobalTool tipsAlertWithTitle:@"获取学校列表失败" message:[error localizedDescription] cancelBtnTitle:@"确定"];
        }else{
            DISPATCH_MAIN(^(){
                [strongSelf.showTableView reloadData];
            });
        }
        [MBProgressHUD hideAllHUDsForView:strongSelf.navigationController.view animated:YES];
    }];
}



#pragma mark -
#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (isCurrentSearchResult) {
        if (self.schoolDataFetcher.cachedHotSchools.count == 0) {
            return [self sectionHeaderViewWithTitle:@"未搜索到该学校"];
        }else
        {
            return [self sectionHeaderViewWithTitle:@"搜索结果"];
        }
    }else
    {
        return [self sectionHeaderViewWithTitle:@"热门学校"];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.schoolDataFetcher.cachedHotSchools.count == 0) {
        
    }
        return self.schoolDataFetcher.cachedHotSchools.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        cell.preservesSuperviewLayoutMargins = NO;
    }
    cell.textLabel.textColor = RGB_COLOR(170, 170, 170, 1.0);
    cell.textLabel.font = [UIFont systemFontOfSize:14];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kSchoolSelectTableViewReuseKey" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    SchoolModel *tempModel = nil;
    //if (isCurrentSearchResult) {
        tempModel = [self.schoolDataFetcher.cachedHotSchools objectAtIndex:indexPath.row];
    //}
    cell.textLabel.text = tempModel.schoolName;
    if ([tempModel isEqual:[UserModel currentUser].currentSelectSchool]) {
        if (self.shouldCacheSelection) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SchoolModel *tempModel = nil;
    tempModel = [self.schoolDataFetcher.cachedHotSchools objectAtIndex:indexPath.row];
    
    if (self.shouldCacheSelection) {
        BOOL cacheSucceed = [tempModel cacheSelfIntoUserDefault];
        NSLog(@"保存学校:%@",@(cacheSucceed));
    }
    
    if (self.finishedSchoolPickBlock) {
        NSUserDefaults *userDF = [NSUserDefaults standardUserDefaults];
        BOOL isFirst = [userDF boolForKey:@"schoolIsFirst"];
        NSLog(@"isFirst is:%d", isFirst);
        if (isFirst == NO) {
            NSUserDefaults *userDF = [NSUserDefaults standardUserDefaults];
            [userDF setBool:YES forKey:@"schoolIsFirst"];
            [userDF synchronize];
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:tempModel.schoolID forKey:@"schoolSelected"];
            [user synchronize];
        }
        self.finishedSchoolPickBlock(tempModel);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -
#pragma mark - Inner

- (UIView *)sectionHeaderViewWithTitle:(NSString *)title
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.showTableView.frame.size.width, 40)];
    bgView.backgroundColor = RGB_COLOR(239, 239, 239, 1);
    UILabel *label = [[UILabel alloc] initWithFrame:bgView.bounds];
    label.backgroundColor = [UIColor clearColor];
    label.text = title;
    label.font = [UIFont systemFontOfSize:17];
    label.textColor = RGB_COLOR(0, 191, 121, 1);
    [bgView addSubview:label];
    label.frame = CGRectOffset(label.frame, 15, 0);
    
    return bgView;
}

#pragma mark -
#pragma mark - UISearchbarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (self.searchBar.text.length == 0) {
        [self startFetchHotSchoolData];
        return;
    }
    isCurrentSearchResult = YES;
    [self.searchBar resignFirstResponder];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak __typeof(self)weakSelf = self;
    [self.schoolDataFetcher searchForSchoolWithKeyWord:self.searchBar.text completionHandler:^(NSArray *allSchools, NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (error) {
            [GlobalTool tipsAlertWithTitle:@"获取学校列表失败" message:[error localizedDescription] cancelBtnTitle:@"确定"];
        } else {
            DISPATCH_MAIN(^(){
                [strongSelf.showTableView reloadData];
            });
        }
        [MBProgressHUD hideAllHUDsForView:strongSelf.view animated:YES];
    }];
    
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;
{
    if (self.searchBar.text.length == 0) {
        [self startFetchHotSchoolData];
        return;
    }
    /*isCurrentSearchResult = YES;
    [self.searchBar resignFirstResponder];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak __typeof(self)weakSelf = self;
    [self.schoolDataFetcher searchForSchoolWithKeyWord:self.searchBar.text completionHandler:^(NSArray *allSchools, NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (error) {
            [GlobalTool tipsAlertWithTitle:@"获取学校列表失败" message:[error localizedDescription] cancelBtnTitle:@"确定"];
        } else {
            DISPATCH_MAIN(^(){
                [strongSelf.showTableView reloadData];
            });
        }
        [MBProgressHUD hideAllHUDsForView:strongSelf.view animated:YES];
    }];*/
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.searchBar.text = @"";
    [self startFetchHotSchoolData];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [_searchBar resignFirstResponder];
}
@end
