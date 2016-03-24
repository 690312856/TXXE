//
//  GoodReportVC.m
//  TongxiaoXiaoEr
//
//  Created by xueyaoji on 15-4-2.
//  Copyright (c) 2015年 com.e-techco. All rights reserved.
//

#import "GoodReportVC.h"
#import "NetController.h"
#import "ProgressHudCommon.h"
#import "Constants.h"
#import "NSString+Addition.h"
#import "ReasonCell.h"
#define ROWHeigt  40
@interface GoodReportVC ()

@end

@implementation GoodReportVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backItem];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.0/255 green:191.0/255 blue:121.0/255 alpha:1.0];
    self.view.backgroundColor = tableWhitColor;
    _curSelectIndex = 0;//默认第一个
    self.title = @"举报";
    dataArr = [[NSMutableArray alloc] initWithCapacity:0];

    [self createGoodReportVC];
    [self requestData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    for (UIView *view in self.parentViewController.tabBarController.view.subviews) {
        if (view.tag == 100) {
            view.hidden = YES;
        }
    }
    self.navigationController.navigationBarHidden = NO;
}
-(void)requestData
{
    
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [[NetController sharedInstance] postWithAPI:API_report_reason parameters:dic completionHandler:^(id responseObject, NSError *error){
        if (error) {
            [ProgressHudCommon showHudAndHide:self.view andNotice:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
            
        }else
        {
            
            
            NSLog(@"举报返回 %@",responseObject);
            dataArr = [[NSMutableArray alloc] initWithArray:responseObject[@"data"]];
            [listTableView reloadData];
        }
        
    }];

}
-(void)createGoodReportVC
{
    listTableView = [[UITableView alloc] initWithFrame:CGRectMake(30, 20, KScreenWidth-60, 340)];
    listTableView.dataSource = self;
    listTableView.delegate = self;
    listTableView.backgroundView = nil;
    listTableView.backgroundColor = [UIColor clearColor];
    listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:listTableView];
    
   
    
    
    
    UIButton * repertBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 440, KScreenWidth-30, 40)];
    [repertBtn setTitleColor:[UIColor whiteColor] forState:0];
    [repertBtn setTitle:@"举报" forState:0];
    repertBtn.layer.cornerRadius = 5.0;
    [repertBtn addTarget:self action:@selector(clickReportBtn:) forControlEvents:UIControlEventTouchUpInside];
    repertBtn.backgroundColor = GreenFontColor;
    [self.view addSubview:repertBtn];
    
    

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ROWHeigt;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [dataArr count];

}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * idCell = @"4555";
    
    
    
    
    
    
    ReasonCell * cell = [tableView dequeueReusableCellWithIdentifier:idCell];
    if (cell==nil) {
        cell = [[ReasonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idCell];
        
        
    }
    
   
    [cell refreshWithStr:[dataArr objectAtIndex:[indexPath row]]];
    
    
    if ([indexPath row]==_curSelectIndex) {
        [cell.choseImg setHidden:NO];
    }else
    {
         [cell.choseImg setHidden:YES];;
    }
    
   
    
    return cell;



}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    _curSelectIndex = [indexPath row];
    [tableView reloadData];

}
-(void)clickReportBtn:(UIButton*)sender
{
    
    
    if (self.reportCallBack) {

        self.reportCallBack([NSString realForString:[dataArr objectAtIndex:_curSelectIndex]]);
        [self.navigationController popViewControllerAnimated:YES];
    }
    


}
@end
