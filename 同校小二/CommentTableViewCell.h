//
//  CommentTableViewCell.h
//  TXXE
//
//  Created by River on 15/7/1.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "GoodDetailsDataModel.h"
typedef void(^tappedCallBack)(UITapGestureRecognizer *sender);
@interface CommentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UILabel *senderName;
@property (weak, nonatomic) IBOutlet UILabel *midText;
@property (weak, nonatomic) IBOutlet UILabel *toName;
@property (weak, nonatomic) IBOutlet UILabel *Contents;
//@property (weak, nonatomic) IBOutlet UITextView *contents;
@property (weak, nonatomic) IBOutlet UILabel *time;

@property (nonatomic,strong)NSString *sellerName;

@property(nonatomic,strong)tappedCallBack tapBlock;
-(void)refreshWithDic:(NSDictionary*)dic;
-(void)refreshDic:(NSDictionary*)dic;
@end
