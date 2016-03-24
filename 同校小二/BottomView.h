//
//  BottomView.h
//  TongxiaoXiaoEr
//
//  Created by xueyaoji on 15-3-7.
//  Copyright (c) 2015年 xxx.xxxx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^comment)(id sender);
typedef void(^contact)(id sender);
typedef void(^collect)(UIButton * sender);

@interface BottomView : UIView
{

}
@property(nonatomic,strong)UIButton * collectBtn;
@property(nonatomic,strong)comment commentCallBack;
@property(nonatomic,strong)contact contactCallBack;
@property(nonatomic,strong)collect collectCallBack;
-(void)createBottomView;
@end
