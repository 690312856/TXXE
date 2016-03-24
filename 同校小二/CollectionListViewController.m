//
//  CollectionListViewController.m
//  TXXE
//
//  Created by 李雨龙 on 15/7/24.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "CollectionListViewController.h"
#import "myCollectionAskModel.h"
#import "myCollectionGoodModel.h"
#import "AskCollectionListTableViewCell.h"
#import "GoodCollectionListTableViewCell.h"
#import <MJRefresh.h>
#import <MBProgressHUD.h>
#import <SDWebImageCompat.h>
#import "SimplifyAlertView.h"
#import "GoodDetailViewController.h"
#import "SellerInfoViewController.h"

#import "ImageScrollView.h"

@interface CollectionListViewController ()<UITableViewDataSource,UITableViewDelegate,ImageScrollViewDelegate,UIScrollViewDelegate>
{
    long numOfPicture;
    
    ImageListView *listOfImage;
    NSInteger currentIndex;
    UIView *markView;
    UIView *scrollPanel;
    UIScrollView *myScrollView;
}
@property (nonatomic,strong) myCollectionAskModel *myCollectionAskListFetcher;
@property (nonatomic,strong) myCollectionGoodModel *myCollectionGoodListFetcher;
@end


@implementation CollectionListViewController
- (myCollectionAskModel *)myCollectionAskListFetcher
{
    if (!_myCollectionAskListFetcher) {
        _myCollectionAskListFetcher = [[myCollectionAskModel alloc]init];
    }
    return _myCollectionAskListFetcher;
}

- (myCollectionGoodModel *)myCollectionGoodListFetcher
{
    if (!_myCollectionGoodListFetcher) {
        _myCollectionGoodListFetcher = [[myCollectionGoodModel alloc]init];
    }
    return _myCollectionGoodListFetcher;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.segment setTintColor:[UIColor colorWithRed:0.0/255 green:191.0/255 blue:121.0/255 alpha:1.0]];
    [self.segment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    self.segment.selectedSegmentIndex = 0;
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.0/255 green:191.0/255 blue:121.0/255 alpha:1.0];
    ///
    [self.tableView registerClass:[AskCollectionListTableViewCell class] forCellReuseIdentifier:@"kAskCollectionListTableViewCellReusedKey"];
    [self.tableView registerClass:[GoodCollectionListTableViewCell class] forCellReuseIdentifier:@"kGoodCollectionListTableViewCellReusedKey"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageTag:) name:@"imageTag" object:nil];
    //////////////
    //展示图片1
    scrollPanel = [[UIView alloc] initWithFrame:self.view.bounds];
    scrollPanel.backgroundColor = [UIColor blackColor];
    scrollPanel.alpha = 0;
    [self.view addSubview:scrollPanel];
    //展示图片2
    markView = [[UIView alloc] initWithFrame:scrollPanel.bounds];
    markView.backgroundColor = [UIColor blackColor];
    markView.alpha = 0.0;
    [scrollPanel addSubview:markView];
    //展示图片3
    myScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [scrollPanel addSubview:myScrollView];
    myScrollView.pagingEnabled = YES;
    myScrollView.delegate = self;
    
    /////////////
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView headerBeginRefreshing];
    
}

////////////////////////////////////////////////
-(void)segmentAction:(UISegmentedControl *)Seg
{
    NSInteger index = Seg.selectedSegmentIndex;
    switch (index) {
        case 0:
            [self.tableView headerBeginRefreshing];
            break;
        case 1:
            [self.tableView headerBeginRefreshing];
            break;
        default:
            break;
    }
}
////////////////////////////////////////////////////


#pragma mark -
#pragma mark - Inner

- (void)refreshData
{
    if (self.segment.selectedSegmentIndex == 0) {
        [self refreshGoodCollectionList];
    }else if (self.segment.selectedSegmentIndex == 1)
    {
        [self refreshAskCollectionList];
    }
}

- (void)loadMoreData
{
    if (self.segment.selectedSegmentIndex == 0) {
        [self loadMoreGoodCollectionList];
    }else if (self.segment.selectedSegmentIndex == 1)
    {
        [self loadMoreAskCollectionList];
    }
}


- (void)refreshGoodCollectionList
{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    __weak __typeof(self)weakSelf = self;
    void (^completionHandler)(NSError *,NSArray *) = ^(NSError *error,NSArray *GoodCollectionList)
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
    [self.myCollectionGoodListFetcher refreshCollectionGoodListWithCompletionHandler:completionHandler];
}

- (void)refreshAskCollectionList
{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    __weak __typeof(self)weakSelf = self;
    void (^completionHandler)(NSError *,NSArray *) = ^(NSError *error,NSArray *AskCollectionList)
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
    [self.myCollectionAskListFetcher refreshCollectionAskListWithCompletionHandler:completionHandler];
}

- (void)loadMoreGoodCollectionList
{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    __weak __typeof(self)weakSelf = self;
    
    [self.myCollectionGoodListFetcher loadMoreCollectionGoodListWithCompletionHandler:^(NSError *error, NSArray *goodList){
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

- (void)loadMoreAskCollectionList
{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    __weak __typeof(self)weakSelf = self;
    
    [self.myCollectionAskListFetcher loadMoreCollectionAskListWithCompletionHandler:^(NSError *error, NSArray *askList){
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


- (void)cancelCollectionWithCollectedGood:(myCollectionGoodModel *)myCollectionGoodModel
{
    __weak __typeof(self)weakSelf = self;
    [SimplifyAlertView alertWithTitle:@"" message:@"是否确认取消收藏?" operationResult:^(NSInteger selectedIndex) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (selectedIndex == 0) {
            NSLog(@"66666");
            
        }else if (selectedIndex == 1)
        {
            [MBProgressHUD showHUDAddedTo:strongSelf.navigationController.view animated:YES];
            [myCollectionGoodModel cancelCollectionWithCompletionHandler:^(NSError *error) {
                if (error) {
                    [MBProgressHUD hideAllHUDsForView:strongSelf.navigationController.view animated:YES];
                }else
                {
                    
                    dispatch_main_async_safe(^(){
                        [strongSelf refreshData];
                    });
                }
            }];
        }
    } cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
}

- (void)cancelCollectionWithCollectedAsk:(myCollectionAskModel *)myCollectionAskModel
{
    __weak __typeof(self)weakSelf = self;
    [SimplifyAlertView alertWithTitle:@"" message:@"是否确认取消收藏?" operationResult:^(NSInteger selectedIndex) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (selectedIndex == 0) {
            NSLog(@"66666");
            
        }else if (selectedIndex == 1)
        {
            [MBProgressHUD showHUDAddedTo:strongSelf.navigationController.view animated:YES];
            [myCollectionAskModel cancelCollectionWithCompletionHandler:^(NSError *error) {
                if (error) {
                    
                    [MBProgressHUD hideAllHUDsForView:strongSelf.navigationController.view animated:YES];
                }else
                {
                    
                    dispatch_main_async_safe(^(){
                        [strongSelf refreshData];
                    });
                }
            }];
        }
    } cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark -
#pragma mark - UITableViewDelegate & UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.segment.selectedSegmentIndex == 0) {
        return 135;
    }else
    {
        if (numOfPicture > 6) {
            return 395;
        }else if (numOfPicture > 3 && numOfPicture <= 6)
        {
            return 310;
        }else if (numOfPicture > 1 && numOfPicture <= 3)
        {
            return 225;
        }else if (numOfPicture == 1)
        {
            return 235;
        }else
        {
            return 135;
        }
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.segment.selectedSegmentIndex == 0) {
        return self.myCollectionGoodListFetcher.cachedGoodList.count;
    }else
    {
        return self.myCollectionAskListFetcher.cachedAskList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.segment.selectedSegmentIndex == 0) {
        GoodCollectionListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kGoodCollectionListTableViewCellReusedKey" forIndexPath:indexPath];
        myCollectionGoodModel *tempModel = self.myCollectionGoodListFetcher.cachedGoodList[indexPath.row];
        NSLog(@"!!!!!!!!!%@",tempModel);
        cell.myCollectionGoodModel = tempModel;
        __weak __typeof(self)weakSelf = self;
        cell.cancelCollectedButtonActionBlock = ^(){
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf cancelCollectionWithCollectedGood:tempModel];
        };
        return cell;
    }else
    {
        AskCollectionListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kAskCollectionListTableViewCellReusedKey" forIndexPath:indexPath];
        
        myCollectionAskModel *tempModel = self.myCollectionAskListFetcher.cachedAskList[indexPath.row];
        numOfPicture = tempModel.imageUrlTexts.count;
        NSLog(@"!!!!!!!!!%@",tempModel);
        cell.myCollectionAskModel = tempModel;
        __weak __typeof(self)weakSelf = self;
        cell.cancelCollectedButtonActionBlock = ^(){
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf cancelCollectionWithCollectedAsk:tempModel];
        };
        return cell;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.segment.selectedSegmentIndex == 0) {
        GoodDetailViewController *vc = [[GoodDetailViewController alloc]init];
        vc.goodId = [self.myCollectionGoodListFetcher.cachedGoodList[indexPath.row] goodId];
        NSLog(@"///////%@",vc.goodId);
        for (UIView *view in self.parentViewController.tabBarController.view.subviews) {
            if (view.tag == 100) {
                view.hidden = YES;
            }
        }
        [self.navigationController pushViewController:vc animated:YES];
    }else
    {
        SellerInfoViewController *vc = [[SellerInfoViewController alloc]init];
        vc.askId = [self.myCollectionAskListFetcher.cachedAskList[indexPath.row] askId];
        vc.type = 2;
        vc.memberId = [self.myCollectionAskListFetcher.cachedAskList[indexPath.row] memberId];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)imageTag:(NSNotification *)text
{
    [self.view bringSubviewToFront:scrollPanel];
    scrollPanel.alpha = 1.0;
    
    UIImageView *tmpView = text.userInfo[@"imgView"];
    currentIndex = [text.userInfo[@"imgViewTag"] integerValue]-10;
    NSArray *imglist = text.userInfo[@"imgList"];
    listOfImage = text.userInfo[@"imageListView"];
    
    CGSize contentSize = myScrollView.contentSize;
    contentSize.height = self.view.bounds.size.height;
    contentSize.width = self.view.bounds.size.width * imglist.count;
    myScrollView.contentSize = contentSize;
    
    //转换后的rect
    CGRect convertRect = [[tmpView superview] convertRect:tmpView.frame toView:self.view];
    CGPoint contentOffset = myScrollView.contentOffset;
    contentOffset.x = currentIndex*self.view.frame.size.width;
    myScrollView.contentOffset = contentOffset;
    
    //添加
    [self addSubImgView:imglist];
    
    ImageScrollView *tmpImgScrollView = [[ImageScrollView alloc] initWithFrame:(CGRect){contentOffset,myScrollView.bounds.size}];
    [tmpImgScrollView setContentWithFrame:convertRect];
    [tmpImgScrollView setImage:tmpView.image];
    [myScrollView addSubview:tmpImgScrollView];
    tmpImgScrollView.i_delegate = self;
    
    [self performSelector:@selector(setOriginFrame:) withObject:tmpImgScrollView afterDelay:0.1];
}

- (void) addSubImgView:(NSArray *)imglist
{
    for (UIView *tmpView in myScrollView.subviews)
    {
        [tmpView removeFromSuperview];
    }
    
    for (int i = 0; i < imglist.count; i ++)
    {
        if (i == currentIndex)
        {
            continue;
        }
        
        UIImageView *tmpView = (UIImageView *)[listOfImage viewWithTag:10 + i];
        
        //转换后的rect
        CGRect convertRect = [[tmpView superview] convertRect:tmpView.frame toView:self.view];
        
        ImageScrollView *tmpImgScrollView = [[ImageScrollView alloc] initWithFrame:(CGRect){i*myScrollView.bounds.size.width,0,myScrollView.bounds.size}];
        [tmpImgScrollView setContentWithFrame:convertRect];
        [tmpImgScrollView setImage:tmpView.image];
        [myScrollView addSubview:tmpImgScrollView];
        tmpImgScrollView.i_delegate = self;
        
        [tmpImgScrollView setAnimationRect];
    }
}

- (void) setOriginFrame:(ImageScrollView *) sender
{
    [UIView animateWithDuration:0.4 animations:^{
        [sender setAnimationRect];
        markView.alpha = 1.0;
    }];
}

#pragma mark -
#pragma mark - scroll delegate
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = myScrollView.frame.size.width;
    currentIndex = floor(scrollView.contentOffset.x/pageWidth - 0.5) + 1;
}

- (void) tapImageViewTappedWithObject:(id)sender
{
    
    ImageScrollView *tmpImgView = sender;
    
    [UIView animateWithDuration:0.5 animations:^{
        markView.alpha = 0;
        [tmpImgView rechangeInitRect];
    } completion:^(BOOL finished) {
        scrollPanel.alpha = 0;
    }];
    
}

@end
