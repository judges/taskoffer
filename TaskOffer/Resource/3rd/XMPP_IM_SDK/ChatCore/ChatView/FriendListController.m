//
//  FriendListController.m
//  XMPPIM
//
//  Created by BourbonZ on 14/12/23.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import "FriendListController.h"
#import "XMPPHelper.h"
#import "XMPPRoomHelper.h"
#import "SingleChatController.h"
#import "GroupChatViewController.h"
#import "ToolHelper.h"
#import "AppDelegate.h"
#import "GroupChatViewController.h"
#import "MBProgressHUD.h"
#import "GroupChatInfoHelper.h"
#import "ContactCell.h"
#import "TOHttpHelper.h"
@interface FriendListController ()<UITableViewDelegate,UITableViewDataSource,XMPPRoomHelperDelegate>
{
    UITableView *listTable;
    NSMutableArray *listArray;
    NSMutableArray *addFriendArray;
    MBProgressHUD *HUD;
    NSDictionary *valueDict;
    NSArray *keyArray;
}
@end

@implementation FriendListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发起聊天";
    // Do any additional setup after loading the view.
    listTable                 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:(UITableViewStylePlain)];
    listTable.dataSource      = self;
    listTable.delegate        = self;
    listTable.tableFooterView = [[UIView alloc] init];
    listTable.sectionIndexBackgroundColor = [UIColor clearColor];
    listTable.backgroundColor = [UIColor colorWithHexString:kDefaultBackColor];
    listTable.sectionIndexColor = [UIColor colorWithHexString:@"004d93"];
    listArray = [NSMutableArray array];
    [listArray addObjectsFromArray:[XMPPHelper allMyFriendsWithState:kAllFriend]];
    addFriendArray = [NSMutableArray array];
    
    //好友信息
    valueDict = [ToolHelper arrayToDictionary:listArray];
    keyArray = [[valueDict allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];

    [self.view addSubview:listTable];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:(UIBarButtonItemStylePlain) target:self action:@selector(clickDoneButton:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:(UIBarButtonItemStylePlain) target:self action:@selector(clickCancelButton)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 点击取消按钮
-(void)clickCancelButton
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark 点击确认按钮
-(void)clickDoneButton:(UIBarButtonItem *)button
{
    if (addFriendArray.count == 1)
    {
        SingleChatController *chat = [[SingleChatController alloc] init];
//        chat.currentUser = [addFriendArray firstObject];
        chat.popToRoot = YES;
        FriendUserInfo *friendUserInfo = [addFriendArray firstObject];
        chat.currentUserName = friendUserInfo.userID;
        [self dismissViewControllerAnimated:YES completion:^{
            chat.hidesBottomBarWhenPushed = YES;
            [self.popController.navigationController pushViewController:chat animated:YES];
        }];
    }
    else if (addFriendArray.count > 1)
    {
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [HUD setLabelText:@"正在创建"];
        [HUD show:YES];
        [self.view addSubview:HUD];
        
        NSString *groupName = [ToolHelper deviceUUID];
        XMPPRoomHelper *roomHelper = [XMPPRoomHelper sharedRoom];
        [roomHelper setDelegate:self];
        XMPPJID *jid = kDefaultJID;
        [roomHelper createChatRoomWithName:groupName withNickName:jid.user];
    }

}
#pragma mark UITableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [keyArray count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = [keyArray objectAtIndex:section];
    NSArray *array = [valueDict objectForKey:key];
    return [array count];
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *key = [keyArray objectAtIndex:section];
    return key;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [[[valueDict allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }] objectAtIndex:(indexPath.section)];
    NSArray *array = [valueDict objectForKey:key];
    FriendUserInfo *object = [array objectAtIndex:indexPath.row];
    NSString *name = [[XMPPRosterHelper sharedHelper] remarkNameOrNickNameForFriend:object.userID];
    if ([object.userID isEqualToString:name])
    {
        [TOHttpHelper getUrl:kTOgetInfo parameters:@{@"id":object.userID,@"type":@"1"} showHUD:NO success:^(NSDictionary *dataDictionary) {
            
            NSString *name = [[[dataDictionary objectForKey:@"info"] objectForKey:@"ServerAppUser"] objectForKey:@"userName"];
            [[XMPPRosterHelper sharedHelper] changeNickForDatabase:name useID:object.userID];
            //好友信息
            listArray = [[XMPPHelper allMyFriendsWithState:kAllFriend] mutableCopy];
            valueDict = [ToolHelper arrayToDictionary:listArray];
            NSString *headPath = [NSString stringWithFormat:@"%@%@/%@",kTOHOSt,kTOUploadUserIcon,[[[dataDictionary objectForKey:@"info"] objectForKey:@"ServerAppUser"] objectForKey:@"userHeadPicture"]];
            [object setHeadPath:headPath];
            
            
            [listTable reloadData];
            
        }];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellID = @"cell";
    ContactCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[ContactCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellID];
    }
    
    NSString *key = [keyArray objectAtIndex:indexPath.section];
    NSArray *array = [valueDict objectForKey:key];
    FriendUserInfo *object = [array objectAtIndex:indexPath.row];
    cell.nameLabel.text = [[XMPPRosterHelper sharedHelper] remarkNameOrNickNameForFriend:object.userID];
    cell.redView.hidden = YES;
    [TOHttpHelper getUrl:kTOgetInfo parameters:@{@"id":object.userID,@"type":@"1"} showHUD:NO success:^(NSDictionary *dataDictionary) {
        
        NSString *headPath = [NSString stringWithFormat:@"%@%@/%@",kTOHOSt,kTOUploadUserIcon,[[[dataDictionary objectForKey:@"info"] objectForKey:@"ServerAppUser"] objectForKey:@"userHeadPicture"]];
        
        [cell.iconView sd_setImageWithURL:[NSURL URLWithString:headPath] placeholderImage:kDefaultIcon];
        
        
    }];

    
    if ([self.defaultArray containsObject:object])
    {
        [cell setAccessoryType:(UITableViewCellAccessoryCheckmark)];
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *key = [keyArray objectAtIndex:indexPath.section];
    NSArray *array = [valueDict objectForKey:key];
    FriendUserInfo *object = [array objectAtIndex:indexPath.row];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark)
    {
        [cell setAccessoryType:(UITableViewCellAccessoryNone)];
        [addFriendArray removeObject:object];
    }
    else
    {
        [cell setAccessoryType:(UITableViewCellAccessoryCheckmark)];
        [addFriendArray addObject:object];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 63.0f;
}
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return keyArray;
}

#pragma mark 创建群聊成功再邀请好友
-(void)joinRoomSuccess:(XMPPRoom *)room
{
    [HUD hide:YES];
    [HUD removeFromSuperview];
    HUD = nil;
    
    NSString *roomSubject = @"";
    for (int i = 0; i < addFriendArray.count; i++)
    {
        FriendUserInfo *object = [addFriendArray objectAtIndex:i];
        [room inviteUser:[XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",object.userID,kDOMAIN]] withMessage:@"sss"];
        roomSubject = [roomSubject stringByAppendingFormat:@"%@,",[object userID]];
    }
    roomSubject = [roomSubject substringToIndex:roomSubject.length-1];
    [room changeRoomSubject:roomSubject];
    
    GroupChatViewController *groupChat = [[GroupChatViewController alloc] init];
    XMPPRoomHelper *roomHelper = [XMPPRoomHelper sharedRoom];
    XMPPRoomMemberInfo *info = [roomHelper searchGroupWithName:room.roomJID.user];
    groupChat.roomJID = room.roomJID;
    groupChat.popToRoot = YES;
    
    GroupChatInfoHelper *groupInfo = [GroupChatInfoHelper shared];
    [groupInfo addGroupChat:info.roomJID.user subject:roomSubject];
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self.popController.navigationController pushViewController:groupChat animated:YES];
    }];
}
@end
