//
//  GoodDetailViewController.m
//  TXXE
//
//  Created by River on 15/6/30.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "GoodDetailViewController.h"
#import "NetController.h"
#import "NSString+Addition.h"
#import "UIImageView+WebCache.h"
#import "Constants.h"
#import <MessageUI/MessageUI.h>
#import "ProgressHudCommon.h"
#import "CommentTableViewCell.h"
#import "GoodDetailsPageHeaderView.h"
#import "BLActionSheet.h"

#import "ImageScrollView.h"

#import "TapImageView.h"
#import "SellerInfoViewController.h"
#import "GoodReportVC.h"
#import "AppDelegate.h"
#import "UMSocialSnsPlatformManager.h"
#import <MBProgressHUD.h>
#import "Constants.h"

#import <UIImageView+WebCache.h>

@interface GoodDetailViewController ()<UITableViewDataSource,UITableViewDelegate,BLActionSheetDelegate,MFMessageComposeViewControllerDelegate,TapImageViewDelegate,ImageScrollViewDelegate,UIScrollViewDelegate,UIActionSheetDelegate>
{
    long numOfPicture;
    
    ImageListView *listOfImage;
    NSInteger currentIndex;
    NSInteger currentHeight;
    UIView *markView;
    UIView *scrollPanel;
    UIScrollView *myScrollView;
    
    BOOL isCommentBtn;
}

@property (nonatomic,strong)NSString *targetId;
@property (nonatomic,copy) NSString *mobileNumber;
@property (nonatomic,copy) NSString *qq;
@end

@implementation GoodDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.distance == 1) {
        self.heightConstraint.constant = self.heightConstraint.constant-64;
    }
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.num = appDelegate.num+1;
    self.navigationController.navigationBarHidden = NO;
    self.title = @"商品详情";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollsToTop = YES;
    self.tableView.backgroundColor = [UIColor grayColor];
    self.tableView.tableHeaderView.hidden = NO;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStyleDone target:self action:@selector(shareAndReportBtnAction)];
    [self.navigationItem.rightBarButtonItem setImage:[UIImage imageNamed:@"右上角-更多"]];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.0/255 green:191.0/255 blue:121.0/255 alpha:1.0];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:0.0/255 green:191.0/255 blue:121.0/255 alpha:1.0];
    static NSString * cellID = @"commentItem";
    [self.tableView registerNib:[UINib nibWithNibName:@"CommentTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
    [self requestData];
    
    
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
    myScrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    NSLog(@"AAAAAA%fBBBBBB%fCCCCCCC%fDDDDDDDD%f",self.view.bounds.origin.x,self.view.bounds.origin.y,self.view.bounds.size.width,self.view.bounds.size.height);
    [scrollPanel addSubview:myScrollView];
    myScrollView.pagingEnabled = YES;
    myScrollView.delegate = self;
    
    /////////////
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageTag:) name:@"imageTaggg" object:nil];
    ////////
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    __weak GoodDetailViewController * weak = self;
    self.inputView = [[CommentInputView alloc] initWithFrame:CGRectMake(0, kContentViewHeight+65, self.view.frame.size.width, 60)];
    self.inputView.subCallBack = ^(NSString * commentStr){
        
        [UIView animateWithDuration:0.25 animations:^(){
            
            [weak.inputView setFrame:CGRectMake(0, kContentViewHeight, KScreenWidth, 60)];
            
        } completion:^(BOOL isFinish){
            
            
        }];
        
        
        //登录状态判断
        if (![[UserModel currentUser] isCurrentUserValid]) {
            
            [[UserModel currentUser] operationAuthorizeWithCompletionHandler:^(BOOL isValidUser) {
                if (isValidUser) {
                    
                }
            }];
            
            return;
        }
        
        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:0];
        [dic setValue:[NSString realForString:[UserModel currentUser].memberId] forKey:@"memberId"];
        [dic setValue:weak.goodId forKey:@"id"];
        [dic setValue:commentStr forKey:@"contents"];
        [dic setValue:weak.targetId forKey:@"targetId"];
        weak.targetId = nil;
        
        
        [[NetController sharedInstance] postWithAPI:API_goods_addReview parameters:dic completionHandler:^(id responseObject, NSError *error){
            if (error) {
                [ProgressHudCommon showHudAndHide:weak.view andNotice:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
                
            }else
            {
                
                //
                [weak requestData];
                //[ProgressHudCommon showHudAndHide:weak.view andNotice:@"评论成功"];
            }
            weak.inputView.inputTextField.text = @"";
        }];
        [weak.inputView setFrame:CGRectMake(0, kContentViewHeight+65, KScreenWidth, 65)];
        [ProgressHudCommon showHudAndHide:weak.view andNotice:@"评论成功"];
    };
    self.inputView.inputTextField.delegate = self;
    self.inputView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.inputView];
}

- (void)requestData
{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [paramDic setValue:self.goodId forKey:@"id"];
    [paramDic setValue:[NSString realForString:[UserModel currentUser].memberId] forKey:@"memberId"];
    [[NetController sharedInstance] postWithAPI:API_good_JsonDetaill parameters:paramDic completionHandler:^(id responseObject, NSError *error) {
        
        if (error) {
        }else
        {
            goodDic = [[NSDictionary alloc] initWithDictionary:responseObject];
            
            NSMutableArray *comment = [NSMutableArray array];
            NSMutableDictionary * backDic = responseObject[@"data"];
            
            self.qq = [backDic objectForKey:@"qq"];
            self.mobileNumber = [backDic objectForKey:@"mobileNumber"];
            
            NSLog(@"#######%@",self.qq);
            NSLog(@"#######%@",self.mobileNumber);
            if ([[NSString realForString:[backDic objectForKey:@"isFavorited"]] isEqualToString:@"1"]) {
                self.isFavorited = YES;
                [self.collectionBtn setTitle:@"取消收藏" forState:UIControlStateNormal];
                //.title.text = @"取消收藏";
                /*[weakSelf.bottomView.collectBtn setBackgroundImage:[UIImage imageNamed:@"btn04"] forState:0];
                 [weakSelf.bottomView.collectBtn setBackgroundImage:[UIImage imageNamed:@"btn04"] forState:1];*/
                
            }else
            {
                self.isFavorited = NO;
                [self.collectionBtn setTitle:@"收藏" forState:UIControlStateNormal];
               // self.collectionBtn.title = @"收藏";
                /*[weakSelf.bottomView.collectBtn setBackgroundImage:[UIImage imageNamed:@"btn05"] forState:0];
                 [weakSelf.bottomView.collectBtn setBackgroundImage:[UIImage imageNamed:@"btn05"] forState:1];*/
                
            }
            for (NSDictionary *dict in responseObject[@"data"][@"reviews"]) {
                NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:0];
                [paramDic setValue:dict forKey:@"reviews"];
                [comment addObject:paramDic];
                NSLog(@"%lu",(unsigned long)[comment count]);
                NSLog(@"%@",[comment objectAtIndex:0]);
            }
            reviews = comment;
            
            self.userModel = [[UserModel alloc]init];
            [self.userModel setValuesForKeysWithDictionary:responseObject[@"data"][@"sellerInfo"]];
            NSLog(@"mmmmmmmmmm%@",self.userModel.nickName);
            GoodDetailsPageHeaderView *head = [[[NSBundle mainBundle] loadNibNamed:@"GoodDetailsPageHeaderView" owner:nil options:nil] firstObject];
            head.tapBlock = ^(UITapGestureRecognizer *sender){
                AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
                NSLog(@"uuuuuuuu%ld",appDelegate.num);
                if (appDelegate.num >= 2) {
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    SellerInfoViewController *vc = [[SellerInfoViewController alloc] init];
                    vc.memberId = self.userModel.memberId;
                    NSLog(@"rrrrrrrrr%@",vc.memberId);
                    vc.type = 1;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            };
            head.clickBlock = ^(UIButton *sender){
                [UIView animateWithDuration:0.1 animations:^{
                    isCommentBtn = YES;
                    [self.inputView.inputTextField becomeFirstResponder];
                    self.targetId = nil;
                    self.inputView.inputTextField.placeholder = @"填写评论";
                    ///////////////////////
                }];
            };
            [head refreshWithDic:goodDic];
            self.tableView.tableHeaderView = head;
            [self.tableView reloadData];
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [reviews count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"commentItem";
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID    forIndexPath:indexPath];
    if (cell==nil) {
        cell = [[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    [cell refreshWithDic:[reviews objectAtIndex:indexPath.row]];
    cell.tapBlock = ^(UITapGestureRecognizer *sender){
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSLog(@"uuuuuuuu%ld",appDelegate.num);
        if (appDelegate.num >= 2) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            SellerInfoViewController *vc = [[SellerInfoViewController alloc] init];
            vc.memberId = [reviews objectAtIndex:indexPath.row][@"reviews"][@"memberId"];
            NSLog(@"rrrrrrrrr%@",vc.memberId);
            vc.type = 1;
            [self.navigationController pushViewController:vc animated:YES];
        }
    };
    cell.sellerName = [NSString realForString:[[[goodDic objectForKey:@"data"]objectForKey:@"sellerInfo"] objectForKey:@"nickName"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.inputView.inputTextField becomeFirstResponder];
    self.inputView.inputTextField.placeholder = [NSString stringWithFormat:@"回复 %@",[reviews objectAtIndex:indexPath.row][@"reviews"][@"nickName"]];
    self.targetId = [reviews objectAtIndex:indexPath.row][@"reviews"][@"memberId"];
    [self.tableView setContentSize:CGSizeMake(self.tableView.frame.size.width, [self getLastCommentheight]+self.tableView.frame.size.height)];
    [self.tableView setContentOffset:CGPointMake(0,self.tableView.frame.size.height-200+70*[indexPath row]) animated:YES];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0;
    
}
- (IBAction)backBtnAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    NSLog(@"7777777%d",height);
    if (self.distance == 1) {
       [self.inputView setFrame:CGRectMake(0, kContentViewHeight-height-64, KScreenWidth, 65)];
    }else
    {
        [self.inputView setFrame:CGRectMake(0, kContentViewHeight-height, KScreenWidth, 65)];
    }
    
    if (isCommentBtn == YES) {
        [self.tableView setContentSize:CGSizeMake(self.tableView.frame.size.width, [self getLastCommentheight]+height)];
        [self.tableView setContentOffset:CGPointMake(0,height+70*[reviews count]) animated:YES];
    }

}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    isCommentBtn = NO;
    //
    [self.tableView setContentSize:CGSizeMake(self.tableView.frame.size.width, [self getLastCommentheight])];
    [self.tableView setContentOffset:CGPointMake(0,[self getLastCommentheight]-self.tableView.frame.size.height) animated:YES];
    [self.inputView setFrame:CGRectMake(0, kContentViewHeight+65, KScreenWidth, 65)];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.inputView.inputTextField resignFirstResponder];
    [self.tableView setContentSize:CGSizeMake(self.tableView.frame.size.width, [self getLastCommentheight])];
    [self.tableView setContentOffset:CGPointMake(0,0) animated:YES];
}

-(float)getLastCommentheight
{
    return self.tableView.frame.size.height+70*[reviews count];
}
- (IBAction)collectBtnAction:(id)sender {
    if (![UserModel currentUser].isCurrentUserValid) {
        [[UserModel currentUser]operationAuthorizeWithCompletionHandler:^(BOOL isValidUser) {
            if (isValidUser) {
                [self requestisisFavorited];
            }
        }];
        return;
    }
    [self requestisisFavorited];
    if (self.isFavorited == YES) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
        [dic setValue:[NSString realForString:[UserModel currentUser].memberId] forKey:@"memberId"];
        [dic setValue:@"1" forKey:@"favoriteType"];
        [dic setValue:self.goodId forKey:@"assocId"];
        //////////////////API_favorite_remove
        [[NetController sharedInstance] postWithAPI:API_favorite_remove parameters:dic completionHandler:^(id responseObject, NSError *error) {
            if (error) {
                //[ProgressHudCommon showHudAndHide:self.view andNotice:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
                NSLog(@"NSLocalizedDescription");
            }else
            {
                self.isFavorited = NO;
                [self.collectionBtn setTitle:@"收藏" forState:UIControlStateNormal];
                //self.collectionBtn.title = @"收藏";
                [ProgressHudCommon showHudAndHide:self.view andNotice:@"取消收藏成功"];
                NSLog(@"取消收藏成功");
            }
        }];
    }else
    {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
        [dic setValue:[NSString realForString:[UserModel currentUser].memberId] forKey:@"memberId"];
        [dic setValue:@"1" forKey:@"favoriteType"];
        [dic setValue:self.goodId forKey:@"assocId"];
        ///////////API_favorite_add
        [[NetController sharedInstance] postWithAPI:API_favorite_add parameters:dic completionHandler:^(id responseObject, NSError *error) {
            if (error) {
                [ProgressHudCommon showHudAndHide:self.view andNotice:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
                NSLog(@"NSLocalizedDescription2");
            }
            else
            {
                self.isFavorited = YES;
                [self.collectionBtn setTitle:@"取消收藏" forState:UIControlStateNormal];
                //self.collectionBtn.title = @"取消收藏";
                [ProgressHudCommon showHudAndHide:self.view andNotice:@"收藏成功"];
                NSLog(@"收藏成功");
            }
        }];
    }
    
}
- (IBAction)contactBtnAction:(id)sender {
    BLActionSheet *sheet = [[BLActionSheet alloc]initWithFrame:CGRectZero andTitles:[NSArray arrayWithObjects:@"QQ",@"电话",@"短信", nil]];
    sheet.delegate = self;
    [sheet showInView:self.view];
}

-(void)actionBLSheet:(BLActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        //联系QQ
        case 0:
        {if ([self.qq isEqualToString:@""]) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未填写QQ号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
        }else
        {
            NSString * qqUrlStr = [NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",[NSString realForString:self.qq]];
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:qqUrlStr]]) {
                UIWebView *qqWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
                NSURL *url = [NSURL URLWithString:qqUrlStr];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                // webView.delegate = self;
                [qqWebView loadRequest:request];
                [self.view addSubview:qqWebView];
            }
            
            else{
                
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请安装QQ客户端" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
            }
        }
        }
        break;
        // 拨打手机
        case 1:
        {
            
            NSLog(@"44444444%@",self.mobileNumber);
            if ([self.mobileNumber isMobilePhoneNumber] == YES&&(![[NSString realForString:self.mobileNumber] isEqualToString:@""])) {
                NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.mobileNumber];
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
            if ([self.mobileNumber isEqualToString:@""]) {
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未填写手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
            }else{
            if([MFMessageComposeViewController canSendText])
            {
                
                controller.recipients  = [NSArray arrayWithObject:[NSString realForString:self.mobileNumber]];
                controller.messageComposeDelegate = self;
                [self presentViewController:controller animated:YES completion:^(){
                    
                    
                }];
                
            }
            }
        }
            break;
        default:
            break;
    }
    
    
    
    
    
}

#pragma mark 请求是否已收藏
-(void)requestisisFavorited
{
    
    
    __block GoodDetailViewController * weakSelf = self;
    
    //请求商品信息判断是否收藏
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic setValue:weakSelf.goodId forKey:@"id"];
    [dic setValue:[NSString realForString:[UserModel currentUser].memberId] forKey:@"memberId"];
    
    [[NetController sharedInstance] postWithAPI:API_good_JsonDetaill parameters:dic completionHandler:^(id responseObject,NSError * error){
        
        NSMutableDictionary * backDic = responseObject[@"data"];
        
        if ([[NSString realForString:[backDic objectForKey:@"isFavorited"]] isEqualToString:@"1"]) {
            weakSelf.isFavorited = YES;
            [weakSelf.collectionBtn setTitle:@"取消收藏" forState:UIControlStateNormal];
            //weakSelf.collectionBtn.title = @"取消收藏";
            
        }else
        {
            weakSelf.isFavorited = NO;
            [weakSelf.collectionBtn setTitle:@"收藏" forState:UIControlStateNormal];
            //weakSelf.collectionBtn.title = @"收藏";
            
            
        }
        
        
    }];
    
}




/*- (void)setMyScrollView
{
    CGSize contentSize = myScrollView.contentSize;
    contentSize.height = self.view.bounds.size.height;
    contentSize.width = self.view.bounds.size.width*[[[goodDic objectForKey:@"data"]objectForKey:@"images"] count];
    myScrollView.contentSize = contentSize;
}*/

#pragma mark -
#pragma mark - scroll delegate
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //[self.inputView.inputTextField resignFirstResponder];
    self.inputView.inputTextField.text = @"";
    CGFloat pageWidth = myScrollView.frame.size.width;
    currentIndex = floor(scrollView.contentOffset.x/pageWidth - 0.5) + 1;
    currentHeight = scrollView.contentOffset.y;
    NSLog(@"######%f",scrollView.contentOffset.y);
}

- (void)shareAndReportBtnAction{
    
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:@"举报"
                                  otherButtonTitles:@"分享到微信", @"分享到朋友圈",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        if (![UserModel currentUser].isCurrentUserValid) {
            [[UserModel currentUser]operationAuthorizeWithCompletionHandler:^(BOOL isValidUser) {
                if (isValidUser) {
                    
                }
            }];
            return;
        }
        
        GoodReportVC * vc = [[GoodReportVC alloc] init];
        vc.reportCallBack  = ^(NSString * str){
            NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:0];
            [dic setValue:[NSString realForString:[UserModel currentUser].memberId] forKey:@"memberId"];
            [dic setValue:self.goodId forKey:@"goodsId"];
            [dic setValue:str forKey:@"reason"];
            
            [[NetController sharedInstance] postWithAPI:API_good_report parameters:dic completionHandler:^(id responseObject, NSError *error){
                if (error) {
                    [ProgressHudCommon showHudAndHide:self.view andNotice:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
                }else
                {
                    [ProgressHudCommon showHudAndHide:self.view andNotice:@"举报成功"];
                    [self.tableView reloadData];
                }
                
            }];
        };
        [self.navigationController pushViewController:vc animated:YES];
        NSLog(@"确定");
    }else if (buttonIndex == 1) {
        NSString *snsName = UMShareToWechatSession;
        NSString *shareText = [NSString stringWithFormat:@"%@/wx/#second+goods-detail?id=%@",kServerHttpBaseURLString,self.goodId];
        
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[[goodDic objectForKey:@"data"]objectForKey:@"images"] lastObject]]];
        UIImage *shareImage = [UIImage imageWithData:data];
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeDefault url:shareText];
        [UMSocialData defaultData].extConfig.wechatSessionData.url = shareText;
        [UMSocialData defaultData].extConfig.wechatSessionData.title = [NSString realForString:[[goodDic objectForKey:@"data"]objectForKey:@"title"]];
        [urlResource setResourceType:UMSocialUrlResourceTypeDefault url:shareText];
         NSLog(@"uuuuuuu%@",urlResource);
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[UMSocialDataService defaultDataService] postSNSWithTypes:@[snsName] content:[NSString realForString:[[goodDic objectForKey:@"data"] objectForKey:@"description"]] image:shareImage location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity * response){
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if (response.responseCode == UMSResponseCodeSuccess) {
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"成功" message:@"已成功分享" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
                [alertView show];
            } else if(response.responseCode != UMSResponseCodeCancel) {
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"失败" message:@"分享失败" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
                [alertView show];
            }
        }];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"第一项");
    }else if(buttonIndex == 2) {
        NSString *snsName = UMShareToWechatTimeline;
        NSString *shareText = [NSString stringWithFormat:@"%@/wx/#second+goods-detail?id=%@",kServerHttpBaseURLString,self.goodId];
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[[goodDic objectForKey:@"data"]objectForKey:@"images"] lastObject]]];
        UIImage *shareImage = [UIImage imageWithData:data];
        
        [UMSocialData defaultData].extConfig.wechatTimelineData.url =shareText;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[UMSocialDataService defaultDataService] postSNSWithTypes:@[snsName] content:[NSString realForString:[[goodDic objectForKey:@"data"]objectForKey:@"title"]] image:shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity * response){
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if (response.responseCode == UMSResponseCodeSuccess) {
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"成功" message:@"已成功分享" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
                [alertView show];
            } else if(response.responseCode != UMSResponseCodeCancel) {
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"失败" message:@"分享失败" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
                [alertView show];
            }
        }];
        NSLog(@"第二项");
    }else if(buttonIndex == 3) {
        for (UIView *view in self.parentViewController.tabBarController.view.subviews) {
            if (view.tag == 100) {
                view.hidden = YES;
            }
        }
        NSLog(@"取消");
    }
    
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    
    [self dismissViewControllerAnimated:YES completion:nil];//关键的一句   不能为YES
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
    NSLog(@"a%fb%f",contentOffset.x,contentOffset.y);
    NSLog(@"c%fd%f",myScrollView.bounds.size.width,myScrollView.bounds.size.height);
    [tmpImgScrollView setContentWithFrame:convertRect];
    NSLog(@"e%ff%fg%fh%f",convertRect.origin.x,convertRect.origin.y,convertRect.size.width,convertRect.size.height);
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
        NSLog(@"44444%f",convertRect.size.width);
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
