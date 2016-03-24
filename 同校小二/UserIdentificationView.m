//
//  UserIdentificationView.m
//  TongxiaoXiaoEr
//
//  Created by IOS－001 on 15/3/12.
//  Copyright (c) 2015年 com.xxxxxx. All rights reserved.
//

#import "UserIdentificationView.h"
#import <SDWebImageCompat.h>
#import "SimplifyActionSheet.h"
#import "Constants.h"
#import <MBProgressHUD.h>
#import "ImageModel.h"
#import "NetController.h"
#import "UserModel.h"
#import <KGModal.h>

@interface UserIdentificationView () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *identifyImageView;
@property (nonatomic , strong) ImageModel *imageModel;

@end

@implementation UserIdentificationView

- (ImageModel *)imageModel
{
    if (!_imageModel) {
        _imageModel = [[ImageModel alloc] init];
    }
    return _imageModel;
}

- (IBAction)uploadButton:(UIButton *)sender
{
    [self takePhotoAction];
}


- (IBAction)confirmButton:(UIButton *)sender
{
    if (self.imageModel.localImagePath.length != 0) {
        //上传认证图片
        //上传成功后，自动消失这个视图
        [MBProgressHUD showHUDAddedTo:self animated:YES];
        [ImageModel uploadForLocalImages:@[self.imageModel] completionHandler:^(NSError *error, NSArray *imageUrlTexts) {
            if (error) {
                NSLog(@"认证图片上传失败");
                [MBProgressHUD hideHUDForView:self animated:YES];
            } else {
                //提交认证
                [[NetController sharedInstance] postWithAPI:API_user_verify parameters:@{@"memberId":[UserModel currentUser].memberId,@"img":imageUrlTexts.firstObject} completionHandler:^(id responseObject, NSError *error) {
                    if (error) {
                        NSLog(@"认证失败error = %@",error);
                    } else {
                        if (self.confirmBtnActionBlock) {
                            DISPATCH_MAIN(^(){
                                self.confirmBtnActionBlock(YES);
                            });
                        }
                    }
                    [MBProgressHUD hideHUDForView:self animated:YES];
                }];
            }
        }];
    } else {
        if (self.confirmBtnActionBlock) {
            //        dispatch_main_async_safe(self.confirmBtnActionBlock);
            DISPATCH_MAIN(^(){
                self.confirmBtnActionBlock(NO);
            });
        }
    }
}

#pragma mark -
#pragma mark - 

- (void)takePhotoAction
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
                                 } operationResult:^(NSInteger selectedIndex,NSString *selectedButtonTitle) {
                                     UIImagePickerControllerSourceType sourceType = -1;
                                     sourceType = [availableSourceTypeNames indexOfObject:selectedButtonTitle];
                                     if (((NSInteger)sourceType != NSNotFound) && ((NSInteger)sourceType != -1) && (selectedIndex != 2)) {
                                         //                                         NSLog(@"可以弹出来type = %d",sourceType);
                                         //                                         NSLog(@"最终的选择sourceType = %d",sourceType);
                                         UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                         picker.sourceType = sourceType;
                                         picker.delegate = self;
                                         [[KGModal sharedInstance] hideAnimated:NO];
                                         [[self getCurrentVC] presentViewController:picker animated:YES completion:NULL];
                                     } else {
                                         NSLog(@"取消了");
                                     }
                                 } destructiveButtonIndex:-1 cancelButtonIndex:availableSourceTypeNames.count - 1];
}

- (void)showModalView
{
    //[KGModal sharedInstance].closeButtonType = KGModalCloseButtonTypeNone;
    [KGModal sharedInstance].tapOutsideToDismiss = NO;
    //[KGModal sharedInstance].borderWidth = 0;
    [KGModal sharedInstance].modalBackgroundColor = [UIColor clearColor];
    [[KGModal sharedInstance] showWithContentView:self andAnimated:YES];
}

#pragma mark -
#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.labelText = @"处理照片";
    //保存到Tmp目录，将image的路径返回回来
    
    self.imageModel.orignalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    if ([self.imageModel saveImageOnDiskWithSize:CGSizeMake(500, 500)]) {
        [self.identifyImageView setImage:[UIImage imageWithContentsOfFile:self.imageModel.localImagePath]];
        self.confirmbBtn.hidden = NO;
    } else {
        NSLog(@"保存失败");
    }
    
    [MBProgressHUD hideAllHUDsForView:self animated:YES];
//    [self showModalView];
    [picker dismissViewControllerAnimated:YES completion:^{
        //
        [self showModalView];
        
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [picker dismissViewControllerAnimated:YES completion:^{
        //
        [self showModalView];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
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
@end
