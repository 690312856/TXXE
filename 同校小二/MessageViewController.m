//
//  MessageViewController.m
//  TXXE
//
//  Created by 李雨龙 on 15/7/23.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "MessageViewController.h"
#import <MJRefresh.h>
#import <MBProgressHUD.h>
#import <SDWebImageCompat.h>
#import "SystemMessageModel.h"
#import "CommentMessageModel.h"
#import "SystemMessageTableViewCell.h"
#import "CommentMessageTableViewCell.h"
#import "SystemMessageDetailViewController.h"
#import "SystemRedPacketsViewController.h"
#import "GoodDetailViewController.h"
#import "SellerInfoViewController.h"

@interface MessageViewController ()


@property (nonatomic,strong) SystemMessageModel *systemMessageListFetcher;
@property (nonatomic,strong) CommentMessageModel *commentMessageListFetcher;

@end

@implementation MessageViewController


-(SystemMessageModel *)systemMessageListFetcher
{
    if (!_systemMessageListFetcher) {
        _systemMessageListFetcher = [[SystemMessageModel alloc] init];
    }
    return _systemMessageListFetcher;
}

-(CommentMessageModel *)commentMessageListFetcher
{
    if (!_commentMessageListFetcher) {
        _commentMessageListFetcher = [[CommentMessageModel alloc] init];
    }
    return _commentMessageListFetcher;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.segment setTintColor:[UIColor colorWithRed:0.0/255 green:191.0/255 blue:121.0/255 alpha:1.0]];
    [self.segment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    self.segment.selectedSegmentIndex = 0;
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SystemMessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"kSystemMessageTableViewCellReusedKey"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CommentMessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"kCommentMessageTableViewCellReusedKey"];
    
    
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
    for (UIView *view in self.parentViewController.tabBarController.view.subviews) {
        if (view.tag == 100) {
            view.hidden = NO;
        }
    }
    
    [self.tableView headerBeginRefreshing];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)segmentAction:(UISegmentedControl *)Seg
{
    [self.tableView headerBeginRefreshing];
}

#pragma mark -
#pragma mark - Inner

- (void)refreshData
{
    if (self.segment.selectedSegmentIndex == 0) {
        [self refreshSystemMess];
    }else
    {
        [self refreshCommentMess];
    }
}

- (void)loadMoreData
{
    if (self.segment.selectedSegmentIndex == 0) {
        [self loadMoreSystemMess];
    }else
    {
        [self loadMoreCommentMess];
    }
}


- (void)refreshSystemMess
{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    __weak __typeof(self)weakSelf = self;
    void (^completionHandler)(NSError *,NSArray *) = ^(NSError *error,NSArray *systemMessList)
    {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (error) {
            
        }else
        {
            NSLog(@"111111111111");
            dispatch_main_sync_safe(^(){
                
                [strongSelf.tableView reloadData];
            });
        }
        [strongSelf loadDataEndForFooter:NO];
    };
    [self.systemMessageListFetcher refreshSystemMessageListWithCompletionHandler:completionHandler];
}

- (void)refreshCommentMess
{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    __weak __typeof(self)weakSelf = self;
    void (^completionHandler)(NSError *,NSArray *) = ^(NSError *error,NSArray *CommentMessList)
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
    [self.commentMessageListFetcher refreshCommentMessageListWithCompletionHandler:completionHandler];
}

- (void)loadMoreSystemMess
{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    __weak __typeof(self)weakSelf = self;
    
    [self.systemMessageListFetcher loadMoreSystemMessageWithCompletionHandler:^(NSError *error,NSArray *systemMessList){
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
- (void)loadMoreCommentMess
{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    __weak __typeof(self)weakSelf = self;
    
    [self.commentMessageListFetcher loadMoreCommentMessageWithCompletionHandler:^(NSError *error,NSArray *commentMessList){
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.segment.selectedSegmentIndex == 0)
    {
        return self.systemMessageListFetcher.kcachedMessageList.count;
    }else
    {
        return self.commentMessageListFetcher.cachedMessageList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.segment.selectedSegmentIndex == 0)
    {
        static NSString *CMainCell = @"kSystemMessageTableViewCellReusedKey";
        SystemMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CMainCell];
        if (cell == nil) {
            cell = [[SystemMessageTableViewCell alloc]init];
        }
        SystemMessageModel *messageModel = self.systemMessageListFetcher.kcachedMessageList[indexPath.row];
        cell.messageModel = messageModel;
        return cell;
    }else
    {
        static NSString *CMainCell = @"kCommentMessageTableViewCellReusedKey";
        CommentMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CMainCell];
        if (cell == nil) {
            cell = [[CommentMessageTableViewCell alloc]init];
        }
        CommentMessageModel *messageModel = self.commentMessageListFetcher.cachedMessageList[indexPath.row];
        cell.messageModel = messageModel;
        return cell;
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.segment.selectedSegmentIndex == 0) {
        SystemMessageModel *messageModel = self.systemMessageListFetcher.kcachedMessageList[indexPath.row];
        [messageModel labelHadReadSystemMessageWithCompletionHandler:^(NSError *error) {
            if (error) {
                NSLog(@"confirmSaleWithCompletionHandler.error = %@",error);
            } else {
                dispatch_main_async_safe(^(){
                    [self refreshData];
                });
            }
        }];
        /*if ([messageModel.sMessageType isEqualToString:@"0"]) {
            SystemMessageDetailViewController *vc = [[SystemMessageDetailViewController alloc]init];
            vc.detail = messageModel.messageBodyDict[@"contents"];
            [self.navigationController pushViewController:vc animated:YES];
        }else
        {
            SystemRedPacketsViewController *vc = [[SystemRedPacketsViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }*/
        SystemMessageDetailViewController *vc = [[SystemMessageDetailViewController alloc]init];
        vc.detail = messageModel.messageBodyDict[@"contents"];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        CommentMessageModel *messageModel = self.commentMessageListFetcher.cachedMessageList[indexPath.row];
        [messageModel labelHadReadCommentMessageWithCompletionHandler:^(NSError *error) {
            if (error) {
                NSLog(@"confirmSaleWithCompletionHandler.error = %@",error);
            } else {
                dispatch_main_async_safe(^(){
                    [self refreshData];
                });
            }
        }];
        if ([messageModel.cGoodsType isEqualToString:@"0"]) {
            GoodDetailViewController *vc = [[GoodDetailViewController alloc]init];
            vc.goodId = messageModel.goodOrAskId;
            for (UIView *view in self.parentViewController.tabBarController.view.subviews) {
                if (view.tag == 100) {
                    view.hidden = YES;
                }
            }
            [self.navigationController pushViewController:vc animated:YES];
        }
        if ([messageModel.cGoodsType isEqualToString:@"1"]) {
            SellerInfoViewController *vc = [[SellerInfoViewController alloc]init];
            vc.askId = messageModel.goodOrAskId;
            NSLog(@"rrrrrrrrrr%@",vc.askId);
            vc.type = 2;
            vc.memberId = messageModel.createMemberId;
            for (UIView *view in self.parentViewController.tabBarController.view.subviews) {
                if (view.tag == 100) {
                    view.hidden = YES;
                }
            }
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
}

@end