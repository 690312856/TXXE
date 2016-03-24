//
//  SearchConditionView.h
//  TXXE
//
//  Created by River on 15/6/29.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^clickCallBack)(int isAsc,UIButton * sender);

@interface ConditionBtn : UIButton
{
    UIImageView * Img;
    int isChange;// 默认 2; 不传参
}
@property(nonatomic,strong)clickCallBack callBack;
@end

typedef void(^allBtnCallBack)(int isAsc,UIButton * sender);
typedef void(^classBtnCallBack)(UIButton*sender);
typedef void(^schoolBtnCallBack)(UIButton*sender);


@interface SearchConditionView : UIView
@property(nonatomic,strong)allBtnCallBack aCallBack;
@property(nonatomic,strong)classBtnCallBack cCallBack;
@property(nonatomic,strong)schoolBtnCallBack sCallBack;
@end
