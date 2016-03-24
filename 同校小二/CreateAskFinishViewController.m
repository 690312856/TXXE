//
//  CreateAskFinishViewController.m
//  TXXE
//
//  Created by River on 15/7/17.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "CreateAskFinishViewController.h"
#import "CreateAskSucceedViewController.h"
#import "UIView+Addition.h"
#import "Constants.h"
#import "UITextField+Addition.h"
#import "LengthLimitedInputView.h"
#import "UIViewController+TopBarMessage.h"
#import "CreatCategorySelectionViewController.h"
#import "NSString+Addition.h"
#import <SDWebImageCompat.h>
#import "CreateSucceedPopOutView.h"
#import "AppDelegate.h"
#import <KGModal.h>
#import "ProgressHudCommon.h"
#import <MBProgressHUD.h>
#import "SchoolSelectViewController.h"

@interface CreateAskFinishViewController ()<UIGestureRecognizerDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *chooseCategoryBtn;
//@property (weak, nonatomic) IBOutlet LengthLimitedInputView *tradePlaceField;
@property (weak, nonatomic) IBOutlet UIButton *schoolSelectBtn;
//@property (weak, nonatomic) IBOutlet UISegmentedControl *nSegment;
@property (weak, nonatomic) IBOutlet LengthLimitedInputView *mobileNoField;
@property (weak, nonatomic) IBOutlet LengthLimitedInputView *qqNumberField;
@property (weak, nonatomic) IBOutlet UIView *selectionBoardView;
@property (weak, nonatomic) IBOutlet UIView *selectionContainView;


@property (nonatomic,strong)CategoryModel *categoriesFetcher;
@property (nonatomic,strong)CreatCategorySelectionViewController *categorySelectionVC;
@property (nonatomic,strong)CreateSucceedPopOutView *succeedPopoutView;

@end

@implementation CreateAskFinishViewController

- (CreateSucceedPopOutView *)succeedPopoutView
{
    if (!_succeedPopoutView) {
        _succeedPopoutView = [[[NSBundle mainBundle] loadNibNamed:@"CreateSucceedPopOutView" owner:self options:nil] firstObject];
        _succeedPopoutView.confirmBtnActionBlock = ^(){
            [[KGModal sharedInstance] hideAnimated:YES withCompletionBlock:^{
                //[THE_APP_DELEGATE.inputViewController dismissViewControllerAnimated:YES completion:NULL];
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
        };
    }
    return _succeedPopoutView;
}
- (CategoryModel *)categoriesFetcher
{
    if (!_categoriesFetcher) {
        _categoriesFetcher = [[CategoryModel alloc] init];
    }
    return _categoriesFetcher;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customedSubViewItems];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.0/255 green:191.0/255 blue:121.0/255 alpha:1.0];
    self.schoolSelectBtn.layer.cornerRadius = 5.0;
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.createAskModel = appDelegate.createAskModel;
    self.createAskModel.isNew = 1;
    if (self.createAskModel.netImageUrlTexts.count != 0) {
        self.title = @"编辑";
    }else
    {
        self.title = @"发布";
    }
    
    self.schoolSelectBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonAction)];
    if (self.childViewControllers.count != 0) {
        self.categorySelectionVC = self.childViewControllers.firstObject;
        self.categorySelectionVC.categoryFetcher = self.categoriesFetcher;
    }
    /*[self.nSegment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    self.nSegment.selectedSegmentIndex = 0;*/
    [self recoveryCreateAskModelData];
}

- (void)customedSubViewItems
{
    for (UIView *subView in @[self.mobileNoField,self.qqNumberField]) {
        [subView drawBorderStyleWithBorderWidth:1 borderColor:RGB_COLOR(213, 213, 213, 1.0) cornerRadius:5];
    }
    for (UIView *subView in @[self.chooseCategoryBtn]) {
        [subView drawBorderStyleWithBorderWidth:1 borderColor:APP_MAIN_COLOR cornerRadius:5];
    }
    
    __weak __typeof(self)weakSelf = self;
   /* self.tradePlaceField.currentType = InputViewTypeTextField;
    ((UITextField *)self.tradePlaceField.inputEareView).delegate = self;
    ((UITextField *)self.tradePlaceField.inputEareView).tag = 1000;
    self.tradePlaceField.maxLengthOfInputText = 50;
    self.tradePlaceField.font = [UIFont systemFontOfSize:13];
    self.tradePlaceField.placeholder = @"交易地点";
    self.tradePlaceField.outOfLimitBlock = ^(id inputView){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf showTopMessage:[NSString stringWithFormat:@"交易地点不能超过%@个字！",@(strongSelf.tradePlaceField.maxLengthOfInputText)]];
    };*/
    
    
    
    self.mobileNoField.currentType = InputViewTypeTextField;
    ((UITextField *)self.mobileNoField.inputEareView).delegate = self;
    ((UITextField *)self.mobileNoField.inputEareView).tag = 2000;
    ((UITextField *)self.mobileNoField.inputEareView).keyboardType = UIKeyboardTypePhonePad;
    self.mobileNoField.maxLengthOfInputText = 11;
    self.mobileNoField.font = [UIFont systemFontOfSize:13];
    self.mobileNoField.placeholder = @"手机号";
    self.mobileNoField.outOfLimitBlock = ^(id inputView){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.parentViewController showTopMessage:[NSString stringWithFormat:@"手机号不能超过%@个字！",@(strongSelf.mobileNoField.maxLengthOfInputText)]];
    };
    
    self.qqNumberField.currentType = InputViewTypeTextField;
    ((UITextField *)self.qqNumberField.inputEareView).delegate = self;
    ((UITextField *)self.qqNumberField.inputEareView).tag = 3000;
    ((UITextField *)self.qqNumberField.inputEareView).keyboardType = UIKeyboardTypeNumberPad;
    self.qqNumberField.maxLengthOfInputText = 11;
    self.qqNumberField.font = [UIFont systemFontOfSize:13];
    self.qqNumberField.placeholder = @"QQ号码";
    self.qqNumberField.outOfLimitBlock = ^(id inputView){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.parentViewController showTopMessage:[NSString stringWithFormat:@"QQ号码不能超过%@个字！",@(strongSelf.qqNumberField.maxLengthOfInputText)]];
    };
    
    
}


- (void)recoveryCreateAskModelData
{
    if (self.createAskModel.selectedCategory) {
        [self setCurrentViewWithCategorySelectionModel];
    }
    //self.tradePlaceField.text = [NSString realForString:self.createAskModel.tradeLocation];
    self.mobileNoField.text = [NSString realForString:self.createAskModel.mobileNumber];
    self.qqNumberField.text = [NSString realForString:self.createAskModel.qqNumber];
    
    if (self.mobileNoField.text.length == 0) {
        self.mobileNoField.text = [NSString realForString:[UserModel currentUser].mobileNumber];
        self.createAskModel.mobileNumber = self.mobileNoField.text;
    }
    if (self.qqNumberField.text.length == 0) {
        self.qqNumberField.text = [NSString realForString:[UserModel currentUser].qq];
        self.createAskModel.qqNumber = self.qqNumberField.text;
    }
    
    [self.schoolSelectBtn setTitle:[NSString realForString:[UserModel currentUser].school.schoolName] forState:UIControlStateNormal];
    
    
    self.createAskModel.selectedSchool = [UserModel currentUser].school;
    /*self.createAskModel.selectedSchool.schoolName = [NSString realForString:[UserModel currentUser].school.schoolName];
        NSLog(@"gggg%@",self.createAskModel.selectedSchool.schoolName);
    self.createAskModel.selectedSchool.schoolID =[NSString realForString:[UserModel currentUser].school.schoolID];
    NSLog(@"ssssss%@",[NSString realForString:[UserModel currentUser].school.schoolName]);
    NSLog(@"iiiiiii%@",[NSString realForString:[UserModel currentUser].school.schoolID]);*/
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)segmentAction:(UISegmentedControl *)Seg
{
    if (Seg.selectedSegmentIndex == 0) {
        self.createAskModel.isNew = 1;
        NSLog(@"1");
    }else
    {
        self.createAskModel.isNew = 0;
        NSLog(@"0");
    }
}

- (BOOL)isValidToSubmit
{
    NSString *tipsText = nil;
    //if (self.createAskModel.localImageModels.count == 0) {
    //    tipsText = @"请选择图片后再发布！";
    //} else
    if (self.createAskModel.askTitle.length == 0){
        tipsText = @"请选择求购名称";
    } else if (![NSString convertToNumberForString:self.createAskModel.askPrice]){
        tipsText = @"请填写价格";
    } else if (self.createAskModel.askDescription.length < 15){
        tipsText = @"求购描述不少于15个字";
    } else if (!self.createAskModel.selectedCategory) {
        tipsText = @"请选择分类";
    } else if (self.createAskModel.tradeLocation.length == 0) {
        tipsText = @"请填写交易地点";
    } else if (self.createAskModel.mobileNumber.length == 0) {
        tipsText = @"请填写手机号码";
    } else if (![self.createAskModel.mobileNumber isMobilePhoneNumber]) {
        tipsText = @"请填写正确的手机号码";
    } else if(self.createAskModel.qqNumber.length<5 && self.createAskModel.qqNumber.length>0)
    {
        tipsText = @"请填写正确的qq号码";
    }
    
    if (tipsText) {
        NSString *title = @"";
        if (self.createAskModel.netImageUrlTexts.count == 0) {
            title = @"发布失败";
        } else {
            title = @"编辑失败";
        }
        
        [[[UIAlertView alloc] initWithTitle:title message:tipsText delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]show];
    }
    return (tipsText == nil);
}
- (IBAction)selectionViewTouchAct:(UITapGestureRecognizer *)sender {
    self.selectionBoardView.hidden = YES;
    [self.view sendSubviewToBack:self.selectionBoardView];
    
}
- (IBAction)selectSchoolButtonAction:(id)sender {
    SchoolSelectViewController *schoolSelectVC = [[SchoolSelectViewController alloc] init];
    schoolSelectVC.shouldCacheSelection = NO;
    schoolSelectVC.distance = 1;
    __weak __typeof(self)weakSelf = self;
    schoolSelectVC.finishedSchoolPickBlock = ^(SchoolModel *pickedSchool){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.createAskModel.selectedSchool = pickedSchool;
        DISPATCH_MAIN(^(){
            strongSelf.schoolSelectBtn.titleLabel.text =  strongSelf.createAskModel.selectedSchool.schoolName;
        });
    };
    [self.navigationController pushViewController:schoolSelectVC animated:YES];
}

- (void)rightBarButtonAction
{
    [self.view endEditing:YES];
    NSLog(@"yyyyyyyy%@",[NSString realForString:self.createAskModel.selectedSchool.schoolName]);
    self.createAskModel.tradeLocation = [NSString realForString:self.createAskModel.selectedSchool.schoolName];
    NSLog(@"yyyyyyyy%@",self.createAskModel.tradeLocation);
    self.createAskModel.qqNumber = [NSString realForString:self.qqNumberField.text];
    self.createAskModel.mobileNumber = [NSString realForString:self.mobileNoField.text];
    if ([self isValidToSubmit]) {
        [self.view endEditing:YES];
        __weak __typeof(self)weakSelf = self;
        [MBProgressHUD showHUDAddedTo:weakSelf.navigationController.view animated:YES];
        if (self.createAskModel.netImageUrlTexts.count != 0) {
            [self.createAskModel updateAskWithCompletionHandler:^(NSError *error) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                if (error) {
                    [[[UIAlertView alloc] initWithTitle:@"编辑失败" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                } else {
                    /*[KGModal sharedInstance].tapOutsideToDismiss = NO;
                    [KGModal sharedInstance].modalBackgroundColor = [UIColor clearColor];
                    self.succeedPopoutView.titleLabel.text = @"求购编辑成功";
                    [[KGModal sharedInstance]showWithContentView:self.succeedPopoutView andAnimated:YES];*/
                    [MBProgressHUD hideAllHUDsForView:strongSelf.navigationController.view animated:YES];
                    
                    [ProgressHudCommon showHudAndHide:strongSelf.navigationController.view andNotice:@"求购编辑成功"];
                }
            }];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self.createAskModel startCreateAskWithCompletionHandler:^(NSError *error) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                if (error) {
                    [[[UIAlertView alloc]initWithTitle:@"发布失败" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]show];
                } else{
                    /*[KGModal sharedInstance].tapOutsideToDismiss = NO;
                    [KGModal sharedInstance].modalBackgroundColor = [UIColor clearColor];
                    self.succeedPopoutView.titleLabel.text = @"求购发布成功";
                    [[KGModal sharedInstance]showWithContentView:self.succeedPopoutView andAnimated:YES];*/
                    [MBProgressHUD hideAllHUDsForView:strongSelf.navigationController.view animated:YES];CreateAskSucceedViewController *vc = [[CreateAskSucceedViewController alloc]init];
                    vc.categoryId = [self.createAskModel selectedCategory].categoryId;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }];
        }
    }
}
- (IBAction)chooseCategoryButtonAction:(UIButton *)sender {
    self.selectionBoardView.hidden = NO;
    [self.view bringSubviewToFront:self.selectionBoardView];
    self.categorySelectionVC.currentType = SelectionDataTypeCategory;
    __weak __typeof(self)weakSelf = self;
    self.categorySelectionVC.completeSelection = ^(id selectedObject){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.createAskModel.selectedCategory = (CategoryModel *)selectedObject;
        dispatch_main_async_safe(^(){
            [strongSelf setCurrentViewWithCategorySelectionModel];
            [strongSelf.view sendSubviewToBack:strongSelf.selectionBoardView];
        });
    };
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)setCurrentViewWithCategorySelectionModel
{
    [self.chooseCategoryBtn setTitle:[self.createAskModel.selectedCategory categoryName] forState:UIControlStateNormal];
    self.chooseCategoryBtn.selected = YES;
    self.selectionBoardView.hidden = YES;
}
@end
