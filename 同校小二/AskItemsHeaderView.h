//
//  AskItemsHeaderView.h
//  TXXE
//
//  Created by 李雨龙 on 15/7/29.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageListView.h"

typedef void(^commentClickCallBack)(UIButton *sender);
typedef void(^reportClickCallBack)(UIButton *sender,NSString *askGoodId);
typedef void(^collectionClickCallBack)(UIButton *sender,NSString *askGoodId);
typedef void(^contactClickCallBack)(UIButton *sender,NSDictionary *dic);
typedef void(^tapCallBack)(UITapGestureRecognizer *sender,NSString *memberId);
typedef void(^tapBack)(UITapGestureRecognizer *sender);
@interface AskItemsHeaderView : UIView
{
    NSDictionary *AskDic;
}
@property (nonatomic,strong) UIImageView *photo;
@property (nonatomic,strong) UILabel *nickName;
@property (nonatomic,strong) UILabel *level;
@property (nonatomic,strong) UILabel *AskName;
@property (nonatomic) BOOL isOpen;
@property (nonatomic,strong) ImageListView *imageListView;
@property (nonatomic,strong) UITextView *descriptionTextView;
@property (nonatomic,strong) UILabel *schoolName;
@property (nonatomic,strong) UIImageView *schoolLogo;
@property (nonatomic,strong) UILabel *price;
@property (nonatomic,strong) UIButton *showBtn;
@property (nonatomic,strong) UIButton *reportBtn;
@property (nonatomic,strong) UIButton *collectionBtn;
@property (nonatomic,strong) UIButton *commentBtn;
@property (nonatomic,strong) UIButton *contactBtn;

@property (nonatomic,strong)NSString *askGoodId;
@property (nonatomic,strong)NSString *memberId;

@property (nonatomic,strong)reportClickCallBack repoClickBlock;
@property(nonatomic,strong)commentClickCallBack commClickBlock;
@property(nonatomic,strong)collectionClickCallBack collClickBlock;
@property(nonatomic,strong)contactClickCallBack contClickBlock;
@property(nonatomic,strong)tapCallBack tapBlock;
@property(nonatomic,strong)tapBack tapBackBlock;

-(void)refreshWithDic:(NSDictionary*)dic;
- (id)initWithFrame:(CGRect)frame;
@end
