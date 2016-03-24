//
//  DiscoverHeaderScrollView.h
//  TXXE
//
//  Created by 李雨龙 on 15/8/2.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
    ScrollViewSelectionTypeTap = 100,
    ScrollViewSelectionTypeNone
}ScrollViewSelectionType;

@protocol DiscoverHeaderScrollViewDelegate <NSObject>

@optional

- (void)scrollViewDidClickedAtPage:(NSInteger)pageNumber;

@end

@interface DiscoverHeaderScrollView : UIView<UIScrollViewDelegate>
{
    NSTimer *timer;
    NSArray *sourceArr;
}
@property (strong,nonatomic)UIScrollView *scrollView;
@property (strong,nonatomic)UIPageControl *pageControl;
@property (assign,nonatomic)ScrollViewSelectionType selectionType;
@property (assign,nonatomic)id <DiscoverHeaderScrollViewDelegate>pageViewDelegate;

- (id)initPageViewWithFrame:(CGRect)frame views:(NSArray*)views;

@end
