//
//  SellerInfoViewController.m
//  TXXE
//
//  Created by 李雨龙 on 15/7/26.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "SellerInfoViewController.h"
#import "AppDelegate.h"
#import "NetController.h"
#import <UIImageView+WebCache.h>
#import "UIView+Addition.h"
#import "ImageListView.h"
#import "ImageScrollView.h"
#import "Constants.h"
#import "GoodDetailViewController.h"
#import "ProgressHudCommon.h"


@interface SellerInfoViewController ()<ImageScrollViewDelegate,UIScrollViewDelegate>
{
    ImageListView *listOfImage;
    NSInteger currentIndex;
    UIView *markView;
    UIView *scrollPanel;
    UIScrollView *myScrollView;
}

@property (nonatomic,strong)NSDictionary *infoDic;
@property (nonatomic,strong)NSString *targetId;
@end

@implementation SellerInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view1.backgroundColor = [UIColor colorWithRed:251/255.0 green:251/255.0 blue:251/255.0 alpha:1.0];
    self.view2.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    self.navigationController.navigationBarHidden = NO;
    [self.photo drawBorderStyleWithBorderWidth:0 borderColor:[UIColor clearColor] cornerRadius:self.photo.frame.size.height * 0.5];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageTag:) name:@"imageTag" object:nil];
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.0/255 green:191.0/255 blue:121.0/255 alpha:1.0];
    
    
    UIScreen *s = [UIScreen mainScreen];
    CGFloat width = [s bounds].size.width;
    
    
    self.greenDiscover = [[UIView alloc] initWithFrame:CGRectMake(width/2.0, self.view2.frame.size.height-1, width/2.0, 1)];
    [self.greenDiscover setBackgroundColor:[UIColor colorWithRed:0.0/255 green:191.0/255 blue:121.0/255 alpha:1.0]];
    self.greenDiscover.hidden = YES;
    [self.view2 addSubview:self.greenDiscover];
    
    self.greenCategory = [[UIView alloc] initWithFrame:CGRectMake(0, self.view2.frame.size.height-1, width/2.0, 1)];
    [self.greenCategory setBackgroundColor:[UIColor colorWithRed:0.0/255 green:191.0/255 blue:121.0/255 alpha:1.0]];
    [self.view2 addSubview:self.greenCategory];
    //////////////
    //展示图片1
    NSLog(@"ttttttttt%ld",(long)self.view.tag);
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
    [scrollPanel addSubview:myScrollView];
    myScrollView.pagingEnabled = YES;
    myScrollView.delegate = self;
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tiaozhuanaction:) name:@"tiaozhuanzhi" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(feichushurukuangAction:) name:@"feichushurukuang" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gongchushurukuangAction:) name:@"gongchushurukuang" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dianjitanchupinglunkuangAction:) name:@"dianjitanchupinglunkuang" object:nil];
    
    
    self.title = @"商家详情";
    [self requestData];
    [self initialShow:self.type];
    NSLog(@"hahhaaahha%@",self.memberId);
    
    __weak SellerInfoViewController * weak = self;
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
                
                [ProgressHudCommon showHUDInView:weak.view andInfo:@"评论成功" andImgName:nil
                    andAutoHide:NO];
                NSNotification *notification =[NSNotification notificationWithName:@"chongxinloadView" object:nil userInfo:nil];
                //通过通知中心发送通知
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestData
{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [paramDic setValue:self.memberId forKey:@"memberId"];
    if (self.askId != nil) {
        [paramDic setValue:self.askId forKey:@"goodsInNeedId"];
    }
    [paramDic setValue:@(1) forKey:@"status"];
    [[NetController sharedInstance]postWithAPI:API_user_center_data parameters:paramDic completionHandler:^(id responseObject, NSError *error) {
        if (error) {
        }else{
            self.infoDic = responseObject[@"data"][@"certInfo"];
            NSLog(@"nnnnnnn%@",self.infoDic);
            [self createTopInfo:self.infoDic];
            [self.tableView reloadData];
        }
    }];
}

- (void)createTopInfo:(NSDictionary *)dic
{
    NSURL *url = [NSURL URLWithString:dic[@"avatar"]];
    [self.photo sd_setImageWithURL:url  placeholderImage:nil];
    self.nickName.text = dic[@"nickName"];
    self.schoolName.text = dic[@"schoolName"];
    self.levelLabel.text = dic[@"level"];
    
    NSString *str = [dic[@"certStatus"] stringValue
                     ];
    if ([str isEqualToString:@"1"]) {
        self.identificationLabel.text = @"已验证";
    }else if ([str isEqualToString:@"0"])
    {
        self.identificationLabel.text = @"正在审核中";
    }else if ([str isEqualToString:@"-1"])
    {
        self.identificationLabel.text = @"未审核通过";
    }else
    {
        self.identificationLabel.text = @"未验证";
    }
    
    
}

- (IBAction)goodBtn:(id)sender {
    self.tableView.hidden = YES;
    self.greenDiscover.hidden = YES;
    self.greenCategory.hidden = NO;
    self.collectionView.hidden = NO;
    [self.inputView.inputTextField resignFirstResponder];
    self.inputView.inputTextField.text = @"";
    [self loadGoodView];
}
- (IBAction)askBtn:(id)sender {
    self.collectionView.hidden = YES;
    self.greenDiscover.hidden = NO;
    self.greenCategory.hidden = YES;
    self.tableView.hidden = NO;
    [self.inputView.inputTextField resignFirstResponder];
    self.inputView.inputTextField.text = @"";
    [self loadAskView];
}

- (void)initialShow:(long)type
{
    if (type == 1) {
        [self loadGoodView];
    }else
    {
        [self loadAskView];
    }
}

- (void)loadGoodView
{
    self.greenDiscover.hidden = YES;
    self.greenCategory.hidden = NO;
    [self.goodButton setTitleColor:[UIColor colorWithRed:0.0/255 green:191.0/255 blue:121.0/255 alpha:1.0] forState:UIControlStateNormal];
    [self.askButton setTitleColor:[UIColor colorWithRed:74/255.0 green:74/255.0 blue:74/255.0 alpha:1.0] forState:UIControlStateNormal];
    UIScreen *s = [UIScreen mainScreen];
    CGFloat width = [s bounds].size.width;
    CGFloat height = [s bounds].size.height;
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    self.collectionView = [[SellerGoodCollectionView alloc]initWithFrame:CGRectMake(0, 189, width, height-189) collectionViewLayout:flowLayout withMemberId:self.memberId];

    NSLog(@"ttttttttttt%@",self.collectionView.memberId);
    [self.collectionView reloadData];
    [self.view addSubview:self.collectionView];
    
}

- (void)loadAskView
{
    self.greenDiscover.hidden = NO;
    self.greenCategory.hidden = YES;
    [self.goodButton setTitleColor:[UIColor colorWithRed:74/255.0 green:74/255.0 blue:74/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.askButton setTitleColor:[UIColor colorWithRed:0.0/255 green:191.0/255 blue:121.0/255 alpha:1.0] forState:UIControlStateNormal];
   UIScreen *s = [UIScreen mainScreen];
    CGFloat width = [s bounds].size.width;
    CGFloat height = [s bounds].size.height;
    
    self.tableView = [[SellerAskTableView alloc]initWithFrame:CGRectMake(0, 189, width, height-189) style:UITableViewStylePlain withMemberId:self.memberId withAskId:self.askId];
    [self.view addSubview:self.tableView];
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
    NSLog(@"nnnnnnnnnnn%fnnnn%f",contentSize.width,contentSize.height);
    contentSize.height = self.view.bounds.size.height;
    contentSize.width = self.view.bounds.size.width * imglist.count;
    myScrollView.contentSize = contentSize;
    
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

- (void)feichushurukuangAction:(NSNotification *)text
{
    self.currAskGoodId = text.userInfo[@"textOne"];
    NSLog(@"555555555%@",self.currAskGoodId);
    //self.currAskGoodId = text.userInfo[@"textOne"];
    [UIView animateWithDuration:0.1 animations:^{
        [self.inputView.inputTextField becomeFirstResponder];
        self.inputView.inputTextField.placeholder = @"填写评论";
    }];
}

- (void)gongchushurukuangAction:(NSNotification *)text
{
    [self.inputView.inputTextField resignFirstResponder];
    self.inputView.inputTextField.text = @"";
}

- (void)dianjitanchupinglunkuangAction:(NSNotification *)text
{
    [self.inputView.inputTextField becomeFirstResponder];
    NSLog(@"nnnnnnn%@",text.userInfo[@"textOne"]);
    NSLog(@"mmmmmmm%@",text.userInfo[@"textTwo"]);
    self.inputView.inputTextField.placeholder = text.userInfo[@"textOne"];
    self.targetId = text.userInfo[@"textTwo"];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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


@end
