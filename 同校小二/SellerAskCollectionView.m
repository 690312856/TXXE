//
//  SellerAskCollectionView.m
//  TXXE
//
//  Created by 李雨龙 on 15/7/31.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "SellerAskCollectionView.h"
#import "SellerAskTableViewCell.h"
#import "ProgressHudCommon.h"
#import <MJRefresh.h>
#import <SDWebImageCompat.h>
#import <MBProgressHUD.h>
#import "UserModel.h"
#import "NSString+Addition.h"
#import "NetController.h"
#import "BLActionSheet.h"
#import <MessageUI/MessageUI.h>

@interface SellerAskCollectionView()<UITableViewDataSource,UITableViewDelegate,BLActionSheetDelegate,UISearchBarDelegate,MFMessageComposeViewControllerDelegate>
{
    long numOfPicture;
}
@property (nonatomic,strong)MyCreateAskModel *myCreateAsksFetcher;
@end
@implementation SellerAskCollectionView


- (MyCreateAskModel *)myCreateAsksFetcher
{
    if (!_myCreateAsksFetcher) {
        _myCreateAsksFetcher = [[MyCreateAskModel alloc]init];
    }
    return _myCreateAsksFetcher;
}
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style withMemberId:(NSString *)memberId
{
    self = [super initWithFrame:frame style:style];
    self.backgroundColor = self.backgroundColor = [UIColor colorWithRed:230.0/255 green:230.0/255 blue:230.0/255 alpha:1];    self.showsVerticalScrollIndicator = NO;
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
        [self registerClass:[SellerAskTableViewCell class] forCellReuseIdentifier:@"kSellerAskTableViewCellReusedKey"];
        self.delegate = self;
        self.dataSource = self;
    }
    
    _myCreateAsksFetcher = [[MyCreateAskModel alloc]init];
    _myCreateAsksFetcher.memberId = self.memberId;
    [self refreshData];
    
    return self;
}

#pragma mark -
#pragma mark - Inner

- (void)loadMoreData
{
    //[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    __weak __typeof(self)weakSelf = self;
    [self.myCreateAsksFetcher loadMoreAskListWithCompletionHandler:^(NSError *error, NSArray *askList) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (error) {
            
        }else
        {
            dispatch_main_async_safe(^(){
                [strongSelf reloadData];
            });
        }
        [strongSelf loadDataEndForFooter:NO];
    }];
}

- (void)refreshData
{
    __weak __typeof(self)weakSelf = self;
    [self.myCreateAsksFetcher refreshAskListWithCompletionHandler:^(NSError *error, NSArray *myGoodList) {
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
        [MBProgressHUD hideAllHUDsForView:[strongSelf getCurrentVC].navigationController.view animated:YES];
        if (isFooter) {
            [strongSelf footerEndRefreshing];
        }else{
            [strongSelf headerEndRefreshing];
        }
    });
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.myCreateAsksFetcher.cachedAskList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (numOfPicture > 6) {
        return 400;
    }else if (numOfPicture > 3 && numOfPicture <= 6)
    {
        return 320;
    }else
    {
        return 240;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"kSellerAskTableViewCellReusedKey";
    SellerAskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
    MyCreateAskModel *tempModel = self.myCreateAsksFetcher.cachedAskList[indexPath.row];
    numOfPicture = tempModel.imageUrlTexts.count;
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",numOfPicture],@"num",nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"numOfPicture" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    cell.myCreateAskModel = tempModel;
    
    __weak __typeof(self)weakSelf = self;
    cell.collectionButtonActionBlock = ^(){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf collectionWithAsk:tempModel];
    };
    cell.contactButtonActionBlock = ^(){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf contactWithAsk:tempModel];
    };
    return cell;
    
}



- (void)requestisisFavorited:(NSString *)askGoodId
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic setValue:askGoodId forKey:@"id"];
    [dic setValue:[NSString realForString:[UserModel currentUser].memberId] forKey:@"memberId"];
    
    [[NetController sharedInstance]postWithAPI:API_ask_JsonDetail parameters:dic completionHandler:^(id responseObject, NSError *error) {
        NSMutableDictionary *backDic = responseObject[@"data"];
        
        if ([[NSString realForString:[backDic objectForKey:@"isFavorited"]]isEqualToString:@"1"]) {
            self.isFavorited = YES;
        }else
        {
            self.isFavorited = NO;
        }
    }];
}
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

- (void)collectionWithAsk:(MyCreateAskModel *)myCreateAskModel
{
    if (![UserModel currentUser].isCurrentUserValid) {
        [[UserModel currentUser]operationAuthorizeWithCompletionHandler:^(BOOL isValidUser) {
            if (isValidUser) {
                [self requestisisFavorited:myCreateAskModel.askId];
            }
        }];
        return;
    }
    
    if (self.isFavorited) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
        [dic setValue:[NSString realForString:[UserModel currentUser].memberId] forKey:@"memberId"];
        [dic setValue:@"2" forKey:@"favoriteType"];
        [dic setValue:myCreateAskModel.askId forKey:@"assocId"];
        //////////////////API_favorite_remove
        [[NetController sharedInstance] postWithAPI:API_favorite_remove parameters:dic completionHandler:^(id responseObject, NSError *error) {
            if (error) {
                [ProgressHudCommon showHudAndHide:[self getCurrentVC].view andNotice:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
                NSLog(@"NSLocalizedDescription");
            }else
            {
                self.isFavorited = NO;
                [ProgressHudCommon showHudAndHide:[self getCurrentVC].view andNotice:@"取消收藏成功"];
                NSLog(@"取消收藏成功");
            }
        }];
    }else
    {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
        [dic setValue:[NSString realForString:[UserModel currentUser].memberId] forKey:@"memberId"];
        [dic setValue:@"2" forKey:@"favoriteType"];
        [dic setValue:myCreateAskModel.askId forKey:@"assocId"];
        ///////////API_favorite_add
        [[NetController sharedInstance] postWithAPI:API_favorite_add parameters:dic completionHandler:^(id responseObject, NSError *error) {
            if (error) {
                [ProgressHudCommon showHudAndHide:[self getCurrentVC].view andNotice:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
                NSLog(@"NSLocalizedDescription2");
            }
            else
            {
                self.isFavorited = YES;
                [ProgressHudCommon showHudAndHide:[self getCurrentVC].view andNotice:@"收藏成功"];
                NSLog(@"收藏成功");
            }
        }];
    }

}

- (void)contactWithAsk:(MyCreateAskModel *)myCreateAskModel
{
    BLActionSheet *sheet = [[BLActionSheet alloc]initWithFrame:CGRectZero andTitles:[NSArray arrayWithObjects:@"QQ",@"电话",@"短信", nil]];
    self.AskModel = myCreateAskModel;
    sheet.delegate = self;
    [sheet showInView:[self getCurrentVC].view];
}

-(void)actionBLSheet:(BLActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
            //联系QQ
        case 0:
        {
            NSString * qqUrlStr = [NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",[NSString realForString:self.AskModel.qq]];
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:qqUrlStr]]) {
                UIWebView *qqWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
                NSURL *url = [NSURL URLWithString:qqUrlStr];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                // webView.delegate = self;
                [qqWebView loadRequest:request];
                [[self getCurrentVC].view addSubview:qqWebView];
            }
            
            else{
                
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请安装QQ客户端" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
            }
        }
            break;
            // 拨打手机
        case 1:
        {
            
            //NSLog(@"44444444%@",self.userModel.mobileNumber);
            if ([self.AskModel.mobile isMobilePhoneNumber] == YES&&(![[NSString realForString:self.AskModel.mobile] isEqualToString:@""])) {
                NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.AskModel.mobile];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            }
            else
            {
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无效手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
                
            }
            
        }
            break;
            // 短信
        case 2:
        {
            MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
            
            if([MFMessageComposeViewController canSendText])
            {
                
                controller.recipients  = [NSArray arrayWithObject:[NSString realForString:self.AskModel.mobile]];
                controller.messageComposeDelegate = self;
                [[self getCurrentVC] presentViewController:controller animated:YES completion:^(){
                    
                    
                }];
                
            }
        }
            break;
        default:
            break;
    }
}







/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



@end
