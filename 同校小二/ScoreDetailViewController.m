//
//  ScoreDetailViewController.m
//  TXXE
//
//  Created by 李雨龙 on 15/7/26.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "ScoreDetailViewController.h"
#import "ScoreDetailTableViewCell.h"
#import "ScoreDetailModel.h"
#import "ProgressHudCommon.h"
#import "UserModel.h"
#import <MJRefresh.h>
#import <MBProgressHUD.h>
#import <SDWebImageCompat.h>
#import "NetController.h"
#import "RuleDetailTableViewController.h"

@interface ScoreDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)ScoreDetailModel *scoreDetailListFetcher;

@end

@implementation ScoreDetailViewController

- (ScoreDetailModel *)scoreDetailListFetcher
{
    if (!_scoreDetailListFetcher) {
        _scoreDetailListFetcher = [[ScoreDetailModel alloc]init];
    }
    return _scoreDetailListFetcher;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"积分明细";
    self.scoreLabel.text = [UserModel currentUser].score;
    self.navigationController.navigationBar.translucent = YES;
    [self.tableView registerNib:[UINib nibWithNibName:@"ScoreDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"kScoreDetailTableViewCellReusedKey"];
    
    __weak __typeof(self)weakSelf = self;
    [self.tableView addFooterWithCallback:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf loadMoreData];
    }];
    
    [self.tableView addHeaderWithCallback:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf refreshData];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView headerBeginRefreshing];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark -
#pragma mark - Inner

- (void)refreshData
{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    __weak __typeof(self)weakSelf = self;
    void (^completionHandler)(NSError *,NSArray *) = ^(NSError *error,NSArray *scoreDetailList)
    {
         __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (error) {
            
        }else
        {
            dispatch_main_sync_safe(^(){
                [strongSelf.tableView reloadData];
            });
        }
        [strongSelf loadDataEndForFooter:NO];
    };
    [self.scoreDetailListFetcher refreshScoreDetailListWithCompletionHandler:completionHandler];
}

- (void)loadMoreData
{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    __weak __typeof(self)weakSelf = self;
    
    [self.scoreDetailListFetcher loadMoreScoreDetailListWithCompletionHandler:^(NSError *error,NSArray *scoreDetailList){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (error) {
            
        }else
        {
            dispatch_main_sync_safe(^(){
                [strongSelf.tableView reloadData];
            });
        }
        [strongSelf loadDataEndForFooter:YES];
    }];
}

- (void)loadDataEndForFooter:(BOOL)isFooter
{
    __weak __typeof(self)weakSelf = self;
    dispatch_main_async_safe(^(){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideAllHUDsForView:strongSelf.navigationController.view animated:YES];
        if (isFooter) {
            [strongSelf.tableView footerEndRefreshing];
        } else {
            [strongSelf.tableView headerEndRefreshing];
        }
    });
}

#pragma mark -
#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"$$$$$%lu",(unsigned long)self.scoreDetailListFetcher.cachedScoreDetailList.count);
    return self.scoreDetailListFetcher.cachedScoreDetailList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ScoreDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kScoreDetailTableViewCellReusedKey" forIndexPath:indexPath];
    ScoreDetailModel *detailModel = self.scoreDetailListFetcher.cachedScoreDetailList[indexPath.row];
    NSLog(@"sfsdfafaf");
    cell.scoreDetailModel = detailModel;
    return cell;
}
- (IBAction)ruleDetailBtnAction:(id)sender {
    RuleDetailTableViewController *vc = [[RuleDetailTableViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
