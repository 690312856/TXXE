//
//  CategoryTableView.m
//  TXXE
//
//  Created by River on 15/6/10.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "CategoryTableView.h"
#import "CategoryTableViewCell.h"
#import  <MBProgressHUD.h>
#import "NetController.h"
#import "UserModel.h"
//#import "CategorySearchVC.h"

@interface CategoryTableView ()<UITableViewDataSource,UITableViewDelegate>
@end

@implementation CategoryTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.delegate   = self;
        self.dataSource = self;
        [self registerClass:[CategoryTableViewCell class] forCellReuseIdentifier:@"categorycell"];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ([_CategoryArr count]+1)/2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *categorycell = @"categorycell";
    
    CategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:categorycell forIndexPath:indexPath];
    if (cell==nil) {
        cell = [[CategoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:categorycell];
    }
    
    if (([indexPath row]*2+1)<([_CategoryArr count]-1))
    {
        [cell refreshWithLeftDic:[_CategoryArr objectAtIndex:[indexPath row]*2] andRightDic:[_CategoryArr objectAtIndex:([indexPath row]*2+1)]];
        cell.leftBtn.tag = [indexPath row]*2;
        cell.rightBtn.tag = [indexPath row]*2+1;
        [cell.bottomlineView setHidden:NO];
    }else {
        [cell.bottomlineView setHidden:YES];
        [cell refreshWithLeftDic:[_CategoryArr objectAtIndex:[indexPath row]*2] andRightDic:nil];
        cell.leftBtn.tag = [indexPath row]*2;
        cell.rightBtn.tag = [indexPath row]*2+1;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)requestList
{
    // [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
  //  [ProgressHudCommon showHUDInView:self.view andInfo:@"请求数据中……" andImgName:nil andAutoHide:NO];
    
    [[NetController sharedInstance] postWithAPI:API_good_JsonDetail parameters:[NSMutableDictionary dictionaryWithCapacity:0] completionHandler:^(id responseObject, NSError *error){
        
        if (error) {
            
        }else
        {
            _CategoryArr = [NSMutableArray arrayWithArray:responseObject[@"data"][@"Categories"]];
            
            NSLog(@"_CategoryArr %@",_CategoryArr);
            
    
            [UserModel currentUser].normalCategoryArr = _CategoryArr;//暂存
            
            
            [self reloadData];
            
        }
        
    //    [ProgressHudCommon hiddenHUD:self.view];
        
        
        
        //[MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
        
        
    }];
    
}

@end
