//
//  AskListViewController.m
//  TXXE
//
//  Created by 李雨龙 on 15/7/24.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "AskListViewController.h"
#import "CreateAskViewController.h"
#import "GoodDetailViewController.h"
#import "MyCreateAskModel.h"
#import "AskListTableViewCell.h"
#import <MJRefresh.h>
#import <MBProgressHUD.h>
#import "Constants.h"
#import <SDWebImageCompat.h>
#import "SimplifyAlertView.h"
#import "ImageListView.h"

////////////
#import "ImageScrollView.h"

@interface AskListViewController ()<UITableViewDataSource,UITableViewDelegate,ImageScrollViewDelegate,UIScrollViewDelegate>
//////////////

{
    long numOfPicture;
    
    ImageListView *listOfImage;
    NSInteger currentIndex;
    UIView *markView;
    UIView *scrollPanel;
    UIScrollView *myScrollView;
    
}
@property (nonatomic,strong) MyCreateAskModel *createAskListFetcher;
@property (nonatomic,strong) NSString *mobilePhone;
@end

@implementation AskListViewController

- (MyCreateAskModel *)createAskListFetcher
{
    if (!_createAskListFetcher) {
        _createAskListFetcher = [[MyCreateAskModel alloc]init];
    }
    return _createAskListFetcher;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"已发布的求购";
    [self.segment setTintColor:[UIColor colorWithRed:0.0/255 green:191.0/255 blue:121.0/255 alpha:1.0]];
    [self.segment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    self.segment.selectedSegmentIndex = 0;
    [self.tableView registerClass:[AskListTableViewCell class] forCellReuseIdentifier:@"kAskListTableViewCellReusedKey"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageTag:) name:@"imageTag" object:nil];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.0/255 green:191.0/255 blue:121.0/255 alpha:1.0];
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

- (void)segmentAction:(UISegmentedControl *)Seg
{
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
    [self.createAskListFetcher loadMoreCreatedAskListWithCompletionHandler:^(NSError *error, NSArray *askList) {
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
    
    if (self.segment.selectedSegmentIndex == 0) {
        [self.createAskListFetcher refreshCreatedAskListForPurchasingListWithCompletionHandler:completionHandler];
    }else if (self.segment.selectedSegmentIndex == 1)
    {
        [self.createAskListFetcher refreshCreatedAskListForSuspendedListWithCompletionHandler:completionHandler];
    }else if (self.segment.selectedSegmentIndex == 2)
    {
        [self.createAskListFetcher refreshCreatedAskListForBoughtListWithCompletionHandler:completionHandler];
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
        }else{
            [strongSelf.tableView headerEndRefreshing];
        }
    });
}

- (void)changeStatusWithCreateAsk:(MyCreateAskModel *)myCreateAskModel
{
    if(myCreateAskModel.status.integerValue == 1)
    {
        __weak __typeof(self)weakSelf = self;
        [SimplifyAlertView alertWithTitle:@"" message:@"是否确认中止？" operationResult:^(NSInteger selectedIndex) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (selectedIndex == 0) {
                NSLog(@"66666");
                
            }else if (selectedIndex == 1)
            {
                [MBProgressHUD showHUDAddedTo:strongSelf.navigationController.view animated:YES];
                [myCreateAskModel changeStatusWithCompletionHandler:^(NSError *error) {
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
        } cancelButtonTitle:@"取消" otherButtonTitles:@"确认中止", nil];
    }else{
        __weak __typeof(self)weakSelf = self;
        [SimplifyAlertView alertWithTitle:@"" message:@"是否确认继续求购？" operationResult:^(NSInteger selectedIndex) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (selectedIndex == 0) {
                
            }else if (selectedIndex == 1)
            {
                [MBProgressHUD showHUDAddedTo:strongSelf.navigationController.view animated:YES];
                [myCreateAskModel changeStatusWithCompletionHandler:^(NSError *error) {
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
        } cancelButtonTitle:@"取消" otherButtonTitles:@"确认继续求购", nil];
    }
}

- (void)deleteWithCreateAsk:(MyCreateAskModel *)myCreateAskModel
{
    __weak __typeof(self)weakSelf = self;
    [SimplifyAlertView alertWithTitle:@"" message:@"是否确认删除？" operationResult:^(NSInteger selectedIndex) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (selectedIndex == 0) {
            NSLog(@"66666");
            
        }else if (selectedIndex == 1)
        {
            [MBProgressHUD showHUDAddedTo:strongSelf.navigationController.view animated:YES];
            [myCreateAskModel deleteWithCompletionHandler:^(NSError *error) {
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

- (void)editWithCreatedAsk:(MyCreateAskModel *)myCreateAskModel
{
    UINavigationController *nav = [[UIStoryboard storyboardWithName:@"CreateAskViewController" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
    CreateAskViewController *createVC = nil;
    if ([nav isKindOfClass:[UINavigationController class]]) {
        createVC = [((UINavigationController *)nav).viewControllers firstObject];
    }
    
    CreateAskModel *tempModel = [[CreateAskModel alloc] init];
    tempModel.askId = myCreateAskModel.askId;
    
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
        createVC.createAskModel = tempModel;
        [self presentViewController:nav animated:YES completion:NULL];
    });
}
- (void)confirmSaleWithCreatedAsk:(MyCreateAskModel *)myCreateAskModel
{
    
    if (myCreateAskModel.status.integerValue == 1) {
        
        __weak __typeof(self)weakSelf = self;
        
        
        [SimplifyAlertView alertWithTitle:nil message:@"是否确认已买到？" operationResult:^(NSInteger selectedIndex) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (selectedIndex == 0) {
                NSLog(@"取消");
            } else if (selectedIndex == 1) {
                //  MARK:在refreshData里面有移除HUD的代码
                
                //myCreateAskModel.mobilePhoneForMoney = self.mobilePhone;
                [MBProgressHUD showHUDAddedTo:strongSelf.navigationController.view animated:YES];
                [myCreateAskModel confirmSaleWithCompletionHandler:^(NSError *error) {
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
        } cancelButtonTitle:@"取消" otherButtonTitles:@"确认买到", nil];
        
       /* UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"恭喜你！"
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.createAskListFetcher.cachedAskList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (numOfPicture > 6) {
        return 400;
    }else if (numOfPicture > 3 && numOfPicture <= 6)
    {
        return 315;
    }else if (numOfPicture >1 && numOfPicture<=3)
    {
        return 230;
    }else if (numOfPicture == 1)
    {
        return 240;
    }else
    {
        return 145;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AskListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kAskListTableViewCellReusedKey" forIndexPath:indexPath];
    MyCreateAskModel *tempModel = self.createAskListFetcher.cachedAskList[indexPath.row];
    numOfPicture = tempModel.imageUrlTexts.count;
    cell.myCreateAskModel =tempModel;
    
    __weak __typeof(self)weakSelf = self;
    cell.deleteButtonActionBlock = ^(){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf deleteWithCreateAsk:tempModel];
    };
    cell.editButtonActionBlock = ^(){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf editWithCreatedAsk:tempModel];
    };
    cell.changeStatusActionBlock = ^(){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf changeStatusWithCreateAsk:tempModel];
    };
    cell.confirmBoughtActionBlock = ^(){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf confirmSaleWithCreatedAsk:tempModel];
    };

    return cell;
}

/*- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MyCreateAskModel *tempModel = self.createAskListFetcher.cachedAskList[indexPath.row];
    
}*/



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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)imageTag:(NSNotification *)text
{
    [self.view bringSubviewToFront:scrollPanel];
    scrollPanel.alpha = 1.0;
    
    UIImageView *tmpView = text.userInfo[@"imgView"];
    NSLog(@"!!!!!%f",tmpView.frame.size.width);
    NSLog(@"?????%f",tmpView.frame.size.height);
    currentIndex = [text.userInfo[@"imgViewTag"] integerValue]-10;
     NSArray *imglist = text.userInfo[@"imgList"];
    listOfImage = text.userInfo[@"imageListView"];
    
    CGSize contentSize = myScrollView.contentSize;
    contentSize.height = self.view.bounds.size.height;
    contentSize.width = self.view.bounds.size.width * imglist.count;
    myScrollView.contentSize = contentSize;
    
    
    NSLog(@"!!!!!rrr%f",self.view.frame.size.width);
    NSLog(@"?????rrr%f",self.view.frame.size.height);
    //转换后的rect
    CGRect convertRect = [[tmpView superview] convertRect:tmpView.frame toView:self.view];
    CGPoint contentOffset = myScrollView.contentOffset;
    NSLog(@"nnnnnnnnnnn%fnnnnnnn%f",contentOffset.x,contentOffset.y);
    contentOffset.x = currentIndex*self.view.frame.size.width;
    NSLog(@"nnnnnnnnnnn%f",self.view.frame.size.width);
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
        NSLog(@"44444%f",myScrollView.bounds.size.width);
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
