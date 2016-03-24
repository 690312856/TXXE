//
//  ActivityViewController.m
//  TXXE
//
//  Created by 李雨龙 on 15/8/2.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "ActivityViewController.h"
#import "DiscoveryGoodCollectionViewCell.h"

#import <MJRefresh.h>
#import <SDWebImageCompat.h>
#import <MBProgressHUD.h>
#import "GoodDetailViewController.h"
@interface ActivityViewController ()

@property (nonatomic,strong) DiscoveryGoodItemModel *discoveryGoodsFetcher;

@end

@implementation ActivityViewController
- (DiscoveryGoodItemModel *)discoveryGoodsFercher
{
    if (!_discoveryGoodsFetcher) {
        _discoveryGoodsFetcher = [[DiscoveryGoodItemModel alloc]init];
    }
    return _discoveryGoodsFetcher;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.goodCollectionView.showsVerticalScrollIndicator = NO;
    __weak __typeof(self)weakSelf = self;
    [self.goodCollectionView addFooterWithCallback:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf loadMoreData];
    }];
    
    [self.goodCollectionView addHeaderWithCallback:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf refreshData];
    }];
    if (self)
    {
        [self.goodCollectionView registerNib:[UINib nibWithNibName:@"DiscoveryGoodCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
        self.goodCollectionView.delegate = self;
        self.goodCollectionView.dataSource =self;
    }
    _discoveryGoodsFetcher = [[DiscoveryGoodItemModel alloc]init];
    _discoveryGoodsFetcher.functionId = self.activityId;
    [self refreshData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark -
#pragma mark - Inner

- (void)loadMoreData
{
    //[MBProgressHUD showHUDAddedTo:self.superview animated:YES];
    __weak __typeof(self)weakSelf = self;
    [self.discoveryGoodsFetcher loadMoreFunctionGoodListWithCompletionHandler:^(NSError *error, NSArray *functionList) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (error) {
            //            [self showTopMessage:[error localizedDescription]];
        } else {
            dispatch_main_async_safe(^(){
                [strongSelf.goodCollectionView reloadData];
            });
        }
        [strongSelf loadDataEndForFooter:YES];
    }];
}

- (void)refreshData
{
    //[MBProgressHUD showHUDAddedTo:self.superview animated:YES];
    __weak __typeof(self)weakSelf = self;
    [self.discoveryGoodsFetcher refreshFunctionGoodListWithCompletionHandler:^(NSError *error, NSArray *functionList) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (error) {
            //            [self showTopMessage:[error localizedDescription]];
        } else {
            dispatch_main_async_safe(^(){
                [strongSelf.goodCollectionView reloadData];
            });
        }
        [self loadDataEndForFooter:NO];
    }];
    
    if ([UserModel currentUser].currentSelectSchool && [UserModel currentUser].currentSelectSchool.schoolID.length != 0) {
    }
}

- (void)loadDataEndForFooter:(BOOL)isFooter
{
    __weak __typeof(self)weakSelf = self;
    dispatch_main_async_safe(^(){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        //[MBProgressHUD hideAllHUDsForView:strongSelf.superview animated:YES];
        if (isFooter) {
            [strongSelf.goodCollectionView footerEndRefreshing];
        } else {
            [strongSelf.goodCollectionView headerEndRefreshing];
        }
    });
}


#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.discoveryGoodsFetcher.cachedGoodList.count;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cell";
    DiscoveryGoodCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    [cell sizeToFit];
    if (!cell) {
        NSLog(@"无法创建CollectionViewCell时打印，自定义的cell就不可能进来了。");
    }
    cell.layer.masksToBounds = NO;
    cell.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    cell.layer.shadowOffset = CGSizeMake(4,4);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    cell.layer.shadowOpacity = 0.4;//阴影透明度，默认0
    cell.layer.shadowRadius = 4;
    cell.goodItem = self.discoveryGoodsFetcher.cachedGoodList[indexPath.row];
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIScreen *s = [UIScreen mainScreen];
    CGFloat width = [s bounds].size.width;
    //边距占5*4=20 ，2个
    //图片为正方形，边长：(fDeviceWidth-20)/2-5-5 所以总高(fDeviceWidth-20)/2-5-5 +20+30+5+5 label高20 btn高30 边
    return CGSizeMake((width-40)/2,(width+50)/2);
}
//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 10, 10, 10);
}
//定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //GoodDetailViewController *vc = [[GoodDetailViewController alloc]init];
    //vc.goodId = [self.discoveryGoodsFetcher.cachedGoodList[indexPath.row] goodId];
    //NSLog(@"68756876575785858767857%@",vc.goodId);
    //[[self getCurrentVC].navigationController pushViewController:vc animated:YES];
    //[[self getCurrentVC].navigationController pushViewController:vc animated:YES];
    //[self.inputViewController pushViewController:vc animated:YES];
    //[[self getCurrentVC] presentViewController:vc animated:YES completion:nil];
    NSLog(@"选择%ld",indexPath.row);
    //添加 字典，将label的值通过key值设置传递
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:[self.discoveryGoodsFetcher.cachedGoodList[indexPath.row] goodId],@"goodId", nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"tiaozhuan" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
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
