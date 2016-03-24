//
//  AskItemHeaderView.h
//  TXXE
//
//  Created by River on 15/7/3.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^commentClickCallBack)(UIButton *sender);
typedef void(^collectionClickCallBack)(UIButton *sender,NSString *askGoodId);
typedef void(^contactClickCallBack)(UIButton *sender,NSDictionary *dic);

@interface AskItemHeaderView : UIView
{
    NSDictionary *AskDic;
}
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *level;
@property (weak, nonatomic) IBOutlet UIImageView *goodImage;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *schoolName;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (nonatomic,strong)NSString *askGoodId;

@property(nonatomic,strong)commentClickCallBack commClickBlock;
@property(nonatomic,strong)collectionClickCallBack collClickBlock;
@property(nonatomic,strong)contactClickCallBack contClickBlock;

-(void)refreshWithDic:(NSDictionary*)dic;
@end
