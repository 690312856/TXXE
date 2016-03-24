//
//  SellerAskTableHeaderView.h
//  TXXE
//
//  Created by 李雨龙 on 15/8/1.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageListView.h"

typedef void(^reportClickCallBack)(UIButton *sender,NSString *askGoodId);
typedef void(^commentClickCallBack)(UIButton *sender);
typedef void(^collectionClickCallBack)(UIButton *sender,NSString *askGoodId);
typedef void(^contactClickCallBack)(UIButton *sender,NSDictionary *dic);


@interface SellerAskTableHeaderView : UIView
{
    NSDictionary *AskDic;
}
@property (nonatomic,strong) UILabel *AskName;
@property (nonatomic,strong) ImageListView *imageListView;
@property (nonatomic,strong) UITextView *descriptionTextView;

@property (nonatomic,strong) UILabel *price;

@property (nonatomic,strong) UIButton *collectionBtn;
@property (nonatomic,strong) UIButton *commentBtn;
@property (nonatomic,strong) UIButton *contactBtn;
@property (nonatomic,strong) UIButton *showBtn;
@property (nonatomic,strong) UIButton *reportBtn;

@property (nonatomic,strong)NSString *askGoodId;
@property (nonatomic,strong)NSString *memberId;

@property (nonatomic,strong)reportClickCallBack repoClickBlock;
@property(nonatomic,strong)commentClickCallBack commClickBlock;
@property(nonatomic,strong)collectionClickCallBack collClickBlock;
@property(nonatomic,strong)contactClickCallBack contClickBlock;

-(void)refreshWithDic:(NSDictionary*)dic;
- (id)initWithFrame:(CGRect)frame;
@end
