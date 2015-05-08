//
//  GroupViewController.m
//  XMPPIM
//
//  Created by BourbonZ on 14/12/17.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import "GroupViewController.h"
#import "XMPPRoomHelper.h"
#import "XMPPRoomOccupantCoreDataStorageObject.h"
#import "GroupChatViewController.h"
#import "MBProgressHUD+Conveniently.h"

@interface GroupViewController ()<UITableViewDataSource,UITableViewDelegate,XMPPRoomHelperDelegate>
{
    UITableView *listTable;
    NSMutableArray *listArray;
}
@end

@implementation GroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我加入的群";
    
    ///表格
    listTable            = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64) style:(UITableViewStylePlain)];
    listTable.dataSource = self;
    listTable.delegate   = self;
    listTable.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:listTable];
    
    ///数据
    XMPPRoomHelper *helper = [XMPPRoomHelper sharedRoom];
    [helper setDelegate:self];
    [helper getAllMyExitsRoom];
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
#pragma mark UITableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    UITableViewCell *cell   = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellID];
    }
    
    NSMutableDictionary *dict = [listArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [dict objectForKey:kRoomName];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dict = [listArray objectAtIndex:indexPath.row];
    GroupChatViewController *groupChat = [[GroupChatViewController alloc] init];
    groupChat.roomJID = [dict objectForKey:kRoomID];
    [self.navigationController pushViewController:groupChat animated:YES];
}

#pragma 所有加入的群
-(void)allMyJoinRoomWithResult:(NSArray *)array
{
    listArray = [array mutableCopy];
    [listTable reloadData];
}
@end
