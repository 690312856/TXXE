//
//  DiscoverHeaderScrollView.m
//  TXXE
//
//  Created by 李雨龙 on 15/8/2.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "DiscoverHeaderScrollView.h"
#import <UIImageView+WebCache.h>

@implementation DiscoverHeaderScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (id)initPageViewWithFrame:(CGRect)frame views:(NSArray *)views
{
    self = [super initWithFrame:frame];
    if (self) {
        self.selectionType = ScrollViewSelectionTypeTap;
        sourceArr = views;
        self.userInteractionEnabled = YES;
        [self initSubviewsWithFrame:frame];
    }
    return self;
}

- (void)initSubviewsWithFrame:(CGRect)frame
{
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    CGRect fitRect = CGRectMake(0, 0, width, height);
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:fitRect];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(width*(sourceArr.count+2), height);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    
    UIImageView *firstImageView = [[UIImageView alloc]initWithFrame:fitRect];
    [firstImageView sd_setImageWithURL:[NSURL URLWithString:[[sourceArr lastObject][@"images"] firstObject]] placeholderImage:nil];
    NSLog(@"image%@",[[sourceArr lastObject][@"images"] firstObject]);
    //firstImageView.image = [UIImage imageNamed:@"tag"];
    [self.scrollView addSubview:firstImageView];
    
    for (int i = 0; i < sourceArr.count; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(width*(i+1), 0, width, height)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[[sourceArr objectAtIndex:i][@"images"] firstObject]] placeholderImage:nil];
        //imageView.image = [UIImage imageNamed:@"tag"];
        [self.scrollView addSubview:imageView];
    }
    
    UIImageView *lastImageView = [[UIImageView alloc]initWithFrame:fitRect];
    [lastImageView sd_setImageWithURL:[NSURL URLWithString:[[sourceArr firstObject][@"images"] firstObject]] placeholderImage:nil];
    //lastImageView.image = [UIImage imageNamed:@"tag"];
    [self.scrollView addSubview:lastImageView];
    
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, height-30, width, 30)];
    self.pageControl.numberOfPages = sourceArr.count;
    self.pageControl.currentPage = 0;
    self.pageControl.enabled = YES;
    [self addSubview:self.pageControl];
    
    [self.scrollView scrollRectToVisible:CGRectMake(width, 0, width, height) animated:NO];

    if (sourceArr.count > 1) {
        timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(nextPage:) userInfo:nil repeats:YES];
    }
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:singleTap];
}


#pragma mark --- custom methods
//自动滚动到下一页
-(IBAction)nextPage:(id)sender
{
    
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int currentPage = self.scrollView.contentOffset.x/pageWidth;
    if (currentPage == 0) {
        self.pageControl.currentPage = sourceArr.count-1;
    }
    else if (currentPage == sourceArr.count+1) {
        self.pageControl.currentPage = 0;
    }
    else {
        self.pageControl.currentPage = currentPage-1;
    }
    int currPageNumber = self.pageControl.currentPage;
    CGSize viewSize = self.scrollView.frame.size;
    CGRect rect = CGRectMake((currPageNumber+2)*pageWidth, 0, viewSize.width, viewSize.height);
    [self.scrollView scrollRectToVisible:rect animated:YES];
    currPageNumber++;
    if (currPageNumber == sourceArr.count) {
        CGRect newRect=CGRectMake(viewSize.width, 0, viewSize.width, viewSize.height);
        [self.scrollView scrollRectToVisible:newRect animated:NO];
        currPageNumber = 0;
    }
    self.pageControl.currentPage = currPageNumber;
}

//点击图片的时候 触发
- (void)singleTap:(UITapGestureRecognizer *)tapGesture
{
    if (_selectionType != ScrollViewSelectionTypeTap) {
        return;
    }
    if (_pageViewDelegate && [_pageViewDelegate respondsToSelector:@selector(scrollViewDidClickedAtPage:)]) {
        [_pageViewDelegate scrollViewDidClickedAtPage:self.pageControl.currentPage];
    }
}

#pragma mark---- UIScrollView delegate methods
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //开始拖动scrollview的时候 停止计时器控制的跳转
    [timer invalidate];
    timer = nil;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    CGFloat width = self.scrollView.frame.size.width;
    CGFloat heigth = self.scrollView.frame.size.height;
    //当手指滑动scrollview，而scrollview减速停止的时候 开始计算当前的图片的位置
    int currentPage = self.scrollView.contentOffset.x/width;
    if (currentPage == 0) {
        [self.scrollView scrollRectToVisible:CGRectMake(width*sourceArr.count, 0, width, heigth) animated:NO];
        self.pageControl.currentPage = sourceArr.count-1;
    }
    else if (currentPage == sourceArr.count+1) {
        [self.scrollView scrollRectToVisible:CGRectMake(width, 0, width, heigth) animated:NO];
        self.pageControl.currentPage = 0;
    }
    else {
        self.pageControl.currentPage = currentPage-1;
    }
    //拖动完毕的时候 重新开始计时器控制跳转
    timer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(nextPage:) userInfo:nil repeats:YES];
}














































/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
