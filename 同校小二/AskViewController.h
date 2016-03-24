//
//  AskViewController.h
//  TXXE
//
//  Created by River on 15/7/3.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategorySelectView.h"
#import "SchoolSelectBtnView.h"
#import "AskItemsHeaderView.h"
#import "CommentInputView.h"
@interface AskViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UITextFieldDelegate>
{
    NSMutableArray * AsksArr;
    NSMutableArray * ReviewsArr;
    int priceAsc;
    int creditAsc;
    BOOL isopen;
    long curNum;
    long pageTotal;
}

@property (nonatomic,strong)SchoolSelectBtnView *schoolSelectView;
@property (nonatomic,strong)CategorySelectView *selectView;
@property (nonatomic,strong)AskItemsHeaderView *head;
@property (nonatomic,strong)CommentInputView *inputView;

@property (nonatomic,strong)NSDictionary *AskDictionary;
@property(nonatomic,assign)BOOL isFavorited;


@property (nonatomic,strong)UITableView *askTableView;
@property (nonatomic,strong)UISearchBar * searchBar;
@property (nonatomic,assign)int curPage;
@property (nonatomic,assign)int pageSize;

@property (nonatomic,strong)NSString *currAskGoodId;
@property (nonatomic,strong)NSString *searchTitle;
@property (nonatomic,strong)NSString *categoryId;
@property (nonatomic,strong)NSString *schoolId;
@property (nonatomic,strong)NSString *isInSchool;
@end
