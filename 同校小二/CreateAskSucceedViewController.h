//
//  CreateAskSucceedViewController.h
//  TXXE
//
//  Created by 李雨龙 on 15/8/26.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateAskSucceedViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSMutableArray * goodsArr;
    long pageTotal;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,assign)int curPage;
@property (nonatomic,assign)int pageSize;
@property (nonatomic,strong)NSString *categoryId;
@property (nonatomic,strong)NSString *schoolId;
@end
