//
//  CreateGoodViewController.m
//  TXXE
//
//  Created by River on 15/6/6.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "CreateGoodViewController.h"
#import "PhotoCollectionCell.h"
#import <SDWebImageDownloader.h>
#import "SimplifyActionSheet.h"
#import "SimplifyAlertView.h"
#import <CTAssetsPickerController.h>
#import "Constants.h"
#import <MBProgressHUD.h>
#import "UIViewController+TopBarMessage.h"
#import "LengthLimitedInputView.h"
#import "NSString+Addition.h"
#import "UIView+Addition.h"
#import "UITextField+Addition.h"

static const NSInteger kMaxCountOfGoodImages = 8;

@interface CreateGoodViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CTAssetsPickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *addPhotoButton;
@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;
@property (weak, nonatomic) IBOutlet LengthLimitedInputView *goodTitleTextField;
@property (weak, nonatomic) IBOutlet LengthLimitedInputView *goodDescriptionTextView;
@property (weak, nonatomic) IBOutlet LengthLimitedInputView *goodPriceTextField;


@end

@implementation CreateGoodViewController

- (CreateGoodModel *)createGoodModel
{
    if (!_createGoodModel) {
        _createGoodModel = [[CreateGoodModel alloc]init];
    }
    return _createGoodModel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.0/255 green:191.0/255 blue:121.0/255 alpha:1.0];
    // Do any additional setup after loading the view.
    [self.photoCollectionView registerNib:[UINib nibWithNibName:@"PhotoCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"kPhotoReuseCellKey"];
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    [self configureSubView];
   
}
- (void)setSeletedImage:(UIImage *)image model:(ImageModel *)tempImageModel
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        tempImageModel.orignalImage = image;
        if ([tempImageModel saveImageOnDiskWithSize:CGSizeMake(600, 600)]) {
            [self.createGoodModel.localImageModels addObject:tempImageModel];
            self.photoCollectionView.hidden = NO;
            self.addPhotoButton.hidden = NO;
            
            if (self.createGoodModel.localImageModels.count == kMaxCountOfGoodImages) {
                self.addPhotoButton.hidden = YES;
            }
            
            [self.photoCollectionView reloadData];
        } else {
            NSLog(@"保存失败");
        }
        [self.photoCollectionView reloadData];
    });
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.createGoodModel.netImageUrlTexts.count != 0)
    {
        self.title = @"编辑";
        for (NSString *urlText in self.createGoodModel.netImageUrlTexts) {
            NSURL *url = [NSURL URLWithString:urlText];
            ImageModel *tempImageModel = [[ImageModel alloc]init];
            [[SDWebImageDownloader sharedDownloader]downloadImageWithURL:url options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                //
            } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                if (finished) {
                    [self setSeletedImage:image model:tempImageModel];
                }
            }];
        }
    }else{
        self.title = @"发布";
    }
    if (![NSString isNullOrNilOrEmpty:self.createGoodModel.goodTitle]) {
        self.goodTitleTextField.text = self.createGoodModel.goodTitle;
    }
    if (![NSString isNullOrNilOrEmpty:self.createGoodModel.goodPrice]) {
        self.goodPriceTextField.text = self.createGoodModel.goodPrice;
    }
    if (![NSString isNullOrNilOrEmpty:self.createGoodModel.goodDescription]) {
        self.goodDescriptionTextView.text = self.createGoodModel.goodDescription;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.createGoodModel.goodDescription= self.goodDescriptionTextView.text;
    self.createGoodModel.goodPrice = self.goodPriceTextField.text;
    self.createGoodModel.goodTitle = self.goodTitleTextField.text;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark - Inner
- (void)configureSubView
{
    self.goodDescriptionTextView.currentType = InputViewTypeTextView;
    self.goodDescriptionTextView.maxLengthOfInputText = 200;
    self.goodDescriptionTextView.font = [UIFont systemFontOfSize:13];
    self.goodDescriptionTextView.placeholder = @"商品描述，不少于15个字";
    __weak __typeof(self)weakSelf = self;
    self.goodDescriptionTextView.outOfLimitBlock = ^(id inputView){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf showTopMessage:[NSString stringWithFormat:@"商品描述不能超过%@个字！",@(strongSelf.goodDescriptionTextView.maxLengthOfInputText)]];
    };
    
    
    self.goodPriceTextField.currentType = InputViewTypeTextField;
    ((UITextField *)self.goodPriceTextField.inputEareView).keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    //[((UITextField *)self.goodPriceTextField.inputEareView) setTextCapLeftViewLength:10 leftView:nil rightViewLength:0 rightView:nil];
    self.goodPriceTextField.maxLengthOfInputText = 10;
    self.goodPriceTextField.font = [UIFont systemFontOfSize:13];
    self.goodPriceTextField.placeholder = @" 商品价格";
    self.goodPriceTextField.outOfLimitBlock = ^(id inputView){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.parentViewController showTopMessage:[NSString stringWithFormat:@"商品价格不能超过%@个字！",@(strongSelf.goodPriceTextField.maxLengthOfInputText)]];
    };
    
    self.goodTitleTextField.currentType = InputViewTypeTextField;
    //[((UITextField *)self.goodTitleTextField.inputEareView) setTextCapLeftViewLength:10 leftView:nil rightViewLength:0 rightView:nil];
    self.goodTitleTextField.maxLengthOfInputText = 30;
    self.goodTitleTextField.font = [UIFont systemFontOfSize:13];
    self.goodTitleTextField.placeholder = @" 商品名称";
    self.goodTitleTextField.outOfLimitBlock = ^(id inputView){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.parentViewController showTopMessage:[NSString stringWithFormat:@"商品名称不能超过%@个字！",@(strongSelf.goodTitleTextField.maxLengthOfInputText)]];
    };
    for (UIView *view in @[self.goodDescriptionTextView,self.goodPriceTextField,self.goodTitleTextField]) {
        view.backgroundColor = [UIColor whiteColor];
        [view drawBorderStyleWithBorderWidth:1 borderColor:RGB_COLOR(213, 213, 213, 1.0) cornerRadius:5];
    }
}



#pragma mark -
#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.createGoodModel.localImageModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"kPhotoReuseCellKey" forIndexPath:indexPath];
    ImageModel *imageModel = self.createGoodModel.localImageModels[indexPath.item];
    cell.imageModel = imageModel;
    __weak __typeof(self)weakSelf = self;
    cell.clickBlock =  ^(UIButton *sender){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf deleteWithImage:imageModel];
    };
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(70, 70);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(15, 14, 15, 14);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 8;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 8;
}

/*- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    PhotoFooterReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"kPhotoReuseFooterKey" forIndexPath:indexPath];
    __weak __typeof(self)weakSelf = self;
    footer.addPhotoButtonAction = ^(){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf addPhotoAction];
    };
    return footer;
}*/


- (void)deleteWithImage:(ImageModel *)imageModel
{
    __weak __typeof(self)weakSelf = self;
    [SimplifyAlertView alertWithTitle:@"" message:@"是否确认删除？" operationResult:^(NSInteger selectedIndex) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (selectedIndex == 0) {
            NSLog(@"66666");
            
        }else if (selectedIndex == 1)
        {
            [MBProgressHUD showHUDAddedTo:strongSelf.navigationController.view animated:YES];
            [self.createGoodModel.localImageModels removeObject:imageModel];
            [self.photoCollectionView reloadData];
            [MBProgressHUD hideAllHUDsForView:strongSelf.navigationController.view animated:YES];
        }
    } cancelButtonTitle:@"取消" otherButtonTitles:@"确认删除", nil];
}

#pragma mark -

- (void)addPhotoAction
{
    NSMutableArray *availableSourceTypeNames = [NSMutableArray arrayWithCapacity:3];
    UIImagePickerControllerSourceType sourceType = -1;
    for (sourceType = UIImagePickerControllerSourceTypePhotoLibrary; sourceType <= UIImagePickerControllerSourceTypeCamera; ++sourceType) {
        if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
            [availableSourceTypeNames addObject:@[@"相册",@"拍照"][sourceType]];
        }
    }
    [availableSourceTypeNames addObject:@"取消"];
    [SimplifyActionSheet actionSheetWithTitle:nil buttonTitles:availableSourceTypeNames showingStyle:^(UIActionSheet *actionSheetSelf) {
        [actionSheetSelf showInView:THE_APP_DELEGATE.window];
    } operationResult:^(NSInteger selectedIndex, NSString *selectedButtonTitle) {
        UIImagePickerControllerSourceType sourceType = -1;
        sourceType = [availableSourceTypeNames indexOfObject:selectedButtonTitle];
        if ((NSInteger)sourceType != NSNotFound && ((NSInteger)sourceType != -1) && (selectedIndex != 2)) {
            if (sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
                //相册
                DISPATCH_MAIN(^(){
                    CTAssetsPickerController *picker = [[CTAssetsPickerController alloc]init];
                    picker.assetsFilter = [ALAssetsFilter allPhotos];
                    picker.showsCancelButton = (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad);
                    picker.delegate = self;
                    [self presentViewController:picker animated:YES completion:nil];
                    NSLog(@"123");
                });
            }else if (sourceType == UIImagePickerControllerSourceTypeCamera)
            {
                UIImagePickerController *picker = [[UIImagePickerController alloc]init];
                picker.sourceType = sourceType;
                picker.delegate = self;
                [self presentViewController:picker animated:YES completion:nil];
            }
        }else{
            NSLog(@"取消了");
        }
    } destructiveButtonIndex:-1 cancelButtonIndex:availableSourceTypeNames.count-1];
}

#pragma mark -
#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"处理照片";
    
    ImageModel *tempImageModel = [[ImageModel alloc]init];
    tempImageModel.orignalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    if ([tempImageModel saveImageOnDiskWithSize:CGSizeMake(600, 600)]) {
        [self.createGoodModel.localImageModels addObject:tempImageModel];
        self.photoCollectionView.hidden = NO;
        self.addPhotoButton.hidden = NO;
        if (self.createGoodModel.localImageModels.count == kMaxCountOfGoodImages) {
            
        }
        [self.photoCollectionView reloadData];
    }else{
        NSLog(@"保存失败");
    }
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -action
- (IBAction)addPhotoButtonAction:(UIButton *)sender {
    [self addPhotoAction];
}
- (IBAction)cancelCreateBarBtnItemAction:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)nextStepBarBtnAction:(UIBarButtonItem *)sender {
    [self viewUpdate];
    if ([self isValidToSubmit]) {
        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:self.createGoodModel,@"goodModel",nil];
    //创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"transGoodModel" object:nil userInfo:dict];
    //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        [self performSegueWithIdentifier:@"kGoNextCreatePageSegue" sender:self];
    }
}

- (void)viewUpdate
{
    self.createGoodModel.goodDescription= self.goodDescriptionTextView.text;
    self.createGoodModel.goodPrice = self.goodPriceTextField.text;
    self.createGoodModel.goodTitle = self.goodTitleTextField.text;
}

#pragma mark - Assets Picker Delegate

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker isDefaultAssetsGroup:(ALAssetsGroup *)group
{
    return ([[group valueForProperty:ALAssetsGroupPropertyType]integerValue] == ALAssetsGroupSavedPhotos);
}

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"处理照片";
    for (ALAsset *asset in assets) {
        ImageModel *tempImageModel = [[ImageModel alloc]init];
        tempImageModel.orignalImage =  [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        if ([tempImageModel saveImageOnDiskWithSize:CGSizeMake(600, 600)]) {
            [self.createGoodModel.localImageModels addObject:tempImageModel];
            self.photoCollectionView.hidden = NO;
            self.addPhotoButton.hidden = NO;
            if (self.createGoodModel.localImageModels.count == kMaxCountOfGoodImages) {
                
            }
            [self.photoCollectionView reloadData];
        }else{
            NSLog(@"保存失败");
        }
    }
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
}

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldEnableAsset:(ALAsset *)asset
{
    return YES;
}

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldSelectAsset:(ALAsset *)asset
{
    BOOL should = YES;
    if (picker.selectedAssets.count >= (kMaxCountOfGoodImages - self.createGoodModel.localImageModels.count)) {
        should = NO;
                UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:nil
                                   message:[NSString stringWithFormat:@"选择的图片不能超过%@张",@(kMaxCountOfGoodImages - self.createGoodModel.localImageModels.count)]
                                  delegate:nil
                         cancelButtonTitle:nil
                         otherButtonTitles:@"确定", nil];
        
        [alertView show];
    }
    
    if (!asset.defaultRepresentation) {
        should = NO;
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"图片库还没有下载到本地" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    return should;
}


- (BOOL)isValidToSubmit
{
    NSString *tipsText = nil;
    if (self.createGoodModel.localImageModels.count == 0) {
        tipsText = @"请选择图片后再发布！";
    } else if (self.createGoodModel.goodTitle.length == 0){
        tipsText = @"请选择商品名称";
    } else if (![NSString convertToNumberForString:self.createGoodModel.goodPrice]){
        tipsText = @"请填写价格";
    } else if(self.createGoodModel.goodDescription.length < 15){
        tipsText = @"商品描述不少于15个字";
    }
    
    if (tipsText) {
        NSString *title = @"";
        if (self.createGoodModel.netImageUrlTexts.count == 0) {
            title = @"发布提醒";
        } else {
            title = @"编辑提醒";
        }
        
        [[[UIAlertView alloc] initWithTitle:title message:tipsText delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]show];
    }
    return (tipsText == nil);
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
