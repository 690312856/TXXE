//
//  GoodCollectionViewCell.m
//  TXXE
//
//  Created by River on 15/6/29.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "GoodCollectionViewCell.h"
#import "Constants.h"
#import "NSString+Addition.h"
//#import <QuartzCore/QuartzCore.h>
@implementation GoodCollectionViewCell

- (void)awakeFromNib {
    
}

-(void)refreshWithDic:(NSDictionary*)dic
{
    
    if ([[NSString realForString: [[dic objectForKey:@"images"] firstObject]] isEqualToString:@""]) {
        self.goodImg.image = defaultImg;
    }
    else
    {
        NSLog(@"");
        [self.goodImg sd_setImageWithURL:[NSURL URLWithString:[[dic objectForKey:@"images"]firstObject]] placeholderImage:defaultImg];
    }
    [self.goodImg setContentScaleFactor:[[UIScreen mainScreen] scale]];
    self.goodImg.contentMode = UIViewContentModeScaleAspectFill;
    self.goodImg.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.goodImg.clipsToBounds  = YES;

    
    self.goodTitle.text = [NSString realForString:[dic objectForKey:@"title"]];
    self.location.text = [NSString realForString:[dic objectForKey:@"jyLocation"]];
    self.location.textColor = [UIColor colorWithRed:155.0/255 green:155.0/255 blue:155.0/255 alpha:1.0];
    //self.location.tintColor = [UIColor greenColor];
    self.goodDescription.text = [NSString realForString:[dic objectForKey:@"description"]];
    self.price.text = [NSString stringWithFormat:@"¥ %@",[NSString realForString:[dic objectForKey:@"price"]]];

    [self.isNewImageView setImage:[UIImage imageNamed:@"tag"]];
    
    BOOL isNew = [[dic objectForKey:@"isNew"] boolValue];
    if (isNew == YES) {
        
        [self.isNewImageView setHidden:NO];
    }else
    {
        [self.isNewImageView setHidden:YES];
    }
}

























@end
