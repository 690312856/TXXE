//
//  ReasonCell.h
//  TongxiaoXiaoEr
//
//  Created by xueyaoji on 15-4-4.
//  Copyright (c) 2015年 com.e-techco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReasonCell : UITableViewCell
@property(nonatomic,strong)UILabel * reasonLab;
@property(nonatomic,strong)UIView * lineView;
@property(nonatomic,strong)UIImageView * choseImg;
-(void)refreshWithStr:(NSString*)str;
@end
