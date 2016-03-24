//
//  CategorySelectView.m
//  TXXE
//
//  Created by River on 15/6/29.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "CategorySelectView.h"
#import "Constants.h"
#import "UserModel.h"
#import "NSString+Addition.h"

@implementation CategorySelectView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        lastSelectIndex = -1;
        curSelectIndex = -1;
        leftTempDic = [[NSMutableDictionary alloc] initWithCapacity:0];
        self.backgroundColor = tableBgColor;
        self.leftArr = [UserModel currentUser].normalCategoryArr;
        self.rightArr = [NSMutableArray arrayWithCapacity:0];
        self.allRightArr = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < [[UserModel currentUser].normalCategoryArr count]; i++) {
            
            NSLog(@"%@",[[[UserModel currentUser].normalCategoryArr objectAtIndex:i] objectForKey:@"subCategores"]);
            [self.allRightArr addObject:[[[UserModel currentUser].normalCategoryArr objectAtIndex:i] objectForKey:@"subCategories"]];
        }
        [self createCategorySelectView];
    }
    return self;
}

-(void)createCategorySelectView
{
    leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth*0.5, self.frame.size.height)];
    leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    leftTableView.backgroundColor = tableBgColor;
    leftTableView.dataSource =self;
    leftTableView.delegate = self;
    [self addSubview:leftTableView];
    
    rightTableView = [[UITableView alloc]initWithFrame:CGRectMake(KScreenWidth*0.5, 0, KScreenWidth*0.5, self.frame.size.height)];
    rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    rightTableView.backgroundColor = tableWhitColor;
    rightTableView.dataSource =self;
    rightTableView.delegate = self;
    [self addSubview:rightTableView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == leftTableView) {
        return 50;
    }else
    {
        return 40;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == leftTableView) {
        return [self.leftArr count];
    }else
    {
        return [self.rightArr count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==leftTableView) {
        
        static NSString * leftID = @"left";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:leftID];
        if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:leftID];
            
        }
        cell.textLabel.text =  [NSString realForString:[[self.leftArr objectAtIndex:[indexPath row]] objectForKey:@"name"]];
        cell.textLabel.textColor = lightBlackColor;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.contentView.backgroundColor = tableBgColor;
        return cell;

    }
    else
    {
        static NSString * rightID = @"rightID";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:rightID];
        if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rightID];
        }
        cell.textLabel.text =  [NSString realForString:[[self.rightArr objectAtIndex:[indexPath row]] objectForKey:@"name"]];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.contentView.backgroundColor = tableWhitColor;
        cell.textLabel.textColor = lightBlackColor;
        return cell;
        
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == leftTableView) {
        curSelectIndex = [indexPath row];
        if (lastSelectIndex == -1 || lastSelectIndex == curSelectIndex) {
            lastSelectIndex = curSelectIndex;
        }else
        {
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:lastSelectIndex inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            lastSelectIndex = curSelectIndex;
        }
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.textLabel.textColor = GreenFontColor;
        self.rightArr = [self.allRightArr objectAtIndex:indexPath.row];
        [rightTableView reloadData];
        
        if ([self.rightArr count] <= 0) {
            leftTempDic = [self.leftArr objectAtIndex:curSelectIndex];
            self.cellCallBack(leftTempDic);
        }
    }else
    {
        if (self.cellCallBack) {
            self.cellCallBack([self.rightArr objectAtIndex:[indexPath row]]);
        }
    }
    
}

@end
