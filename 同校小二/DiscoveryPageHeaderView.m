//
//  DiscoveryPageHeaderView.m
//  TXXE
//
//  Created by River on 15/6/15.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "DiscoveryPageHeaderView.h"
#import "Constants.h"
#import "UIView+Addition.h"
#import <UIImageView+WebCache.h>

@implementation DiscoveryPageHeaderView

- (void)awakeFromNib
{
    self.frameWidth = SCREEN_WIDTH;
    self.autoSlideScrollView.frameWidth = SCREEN_WIDTH;
}

#pragma mark - 
#pragma mark - getter

- (void)setFunctionsDataSource:(NSArray *)functionsDataSource
{
    if (_functionsDataSource != functionsDataSource) {
        _functionsDataSource = functionsDataSource;
        
        NSMutableArray *dataSource = [NSMutableArray array];
        for (BaseFuncionModel *tempModel in _functionsDataSource) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.autoSlideScrollView.frameWidth, self.autoSlideScrollView.frameHeight)];
            NSLog(@"aaaaaaaaaaa%f",self.autoSlideScrollView.frameWidth);
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            [imageView sd_setImageWithURL:tempModel.imageUrl placeholderImage:nil];
            [imageView setImage:[UIImage imageNamed:@"tag"]];
            [dataSource addObject:imageView];
        }
        self.autoSlideScrollView.totalPagesCount = ^NSInteger (void){
            return dataSource.count;
        };
        self.autoSlideScrollView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
            return dataSource[pageIndex];
        };
        self.autoSlideScrollView.scrollView.scrollsToTop = NO;
        __weak __typeof(self)weakSelf = self;
        self.autoSlideScrollView.TapActionBlock = ^(NSInteger pageIndex)
        {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            NSLog(@"点击了第%@个",@(pageIndex));
            if (strongSelf.FunctionDidTapped) {
                dispatch_main_async_safe(^(){
                    strongSelf.FunctionDidTapped(_functionsDataSource[pageIndex]);
                });
            }
        };
    }
}

@end
