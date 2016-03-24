//
//  SettingViewController.m
//  TXXE
//
//  Created by 李雨龙 on 15/7/20.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "SettingViewController.h"
#import "UserModel.h"
#import "Constants.h"
#import "SimplifyActionSheet.h"
#import "UIView+Addition.h"
#import "Constants.h"

@interface SettingViewController ()


@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.0/255 green:191.0/255 blue:121.0/255 alpha:1.0];
    [self.btn1 setTitleColor:[UIColor colorWithRed:166/255.0 green:166/255.0 blue:166/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.btn2 setTitleColor:[UIColor colorWithRed:166/255.0 green:166/255.0 blue:166/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.btn3 setTitleColor:[UIColor colorWithRed:166/255.0 green:166/255.0 blue:166/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.btn4 setTitleColor:[UIColor colorWithRed:166/255.0 green:166/255.0 blue:166/255.0 alpha:1.0] forState:UIControlStateNormal];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    for (UIView *view in self.parentViewController.tabBarController.view.subviews) {
        if (view.tag == 100) {
            view.hidden = YES;
        }
    }
    
}


#pragma mark -
#pragma mark - UITableViewDataSource & UITableViewDelegate

/*- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}*/
/*
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell.backgroundView removeFromSuperview];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
    cell.textLabel.textColor = RGB_COLOR(124, 124, 124, 1);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kSettingTableViewCellReuseKey" forIndexPath:indexPath];
    NSDictionary *attribute = self.settingDataSource[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:attribute[@"kImagePath"]];
    cell.textLabel.text = attribute[@"kTitleKey"];
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self performSegueWithIdentifier:@"kSettingAboutUsSegue" sender:self];
    } else if (indexPath.row == 1) {
        [self performSegueWithIdentifier:@"kSettingEditionUpdateSegue" sender:self];
    } else if (indexPath.row == 2) {
        [self performSegueWithIdentifier:@"kSettingFeedbackSegue" sender:self];
    } else if (indexPath.row == 3) {
        [self performSegueWithIdentifier:@"kSettingScoreDetailSegue" sender:self];
    }
}*/

- (IBAction)AboutUsBtnAction:(id)sender {
     [self performSegueWithIdentifier:@"kSettingAboutUsSegue" sender:self];
}
- (IBAction)VersionUpadateBtnAction:(id)sender {
    [self performSegueWithIdentifier:@"kSettingEditionUpdateSegue" sender:self];
}
- (IBAction)SuggestionBtnAction:(id)sender {
    [self performSegueWithIdentifier:@"kSettingFeedbackSegue" sender:self];
}
- (IBAction)ScoreDetailBtnAction:(id)sender {
    [self performSegueWithIdentifier:@"kSettingScoreDetailSegue" sender:self];
}

- (IBAction)logOutAction:(id)sender {
    
    __weak __typeof(self)weakSelf = self;
    [SimplifyActionSheet actionSheetWithTitle:@"是否确认退出登录？" buttonTitles:@[@"退出登录",@"不退出"]
                                 showingStyle:^(UIActionSheet *actionSheetSelf) {
                                     [actionSheetSelf showInView:self.view];
                                 } operationResult:^(NSInteger selectedIndex, NSString *selectedButtonTitle) {
                                     if (selectedIndex == 0) {
                                         [[UserModel currentUser] logout];
                                         __strong __typeof(weakSelf)strongSelf = weakSelf;
                                        
                                        /* DISPATCH_MAIN(^(){
                                             [strongSelf.tableView reloadData];
                                         });*/
                                         NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:nil];
                                         
                                         //创建通知
                                         NSNotification *notification =[NSNotification notificationWithName:@"logout" object:nil userInfo:dict];
                                         //通过通知中心发送通知
                                         [[NSNotificationCenter defaultCenter] postNotification:notification];
                                         NSNotification *notification1 =[NSNotification notificationWithName:@"logoutandmemberid" object:nil userInfo:nil];
                                         //通过通知中心发送通知
                                         [[NSNotificationCenter defaultCenter] postNotification:notification1];
                                         [self.navigationController popViewControllerAnimated:YES];
                                     } else if (selectedIndex == 1) {
                                         
                                     }
                                 } destructiveButtonIndex:0 cancelButtonIndex:1];
    
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
