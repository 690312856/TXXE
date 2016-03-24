//
//  RuleDetailTableViewController.m
//  TXXE
//
//  Created by 李雨龙 on 15/9/5.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "RuleDetailTableViewController.h"
#import "ProgressHudCommon.h"
#import "NetController.h"
#import "RuleDetailTableViewCell.h"

@interface RuleDetailTableViewController ()

@end

@implementation RuleDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestData];
    [self.tableView registerNib:[UINib nibWithNibName:@"RuleDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"KRuleDetailTableViewCellReusedKey"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)requestData
{
    [ProgressHudCommon showHUDInView:self.view andInfo:@"数据加载中..." andImgName:nil andAutoHide:NO];
    [[NetController sharedInstance] postWithAPI:API_score_rule parameters:nil completionHandler:^(id responseObject, NSError *error) {
        if (error) {
            
        }else
        {
            RulesArr = [[NSMutableArray alloc] init];
            for (NSDictionary *dict in responseObject[@"data"])
            {   NSMutableDictionary *temp = [[NSMutableDictionary alloc] initWithDictionary:dict];
                [RulesArr addObject:temp];
            }
            [ProgressHudCommon hiddenHUD:self.view];
            [self.tableView reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [RulesArr count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RuleDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KRuleDetailTableViewCellReusedKey" forIndexPath:indexPath];
        [cell refreshWithDic:RulesArr[indexPath.row]];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
