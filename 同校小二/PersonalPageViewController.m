//
//  PersonalPageViewController.m
//  TXXE
//
//  Created by River on 15/6/27.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "PersonalPageViewController.h"
#import "UserCenterMainDataModel.h"
#import "UserIdentificationView.h"
#import "PersonalPageTableViewCell.h"
#import "UserModel.h"
#import <KGModal.h>
#import "Constants.h"
#import <MBProgressHUD.h>
#import "UIViewController+TopBarMessage.h"
#import "UIView+Addition.h"
#import <UIImageView+WebCache.h>
#import "PersonalProfileEditVCViewController.h"


@interface PersonalPageViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *schoolNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *integrityLabel;
@property (weak, nonatomic) IBOutlet UITableView *menuTableView;
@property (weak, nonatomic) IBOutlet UIProgressView *intergrityProgress;

@property (nonatomic,strong) UserCenterMainDataModel *centerDataFetcher;
@property (nonatomic,strong) UserIdentificationView *identificationView;

@end

@implementation PersonalPageViewController

-(UserIdentificationView *)identificationView
{
    if (!_identificationView) {
        _identificationView = [[[NSBundle mainBundle]loadNibNamed:@"UserIdentificationView" owner:self options:nil]firstObject];
        __weak __typeof(self)weakSelf = self;
        _identificationView.confirmBtnActionBlock = ^(BOOL isSucceed){
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf refreshViewData];
            [[KGModal sharedInstance]hideAnimated:YES withCompletionBlock:^{
                if (isSucceed) {
                    [[[UIAlertView alloc]initWithTitle:nil message:@"成功提交认证，请等候审核结果！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确认", nil]show];
                }
            }];
        };
    }
    return _identificationView;
}

- (UserCenterMainDataModel *)centerDataFetcher
{
    if (!_centerDataFetcher) {
        _centerDataFetcher = [[UserCenterMainDataModel alloc]init];
    }
    return _centerDataFetcher;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.avatarImageView.layer setBorderColor:APP_MAIN_COLOR.CGColor];
    [self.avatarImageView.layer setBorderWidth:2];
    [self.avatarImageView drawBorderStyleWithBorderWidth:0 borderColor:[UIColor clearColor] cornerRadius:self.avatarImageView.frame.size.height * 0.5];
    self.avatarImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoTapped)];
    [self.avatarImageView addGestureRecognizer:singleTap];//点击图片事件
    self.menuTableView.delaysContentTouches = NO;
    [self.menuTableView.backgroundView removeFromSuperview];
    self.menuTableView.backgroundColor = RGB_COLOR(244, 244, 244, 1.0);
    [self.menuTableView registerNib:[UINib nibWithNibName:@"PersonalPageTableViewCell" bundle:nil] forCellReuseIdentifier:@"kMeunTableViewCellKey"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogoutNotificationAction) name:kUserLogoutNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    for (UIView *view in self.parentViewController.tabBarController.view.subviews) {
        if (view.tag == 100) {
            view.hidden = NO;
        }
    }
    [self refreshViewData];
}

- (void)userLogoutNotificationAction
{
    _centerDataFetcher = nil;
}

#pragma mark -
#pragma mark - Action

- (IBAction)settingBarButtonItemAction:(UIBarButtonItem *)sender {
    UIViewController *settingVC = [[UIStoryboard storyboardWithName:@"PersonalSetting" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
    [self.navigationController pushViewController:settingVC animated:YES];
}

- (void)verifyButtonAction
{
    [KGModal sharedInstance].tapOutsideToDismiss = NO;
    [KGModal sharedInstance].modalBackgroundColor = [UIColor clearColor];
    [[KGModal sharedInstance] showWithContentView:self.identificationView andAnimated:YES];
}

#pragma mark -
#pragma mark - Inner

- (void)refreshViewData
{
    __weak __typeof(self)weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [self.centerDataFetcher fetchUserCenterDataWithCompletionHandler:^(NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (error) {
            [strongSelf showTopMessage:[error localizedDescription]];
        } else {
            [strongSelf pasteUserInfoOnView];
        }
        [MBProgressHUD hideAllHUDsForView:strongSelf.navigationController.view animated:YES];
    }];
}

- (void)pasteUserInfoOnView
{
    //////
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.centerDataFetcher.avatarUrlText] placeholderImage:[UIImage imageNamed:@"个人详情头像-默认.png"]];
    self.nickNameLabel.text = self.centerDataFetcher.nickName;
    self.levelLabel.text = [NSString stringWithFormat:@"LV%@",self.centerDataFetcher.level];
    if (![self.centerDataFetcher.school isKindOfClass:[NSNull class]]) {
        self.schoolNameLabel.text = self.centerDataFetcher.school;
    }
   // self.integrityLabel.text = [UserModel currentUser].integrity;
    self.intergrityProgress.progress = [self.centerDataFetcher.integrity longLongValue]/100.0;
    [self.menuTableView reloadData];
}

#pragma mark -
#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }else
    {
        return 1;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.1;
    }else
    {
        return 15;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    PersonalPageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kMeunTableViewCellKey" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    if (section == 1) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.menuTitleLabel.text = @"学生证认证";
        cell.leftConstraint.constant = 75;
        cell.accessoryType = NO;
        cell.numberLabel.hidden = YES;
        __weak __typeof(self)weakSelf = self;
        cell.verifyButtonAction = ^(){
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf verifyButtonAction];
        };
        NSInteger verifyStatus = [self.centerDataFetcher.certificationInfoDict[@"certStatus"] integerValue];
        if (verifyStatus == 1) {
            //认证通过
            cell.verifyButton.enabled = NO;
            [cell.verifyButton setTitle:@"认证通过" forState:UIControlStateNormal];
        } else if (verifyStatus == 0) {
            //审核中
            cell.verifyButton.enabled = NO;
            [cell.verifyButton setTitle:@"认证审核中" forState:UIControlStateNormal];
        } else if (verifyStatus == -2 || verifyStatus == -1) {
            //未提交申请或者审核失败
            cell.verifyButton.enabled = YES;
            [cell.verifyButton setTitle:@"立即认证" forState:UIControlStateNormal];
        }
    }else
    {
        if (indexPath.row == 0)
        {
            cell.menuTitleLabel.text = @"出售";
            cell.verifyButton.hidden = YES;
            //cell.numberLabel.text = [NSString stringWithFormat:@"%@个",self.centerDataFetcher.totalSaleCount];
        }else if (indexPath.row == 1)
        {
            cell.menuTitleLabel.text = @"求购";
            cell.verifyButton.hidden = YES;
            //cell.numberLabel.text = [NSString stringWithFormat:@"%@个",self.centerDataFetcher.totalWantedCount];
        }else if (indexPath.row == 2)
        {
            cell.menuTitleLabel.text = @"收藏";
            cell.verifyButton.hidden = YES;
            //cell.numberLabel.text = [NSString stringWithFormat:@"%@个",self.centerDataFetcher.favoriteGoodCount];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    
    if (section == 0) {
        for (UIView *view in self.parentViewController.tabBarController.view.subviews) {
            if (view.tag == 100) {
                view.hidden = YES;
            }
        }
        if (indexPath.row == 0)
        {
            [self performSegueWithIdentifier:@"kUserCenterGoodListSegue" sender:self];
        }else if (indexPath.row == 1)
        {
            [self performSegueWithIdentifier:@"kUserCenterAskListSegue" sender:self];
        }else if (indexPath.row == 2)
        {
            [self performSegueWithIdentifier:@"kUserCenterCollectionListSegue" sender:self];
        }
    }
}

- (void)photoTapped
{
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"编辑个人信息", nil];
    [action showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self performSegueWithIdentifier:@"kProfileEditSegue" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier  isEqual: @"kProfileEditSegue"]) {
        PersonalProfileEditVCViewController *profileVc = segue.destinationViewController;
        profileVc.avatarText = self.centerDataFetcher.avatarUrlText;
        profileVc.nickName = self.centerDataFetcher.nickName;
    }
}


@end
