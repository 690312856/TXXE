//
//  PersonalProfileEditVCViewController.m
//  TXXE
//
//  Created by 李雨龙 on 15/7/19.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "PersonalProfileEditVCViewController.h"
#import "ProfileEditingTableViewCell.h"
#import "SchoolSelectViewController.h"
#import <UIImageView+WebCache.h>
#import "UIView+Addition.h"
#import "SimplifyActionSheet.h"
#import "UserModel.h"
#import "Constants.h"
#import <MBProgressHUD.h>
#import "SelectLikeCategoryViewController.h"
#import "EditMobilePhoneViewController.h"

@interface PersonalProfileEditVCViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic , strong) UserModel *cachedUserModel;
@end

@implementation PersonalProfileEditVCViewController
- (UserModel *)cachedUserModel
{
    if (!_cachedUserModel) {
        _cachedUserModel = [[UserModel alloc] init];
        NSLog(@"$$$$$%@",[UserModel currentUser]);
        [_cachedUserModel setValuesForKeysWithDictionary:[[UserModel currentUser] convertToDictionary]];
    }
    return _cachedUserModel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemAction)];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.0/255 green:191.0/255 blue:121.0/255 alpha:1.0];
    [self.tableView registerNib:[UINib nibWithNibName:@"ProfileEditingTableViewCell" bundle:nil] forCellReuseIdentifier:@"kProfileEditingTableViewCellKey"];
    self.photoImageView.backgroundColor = [UIColor grayColor];
    [self.photoImageView drawBorderStyleWithBorderWidth:0 borderColor:[UIColor clearColor] cornerRadius:self.photoImageView.frame.size.height * 0.5];
    self.photoImageView.userInteractionEnabled = YES;
    self.cachedUserModel.nickName = self.nickName;
    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:self.avatarText] placeholderImage:nil];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoTapped)];
    [self.photoImageView addGestureRecognizer:singleTap];//点击图片事件

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
            view.hidden = YES;
        }
    }
}
#pragma mark -
#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        UIView *view= [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 30)];
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, tableView.frame.size.width-15, 8)];
    
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, tableView.frame.size.width-15, 8)];
        label1.text = @"1.您的个人信息不会被泄漏";
        [label1 setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:6]];
        label2.text = @"2.支付宝账号仅用于活动红包发放";
        [label2 setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:6]];
        [view addSubview:label1];
        [view addSubview:label2];
         return view;
    }
    return nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 5;
    }
    return 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.1;
    }else
    {
        return 5;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger section = indexPath.section;
    ProfileEditingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kProfileEditingTableViewCellKey" forIndexPath:indexPath];
    if (section == 0) {
        if (indexPath.row == 0) {
            cell.profileItemLabel.text = @"昵称";
            cell.label1.hidden = YES;
            cell.label2.hidden = YES;
            cell.label3.hidden = YES;
            cell.textFieldValueChanged = ^(NSString *text){
                self.cachedUserModel.nickName = text;
            };
            cell.profileItemTextField.text = self.nickName;
        } else if (indexPath.row == 1) {
            cell.profileItemLabel.text = @"学校";
            cell.label1.hidden = YES;
            cell.label2.hidden = YES;
            cell.label3.hidden = YES;
            cell.textFieldValueChanged = ^(NSString *text){
                self.cachedUserModel.school.schoolName = text;
            };
            cell.profileItemTextField.enabled = NO;
            cell.profileItemTextField.text = self.cachedUserModel.school.schoolName;
        } else if (indexPath.row == 2) {
            cell.profileItemLabel.text = @"手机";
            cell.label1.hidden = YES;
            cell.label2.hidden = YES;
            cell.label3.hidden = YES;
            cell.textFieldValueChanged = ^(NSString *text){
                self.cachedUserModel.mobileNumber = text;
            };
            cell.profileItemTextField.text = self.cachedUserModel.mobileNumber;
            cell.profileItemTextField.enabled = NO;
        } else if (indexPath.row == 3) {
            cell.profileItemLabel.text = @"QQ";
            cell.label1.hidden = YES;
            cell.label2.hidden = YES;
            cell.label3.hidden = YES;
            cell.textFieldValueChanged = ^(NSString *text){
                self.cachedUserModel.qq = text;
            };
            cell.profileItemTextField.text = self.cachedUserModel.qq;
        } else if (indexPath.row == 4) {
            cell.profileItemLabel.text = @"我喜欢的";
            NSLog(@"ffffffffffffff%@",self.cachedUserModel.preferences);
            preference = self.cachedUserModel.preferences;
            if (![self.cachedUserModel.preferences isEqualToString:@""]) {
                NSArray *list = [self.cachedUserModel.preferences componentsSeparatedByString:@","];
                
                switch ([list count]) {
                    
                    case 1:
                        cell.label1.text = [self showText:list[0]];
                        cell.label1.hidden = NO;
                        cell.label1.textColor = [UIColor colorWithRed:0.0/255 green:191.0/255 blue:121.0/255 alpha:1.0];
                        cell.label2.hidden = YES;
                        cell.label3.hidden = YES;
                        break;
                    case 2:
                        cell.label1.text = [self showText:list[0]];
                        cell.label2.text = [self showText:list[1]];
                        cell.label1.textColor = [UIColor colorWithRed:0.0/255 green:191.0/255 blue:121.0/255 alpha:1.0];
                        cell.label2.textColor = [UIColor colorWithRed:0.0/255 green:191.0/255 blue:121.0/255 alpha:1.0];
                        cell.label1.hidden = NO;
                        cell.label2.hidden = NO;
                        cell.label3.hidden = YES;
                        break;
                    default:
                        cell.label1.text = [self showText:list[0]];
                        cell.label2.text = [self showText:list[1]];
                        cell.label3.text = @"...";
                        cell.label1.textColor = [UIColor colorWithRed:0.0/255 green:191.0/255 blue:121.0/255 alpha:1.0];
                        cell.label2.textColor = [UIColor colorWithRed:0.0/255 green:191.0/255 blue:121.0/255 alpha:1.0];
                        cell.label3.textColor = [UIColor colorWithRed:0.0/255 green:191.0/255 blue:121.0/255 alpha:1.0];
                        cell.label1.hidden = NO;
                        cell.label2.hidden = NO;
                        cell.label3.hidden = NO;
                        break;
                }
            }else
            {
                cell.label1.hidden = YES;
                cell.label2.hidden = YES;
                cell.label3.hidden = YES;
            
            }
            
            cell.profileItemTextField.hidden = YES;
        } 
    }else
    {
       // [cell.profileItemTextField becomeFirstResponder];
        cell.profileItemLabel.text = @"支付宝账号";
        cell.label1.hidden = YES;
        cell.label2.hidden = YES;
        cell.label3.hidden = YES;
        cell.textFieldValueChanged = ^(NSString *text){
            self.cachedUserModel.alipayAccount = text;
        };
        cell.profileItemTextField.text = self.cachedUserModel.alipayAccount;

    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    if (section == 0) {
        if (indexPath.row == 1) {
            SchoolSelectViewController *schoolSelectVC = [[SchoolSelectViewController alloc] init];
            schoolSelectVC.shouldCacheSelection = NO;
            schoolSelectVC.finishedSchoolPickBlock = ^(SchoolModel *pickedSchool){
                self.cachedUserModel.school = pickedSchool;
                DISPATCH_MAIN(^(){
                    [self.tableView reloadData];
                });
            };
            [self.navigationController pushViewController:schoolSelectVC animated:YES];
        }else if (indexPath.row == 2)
        {
            EditMobilePhoneViewController *MobilePhoneEditVC = [[EditMobilePhoneViewController alloc]init];
            MobilePhoneEditVC.finishedMobilePhonePickBlock = ^(NSString * pickedMobilePhone)
            {
                self.cachedUserModel.mobileNumber = pickedMobilePhone;
                DISPATCH_MAIN(^(){
                    [self.tableView reloadData];
                });
            };
            [self.navigationController pushViewController:MobilePhoneEditVC animated:YES];
        }else if (indexPath.row == 4)
        {
            SelectLikeCategoryViewController *likeSelectVC = [[SelectLikeCategoryViewController alloc]init];
            likeSelectVC.preference = preference;
            likeSelectVC.finishedLikeCategoryPickBlock = ^(NSString * pickedCategory)
            {
                self.cachedUserModel.preferences = pickedCategory;
                DISPATCH_MAIN(^(){
                    [self.tableView reloadData];
                });
            };
            [self.navigationController pushViewController:likeSelectVC animated:YES];
        }
    }
}
- (void)photoTapped
{
    NSMutableArray *availableSourceTypeNames = [NSMutableArray arrayWithCapacity:3];
    UIImagePickerControllerSourceType sourceType = -1;
    for (sourceType = UIImagePickerControllerSourceTypePhotoLibrary; sourceType <= UIImagePickerControllerSourceTypeCamera; ++sourceType) {
        if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
            [availableSourceTypeNames addObject:@[@"相册", @"拍照"][sourceType]];
        }
    }
    [availableSourceTypeNames addObject:@"取消"];
    [SimplifyActionSheet actionSheetWithTitle:nil
                                 buttonTitles:availableSourceTypeNames
                                 showingStyle:^(UIActionSheet *actionSheetSelf) {
                                     [actionSheetSelf showInView:THE_APP_DELEGATE.window];
                                 }
                              operationResult:^(NSInteger selectedIndex,NSString *selectedButtonTitle) {
                                  UIImagePickerControllerSourceType sourceType = -1;
                                  sourceType = [availableSourceTypeNames indexOfObject:selectedButtonTitle];
                                  if (![selectedButtonTitle isEqualToString:@"取消"] && ((NSInteger)sourceType != NSNotFound) && ((NSInteger)sourceType != -1) && (selectedIndex != 2)) {
                                      if (sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
                                          //相册
                                          UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                          picker.sourceType = sourceType;
                                          picker.delegate = self;
                                          [self presentViewController:picker animated:YES completion:NULL];
                                          
                                      } else if (sourceType == UIImagePickerControllerSourceTypeCamera) {
                                          UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                          picker.sourceType = sourceType;
                                          picker.delegate = self;
                                          [self presentViewController:picker animated:YES completion:NULL];
                                      }
                                  } else {
                                      NSLog(@"取消了");
                                  }
                                  
                              }
                       destructiveButtonIndex:-1
                            cancelButtonIndex:availableSourceTypeNames.count - 1];
}

#pragma mark -
#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"处理照片";
    //保存到Tmp目录，将image的路径返回回来
    
    ImageModel *tempImageModel = [[ImageModel alloc] init];
    tempImageModel.orignalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    if ([tempImageModel saveImageOnDiskWithSize:CGSizeMake(300, 300)]) {
        UIImage *image = [UIImage imageWithContentsOfFile:tempImageModel.localImagePath];
        [self.photoImageView setImage:image];
    } else {
        NSLog(@"保存失败");
    }
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        //
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [picker dismissViewControllerAnimated:YES completion:^{
        //
    }];
}


- (void)rightBarButtonItemAction
{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    if ([self.cachedUserModel isValidToSubmit] != YES) {
        [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
        return;
    }else
    {
    __weak __typeof(self)weakSelf = self;
    [self alterAvatarWithCompletionHandler:^(NSError *error,NSString *absFilePath) {
        if (error) {
            [[[UIAlertView alloc] initWithTitle:nil message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        } else {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf.cachedUserModel updateProfileInfoWithCompletionHandler:^(NSError *error) {
                [MBProgressHUD hideAllHUDsForView:strongSelf.navigationController.view animated:YES];
                if (error) {
                    [[[UIAlertView alloc] initWithTitle:@"修改个人信息失败" message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
                } else {
                    
                    [[UserModel currentUser] setValuesForKeysWithDictionary:[self.cachedUserModel convertToDictionary]];
                    [UserModel currentUser].avatarUrlText = absFilePath;
                    
                    [[[UIAlertView alloc] initWithTitle:@"成功" message:@"你已经成功修改个人信息！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
                    [strongSelf.navigationController popViewControllerAnimated:YES];
                }
            }];
        }
    }];
    }
}

- (void)alterAvatarWithCompletionHandler:(void(^)(NSError *error,NSString *absFilePath))completionHandler
{
    ImageModel *tempModel = [[ImageModel alloc] init];
    tempModel.orignalImage = self.photoImageView.image;
    [tempModel uploadOrignalImageWithCompletionHandler:^(NSError *error, NSDictionary *callback) {
        if (error) {
            completionHandler(error,nil);
        } else {
            self.cachedUserModel.avatarUrlText = callback[@"filePath"];
            completionHandler(nil,callback[@"absFilePath"]);
        }
    }];
}

- (NSString *)showText:(NSString *)num
{
    if ([num isEqualToString:@"5"]) {
        return @"校园代步";
    }else if ([num isEqualToString:@"4"])
    {
        return @"数码";
    }
    else if ([num isEqualToString:@"7"])
    {
        return @"体育娱乐";
    }
    else if ([num isEqualToString:@"2"])
    {
        return @"书籍";
    }
    else if ([num isEqualToString:@"6"])
    {
        return @"生活日常";
    }else if ([num isEqualToString:@"13"])
    {
        return @"其他";
    }else
    {
        return @"";
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"fgghjfjhf");
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys: nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"tuichubianji" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}
@end
