//
//  CategoryView.m
//  TXXE
//
//  Created by River on 15/6/28.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "CategoryView.h"
#import "UserModel.h"
#import "NetController.h"

@implementation CategoryView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        height = self.frame.size.height;
        [self createView];
        [self requestList];
    }
    return self;
}

- (void)createView
{
    NSArray *categories = [NSArray arrayWithObjects:@"校园代步",@"数码",@"体育娱乐",@"书籍",@"日常生活",@"其它", nil];
    self.backgroundColor = [UIColor whiteColor];
    int num = 0;
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 3; j++) {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(13+20*j+(self.frame.size.width-60)*j/3.0, 20*(i+1)+(self.frame.size.width-120)*i/3.0, (self.frame.size.width-80)/3.0, (self.frame.size.width-80)/3.0)];
            UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake(13+20*j+(self.frame.size.width-60)*j/3.0, 20*(i+1)+(self.frame.size.width-120)*i/3.0+(self.frame.size.width-120)/3.0, (self.frame.size.width-80)/3.0, 30)];
            text.text= categories[i*3+j];
            
            text.font = [UIFont systemFontOfSize:10];
            text.textAlignment = NSTextAlignmentCenter;
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"c%d",i*3+j]];
            [btn setImage:image forState:UIControlStateNormal];
            btn.tag = ++num;
            [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:text];
            [self addSubview:btn];
        }
    }
}

- (void) clickBtn:(UIButton*)sender
{
    if (self.categorySearchCallBack) {
        self.categorySearchCallBack(sender);
    }
}

-(void)requestList
{
    // [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    [[NetController sharedInstance] postWithAPI:API_category_list parameters:[NSMutableDictionary dictionaryWithCapacity:0] completionHandler:^(id responseObject, NSError *error){
        
        if (error) {
            
        }else
        {
            _normalCategoryArr = [NSMutableArray arrayWithArray:responseObject[@"data"][@"normalCategories"]];
            
            [UserModel currentUser].normalCategoryArr = _normalCategoryArr;//暂存
            
        }        
    }];
    
}






















@end
