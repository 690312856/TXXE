//
//  GoodDetailViewController.h
//  TXXE
//
//  Created by River on 15/6/30.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentInputView.h"
#import "UserModel.h"
@interface GoodDetailViewController : UIViewController
{
    NSDictionary * goodDic;
    NSArray * reviews;
}

@property (nonatomic,strong)NSString *goodId;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *collectionBtn;
@property (weak, nonatomic) IBOutlet UIButton *contactBtn;
@property (nonatomic,strong)CommentInputView *inputView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property(nonatomic,strong)UserModel * userModel;
@property(nonatomic,assign)BOOL isFavorited;
@property (nonatomic,assign)long distance;
@end
