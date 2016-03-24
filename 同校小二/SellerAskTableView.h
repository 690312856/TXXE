//
//  SellerAskTableView.h
//  TXXE
//
//  Created by 李雨龙 on 15/8/1.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SellerAskTableHeaderView.h"
#import "BLActionSheet.h"
#import <MessageUI/MessageUI.h>


typedef void(^commentClickCallBack)(UIButton *sender);
typedef void(^collectionClickCallBack)(UIButton *sender,NSString *askGoodId);
typedef void(^contactClickCallBack)(UIButton *sender,NSDictionary *dic);


@interface SellerAskTableView : UITableView<UITableViewDataSource,UITableViewDelegate,MFMessageComposeViewControllerDelegate,BLActionSheetDelegate,UIScrollViewDelegate>

{
    NSMutableArray * AsksArr;
    NSMutableArray * ReviewsArr;
    BOOL isopen;
    long curNum;
    long pageTotal;
}
@property (nonatomic,strong)SellerAskTableHeaderView *head;


@property (nonatomic,strong)NSString *memberId;
@property (nonatomic,strong)NSString *askId;
@property (nonatomic,assign)int curPage;
@property (nonatomic,strong)NSString *currAskGoodId;
@property (nonatomic,assign)BOOL isFavorited;
@property (nonatomic,strong)NSDictionary *AskDictionary;

@property(nonatomic,strong)commentClickCallBack commClickBlock;
@property(nonatomic,strong)collectionClickCallBack collClickBlock;
@property(nonatomic,strong)contactClickCallBack contClickBlock;

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style withMemberId:(NSString *)memberId withAskId:(NSString *)askId;
@end
