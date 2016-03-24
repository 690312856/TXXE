//
//  CategorySearchViewController.h
//  TXXE
//
//  Created by River on 15/6/29.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategorySelectView.h"
#import "SchoolSelectBtnView.h"

@interface CategorySearchViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UISearchBarDelegate>
{
    NSMutableArray * goodsArr;
    BOOL isSelfSchool;
    int priceAsc;
    int creditAsc;
    long pageTotal;
}

@property (nonatomic,strong)SchoolSelectBtnView *schoolSelectView;
@property (nonatomic,strong)CategorySelectView *selectView;
@property (nonatomic,strong)UICollectionView *goodCollectionView;
@property (nonatomic,strong)UISearchBar * searchBar;
@property (nonatomic,assign)int curPage;
@property (nonatomic,assign)int pageSize;
@property (nonatomic,strong)UIButton *backBtn;
@property (nonatomic,strong)NSString *searchTitle;
@property (nonatomic,strong)NSString *categoryId;
@property (nonatomic,strong)NSString *schoolId;
@property (nonatomic,strong)NSString *isInSchool;
















@end
