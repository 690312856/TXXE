//
//  SellerInfoViewController.h
//  TXXE
//
//  Created by 李雨龙 on 15/7/26.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SellerGoodCollectionView.h"
#import "SellerAskTableView.h"
#import "CommentInputView.h"

@interface SellerInfoViewController : UIViewController

@property (nonatomic)long type;

@property (nonatomic,strong)NSString *memberId;
@property (nonatomic,strong)NSString *askId;
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *schoolName;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *identificationLabel;
@property (weak, nonatomic) IBOutlet UIButton *goodButton;
@property (weak, nonatomic) IBOutlet UIButton *askButton;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (nonatomic,strong)NSString *currAskGoodId;
@property (strong,nonatomic)UIView *greenCategory;
@property (strong,nonatomic)UIView *greenDiscover;
@property (nonatomic,strong)CommentInputView *inputView;
@property (nonatomic,strong)SellerGoodCollectionView *collectionView;
@property (nonatomic,strong)SellerAskTableView *tableView;







@end
