//
//  GoodDetailsPageHeaderView.m
//  TXXE
//
//  Created by River on 15/7/1.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "GoodDetailsPageHeaderView.h"
#import "Constants.h"
#import "UIView+Addition.h"
#import "NSString+Addition.h"
#import <UIImageView+WebCache.h>
#import "TapImageView.h"

@implementation GoodDetailsPageHeaderView


- (void)awakeFromNib
{
    //self.frame = CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-120);
    self.backgroundColor = [UIColor colorWithRed:200/225.0 green:199/225.0 blue:204/225.0 alpha:1.0];
}

-(void)refreshWithDic:(NSDictionary*)dic
{
    //self.h1.constant = ([UIScreen mainScreen].bounds.size.height-120)*2/5.0;
    //self.h2.constant = self.h3.constant = self.h4.constant = ([UIScreen mainScreen].bounds.size.height-120)/5.0;
    self.imageList = [[dic objectForKey:@"data"]objectForKey:@"images"];
    NSLog(@"333333333");
    imageArrayCount = [[[dic objectForKey:@"data"]objectForKey:@"images"] count];
    if ([[NSString realForString:[[[dic objectForKey:@"data"]objectForKey:@"images"] firstObject]] isEqualToString:@""]) {
    }
    else
    {
        CGFloat Width=self.myScrollView.frame.size.width;
        CGFloat Height=self.myScrollView.frame.size.height;
        TapImageView *firstView=[[TapImageView alloc] initWithFrame:CGRectMake(0, 0, Width, Height)];
        firstView.tag = imageArrayCount-1+10;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(aTapped:)];
        [firstView addGestureRecognizer:tap];
        [firstView sd_setImageWithURL:[NSURL URLWithString:[[[dic objectForKey:@"data"]objectForKey:@"images"] lastObject]]];
        [firstView setContentMode:UIViewContentModeScaleAspectFit];
        [self.myScrollView addSubview:firstView];
        
        
        //set the last as the first
        
        for (int i=0; i<imageArrayCount; i++) {
            TapImageView *subViews=[[TapImageView alloc] initWithFrame:CGRectMake(Width*(i+1), 0, Width, Height)];
            subViews.tag = i+10;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(aTapped:)];
            [subViews addGestureRecognizer:tap];
            [subViews sd_setImageWithURL:[NSURL URLWithString:[[[dic objectForKey:@"data"]objectForKey:@"images"] objectAtIndex:i]]];
            [subViews setContentMode:UIViewContentModeScaleAspectFit];
            [self.myScrollView addSubview: subViews];
            
        }
        
        TapImageView *lastView=[[TapImageView alloc] initWithFrame:CGRectMake(Width*(imageArrayCount+1), 0, Width, Height)];
        lastView.tag = 0+10;
        [lastView addGestureRecognizer:tap];
        /////////////////
        //[lastView setContentScaleFactor:[[UIScreen mainScreen] scale]];
        //lastView.contentMode = UIViewContentModeScaleAspectFill;
        //lastView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        //lastView.clipsToBounds  = YES;
        [lastView sd_setImageWithURL:[NSURL URLWithString:[[[dic objectForKey:@"data"]objectForKey:@"images"] firstObject]]];
        [lastView setContentMode:UIViewContentModeScaleAspectFit];
        //lastView.frame=CGRectMake(Width*(imageArrayCount+1), 0, Width, Height);
        [self.myScrollView addSubview:lastView];
        //set the first as the last
        
        [self.myScrollView setContentSize:CGSizeMake(Width*(imageArrayCount+2), Height)];
        [self.myScrollView scrollRectToVisible:CGRectMake(Width, 0, Width, Height) animated:NO];
        
        self.pageControl.numberOfPages = imageArrayCount;
        self.pageControl.currentPage = 0;
        self.pageControl.enabled = YES;
        self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0.0/255 green:191.0/255 blue:121.0/255 alpha:1.0];
        self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
        [self.pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
        myTimer=[NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(scrollToNextPage:) userInfo:nil repeats:YES];
        
    }
    if ([[NSString realForString:[[[dic objectForKey:@"data"]objectForKey:@"sellerInfo"] objectForKey:@"avatar"]] isEqualToString:@""]) {
        self.photo.image = defaultImg;
    }
    else
    {
        NSLog(@"");
        [self.photo sd_setImageWithURL:[NSURL URLWithString:[[[dic objectForKey:@"data"]objectForKey:@"sellerInfo"] objectForKey:@"avatar"]] placeholderImage:defaultImg];
    }
    [self.photo setContentMode:UIViewContentModeScaleAspectFill];
    self.photo.clipsToBounds = YES;
    [self.photo drawBorderStyleWithBorderWidth:0 borderColor:[UIColor clearColor] cornerRadius:self.photo.frame.size.height * 0.5];
    self.photo.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoTapped:)];
    [self.photo addGestureRecognizer:singleTap];
    self.nickName.text = [NSString realForString:[[[dic objectForKey:@"data"]objectForKey:@"sellerInfo"] objectForKey:@"nickName"]];
    NSLog(@"%@",self.nickName.text);
    self.goodName.text = [NSString realForString:[[dic objectForKey:@"data"]objectForKey:@"title"]];
    self.schoolName.text = [NSString realForString:[[dic objectForKey:@"data"] objectForKey:@"schoolName"]];
    self.priceLabel.text = [NSString realForString:[[dic objectForKey:@"data"] objectForKey:@"price"]];
    self.levelLabel.text = [NSString stringWithFormat:@"LV%@",[NSString realForString:[[[dic objectForKey:@"data"] objectForKey:@"sellerInfo"] objectForKey:@"level"]]];
    self.goodDescription.text = [NSString realForString:[[dic objectForKey:@"data"] objectForKey:@"description"]];
    //[self.goodDescription setTextColor:[UIColor colorWithRed:155/225.0 green:155/225.0 blue:155/225.0 alpha:1.0]];
}


#pragma mark -
#pragma mark - getter



#pragma UIScrollView delegate
-(void)scrollToNextPage:(id)sender
{
    long pageNum=self.pageControl.currentPage;
    CGSize viewSize=self.myScrollView.frame.size;
    CGRect rect=CGRectMake((pageNum+2)*viewSize.width, 0, viewSize.width, viewSize.height);
    [self.myScrollView scrollRectToVisible:rect animated:NO];
    pageNum++;
    if (pageNum==imageArrayCount) {
        CGRect newRect=CGRectMake(viewSize.width, 0, viewSize.width, viewSize.height);
        [self.myScrollView scrollRectToVisible:newRect animated:NO];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth=self.myScrollView.frame.size.width;
    int currentPage=floor((self.myScrollView.contentOffset.x-pageWidth/2)/pageWidth)+1;
    if (currentPage==0) {
        self.pageControl.currentPage=imageArrayCount-1;
    }else if(currentPage==imageArrayCount+1){
        self.pageControl.currentPage=0;
    }
    self.pageControl.currentPage=currentPage-1;
    
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [myTimer invalidate];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    myTimer=[NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(scrollToNextPage:) userInfo:nil repeats:YES];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth=self.myScrollView.frame.size.width;
    CGFloat pageHeigth=self.myScrollView.frame.size.height;
    int currentPage=floor((self.myScrollView.contentOffset.x-pageWidth/2)/pageWidth)+1;
    NSLog(@"the current offset==%f",self.myScrollView.contentOffset.x);
    NSLog(@"the current page==%d",currentPage);
    
    if (currentPage==0) {
        [self.myScrollView scrollRectToVisible:CGRectMake(pageWidth*imageArrayCount, 0, pageWidth, pageHeigth) animated:NO];
        self.pageControl.currentPage=imageArrayCount-1;
        NSLog(@"pageControl currentPage==%ld",(long)self.pageControl.currentPage);
        NSLog(@"the last image");
        return;
    }else  if(currentPage==imageArrayCount+1){
        [self.myScrollView scrollRectToVisible:CGRectMake(pageWidth, 0, pageWidth, pageHeigth) animated:NO];
        self.pageControl.currentPage=0;
        NSLog(@"pageControl currentPage==%ld",(long)self.pageControl.currentPage);
        NSLog(@"the first image");
        return;
    }
    self.pageControl.currentPage=currentPage-1;
    NSLog(@"pageControl currentPage==%ld",(long)self.pageControl.currentPage);
    
}
-(IBAction)pageTurn:(UIPageControl *)sender
{
    long pageNum=self.pageControl.currentPage;
    CGSize viewSize=self.myScrollView.frame.size;
    [self.myScrollView setContentOffset:CGPointMake((pageNum+1)*viewSize.width, 0)];
    NSLog(@"myscrollView.contentOffSet.x==%f",self.myScrollView.contentOffset.x);
    NSLog(@"pageControl currentPage==%ld",(long)self.pageControl.currentPage);   [myTimer invalidate];
}
- (IBAction)clickBtn:(UIButton *)sender {
    if (self.clickBlock) {
        self.clickBlock(sender);
    }
}

- (void)photoTapped:(UITapGestureRecognizer *)sender
{
    NSLog(@"2341234123");
    if (self.tapBlock) {
        self.tapBlock(sender);
    }
}

- (void)aTapped:(UIGestureRecognizer *)gesture
{
    NSLog(@"22333333%ld",(long)gesture.self.view.tag);
    NSString *str = [NSString stringWithFormat:@"%ld",(long)gesture.self.view.tag];
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:str,@"imgViewTag",self.imageList,@"imgList",gesture.self.view,@"imgView",self,@"imageListView", nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"imageTaggg" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

@end
