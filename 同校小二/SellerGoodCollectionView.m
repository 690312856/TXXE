//
//  SellerGoodCollectionView.m
//  TXXE
//
//  Created by 李雨龙 on 15/7/26.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "SellerGoodCollectionView.h"
#import "SellerGoodCollectionViewCell.h"

#import <MJRefresh.h>
#import <SDWebImageCompat.h>
#import <MBProgressHUD.h>

@interface SellerGoodCollectionView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) MyCreateGoodModel *myCreateGoodsFetcher;
@end
@implementation SellerGoodCollectionView

- (MyCreateGoodModel *)myCreateGoodsFetcher
{
    if (!_myCreateGoodsFetcher) {
        _myCreateGoodsFetcher = [[MyCreateGoodModel alloc]init];
    }
    return _myCreateGoodsFetcher;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout withMemberId:(NSString *)memberId
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    self.backgroundColor = [UIColor whiteColor];
    self.showsVerticalScrollIndicator = NO;
    self.memberId = memberId;
    
    __weak __typeof(self)weakSelf = self;
    [self addFooterWithCallback:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf loadMoreData];
    }];
    
    [self addHeaderWithCallback:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf refreshData];
    }];
    
    if (self) {
        [self registerNib:[UINib nibWithNibName:@"SellerGoodCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"myGoodcellReusedKey"];
        self.delegate =self;
        self.dataSource = self;
    }
    _myCreateGoodsFetcher = [[MyCreateGoodModel alloc]init];
    _myCreateGoodsFetcher.memberId = self.memberId;
    [self refreshData];
    
    return self;
}


#pragma mark -- UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.myCreateGoodsFetcher.cachedGoodList.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"myGoodcellReusedKey";
    SellerGoodCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    [cell sizeToFit];
    if (!cell) {
        NSLog(@"无法创建CollectionViewCell时打印，自定义的cell就不可能进来了。");
    }
    cell.layer.masksToBounds = NO;
    cell.layer.shadowColor = [UIColor blackColor].CGColor;
    cell.layer.shadowOffset = CGSizeMake(2, 2);
    cell.layer.shadowOpacity = 0.4;
    cell.layer.shadowRadius = 2;
    [cell setMyGoodItem:self.myCreateGoodsFetcher.cachedGoodList[indexPath.row]];
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
    return UIEdgeInsetsMake(10, 12, 12, 12);
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
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:[self.myCreateGoodsFetcher.cachedGoodList[indexPath.row] goodId],@"goodId", nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"tiaozhuanzhi" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark -
#pragma mark - Inner

- (void)loadMoreData
{
    //[MBProgressHUD showHUDAddedTo:self.superview animated:YES];
    __weak __typeof(self)weakSelf = self;
    [self.myCreateGoodsFetcher loadMoreGoodListWithCompletionHandler:^(NSError *error, NSArray *myGoodList) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (error) {
            //            [self showTopMessage:[error localizedDescription]];
        } else {
            dispatch_main_async_safe(^(){
                [strongSelf reloadData];
            });
        }
        [strongSelf loadDataEndForFooter:YES];
    }];
}

- (void)refreshData
{
     NSLog(@"ooooooooooo%@",self.memberId);
    //[MBProgressHUD showHUDAddedTo:self.superview animated:YES];
    __weak __typeof(self)weakSelf = self;
    [self.myCreateGoodsFetcher refreshGoodListWithCompletionHandler:^(NSError *error, NSArray *myGoodList) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (error) {
            //            [self showTopMessage:[error localizedDescription]];
        } else {
            dispatch_main_async_safe(^(){
                [strongSelf reloadData];
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
        //[MBProgressHUD hideAllHUDsForView:strongSelf.superview animated:YES];
        if (isFooter) {
            [strongSelf footerEndRefreshing];
        } else {
            [strongSelf headerEndRefreshing];
        }
    });
}










@end
