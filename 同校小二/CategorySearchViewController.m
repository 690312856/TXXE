//
//  CategorySearchViewController.m
//  TXXE
//
//  Created by River on 15/6/29.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "CategorySearchViewController.h"
#import "GoodCollectionViewCell.h"
#import "SearchConditionView.h"
#import "UserModel.h"
#import "Constants.h"
#import <MJRefresh.h>
#import <MBProgressHUD.h>
#import "ProgressHudCommon.h"
#import "NetController.h"
#import "GoodDetailViewController.h"
@interface CategorySearchViewController ()

@end

@implementation CategorySearchViewController

-(id)init
{
    self = [super init];
    if(self){
        
        [self initData];
        _curPage = 1;
        _pageSize = 20;
        
    }
    return self;
    
}

#pragma mark 初始化默认数据
-(void)initData
{
    priceAsc = 2;
    creditAsc = 2;
    _schoolId = [UserModel currentUser].currentSelectSchool.schoolID;
    _categoryId = @"";
    _searchTitle = @"";
    self.isInSchool = @"";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor colorWithRed:230.0/255 green:230.0/255 blue:230.0/255 alpha:1];
    [self createCategorySearchVC];
    [self requestList];
    self.goodCollectionView.backgroundColor = [UIColor whiteColor];
    [self.goodCollectionView registerNib:[UINib nibWithNibName:@"GoodCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"GoodCell"];
    goodsArr = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.num = 0;
    self.navigationController.navigationBarHidden = YES;
    NSLog(@"viewWillAppear");
    for (UIView *view in self.parentViewController.tabBarController.view.subviews) {
        if (view.tag == 100) {
            view.hidden = YES;
        }
    }
    [super viewWillAppear:YES];
}
-(void)createCategorySearchVC
{
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(40, 20, KScreenWidth-40, 44)];
    self.searchBar.delegate = self;
    //self.searchBar.showsCancelButton = YES;
    [self.searchBar setSearchBarStyle:UISearchBarStyleMinimal];
    self.searchBar.tintColor = [UIColor colorWithRed:0.0/255 green:191.0/255 blue:121.0/255 alpha:1.0];
    self.searchBar.placeholder = @"请输入关键字";
    [self.view addSubview:self.searchBar];
    self.backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 25, 40, 35)];
    //[self.backBtn setBackgroundImage:[UIImage imageNamed:@"s1"] forState:UIControlStateNormal];
    //[self.backBtn setTitle:@"<" forState:UIControlStateNormal];
    [self.backBtn setImage:[UIImage imageNamed:@"标题栏-返回按钮v3.png"] forState:UIControlStateNormal];
    //[self.backBtn setImage:[UIImage imageNamed:@"标题栏-返回按钮"]];
    //[self.backBtn setBackgroundImage:[UIImage imageNamed:@"标题栏-返回按钮"] forState:UIControlStateNormal];
    //[self.backBtn setTitleColor:[UIColor colorWithRed:0.0/255 green:191.0/255 blue:121.0/255 alpha:1.0] forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backBtn];
    
    CategorySearchViewController * weakself = self;
    SearchConditionView *conditionView = [[SearchConditionView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, 40)];
    conditionView.aCallBack = ^(int isAsc,UIButton* sender)
    {
        //[weakself initData];
        switch (sender.tag-100) {
            case 1:
            {
                [self.selectView setHidden:YES];
                [self.schoolSelectView setHidden:YES];
                priceAsc = isAsc;
                creditAsc = 2;
                if (priceAsc < 2 ) {
                    
                    [sender setTitleColor:GreenFontColor forState:0];
                }
                
            }
                break;
            case 3:
            {
                [self.selectView setHidden:YES];
                [self.schoolSelectView setHidden:YES];
                priceAsc = 2;
                creditAsc = isAsc;
                if (priceAsc < 2 ) {
                    
                    [sender setTitleColor:GreenFontColor forState:0];
                }
            }
                break;
            default:
                break;
        }
        [self requestList];
        
    };
    
    //点击分类
    conditionView.cCallBack = ^(UIButton*sender)
    {
        if ([self.selectView isHidden]) {
            [self.selectView setHidden:NO];
            [self.schoolSelectView setHidden:YES];
            [self.selectView setFrame:CGRectMake(0, 101, KScreenWidth, KContentViewHasTabBar)];
            [sender setTitleColor:GreenFontColor forState:0];
        }else{
            [sender setTitleColor:lightBlackColor forState:0];
            [self.selectView setHidden:YES];
        }
    };
    
    //点击学校
    conditionView.sCallBack = ^(UIButton*sender)
    {
        if ([self.schoolSelectView isHidden]) {
            [self.schoolSelectView setHidden:NO];
            [self.selectView setHidden:YES];
            [self.schoolSelectView setFrame:CGRectMake(0, 101, KScreenWidth/4, 30)];
            [sender setTitleColor:lightBlackColor forState:0];
        }else
        {
            [sender setTitleColor:lightBlackColor forState:0];
            [self.schoolSelectView setHidden:YES];
        }
    };
    [self.view addSubview:conditionView];
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.goodCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 101, KScreenWidth, KContentViewHasTabBar) collectionViewLayout:flowLayout];
    self.goodCollectionView.dataSource = self;
    self.goodCollectionView.delegate = self;
    self.goodCollectionView.backgroundColor = tableBgColor;
    [self.view addSubview:self.goodCollectionView];
    
    if([self.searchTitle isEqualToString:@""])
    {
        __weak CategorySearchViewController *wSelf = self;
        [self.goodCollectionView addFooterWithCallback:^{

            wSelf.curPage = ++wSelf.curPage;
            if (wSelf.curPage > pageTotal) {
                wSelf.curPage = wSelf.curPage-1;
                [wSelf.goodCollectionView headerEndRefreshing];
                [wSelf.goodCollectionView footerEndRefreshing];

            }else{
                NSLog(@"%d",wSelf.curPage);
                [wSelf requestList];
            }
        
        }];
        
        
        [self.goodCollectionView addHeaderWithCallback:^{
        wSelf.curPage = 1;
        [wSelf requestList];
    }];
    
    }
    
    self.selectView = [[CategorySelectView alloc] initWithFrame:CGRectMake(0, 101, KScreenWidth, KContentViewHasTabBar)];
    self.selectView.cellCallBack = ^(NSMutableDictionary *dic){
        [weakself initData];
        [weakself.selectView setHidden:YES];
        weakself.categoryId = [dic objectForKey:@"id"];
        weakself.curPage = 0;
        [weakself requestList];
    };
    [self.view addSubview:self.selectView];
    [self.selectView setHidden:YES];
    
    self.schoolSelectView = [[SchoolSelectBtnView alloc]initWithFrame:CGRectMake(0, 101, KScreenWidth/4, 30)];
    self.schoolSelectView.BCallBack = ^(int param)
    {
        //[weakself initData];
        for (UIButton *btn in conditionView.subviews) {
            if (btn.tag == 100) {
                if (param == -1) {
                    [btn setTitle:@"外校" forState:0];
                    weakself.isInSchool =[NSString stringWithFormat:@"%d",param];
                    
                }else
                {
                    weakself.isInSchool = @"";
                    [btn setTitle:@"本校" forState:0];
                }
                
            }
        }
        [weakself.schoolSelectView setHidden:YES];
        weakself.curPage = 0;
        [weakself requestList];
    };
    [self.view addSubview:self.schoolSelectView];
    [self.schoolSelectView setHidden:YES];
    
}

- (void)requestList
{
    [ProgressHudCommon showHUDInView:self.view andInfo:@"数据加载中..." andImgName:nil andAutoHide:NO];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [paramDic setValue:self.searchTitle forKey:@"title"];
    if (priceAsc == 2) {
        [paramDic setValue:@"" forKey:@"price"];
    }else
    {
        [paramDic setValue:[NSNumber numberWithBool:priceAsc] forKey:@"price"];
    }
    if (creditAsc == 2) {
        [paramDic setValue:@"" forKey:@"credit"];
    }else
    {
        [paramDic setValue:[NSNumber numberWithBool:creditAsc] forKey:@"credit"];
    }
    [paramDic setValue:self.categoryId forKey:@"categoryId"];
    if ([self.searchTitle isEqualToString:@""]) {
        [paramDic setValue:self.schoolId forKey:@"schoolId"];
    }
    
    [paramDic setValue:self.isInSchool forKey:@"isInSchool"];
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
                    
                    [self.goodCollectionView reloadData];
                }
            }else{
                for (NSDictionary *dict in responseObject[@"data"])
                {
                    
                    [goodsArr addObject:dict];
                }
                pageTotal = [responseObject[@"pagination"][@"pageTotal"]longValue];
                [self.goodCollectionView reloadData];
                
            }
        }
        [ProgressHudCommon hiddenHUD:self.view];
        if ([goodsArr count] == 0) {
            [ProgressHudCommon showHUDInView:self.view andInfo:@"未搜索到相关商品" andImgName:nil andAutoHide:YES];
        }
        [self.goodCollectionView headerEndRefreshing];
        [self.goodCollectionView footerEndRefreshing];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.searchTitle = self.searchBar.text;
    [self requestList];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.searchTitle = @"";
    [self requestList];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [_searchBar resignFirstResponder];
}

- (void)backBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
