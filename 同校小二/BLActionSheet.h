//
//  BLActionSheet.h
//  SheetDemo
//
//  Created by llbt_ych on 15/3/3.
//  Copyright (c) 2015年 keyborder. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BLActionSheet;

@protocol BLActionSheetDelegate <NSObject>

- (void)actionBLSheet:(BLActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
@end



@interface BLActionSheet : UIView
{
   
    UIImageView * bgImgView;
    UIControl * grayView;
   
    
}
@property(nonatomic,assign)id<BLActionSheetDelegate> delegate;
@property(nonatomic,strong)UIColor * bgColor;
@property(nonatomic,strong)UIImage* bgImg;
-(id)initWithFrame:(CGRect)frame andTitles:(NSArray*)arr;
-(void)showInView:(UIView*)view;
-(void)dismiss;
@end
