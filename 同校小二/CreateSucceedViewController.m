//
//  CreateSucceedViewController.m
//  TXXE
//
//  Created by 李雨龙 on 15/8/23.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "CreateSucceedViewController.h"
#import "SearchConditionView.h"
#import "Constants.h"
#import <MJRefresh.h>
#import "ProgressHudCommon.h"
#import <MessageUI/MessageUI.h>
#import "NetController.h"
#import "NSString+Addition.h"
#import "BLActionSheet.h"
#import "CommentTableViewCell.h"
#import "GoodReportVC.h"
#import "AppDelegate.h"
#import "SellerInfoViewController.h"

#import "GoodListViewController.h"
#import "ImageScrollView.h"
@interface CreateSucceedViewController ()<BLActionSheetDelegate,MFMessageComposeViewControllerDelegate,ImageScrollViewDelegate,UIScrollViewDelegate>
{
    ImageListView *listOfImage;
    NSInteger currentIndex;
    NSInteger currentHeight;
    UIView *markView;
    UIView *scrollPanel;
    UIScrollView *myScrollView;
    
    UIButton *temp;
}
@property (nonatomic,strong)NSString *targetId;

@end

@implementation CreateSucceedViewController

-(id)init
{
    self = [super init];
    if (self) {
        _curPage = 0;
        _pageSize = 20;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewWillAppear:) name:@"tanchu" object:nil];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.0/255 green:191.0/255 blue:121.0/255 alpha:1.0];
    [self init];
    curNum = 0;
    
    _currAskGoodId = [[NSString alloc]init];
    AsksArr = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor colorWithRed:230.0/255 green:230.0/255 blue:230.0/255 alpha:1];
    [self.tableView registerNib:[UINib nibWithNibName:@"CommentTableViewCell" bundle:nil] forCellReuseIdentifier:@"KCommentTableViewCellReusedKey"];
    
    [self requestList];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageTag:) name:@"imageTag" object:nil];
    
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
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    __weak CreateSucceedViewController * weak = self;
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
        [dic setValue:weak.currAskGoodId forKey:@"id"];
        [dic setValue:commentStr forKey:@"contents"];
        [dic setValue:weak.targetId forKey:@"targetId"];
        weak.targetId = nil;
        
        [[NetController sharedInstance] postWithAPI:API_asks_addReview parameters:dic completionHandler:^(id responseObject, NSError *error){
            if (error) {
                [ProgressHudCommon showHudAndHide:weak.view andNotice:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
                
            }else
            {
                [ProgressHudCommon showHudAndHide:weak.view andNotice:@"评论成功"];
                [weak requestList];
                [weak.tableView reloadData];
            }
            
        }];
    };
    self.inputView.inputTextField.delegate = self;
    self.inputView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.inputView];

}


- (void)requestList
{
    [ProgressHudCommon showHUDInView:self.view andInfo:@"数据加载中..." andImgName:nil andAutoHide:NO];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [paramDic setValue:self.categoryId forKey:@"categoryId"];
    [paramDic setValue:self.schoolId forKey:@"schoolId"];
    [paramDic setValue:[NSNumber numberWithInt:self.curPage] forKey:@"page"];
    [paramDic setValue:[NSNumber numberWithInt:self.pageSize] forKey:@"pageSize"];
    [[NetController sharedInstance] postWithAPI:API_ask_list parameters:paramDic completionHandler:^(id responseObject, NSError *error) {
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
                AsksArr = [[NSMutableArray alloc] init];
                for (NSDictionary *dict in responseObject[@"data"])
                {   NSMutableDictionary *temp = [[NSMutableDictionary alloc] initWithDictionary:dict];
                    [temp setValue:@(0) forKey:@"isOpen"];
                    NSLog(@"ttttttttttt%@",temp);
                    [AsksArr addObject:temp];
                }
                //NSLog(@"ssssssssssss%@",AsksArr[1]);
                [self.tableView reloadData];
            }else{
                for (NSDictionary *dict in responseObject[@"data"])
                {   NSMutableDictionary *temp = [[NSMutableDictionary alloc] initWithDictionary:dict];
                    [temp setValue:@(0) forKey:@"isOpen"];
                    NSLog(@"ttttttttttt%@",temp);
                    [AsksArr addObject:temp];
                    
                }
                NSLog(@"ssssssssssss%@",AsksArr[1]);
                [self.tableView reloadData];
            }
        }
        [ProgressHudCommon hiddenHUD:self.view];
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
    }];
}
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)lookGoodAction:(id)sender {
    GoodListViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"GoodList"];
    vc.distance = 1;
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"ppppppppppppp%ld",(long)[AsksArr count]);
    return [AsksArr count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
        return 475;
    }else if ([[AsksArr[section] objectForKey:@"images"] count] > 3 && [[AsksArr[section] objectForKey:@"images"] count] <= 6)
    {
        return 390;
    }else if  ([[AsksArr[section] objectForKey:@"images"] count] >1 && [[AsksArr[section] objectForKey:@"images"] count] <= 3)
    {
        return 305;
    }else if ([[AsksArr[section] objectForKey:@"images"] count] == 1)
    {
        return 315;
    }else
    {
        return 215;
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //self.head = [[[NSBundle mainBundle] loadNibNamed:@"AskItemHeaderView" owner:nil options:nil] firstObject];
    if ([[AsksArr[section] objectForKey:@"images"] count] == 0) {
        self.head = [[AskItemsHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 225)];
    }else if ([[AsksArr[section] objectForKey:@"images"] count] == 1) {
        self.head = [[AskItemsHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 325)];
    }else if([[AsksArr[section] objectForKey:@"images"] count] > 1 && [[AsksArr[section] objectForKey:@"images"] count] <= 3)
    {
        self.head = [[AskItemsHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 315)];
    }else if([[AsksArr[section] objectForKey:@"images"] count] > 3 && [[AsksArr[section] objectForKey:@"images"] count] <= 6)
    {
        self.head = [[AskItemsHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 400)];
    }else if([[AsksArr[section] objectForKey:@"images"] count] > 6)
    {
        self.head = [[AskItemsHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 485)];
    }
    __weak __typeof(self)weakSelf = self;
    weakSelf.head.commClickBlock = ^(UIButton *sender){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        [AsksArr[section] setValue:@(![[AsksArr[section] objectForKey:@"isOpen"] boolValue]) forKey:@"isOpen"];
        NSLog(@"$$$$%ld",[[AsksArr[section] objectForKey:@"isOpen"] longValue]);
        curNum = section;
        [strongSelf.tableView reloadData];
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:curNum];
        [strongSelf.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        NSLog(@"qqqqqqqqqqqqqqq%@",[AsksArr objectAtIndex:section]);
        strongSelf.currAskGoodId = [AsksArr objectAtIndex:section][@"id"];
        if ([[AsksArr[section] objectForKey:@"isOpen"] boolValue] == YES) {
            [UIView animateWithDuration:0.1 animations:^{
                [self.inputView.inputTextField becomeFirstResponder];
                self.inputView.inputTextField.placeholder = @"填写评论";
            }];
        }
        
    };
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
                    [ProgressHudCommon showHudAndHide:self.view andNotice:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
                }else
                {
                    [ProgressHudCommon showHudAndHide:self.view andNotice:@"举报成功"];
                    [self.tableView reloadData];
                }
                
            }];
        };
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    
    
    weakSelf.head.collClickBlock = ^(UIButton *sender,NSString *askGoodId){
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
            //////////////////API_favorite_remove
            [[NetController sharedInstance] postWithAPI:API_favorite_remove parameters:dic completionHandler:^(id responseObject, NSError *error) {
                if (error) {
                    //[ProgressHudCommon showHudAndHide:self.view andNotice:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
                    NSLog(@"NSLocalizedDescription");
                }else
                {
                    self.isFavorited = NO;
                    [ProgressHudCommon showHudAndHide:self.view andNotice:@"取消收藏成功"];
                    NSLog(@"取消收藏成功");
                }
            }];
        }else
        {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
            [dic setValue:[NSString realForString:[UserModel currentUser].memberId] forKey:@"memberId"];
            [dic setValue:@"2" forKey:@"favoriteType"];
            [dic setValue:askGoodId forKey:@"assocId"];
            ///////////API_favorite_add
            [[NetController sharedInstance] postWithAPI:API_favorite_add parameters:dic completionHandler:^(id responseObject, NSError *error) {
                if (error) {
                    [ProgressHudCommon showHudAndHide:self.view andNotice:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
                    NSLog(@"NSLocalizedDescription2");
                }
                else
                {
                    self.isFavorited = YES;
                    [ProgressHudCommon showHudAndHide:self.view andNotice:@"收藏成功"];
                    NSLog(@"收藏成功");
                }
            }];
        }
    };
    
    weakSelf.head.contClickBlock = ^(UIButton *sender,NSDictionary *AskDic){
        for (UIView *view in self.parentViewController.tabBarController.view.subviews) {
            if (view.tag == 100) {
                view.hidden = YES;
            }
        }
        BLActionSheet *sheet = [[BLActionSheet alloc]initWithFrame:CGRectZero andTitles:[NSArray arrayWithObjects:@"QQ",@"电话",@"短信", nil]];
        self.AskDictionary = AskDic;
        sheet.delegate = self;
        [sheet showInView:self.view];
    };
    
    weakSelf.head.tapBackBlock = ^(UITapGestureRecognizer *sender)
    {
        [self.inputView.inputTextField resignFirstResponder];
    };
    
    weakSelf.head.tapBlock = ^(UITapGestureRecognizer *sender,NSString *memberId)
    {
        /*AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
         NSLog(@"uuuuuuuu%ld",appDelegate.num);
         if (appDelegate.num >= 2) {
         [self.navigationController popViewControllerAnimated:YES];
         }else{*/
        SellerInfoViewController *vc = [[SellerInfoViewController alloc] init];
        vc.memberId = memberId;
        for (UIView *view in self.parentViewController.tabBarController.view.subviews) {
            if (view.tag == 100) {
                view.hidden = YES;
            }
        }
        NSLog(@"rrrrrrrrr%@",vc.memberId);
        vc.type = 2;
        [self.navigationController pushViewController:vc animated:YES];
    };
    NSLog(@"000000000000000%@",AsksArr[section]);
    
    [self.head refreshWithDic:AsksArr[section]];
    //[self.head refreshWithDicWith:1];
    return self.head;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KCommentTableViewCellReusedKey" forIndexPath:indexPath];
    [cell sizeToFit];
    if (cell == nil) {
        NSLog(@"无法创建CollectionViewCell时打印，自定义的cell就不可能进来了。");
    }
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in [AsksArr objectAtIndex:indexPath.section][@"reviews"]) {
        [arr addObject:dic];
    }
    ReviewsArr = arr;
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
    [self.inputView.inputTextField becomeFirstResponder];
    self.inputView.inputTextField.placeholder = [NSString stringWithFormat:@"回复 %@",[ReviewsArr objectAtIndex:indexPath.row][@"nickName"]];
    self.targetId = [ReviewsArr objectAtIndex:indexPath.row][@"memberId"];
    
}


//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //if ([self.searchBar isFirstResponder] == NO) {
        //获取键盘的高度
        NSDictionary *userInfo = [aNotification userInfo];
        NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardRect = [aValue CGRectValue];
        int height = keyboardRect.size.height;
        [self.inputView setFrame:CGRectMake(0, kContentViewHeight-height, KScreenWidth, 65)];
   // }
    
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
   // if ([self.searchBar isFirstResponder] == NO) {
        [self.inputView setFrame:CGRectMake(0, kContentViewHeight+65, KScreenWidth, 65)];
   // }
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.inputView.inputTextField resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //设置动画的名字
    [UIView beginAnimations:@"Animation" context:nil];
    //设置动画的间隔时间
    [UIView setAnimationDuration:0.20];
    //??使用当前正在运行的状态开始下一段动画
    [UIView setAnimationBeginsFromCurrentState: YES];
    //设置视图移动的位移
    self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y - 300, self.tableView.frame.size.width, self.tableView.frame.size.height);
    //设置动画结束
    [UIView commitAnimations];
}
//在UITextField 编辑完成调用方法
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //设置动画的名字
    [UIView beginAnimations:@"Animation" context:nil];
    //设置动画的间隔时间
    [UIView setAnimationDuration:0.20];
    //??使用当前正在运行的状态开始下一段动画
    [UIView setAnimationBeginsFromCurrentState: YES];
    //设置视图移动的位移
    self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y + 300, self.tableView.frame.size.width, self.tableView.frame.size.height);
    //设置动画结束
    [UIView commitAnimations];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    //[_searchBar resignFirstResponder];
}



#pragma mark 请求是否已收藏
-(void)requestisisFavorited:(NSString *)askGoodId
{
    
    
    __block CreateSucceedViewController * weakSelf = self;
    
    //请求商品信息判断是否收藏
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic setValue:askGoodId forKey:@"id"];
    [dic setValue:[NSString realForString:[UserModel currentUser].memberId] forKey:@"memberId"];
    
    [[NetController sharedInstance] postWithAPI:API_ask_JsonDetail parameters:dic completionHandler:^(id responseObject,NSError * error){
        
        NSMutableDictionary * backDic = responseObject[@"data"];
        
        if ([[NSString realForString:[backDic objectForKey:@"isFavorited"]] isEqualToString:@"1"]) {
            weakSelf.isFavorited = YES;
            
            /*[weakSelf.bottomView.collectBtn setBackgroundImage:[UIImage imageNamed:@"btn04"] forState:0];
             [weakSelf.bottomView.collectBtn setBackgroundImage:[UIImage imageNamed:@"btn04"] forState:1];*/
            
        }else
        {
            weakSelf.isFavorited = NO;
            /*[weakSelf.bottomView.collectBtn setBackgroundImage:[UIImage imageNamed:@"btn05"] forState:0];
             [weakSelf.bottomView.collectBtn setBackgroundImage:[UIImage imageNamed:@"btn05"] forState:1];*/
            
        }
        
        
    }];
    
    
}



-(void)actionBLSheet:(BLActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    switch (buttonIndex) {
            //联系QQ
        case 0:
        {
            NSString * qqUrlStr = [NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",[NSString realForString:[[self.AskDictionary objectForKey:@"sellerInfo"] objectForKey:@"qq"]]];
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
            break;
            // 拨打手机
        case 1:
        {
            
            //NSLog(@"44444444%@",self.userModel.mobileNumber);
            if ([[[self.AskDictionary objectForKey:@"sellerInfo"] objectForKey:@"mobileNumber"] isMobilePhoneNumber] == YES&&(![[NSString realForString:[[self.AskDictionary objectForKey:@"sellerInfo"] objectForKey:@"mobileNumber"]] isEqualToString:@""])) {
                NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",[[self.AskDictionary objectForKey:@"sellerInfo"] objectForKey:@"mobileNumber"]];
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
                
                controller.recipients  = [NSArray arrayWithObject:[NSString realForString:[[self.AskDictionary objectForKey:@"sellerInfo"] objectForKey:@"mobileNumber"]]];
                controller.messageComposeDelegate = self;
                [self presentViewController:controller animated:YES completion:^(){
                    
                    
                }];
                
            }
        }
            break;
        default:
            
            break;
    }
    
}

- (void)imageTag:(NSNotification *)text
{
    [self.view bringSubviewToFront:scrollPanel];
    scrollPanel.alpha = 1.0;
    UIImageView *tmpView = text.userInfo[@"imgView"];
   
    currentIndex = [text.userInfo[@"imgViewTag"] integerValue]-10;
    NSArray *imglist = text.userInfo[@"imgList"];
    listOfImage = text.userInfo[@"imageListView"];
    
    CGSize contentSize = myScrollView.contentSize;
    contentSize.height = self.view.bounds.size.height;
    contentSize.width = self.view.bounds.size.width * imglist.count;
    myScrollView.contentSize = contentSize;
    
    //转换后的rect
    CGRect convertRect = [[tmpView superview] convertRect:tmpView.frame toView:self.view];
    CGPoint contentOffset = myScrollView.contentOffset;
    contentOffset.x = currentIndex*self.view.frame.size.width;
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
    currentHeight = scrollView.contentOffset.y;
    NSLog(@"######%f",scrollView.contentOffset.y);
    
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
    if (!text) {
        [[[UIAlertView alloc] initWithTitle:@"提示信息" message:text delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
    }
}

@end
