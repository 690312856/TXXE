//
//  SellerAskTableView.m
//  TXXE
//
//  Created by 李雨龙 on 15/8/1.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "SellerAskTableView.h"
#import "CommentTableViewCell.h"
#import "ProgressHudCommon.h"
#import "NetController.h"
#import <MJRefresh.h>
#import "UserModel.h"
#import "NSString+Addition.h"
#import "GoodReportVC.h"

@implementation SellerAskTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style withMemberId:(NSString *)memberId withAskId:(NSString *)askId
{
    self = [super initWithFrame:frame style:style];
    self.backgroundColor = self.backgroundColor = [UIColor colorWithRed:230.0/255 green:230.0/255 blue:230.0/255 alpha:1];    self.showsVerticalScrollIndicator = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chongxinloadViewaction:) name:@"chongxinloadView" object:nil];
    self.memberId = memberId;
    self.askId = askId;
    self.curPage = 0;
    isopen = NO;
    
    __weak __typeof(self)weakSelf = self;
    [self addFooterWithCallback:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.curPage = ++strongSelf.curPage;
        if (strongSelf.curPage > pageTotal) {
            strongSelf.curPage = strongSelf.curPage-1;
        }
        [strongSelf requestData];
    }];
    
    [self addHeaderWithCallback:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.curPage = 0;
        [strongSelf requestData];
    }];
    
    if (self) {
        [self registerNib:[UINib nibWithNibName:@"CommentTableViewCell" bundle:nil] forCellReuseIdentifier:@"kCommentTableViewCellReusedKey"];
        self.delegate = self;
        self.dataSource = self;
    }

    [self requestData];
    return self;
}


#pragma mark -
#pragma mark - Inner

- (void)requestData
{
    [ProgressHudCommon showHUDInView:[self getCurrentVC].view andInfo:@"数据加载中..." andImgName:nil andAutoHide:NO];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [paramDic setValue:@(self.curPage) forKey:@"page"];
    [paramDic setValue:@(20) forKey:@"pageSize"];
    [paramDic setValue:self.memberId forKey:@"memberId"];
    NSLog(@"nnnnn%@",self.askId);
    [paramDic setValue:self.askId forKey:@"goodsInNeedId"];
    [paramDic setValue:@(1) forKey:@"status"];


    [[NetController sharedInstance]postWithAPI:API_ask_my_ask parameters:paramDic completionHandler:^(id responseObject, NSError *error) {
        if (error)
        {
            if (self.curPage <= 0) {
            }else
            {
                self.curPage = self.curPage - 1;
            }
        }else
        {
            if (self.curPage <= 1) {
                
                if (responseObject[@"pagination"] && ![responseObject[@"pagination"] isKindOfClass:[NSNull class]]) {
                    AsksArr = [[NSMutableArray alloc] init];
                    for (NSDictionary *dict in responseObject[@"data"])
                    {   NSMutableDictionary *temp = [[NSMutableDictionary alloc] initWithDictionary:dict];
                        [temp setValue:@(0) forKey:@"isOpen"];
                        NSLog(@"ttttttttttt%@",temp);
                        [AsksArr addObject:temp];
                    }

                    [self reloadData];                }
                
            }else{
                for (NSDictionary *dict in responseObject[@"data"])
                {
                    NSMutableDictionary *temp = [[NSMutableDictionary alloc] initWithDictionary:dict];
                    [temp setValue:@(0) forKey:@"isOpen"];
                    NSLog(@"ttttttttttt%@",temp);
                    [AsksArr addObject:temp];
                }
                pageTotal = [responseObject[@"pagination"][@"pageTotal"]longValue];
                [self reloadData];
            }
        }
        [ProgressHudCommon hiddenHUD:[self getCurrentVC].view];
        [self headerEndRefreshing];
        [self footerEndRefreshing];
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"8888888%lu",(unsigned long)[AsksArr count]);
    return [AsksArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"999999%@",[AsksArr[section] objectForKey:@"isOpen"]);
    if ([[AsksArr[section] objectForKey:@"isOpen"] boolValue] == YES) {
        if (section == curNum) {
            return [[AsksArr[section] objectForKey:@"reviews"] count];
        }else{
            return 0;
        }
    }else
    {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([[AsksArr[section] objectForKey:@"images"] count] > 6) {
        return 388.5;
    }else if ([[AsksArr[section] objectForKey:@"images"] count] > 3 && [[AsksArr[section] objectForKey:@"images"] count] <= 6)
    {
        return 303.5;
    }else if([[AsksArr[section] objectForKey:@"images"] count] > 1 && [[AsksArr[section] objectForKey:@"images"] count] <= 3)
    {
        return 218.5;
    }else if([[AsksArr[section] objectForKey:@"images"] count] == 1 )
    {
        return 228.5;
    }else
    {
        return 128.5;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([[AsksArr[section] objectForKey:@"images"] count] == 0) {
        self.head = [[SellerAskTableHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 150)];
    }else if ([[AsksArr[section] objectForKey:@"images"] count] == 1) {
        self.head = [[SellerAskTableHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 250)];
    }else if([[AsksArr[section] objectForKey:@"images"] count] > 1 && [[AsksArr[section] objectForKey:@"images"] count] <= 3)
    {
        self.head = [[SellerAskTableHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 240)];
    }else if([[AsksArr[section] objectForKey:@"images"] count] > 3 && [[AsksArr[section] objectForKey:@"images"] count] <= 6)
    {
        self.head = [[SellerAskTableHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 320)];
    }else if([[AsksArr[section] objectForKey:@"images"] count] > 6)
    {
        self.head = [[SellerAskTableHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 400)];
    }
    
    __weak __typeof(self)weakSelf = self;
    
    weakSelf.head.repoClickBlock = ^(UIButton *sender,NSString *askGoodId){
        if (![UserModel currentUser].isCurrentUserValid) {
            [[UserModel currentUser]operationAuthorizeWithCompletionHandler:^(BOOL isValidUser) {
                if (isValidUser) {
                    
                }
            }];
            return ;
        }
        
        GoodReportVC * vc = [[GoodReportVC alloc] init];
        vc.reportCallBack  = ^(NSString * str){
            NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:0];
            [dic setValue:[NSString realForString:[UserModel currentUser].memberId] forKey:@"memberId"];
            [dic setValue:askGoodId forKey:@"goodsInNeedId"];
            [dic setValue:str forKey:@"reason"];
            
            [[NetController sharedInstance] postWithAPI:API_ask_report parameters:dic completionHandler:^(id responseObject, NSError *error){
                if (error) {
                    [ProgressHudCommon showHudAndHide:[self getCurrentVC].view andNotice:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
                }else
                {
                    [ProgressHudCommon showHudAndHide:[self getCurrentVC].view andNotice:@"举报成功"];
                    [self reloadData];
                }
                
            }];
        };
        [[self viewController].navigationController pushViewController:vc animated:YES];
    };
    

    weakSelf.head.commClickBlock = ^(UIButton *sender)
    {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [AsksArr[section] setValue:@(![[AsksArr[section] objectForKey:@"isOpen"] boolValue]) forKey:@"isOpen"];
        NSLog(@"6666666%@",[AsksArr[section] objectForKey:@"isOpen"]);
        curNum = section;
        [strongSelf reloadData];
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:curNum];
        [strongSelf reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        strongSelf.currAskGoodId = [AsksArr objectAtIndex:section][@"id"];
        if ([[AsksArr[section] objectForKey:@"isOpen"] boolValue] == YES) {
            
            NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:strongSelf.currAskGoodId,@"textOne", nil];
            NSNotification *notification =[NSNotification notificationWithName:@"feichushurukuang" object:nil userInfo:dict];
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }
    };
    
    weakSelf.head.collClickBlock = ^(UIButton *sender,NSString *askGoodId)
    {
        if (![UserModel currentUser].isCurrentUserValid) {
            [[UserModel currentUser]operationAuthorizeWithCompletionHandler:^(BOOL isValidUser) {
                if (isValidUser) {
                    [self requestisisFavorited:askGoodId];
                }
            }];
            return;
        }
        
        if (self.isFavorited) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
            [dic setValue:[NSString realForString:[UserModel currentUser].memberId] forKey:@"memberId"];
            [dic setValue:@"2" forKey:@"favoriteType"];
            [dic setValue:askGoodId forKey:@"assocId"];
            
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
            [dic setValue:askGoodId forKey:@"assocId"];
            
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
    };
    
    weakSelf.head.contClickBlock = ^(UIButton *sender,NSDictionary *AskDic)
    {
        BLActionSheet *sheet = [[BLActionSheet alloc]initWithFrame:CGRectZero andTitles:[NSArray arrayWithObjects:@"QQ",@"电话",@"短信", nil]];
        self.AskDictionary = AskDic;
        sheet.delegate = self;
        [sheet showInView:[self getCurrentVC].view];
    };

    [self.head refreshWithDic:AsksArr[section]];
    return self.head;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kCommentTableViewCellReusedKey" forIndexPath:indexPath];
    //[cell sizeToFit];
    if (cell == nil) {
        cell = [[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"kCommentTableViewCellReusedKey"];
        NSLog(@"无法创建CollectionViewCell时打印，自定义的cell就不可能进来了。");
    }
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in [AsksArr objectAtIndex:indexPath.section][@"reviews"]) {
        [arr addObject:dic];
    }
    ReviewsArr = arr;
    NSLog(@"uuuuuuuuu%@",[ReviewsArr objectAtIndex:indexPath.row]);
    [cell refreshDic:[ReviewsArr objectAtIndex:indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in [AsksArr objectAtIndex:indexPath.section][@"reviews"]) {
        [arr addObject:dic];
    }
    ReviewsArr = arr;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"nnnnnnn%@",[NSString stringWithFormat:@"回复 %@",[ReviewsArr objectAtIndex:indexPath.row][@"nickName"]]);
    NSLog(@"mmmmmmm%@",[ReviewsArr objectAtIndex:indexPath.row][@"memberId"]);
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"回复 %@",[ReviewsArr objectAtIndex:indexPath.row][@"nickName"]],@"textOne",[ReviewsArr objectAtIndex:indexPath.row][@"memberId"],@"textTwo", nil];
    NSNotification *notification =[NSNotification notificationWithName:@"dianjitanchupinglunkuang" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    
}
-(void)requestisisFavorited:(NSString *)askGoodId
{
    
    //请求商品信息判断是否收藏
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic setValue:askGoodId forKey:@"id"];
    [dic setValue:[NSString realForString:[UserModel currentUser].memberId] forKey:@"memberId"];
    
    [[NetController sharedInstance] postWithAPI:API_ask_JsonDetail parameters:dic completionHandler:^(id responseObject,NSError * error){
        
        NSMutableDictionary * backDic = responseObject[@"data"];
        
        if ([[NSString realForString:[backDic objectForKey:@"isFavorited"]] isEqualToString:@"1"]) {
            self.isFavorited = YES;
            
            /*[weakSelf.bottomView.collectBtn setBackgroundImage:[UIImage imageNamed:@"btn04"] forState:0];
             [weakSelf.bottomView.collectBtn setBackgroundImage:[UIImage imageNamed:@"btn04"] forState:1];*/
            
        }else
        {
            self.isFavorited = NO;
            /*[weakSelf.bottomView.collectBtn setBackgroundImage:[UIImage imageNamed:@"btn05"] forState:0];
             [weakSelf.bottomView.collectBtn setBackgroundImage:[UIImage imageNamed:@"btn05"] forState:1];*/
            
        }
        
    }];
    
    
}

-(void)actionBLSheet:(BLActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"6666666666666%@",self.AskDictionary);
    switch (buttonIndex) {
            //联系QQ
        case 0:
        {
            NSString * qqUrlStr = [NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",[NSString realForString:[[self.AskDictionary objectForKey:@"sellerInfo"]objectForKey:@"qq"]]];
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
            
            NSLog(@"44444444%@",[self.AskDictionary objectForKey:@"mobileNumber"]);
            if ([[[self.AskDictionary objectForKey:@"sellerInfo"]objectForKey:@"mobileNumber"] isMobilePhoneNumber] == YES&&(![[NSString realForString:[[self.AskDictionary objectForKey:@"sellerInfo"]objectForKey:@"mobileNumber"]] isEqualToString:@""])) {
                NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",[[self.AskDictionary objectForKey:@"sellerInfo"]objectForKey:@"mobileNumber"]];
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
                
                controller.recipients  = [NSArray arrayWithObject:[NSString realForString:[[self.AskDictionary objectForKey:@"sellerInfo"]objectForKey:@"mobileNumber"]]];
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

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    
    [[self getCurrentVC] dismissViewControllerAnimated:YES completion:nil];//关键的一句   不能为YES
    NSString *text = nil;
    switch ( result ) {
        case MessageComposeResultCancelled:
            
            break;
        case MessageComposeResultSent:// send failed
            text = @"发送成功";
            break;
        case MessageComposeResultFailed:
            text = @"发送失败";
            break;
        default:
            break;
    }
    /*if (!text) {
        [[[UIAlertView alloc] initWithTitle:@"提示信息" message:text delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
    }*/
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

- (UIViewController *)viewController {
         for (UIView* next = [self superview]; next; next = next.superview) {
                UIResponder *nextResponder = [next nextResponder];
               if ([nextResponder isKindOfClass:[UIViewController class]]) {
                       return (UIViewController *)nextResponder;
                  }
             }
        return nil;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"123456");
    NSNotification *notification =[NSNotification notificationWithName:@"gongchushurukuang" object:nil userInfo:nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void) chongxinloadViewaction:(NSNotification *)text
{
    [self requestData];
    [self reloadData];
}
@end
