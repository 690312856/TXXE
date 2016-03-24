//
//  CreateSucceedViewController.h
//  TXXE
//
//  Created by 李雨龙 on 15/8/23.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AskItemsHeaderView.h"
#import "CommentInputView.h"

@interface CreateSucceedViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    NSMutableArray * AsksArr;
    NSMutableArray * ReviewsArr;
    long curNum;
}
@property (weak, nonatomic) IBOutlet UIButton *lookGoodButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong)AskItemsHeaderView *head;
@property (nonatomic,strong)CommentInputView *inputView;

@property (nonatomic,strong)NSDictionary *AskDictionary;
@property(nonatomic,assign)BOOL isFavorited;

@property (nonatomic,assign)int curPage;
@property (nonatomic,assign)int pageSize;

@property (nonatomic,strong)NSString *currAskGoodId;
@property (nonatomic,strong)NSString *categoryId;
@property (nonatomic,strong)NSString *schoolId;
@end
