//
//  GoodDetailsPageHeaderView.h
//  TXXE
//
//  Created by River on 15/7/1.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^clickCallBack)(UIButton *sender);
typedef void(^tapCallBack)(UITapGestureRecognizer *sender);
@interface GoodDetailsPageHeaderView : UIView
{
    long imageArrayCount;
    NSTimer *myTimer;
    UIView *content;
}
@property (nonatomic,strong)NSArray *imageList;
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UILabel *goodName;
@property (weak, nonatomic) IBOutlet UILabel *schoolName;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UITextView *goodDescription;

//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h1;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h2;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h3;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h4;
@property(nonatomic,strong)tapCallBack tapBlock;
@property(nonatomic,strong)clickCallBack clickBlock;
-(void)refreshWithDic:(NSDictionary*)dic;
@end
