//
//  CreateGoodFinishViewController.m
//  TXXE
//
//  Created by River on 15/6/14.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "CreateGoodFinishViewController.h"
#import "UIView+Addition.h"
#import "Constants.h"
#import "UITextField+Addition.h"
#import "LengthLimitedInputView.h"
#import "UIViewController+TopBarMessage.h"
#import "CreatCategorySelectionViewController.h"
#import <SDWebImageCompat.h>
#import "NSString+Addition.h"
#import <MBProgressHUD.h>
#import "SchoolSelectViewController.h"
#import "CreateSucceedPopOutView.h"
#import "AppDelegate.h"
#import <KGModal.h>
#import "ProgressHudCommon.h"
#import "CreateSucceedViewController.h"

@interface CreateGoodFinishViewController ()<UIGestureRecognizerDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *chooseCategoryButtn;
@property (weak, nonatomic) IBOutlet UIButton *schoolSelectBtn;

//@property (weak, nonatomic) IBOutlet LengthLimitedInputView *tradePlaceField;
@property (weak, nonatomic) IBOutlet LengthLimitedInputView *mobileNoField;
@property (weak, nonatomic) IBOutlet LengthLimitedInputView *qqNumberField;
@property (weak, nonatomic) IBOutlet UIView *selectionBoardView;
@property (weak, nonatomic) IBOutlet UIView *selectionContainView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *nSegment;


@property (nonatomic , strong) CategoryModel *categoriesFetcher;

@property (nonatomic , strong) CreatCategorySelectionViewController *categorySelectionVC;

@property (nonatomic , strong) CreateSucceedPopOutView *succeedPopoutView;
@end

@implementation CreateGoodFinishViewController
- (CreateSucceedPopOutView *)succeedPopoutView
{
    if (!_succeedPopoutView) {
        _succeedPopoutView = [[[NSBundle mainBundle] loadNibNamed:@"CreateSucceedPopOutView" owner:self options:nil] firstObject];
        _succeedPopoutView.confirmBtnActionBlock = ^(){
            [[KGModal sharedInstance] hideAnimated:YES withCompletionBlock:^{
                //[THE_APP_DELEGATE.inputViewController dismissViewControllerAnimated:YES completion:NULL];
                /*NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:nil];
                //创建通知
                NSNotification *notification =[NSNotification notificationWithName:@"logout" object:nil userInfo:dict];
                //通过通知中心发送通知
                [[NSNotificationCenter defaultCenter] postNotification:notification];*/
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
    // Do any additional setup after loading the view.
    [self customedSubViewItems];
    AppDelegate *appDelegate=[[UIApplication sharedApplication] delegate];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.0/255 green:191.0/255 blue:121.0/255 alpha:1.0];
    self.schoolSelectBtn.layer.cornerRadius = 5.0;
    self.createGoodModel = appDelegate.createGoodModel;
    self.createGoodModel.isNew = 1;
    if (self.createGoodModel.netImageUrlTexts.count != 0) {
        self.title = @"编辑";
    } else {
        self.title = @"发布";
    }
    
    self.schoolSelectBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    NSLog(@"33333%@",self.createGoodModel.goodPrice);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonAction)];
    if (self.childViewControllers.count != 0) {
        self.categorySelectionVC = self.childViewControllers.firstObject;
        self.categorySelectionVC.categoryFetcher = self.categoriesFetcher;
        //self.categorySelectionVC.functionFetcher = self.functionsFetcher;
    }
    [self.nSegment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    self.nSegment.selectedSegmentIndex = 0;
    [self recoveryCreateGoodModelData];
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    //
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)segmentAction:(UISegmentedControl *)Seg
{
    if (Seg.selectedSegmentIndex == 0) {
        self.createGoodModel.isNew = 1;
        NSLog(@"1");
    }else
    {
        self.createGoodModel.isNew = 0;
        NSLog(@"0");
    }
}
- (void)recoveryCreateGoodModelData
{
    if (self.createGoodModel.selectedCategory) {
        [self setCurrentViewWithCategorySelectionModel];
    }
    NSLog(@"000000%@",[NSString realForString:[UserModel currentUser].school.schoolName]);
    //self.tradePlaceField.text = [NSString realForString:self.createGoodModel.tradeLocation];
    self.mobileNoField.text = [NSString realForString:self.createGoodModel.mobileNumber];
    self.qqNumberField.text = [NSString realForString:self.createGoodModel.qqNumber];
    
    //self.schoolSelectBtn.titleLabel.text =  self.createGoodModel.selectedSchool.schoolName;
    if (self.mobileNoField.text.length == 0) {
        self.mobileNoField.text = [NSString realForString:[UserModel currentUser].mobileNumber];
        self.createGoodModel.mobileNumber = self.mobileNoField.text;
    }
    if (self.qqNumberField.text.length == 0) {
        self.qqNumberField.text = [NSString realForString:[UserModel currentUser].qq];
        self.createGoodModel.qqNumber = self.qqNumberField.text;
    }
    //if ([self.schoolSelectBtn.titleLabel.text isEqualToString:@"交易地点"]) {
        //self.schoolSelectBtn.titleLabel.text = [NSString realForString:[UserModel currentUser].school.schoolName];
    [self.schoolSelectBtn setTitle:[NSString realForString:[UserModel currentUser].school.schoolName] forState:UIControlStateNormal];
    
    self.createGoodModel.selectedSchool = [UserModel currentUser].school;
    //self.createGoodModel.selectedSchool.schoolName = [NSString realForString:[UserModel currentUser].school.schoolName];
    //self.createGoodModel.selectedSchool.schoolID = [NSString realForString:[UserModel currentUser].school.schoolID];
    //}
}
- (void)customedSubViewItems
{
    for (UIView *subView in @[self.mobileNoField,self.qqNumberField]) {
        [subView drawBorderStyleWithBorderWidth:1 borderColor:RGB_COLOR(213, 213, 213, 1.) cornerRadius:5];
    }
    for (UIView *subView in @[self.chooseCategoryButtn]) {
        [subView drawBorderStyleWithBorderWidth:1 borderColor:APP_MAIN_COLOR cornerRadius:5];
    }
    /*for (LengthLimitedInputView *textField in @[self.tradePlaceField,self.mobileNoField,self.qqNumberField]) {
        [((UITextField *)textField.inputEareView) setTextCapLeftViewLength:kCommonTextCapForTextField leftView:nil rightViewLength:0 rightView:nil];
    }*/
    
    __weak __typeof(self)weakSelf = self;
    /*self.tradePlaceField.currentType = InputViewTypeTextField;
    //[((UITextField *)self.tradePlaceField.inputEareView) setTextCapLeftViewLength:10 leftView:nil rightViewLength:0 rightView:nil];
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
    //[((UITextField *)self.qqNumberField.inputEareView) setTextCapLeftViewLength:10 leftView:nil rightViewLength:0 rightView:nil];
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

- (BOOL)isValidToSubmit
{
    NSString *tipsText = nil;
    if (self.createGoodModel.localImageModels.count == 0) {
        tipsText = @"请选择图片后再发布！";
    } else if (self.createGoodModel.goodTitle.length == 0){
        tipsText = @"请选择商品名称";
    } else if (![NSString convertToNumberForString:self.createGoodModel.goodPrice]){
        tipsText = @"请填写价格";
    } else if (self.createGoodModel.goodDescription.length < 15){
        tipsText = @"商品描述不少于15个字";
    } else if (!self.createGoodModel.selectedCategory) {
        tipsText = @"请选择分类";
    } else if (self.createGoodModel.tradeLocation.length == 0) {
        tipsText = @"请填写交易地点";
    } else if (self.createGoodModel.mobileNumber.length == 0) {
        tipsText = @"请填写手机号码";
    } else if (![self.createGoodModel.mobileNumber isMobilePhoneNumber]) {
        tipsText = @"请填写正确的手机号码";
    }else if(self.createGoodModel.qqNumber.length<5 && self.createGoodModel.qqNumber.length>0)
    {
        tipsText = @"请填写正确的qq号码";
    }
    
    if (tipsText) {
        NSString *title = @"";
        if (self.createGoodModel.netImageUrlTexts.count == 0) {
            title = @"发布失败";
        } else {
            title = @"编辑失败";
        }
        
        [[[UIAlertView alloc] initWithTitle:title message:tipsText delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]show];
    }
    return (tipsText == nil);
}
#pragma mark -
#pragma mark - Action
- (IBAction)selectionViewTouchAct:(UITapGestureRecognizer *)sender {
    self.selectionBoardView.hidden = YES;
    [self.view sendSubviewToBack:self.selectionBoardView];
}

- (void)rightBarButtonAction
{
    [self.view endEditing:YES];
    ///////////////?
    self.createGoodModel.tradeLocation = [NSString realForString:self.createGoodModel.selectedSchool.schoolName];
    NSLog(@"ooooooooo%@",[NSString realForString:self.createGoodModel.selectedSchool.schoolName]);
    self.createGoodModel.qqNumber = [NSString realForString:self.qqNumberField.text];
    self.createGoodModel.mobileNumber = [NSString realForString:self.mobileNoField.text];
    if ([self isValidToSubmit]) {
        [self.view endEditing:YES];
        __weak __typeof(self)weakSelf = self;
        [MBProgressHUD showHUDAddedTo:weakSelf.navigationController.view animated:YES];
        if (self.createGoodModel.netImageUrlTexts.count != 0) {
            [self.createGoodModel updateGoodWithCompletionHandler:^(NSError *error) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                if (error) {
                    [[[UIAlertView alloc] initWithTitle:@"编辑失败" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                } else {
                    [MBProgressHUD hideAllHUDsForView:strongSelf.navigationController.view animated:YES];
                    
                    [ProgressHudCommon showHudAndHide:strongSelf.navigationController.view andNotice:@"商品编辑成功"];


                    
                }
            }];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self.createGoodModel startCreateGoodWithCompletionHandler:^(NSError *error) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                if (error) {
                    [[[UIAlertView alloc]initWithTitle:@"发布失败" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]show];
                } else{
                    /*[KGModal sharedInstance].tapOutsideToDismiss = NO;
                    [KGModal sharedInstance].modalBackgroundColor = [UIColor clearColor];
                    self.succeedPopoutView.titleLabel.text = @"商品发布成功";
                    [[KGModal sharedInstance]showWithContentView:self.succeedPopoutView andAnimated:YES];*/
                    [MBProgressHUD hideAllHUDsForView:strongSelf.navigationController.view animated:YES];
                    CreateSucceedViewController *vc = [[CreateSucceedViewController alloc]init];
                    vc.categoryId = [self.createGoodModel selectedCategory].categoryId;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }];
        }
    }
}
- (IBAction)selectSchoolButtonAction:(id)sender {
    
    SchoolSelectViewController *schoolSelectVC = [[SchoolSelectViewController alloc] init];
    schoolSelectVC.shouldCacheSelection = NO;
    schoolSelectVC.distance = 1;
    __weak __typeof(self)weakSelf = self;
    schoolSelectVC.finishedSchoolPickBlock = ^(SchoolModel *pickedSchool){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.createGoodModel.selectedSchool = pickedSchool;
        DISPATCH_MAIN(^(){
            strongSelf.schoolSelectBtn.titleLabel.text =  strongSelf.createGoodModel.selectedSchool.schoolName;
        });
    };
    [self.navigationController pushViewController:schoolSelectVC animated:YES];

}

- (IBAction)chooseCategoryButtonAction:(UIButton *)sender {
    self.selectionBoardView.hidden = NO;
    [self.view bringSubviewToFront:self.selectionBoardView];
    self.categorySelectionVC.currentType = SelectionDataTypeCategory;
    __weak __typeof(self)weakSelf = self;
    self.categorySelectionVC.completeSelection = ^(id selectedObject){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.createGoodModel.selectedCategory = (CategoryModel *)selectedObject;
        dispatch_main_async_safe(^(){
            [strongSelf setCurrentViewWithCategorySelectionModel];
            [strongSelf.view sendSubviewToBack:strongSelf.selectionBoardView];
        });
    };
    
}

- (void)setCurrentViewWithCategorySelectionModel
{
    [self.chooseCategoryButtn setTitle:[self.createGoodModel.selectedCategory categoryName] forState:UIControlStateNormal];
    self.chooseCategoryButtn.selected = YES;
    self.selectionBoardView.hidden = YES;
}


@end
