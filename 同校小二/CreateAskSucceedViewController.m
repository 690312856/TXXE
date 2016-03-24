//
//  CreateAskSucceedViewController.m
//  TXXE
//
//  Created by 李雨龙 on 15/8/26.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "CreateAskSucceedViewController.h"
#import "GoodCollectionViewCell.h"
#import "Constants.h"
#import <MJRefresh.h>
#import <MBProgressHUD.h>
#import "ProgressHudCommon.h"
#import "NetController.h"
#import "GoodDetailViewController.h"
#import "AskListViewController.h"
@interface CreateAskSucceedViewController ()

@end

@implementation CreateAskSucceedViewController
-(id)init
{
    self = [super init];
    if(self){
        
        _curPage = 1;
        _pageSize = 20;
        
    }
    return self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //self.view.backgroundColor = [UIColor colorWithRed:230.0/255 green:230.0/255 blue:230.0/255 alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.0/255 green:191.0/255 blue:121.0/255 alpha:1.0];
    [self requestList];
    [self.collectionView registerNib:[UINib nibWithNibName:@"GoodCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"GoodCell"];
    goodsArr = [[NSMutableArray alloc] init];
}


- (void)requestList
{
    [ProgressHudCommon showHUDInView:self.view andInfo:@"数据加载中..." andImgName:nil andAutoHide:NO];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [paramDic setValue:self.categoryId forKey:@"categoryId"];
    [paramDic setValue:self.schoolId forKey:@"schoolId"];
    NSLog(@"rrrrrrrrrrrrr%@",self.schoolId);
    [paramDic setValue:[NSNumber numberWithInt:self.curPage] forKey:@"page"];
    [paramDic setValue:[NSNumber numberWithInt:self.pageSize] forKey:@"pageSize"];
    [[NetController sharedInstance] postWithAPI:API_good_list parameters:paramDic completionHandler:^(id responseObject, NSError *error) {
        if (error) {
            if (self.curPage <= 0) {
            }
            else
            {
                self.curPage = self.curPage - 1;
            }
        }else
        {
            if (self.curPage <= 1) {
                if (responseObject[@"pagination"] && ![responseObject[@"pagination"] isKindOfClass:[NSNull class]]) {
                    goodsArr = [[NSMutableArray alloc] initWithArray:responseObject[@"data"]];
                    pageTotal = [responseObject[@"pagination"][@"pageTotal"]longValue];
                    [self.collectionView reloadData];
                }
            }else{
                for (NSDictionary *dict in responseObject[@"data"])
                {
                    
                    [goodsArr addObject:dict];
                }
                pageTotal = [responseObject[@"pagination"][@"pageTotal"]longValue];
                [self.collectionView reloadData];
            }
        }
        [ProgressHudCommon hiddenHUD:self.view];
        [self.collectionView headerEndRefreshing];
        [self.collectionView footerEndRefreshing];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    
}
#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [goodsArr count];
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"GoodCell";
    GoodCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    
    [cell sizeToFit];
    if (cell == nil) {
        NSLog(@"无法创建CollectionViewCell时打印，自定义的cell就不可能进来了。");
    }
    cell.layer.masksToBounds = NO;
    cell.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    cell.layer.shadowOffset = CGSizeMake(2,2);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    cell.layer.shadowOpacity = 0.4;//阴影透明度，默认0
    cell.layer.shadowRadius = 2;
    [cell refreshWithDic:[goodsArr objectAtIndex:[indexPath row]]];
    return cell;
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIScreen *s = [UIScreen mainScreen];
    CGFloat width = [s bounds].size.width;
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
    //    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    //    cell.backgroundColor = [UIColor redColor];
    GoodDetailViewController *vc = [[GoodDetailViewController alloc]init];
    vc.goodId = [[goodsArr objectAtIndex:[indexPath row]] objectForKey:@"id"];
    vc.distance = 1;
    NSLog(@"%@",vc.goodId);
    for (UIView *view in self.parentViewController.tabBarController.view.subviews) {
        if (view.tag == 100) {
            view.hidden = YES;
        }
    }
    [self.navigationController pushViewController:vc animated:YES];
    //[self presentViewController:vc animated:YES completion:nil];
    NSLog(@"选择%ld",indexPath.row);
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (IBAction)backBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)lookAskAction:(id)sender {
    AskListViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AskList"];
    
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
