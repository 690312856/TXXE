//
//  GoodListViewController.m
//  TXXE
//
//  Created by 李雨龙 on 15/7/19.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "GoodListViewController.h"
#import "GoodListTableViewCell.h"
#import "GoodDetailViewController.h"
#import "CreateGoodViewController.h"
#import "MyCreateGoodModel.h"
#import <MJRefresh.h>
#import <MBProgressHUD.h>
#import "Constants.h"
#import <SDWebImageCompat.h>
#import "SimplifyAlertView.h"

@interface GoodListViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (nonatomic,strong) MyCreateGoodModel *createGoodListFetcher;
@property (nonatomic,strong) NSString *mobilePhone;

@end

@implementation GoodListViewController

- (MyCreateGoodModel *)createGoodListFetcher
{
    if (!_createGoodListFetcher) {
        _createGoodListFetcher = [[MyCreateGoodModel alloc] init];
    }
    return _createGoodListFetcher;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"已发布的商品";
    [self.segment setTintColor:[UIColor colorWithRed:0.0/255 green:191.0/255 blue:121.0/255 alpha:1.0]];
    [self.segment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    self.segment.selectedSegmentIndex = 0;
    [self.tableView registerNib:[UINib nibWithNibName:@"GoodListTableViewCell" bundle:nil] forCellReuseIdentifier:@"kGoodListTableViewCellReuseKey"];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.0/255 green:191.0/255 blue:121.0/255 alpha:1.0];
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
    self.navigationController.navigationBarHidden = NO;
    [self.tableView headerBeginRefreshing];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)segmentAction:(UISegmentedControl *)Seg{
    
    NSInteger Index = Seg.selectedSegmentIndex;
    switch (Index) {
        case 0:
            NSLog(@"%ld",(long)Index);
            [self.tableView headerBeginRefreshing];
            break;
        case 1:
            NSLog(@"%ld",(long)Index);
            [self.tableView headerBeginRefreshing];
            break;
        case 2:
            NSLog(@"%ld",(long)Index);
            [self.tableView headerBeginRefreshing];
            break;
        default:
            break;
    }
}
#pragma mark -
#pragma mark - Inner

- (void)loadMoreData
{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    __weak __typeof(self)weakSelf = self;
    [self.createGoodListFetcher loadMoreCreatedGoodListWithCompletionHandler:^(NSError *error, NSArray *goodList) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (error) {
            
        }else
        {
            dispatch_main_async_safe(^(){
                [strongSelf.tableView reloadData];
            });
        }
        [strongSelf loadDataEndForFooter:YES];
    }];
    
}

- (void)refreshData
{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    __weak __typeof(self)weakSelf = self;
    
    void (^completionHandler)(NSError *,NSArray *) = ^(NSError *error,NSArray *goodList)
    {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (error) {
            
        }else
        {
            dispatch_main_async_safe(^(){
                [strongSelf.tableView reloadData];
            });
        }
        [strongSelf loadDataEndForFooter:NO];
    };
    NSLog(@"@@@@%ld",(long)self.segment.selectedSegmentIndex);
    if (self.segment.selectedSegmentIndex == 0) {
        [self.createGoodListFetcher refreshCreatedGoodListForOnSalingListWithCompletionHandler:completionHandler];
    }else if (self.segment.selectedSegmentIndex == 1)
    {
        [self.createGoodListFetcher refreshCreatedGoodListForUndercarriageListWithCompletionHandler:completionHandler];
    }else if (self.segment.selectedSegmentIndex == 2)
    {
        [self.createGoodListFetcher refreshCreatedGoodListForSoldListWithCompletionHandler:completionHandler];
    }
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

- (void)changeStatusWithCreateGood:(MyCreateGoodModel *)myCreateGoodModel
{
    NSLog(@"bbbbbb%ld",(long)myCreateGoodModel.currentFetcherStatus.integerValue);
    if(myCreateGoodModel.status.integerValue == 1)
    {
        __weak __typeof(self)weakSelf = self;
        [SimplifyAlertView alertWithTitle:@"" message:@"是否确认下架？" operationResult:^(NSInteger selectedIndex) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (selectedIndex == 0) {
                NSLog(@"66666");

            }else if (selectedIndex == 1)
            {
                [MBProgressHUD showHUDAddedTo:strongSelf.navigationController.view animated:YES];
                [myCreateGoodModel changeStatusWithCompletionHandler:^(NSError *error) {
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
        } cancelButtonTitle:@"取消" otherButtonTitles:@"确认下架", nil];
    }else{
        __weak __typeof(self)weakSelf = self;
        [SimplifyAlertView alertWithTitle:@"" message:@"是否确认上架？" operationResult:^(NSInteger selectedIndex) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (selectedIndex == 0) {
                
            }else if (selectedIndex == 1)
            {
                [MBProgressHUD showHUDAddedTo:strongSelf.navigationController.view animated:YES];
                [myCreateGoodModel changeStatusWithCompletionHandler:^(NSError *error) {
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
        } cancelButtonTitle:@"取消" otherButtonTitles:@"确认上架", nil];
    }
}

- (void)deleteWithCreateGood:(MyCreateGoodModel *)myCreateGoodModel
{
    __weak __typeof(self)weakSelf = self;
    [SimplifyAlertView alertWithTitle:@"" message:@"是否确认删除？" operationResult:^(NSInteger selectedIndex) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (selectedIndex == 0) {
            NSLog(@"66666");
            
        }else if (selectedIndex == 1)
        {
            [MBProgressHUD showHUDAddedTo:strongSelf.navigationController.view animated:YES];
            [myCreateGoodModel deleteWithCompletionHandler:^(NSError *error) {
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
    } cancelButtonTitle:@"取消" otherButtonTitles:@"确认删除", nil];
}
- (void)editWithCreatedGood:(MyCreateGoodModel *)myCreateGoodModel
{
    UINavigationController *nav = [[UIStoryboard storyboardWithName:@"CreateGoodViewController" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
    CreateGoodViewController *createVC = nil;
    if ([nav isKindOfClass:[UINavigationController class]]) {
        createVC = [((UINavigationController *)nav).viewControllers firstObject];
    }
    
    CreateGoodModel *tempModel = [[CreateGoodModel alloc] init];
    tempModel.goodId = myCreateGoodModel.goodId;
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    //    __weak __typeof(CreateGoodModel *)weakSelf = tempModel;
    dispatch_group_t uploadGroup = dispatch_group_create();
    dispatch_group_enter(uploadGroup);
    [tempModel fetchDetailWithCompletionHandler:^(NSError *error) {
        //        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (error) {
            [[[UIAlertView alloc] initWithTitle:nil message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        } else {
            DISPATCH_MAIN(^(){
                //                createVC.createGoodModel = strongSelf;
            });
        }
        dispatch_group_leave(uploadGroup);
        [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
    }];
    
    dispatch_group_notify(uploadGroup, dispatch_get_main_queue(), ^{
        createVC.createGoodModel = tempModel;
        [self presentViewController:nav animated:YES completion:NULL];
    });
}
- (void)confirmSaleWithCreatedGood:(MyCreateGoodModel *)myCreateGoodModel
{
    
    if (myCreateGoodModel.status.integerValue == 1) {
        
        __weak __typeof(self)weakSelf = self;
        

        [SimplifyAlertView alertWithTitle:nil message:@"是否确认售出？" operationResult:^(NSInteger selectedIndex) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (selectedIndex == 0) {
                NSLog(@"取消");
            } else if (selectedIndex == 1) {
                //  MARK:在refreshData里面有移除HUD的代码
                
                //myCreateGoodModel.mobilePhoneForMoney = self.mobilePhone;
                [MBProgressHUD showHUDAddedTo:strongSelf.navigationController.view animated:YES];
                [myCreateGoodModel confirmSaleWithCompletionHandler:^(NSError *error) {
                    if (error) {
                        NSLog(@"confirmSaleWithCompletionHandler.error = %@",error);
                        [MBProgressHUD hideAllHUDsForView:strongSelf.navigationController.view animated:YES];
                    } else {
                        dispatch_main_async_safe(^(){
                            [strongSelf refreshData];
                        });
                    }
                }];
            }
        } cancelButtonTitle:@"取消" otherButtonTitles:@"确认售出", nil];
        
        /*UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"恭喜你！"
                                                        message:@"获得小二赠送的支付宝现金红包！你只需填写买家手机号，我们将通知买家。双方验证交易有效后，即可查收。"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定",nil];
        [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
        UITextField * text1 = [alert textFieldAtIndex:0];
        text1.keyboardType = UIKeyboardTypeNumberPad;
        [alert show];*/
    }
}
#pragma mark -
#pragma mark - UITableViewDelegate & UITableViewDataSource


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.createGoodListFetcher.cachedGoodList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 108.5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kGoodListTableViewCellReuseKey" forIndexPath:indexPath];
    MyCreateGoodModel *tempModel = self.createGoodListFetcher.cachedGoodList[indexPath.section];
    NSLog(@"hahahhahah%@",tempModel.status);
    cell.myCreateGoodModel = tempModel;
    NSLog(@"2333333333%@",cell.myCreateGoodModel.status);
    __weak __typeof(self)weakSelf = self;
    cell.deleteButtonActionBlock = ^(){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf deleteWithCreateGood:tempModel];
    };
    cell.editButtonActionBlock = ^(){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf editWithCreatedGood:tempModel];
    };
    cell.changeStatusActionBlock = ^(){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf changeStatusWithCreateGood:tempModel];
    };
    cell.confirmSaleActionBlock = ^(){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf confirmSaleWithCreatedGood:tempModel];
    };
    return cell;
}

#pragma marks -- UIAlertViewDelegate --
//根据被点击按钮的索引处理点击事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        UITextField *tf=[alertView textFieldAtIndex:0];
        NSString *str = tf.text;
        self.mobilePhone = str;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MyCreateGoodModel *tempModel = self.createGoodListFetcher.cachedGoodList[indexPath.section];
    
    GoodDetailViewController * vc  = [[GoodDetailViewController  alloc] init];
    
    vc.distance = self.distance;
    vc.goodId = tempModel.goodId;
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
