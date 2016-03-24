//
//  LeadViewController.m
//  TXXE
//
//  Created by 李雨龙 on 15/8/22.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "LeadViewController.h"

@interface LeadViewController ()<UIScrollViewDelegate>

@end

@implementation LeadViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    for (int i = 1; i <= 4; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"D%d.jpg",i]]];
        imageView.frame = CGRectMake(self.view.frame.origin.x + self.view.frame.size.width * (i - 1), self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
        imageView.userInteractionEnabled = YES;
        [self.scrollView addSubview:imageView];
    }
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width * 4, self.view.frame.size.height);
    

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    // 记录scrollView 的当前位置，因为已经设置了分页效果，所以：位置/屏幕大小 = 第几页
    int current = scrollView.contentOffset.x/[UIScreen mainScreen].bounds.size.width;
    NSLog(@"FFFFFFFF%d",current);
    if (current == 3) {
        
        NSUserDefaults *userDF = [NSUserDefaults standardUserDefaults];
        
        [userDF setBool:YES forKey:@"isFirst"];
        [userDF synchronize];
        self.view.window.rootViewController = [self.view.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"appVC"];
        NSLog(@"已经进入应用。。。。。。。。。");
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
