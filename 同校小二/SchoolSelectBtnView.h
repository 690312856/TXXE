//
//  SchoolSelectBtnView.h
//  TXXE
//
//  Created by River on 15/6/29.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BtnCallBack)(int param);

@interface SchoolSelectBtnView : UIView
{
    UIButton *schoolButton;
    int lastSelectIndex;
    int curSelectIndex;
}

@property (nonatomic,strong)BtnCallBack BCallBack;
@end
