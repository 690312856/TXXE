//
//  ImageListView.m
//  TXXE
//
//  Created by 李雨龙 on 15/7/24.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "ImageListView.h"
#import <UIImageView+WebCache.h>

@implementation ImageListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        for (int i = 0; i < 9; i++) {
            UIImageView *image = [[UIImageView alloc]init];
            [self addSubview:image];
        }
    }
    return self;
}

#pragma mark - 给每张图片内容赋值并计算图片尺寸与位置

- (void)setImageList:(NSArray *)imageList
{
    _imageList = imageList;
    
    NSInteger imageCount = imageList.count;
    for (int i = 0; i < 9; i++) {
        UIImageView *statusImages = self.subviews[i];
        statusImages.userInteractionEnabled = YES;
        statusImages.tag = 10+i;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapAction:)];
        [statusImages addGestureRecognizer:tapGesture];
        if (i < imageCount) {
            statusImages.hidden = NO;
            [statusImages sd_setImageWithURL:[NSURL URLWithString:imageList[i]] placeholderImage:nil];
            
            if (imageCount == 1) {
                self.backgroundColor = [UIColor clearColor];
                statusImages.contentMode = UIViewContentModeScaleAspectFit;
                statusImages.clipsToBounds = YES;
                //
                statusImages.frame = CGRectMake(0, 0, 100, 100);
            }else
            {
                self.backgroundColor = [UIColor clearColor];
                statusImages.contentMode = UIViewContentModeScaleAspectFill;
                statusImages.clipsToBounds = YES;
                
                //
                NSInteger count = (imageCount == 4)?2:3;
                
                CGFloat multipleWidth = 80;
                CGFloat multipleHeight = 80;
                NSInteger row = i / count;
                NSInteger column = i % count;
                statusImages.frame = CGRectMake(column *(5+multipleWidth)+5, row *(5+multipleWidth)+5 , multipleWidth, multipleHeight);
            }
        }else{
            statusImages.hidden = YES;
        }
    }
}

+ (CGSize)sizeofViewWithImageCount:(NSInteger)count
{
    if (count == 1) {
        return CGSizeMake(100, 100);
    }else{
        NSInteger columns = (count > 2 && count != 4)?3:2;
        NSInteger rows = (count +columns -1)/columns;
        
        return CGSizeMake(columns*(80 + 5) + 5, rows *(80 + 5) +5);
    }
}

- (void)imageViewTapAction:(UITapGestureRecognizer *)sender
{
    NSLog(@"RRRRRRRRRRR%ld",(long)sender.self.view.tag);
    NSString *str = [NSString stringWithFormat:@"%ld",(long)sender.self.view.tag];
    
    
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:str,@"imgViewTag",self.imageList,@"imgList",sender.self.view,@"imgView",self,@"imageListView", nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"imageTag" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}



















@end
