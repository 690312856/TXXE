//
//  DiscoveryViewController.m
//  TXXE
//
//  Created by River on 15/6/6.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "DiscoveryViewController.h"
#import "DiscoveryPageHeaderView.h"
#import "DiscoveryPageHeadModel.h"
#import "CategorySearchViewController.h"
#import "UserModel.h"
#import "Constants.h"
#import <MBProgressHUD.h>
#import "NetController.h"
#import "UIView+Addition.h"
#import "SchoolSelectViewController.h"
#import "GoodDetailViewController.h"
#import "DiscoverHeaderScrollView.h"
#import "ActivityDetailViewController.h"


@interface DiscoveryViewController ()<DiscoverHeaderScrollViewDelegate,UIScrollViewDelegate>
//活动
@property (nonatomic,strong)DiscoverHeaderScrollView *scroll;
@property (nonatomic,strong)NSMutableArray *functions;

@end

@implementation DiscoveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.num = 0;
    
    //self.title = @"发现";
    UIButton *leftBarItemButton = [[[NSBundle mainBundle] loadNibNamed:@"HomePageWidgets" owner:self options:nil] firstObject];
    [leftBarItemButton addTarget:self action:@selector(leftBarButtonItemAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarItemButton];
    
    self.searchBar.delegate = self;
    self.searchBar.tintColor = [UIColor colorWithRed:0.0/255 green:191.0/255 blue:121.0/255 alpha:1.0];
    self.searchBar.placeholder = @"搜索小二";
    [self.view addSubview:self.searchBar];
    
    ////////////////////////////////////////////
    /*NSArray *buttonNames = [NSArray arrayWithObjects:@"商品分类", @"发现好货", nil];
    self.segment = [[UISegmentedControl alloc] initWithItems:buttonNames];
    [self.segment setTintColor:[UIColor colorWithRed:0.0/255 green:191.0/255 blue:121.0/255 alpha:1.0]];
    UIScreen *s = [UIScreen mainScreen];
    CGFloat width = [s bounds].size.width;
    CGFloat height = [s bounds].size.height;
    [self.segment setFrame:CGRectMake(width/2.0-80, height/2.0-95+40, 160, 30)];
    [self.segment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    self.segment.selectedSegmentIndex = 0;
    [self.view addSubview:self.segment];*/
    /////////////////////////////////////////////
    UIScreen *s = [UIScreen mainScreen];
    CGFloat width = [s bounds].size.width;
    CGFloat height = [s bounds].size.height;
    
    
    self.greenDiscover = [[UIView alloc] initWithFrame:CGRectMake(width/2.0, height/2.0-45+40, width/2.0, 1)];
    [self.greenDiscover setBackgroundColor:[UIColor colorWithRed:0.0/255 green:191.0/255 blue:121.0/255 alpha:1.0]];
    self.greenDiscover.hidden = YES;
    [self.view addSubview:self.greenDiscover];
    
    self.greenCategory = [[UIView alloc] initWithFrame:CGRectMake(0, height/2.0-45+40, width/2.0, 1)];
    [self.greenCategory setBackgroundColor:[UIColor colorWithRed:0.0/255 green:191.0/255 blue:121.0/255 alpha:1.0]];
    [self.view addSubview:self.greenCategory];
    
    self.categoryBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, height/2.0-90+40, width/2.0, 45)];
    [self.categoryBtn setTitle:@"商品分类" forState:UIControlStateNormal];
    [self.categoryBtn setTitleColor:[UIColor colorWithRed:0.0/255 green:191.0/255 blue:121.0/255 alpha:1.0] forState:UIControlStateNormal];
    [self.categoryBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [self.categoryBtn setBackgroundColor:[UIColor whiteColor]];
    [self.categoryBtn addTarget:self action:@selector(categoryBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.discoverBtn = [[UIButton alloc] initWithFrame:CGRectMake(width/2.0, height/2.0-90+40, width/2.0, 45)];
    [self.discoverBtn setTitle:@"发现好货" forState:UIControlStateNormal];
    [self.discoverBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.discoverBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [self.discoverBtn setBackgroundColor:[UIColor whiteColor]];
    [self.discoverBtn addTarget:self action:@selector(discoverBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.categoryBtn];
    [self.view addSubview:self.discoverBtn];
    [self performSelector:@selector(initialShow) withObject:nil afterDelay:0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tiaozhuanaction:) name:@"tiaozhuan" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tanxiajianpan:) name:@"tanxiajianpan" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.num = 0;
    self.navigationController.navigationBarHidden = YES;
    for (UIView *view in self.parentViewController.tabBarController.view.subviews) {
        if (view.tag == 100) {
            view.hidden = NO;
        }
    }
    if (![UserModel currentUser].currentSelectSchool) {
        [self goSelectSchool];
    } else {
        [self finishedPickingSchoolWithModel:[UserModel currentUser].currentSelectSchool];
    }
    
}

- (void)initialShow
{
    [self loadCategoryView];
}

- (void)loadCategoryView
{
    UIScreen *s = [UIScreen mainScreen];
    CGFloat width = [s bounds].size.width;
    CGFloat height = [s bounds].size.height;
    __weak typeof(self) weakSelf = self;
    self.categoryView = [[CategoryView alloc]initWithFrame:CGRectMake(0, height/2.0-44+40, width, height/2.0+44-40)];
    
    self.categoryView.categorySearchCallBack = ^(id sender){
        CategorySearchViewController *vc = [[CategorySearchViewController alloc]init];
        NSLog(@"%ld",(long)[sender tag]);
        switch ((long)[sender tag]) {
            case 1:
                vc.categoryId = [NSString stringWithFormat:@"%d",5];
                [weakSelf.navigationController pushViewController:vc animated:YES];
                break;
            case 2:
                vc.categoryId = [NSString stringWithFormat:@"%d",4];
                [weakSelf.navigationController pushViewController:vc animated:YES];
                break;
            case 3:
                vc.categoryId = [NSString stringWithFormat:@"%d",7];
                [weakSelf.navigationController pushViewController:vc animated:YES];
                break;
            case 4:
                vc.categoryId = [NSString stringWithFormat:@"%d",2];
                [weakSelf.navigationController pushViewController:vc animated:YES];
                break;
            case 5:
                vc.categoryId = [NSString stringWithFormat:@"%d",38];
                [weakSelf.navigationController pushViewController:vc animated:YES];
                break;
            case 6:
                vc.categoryId = [NSString stringWithFormat:@"%d",13];
                [weakSelf.navigationController pushViewController:vc animated:YES];
                break;
            default:
                break;
        }
        
    };
    [self.view addSubview:self.categoryView];

}
- (void)loadDiscoveryView
{
    UIScreen *s = [UIScreen mainScreen];
    CGFloat width = [s bounds].size.width;
    CGFloat height = [s bounds].size.height;
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    self.collectionView = [[DiscoveryGoodColletionView alloc]initWithFrame:CGRectMake(0, height/2.0-44+40, width, height/2.0+44-40) collectionViewLayout:flowLayout];
    [self.view addSubview:self.collectionView];

}
/////////////////////////////////////////////////
-(void)segmentAction:(UISegmentedControl *)Seg{
    
    NSInteger Index = Seg.selectedSegmentIndex;
    NSLog(@"Index %li", (long)Index);
    switch (Index) {
        case 0:
            self.collectionView.hidden = YES;
            [self loadCategoryView];
            break;
        case 1:
            self.categoryView.hidden = YES;
            [self loadDiscoveryView];
            break;
        default:
            break;
    }
}
/////////////////////////////////////////////////
- (void)categoryBtnAction
{
    [self.searchBar resignFirstResponder];
    self.collectionView.hidden = YES;
    self.greenDiscover.hidden = YES;
    self.categoryView.hidden = NO;
    self.greenCategory.hidden = NO;
    [self.categoryBtn setTitleColor:[UIColor colorWithRed:0.0/255 green:191.0/255 blue:121.0/255 alpha:1.0] forState:UIControlStateNormal];
    [self.discoverBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self loadCategoryView];
}

- (void)discoverBtnAction
{
    [self.searchBar resignFirstResponder];
    self.collectionView.hidden = NO;
    self.greenDiscover.hidden = NO;
    self.categoryView.hidden = YES;
    self.greenCategory.hidden = YES;
    [self.categoryBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.discoverBtn setTitleColor:[UIColor colorWithRed:0.0/255 green:191.0/255 blue:121.0/255 alpha:1.0]forState:UIControlStateNormal];
    [self loadDiscoveryView];

}
- (void)finishedPickingSchoolWithModel:(SchoolModel *)pickedModel
{
    if ([pickedModel isEqual:[UserModel currentUser].currentSelectSchool]) {
        if (self.functions.count == 0) {
            [self loadHomePageGoodListForSchool:pickedModel];
        }
    } else {
        [UserModel currentUser].currentSelectSchool = pickedModel;
        [self loadHomePageGoodListForSchool:pickedModel];
    }
}

- (void)loadHomePageGoodListForSchool:(SchoolModel *)tempModel
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dict setValue:tempModel.schoolID forKey:@"schoolId"];
    [[NetController sharedInstance] postWithAPI:API_function_list parameters:dict completionHandler:^(id responseObject, NSError *error) {
        if (error) {
        }else{
            NSMutableArray *functions = [NSMutableArray array];
            for (NSDictionary *dict in responseObject[@"data"])
            {
                [functions addObject:dict];
            }
                self.functions = functions;
                UIScreen *s = [UIScreen mainScreen];
                CGFloat width = [s bounds].size.width;
                CGFloat height = [s bounds].size.height;

                self.scroll = [[DiscoverHeaderScrollView alloc]initPageViewWithFrame:CGRectMake(0, 65, width, height/2.0-128) views:self.functions];
                UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 64, width, 0.5)];
            view1.backgroundColor = [UIColor colorWithRed:200.0/255 green:199.0/255 blue:204.0/255 alpha:1.0];
                UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, height/2.0-63, width, 0.5)];
            view2.backgroundColor = [UIColor colorWithRed:200.0/255 green:199.0/255 blue:204.0/255 alpha:1.0];
                self.scroll.pageViewDelegate = self;
                [self.view addSubview:view1];
                [self.view addSubview:view2];
                [self.view addSubview:self.scroll];
            
            }
    }];
    
}



- (void)leftBarButtonItemAction
{
    [self goSelectSchool];
}

- (void)goSelectSchool
{
    SchoolSelectViewController *schoolSelectVC = [[SchoolSelectViewController alloc] init];
    schoolSelectVC.shouldCacheSelection = YES;
    __weak __typeof(self)weakSelf = self;
    schoolSelectVC.finishedSchoolPickBlock = ^(SchoolModel *pickedSchool){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf finishedPickingSchoolWithModel:pickedSchool];
        if (self.segment.selectedSegmentIndex == 1) {
            [self.collectionView refresData];
            [self.collectionView reloadData];
        }
        //self.navigationItem.title = [UserModel currentUser].currentSelectSchool.schoolName;
    };
    //schoolSelectVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:schoolSelectVC animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    CategorySearchViewController * vc = [[CategorySearchViewController alloc]init];
    vc.searchTitle = [NSString realForString:_searchBar.text];
    
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [_searchBar resignFirstResponder];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.searchBar resignFirstResponder];
}

- (void)tiaozhuanaction:(NSNotification *)text
{
    GoodDetailViewController *vc = [[GoodDetailViewController alloc]init];
    vc.goodId = text.userInfo[@"goodId"];
    for (UIView *view in self.parentViewController.tabBarController.view.subviews) {
        if (view.tag == 100) {
            view.hidden = YES;
        }
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tanxiajianpan:(NSNotification *)text
{
    [self.searchBar resignFirstResponder];
}

#pragma mark --- FFScrollView delegate method
- (void)scrollViewDidClickedAtPage:(NSInteger)pageNumber
{
    /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"点击了第%ld个view",(long)pageNumber]
                                                    message:nil
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil, nil];
    
    [alert show];*/
    ActivityDetailViewController *vc = [[ActivityDetailViewController alloc]init];
    vc.activityUrl = [[self.functions objectAtIndex:pageNumber][@"url"] stringValue];
    NSLog(@"string%@",vc.activityUrl);
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)schoolSelectAction:(id)sender {
    NSLog(@"555555");
    [self goSelectSchool];
}


- (void) showScrollView
{
    UIScrollView *_scrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width*4, [UIScreen mainScreen].bounds.size.height);
    _scrollView.tag = 500;
    
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    
    for (int i = 0; i < 4; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * i, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"D%d",i+1]];
        imageView.image = image;
        [_scrollView addSubview:imageView];
    }
    
    UIPageControl *pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(140, self.view.frame.size.height - 60, 50, 40)];
    pageControl.numberOfPages = 4;
    pageControl.tag = 501;
    
    [self.view addSubview:_scrollView];
    [self.view addSubview:pageControl];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int current = scrollView.contentOffset.x/[UIScreen mainScreen].bounds.size.width;
    
    UIPageControl *page = (UIPageControl *)[self.view viewWithTag:501];
    page.currentPage = current;
    
    if (page.currentPage == 3) {
        [self scrollViewDisappear];
    }
}

- (void)scrollViewDisappear
{
    UIScrollView *scrollView = (UIScrollView *)[self.view viewWithTag:500];
    UIPageControl *page = (UIPageControl *)[self.view viewWithTag:501];
    
    //设置滑动图消失的动画效果图
    [UIView animateWithDuration:3.0f animations:^{
        
        scrollView.center = CGPointMake(self.view.frame.size.width/2, 1.5 * self.view.frame.size.height);
        
    } completion:^(BOOL finished) {
        
        [scrollView removeFromSuperview];
        [page removeFromSuperview];
    }];
    
    //将滑动图启动过的信息保存到 NSUserDefaults 中，使得第二次不运行滑动图
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"YES" forKey:@"isScrollViewAppear"];
}





















@end
