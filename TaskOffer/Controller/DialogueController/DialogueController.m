//
//  DialogueController.m
//  TaskOffer
//
//  Created by BourbonZ on 15/3/12.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "DialogueController.h"
#import "DialogueModel.h"
#import "DialogueCell.h"
#import "SingleChatController.h"
#import "GroupChatViewController.h"
#import "FriendListController.h"
#import "ProjectDialogueView.h"
#import "ProjectDialogueTableController.h"
#import "TOHttpHelper.h"
@interface DialogueController ()<xmppDelegate,UITableViewDataSource,UITableViewDelegate,XMPPRoomHelperDelegate,ProjectDialogueViewDelegate>
{
    NSMutableArray *listArray;
    CustomTable *listTable;
}
@end

@implementation DialogueController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    listArray = [DialogueModel allDialogue];

    [listTable reloadData];
    XMPPHelper *helper = [XMPPHelper sharedHelper];
    [helper setDelegate:self];
    NSString *badgeValue = [[RedViewHelper sharedHelper] allRedViewWithType:[NSNumber numberWithInt:1]];
    self.tabBarItem.badgeValue = badgeValue;
    
    ProjectDialogueView *projectDialogueView = [[ProjectDialogueView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 66)];
    [projectDialogueView setDelegate:self];
    listTable.tableHeaderView = projectDialogueView;


}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ///左侧搜索按钮
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemSearch) target:self action:@selector(clickSearchButton)];
    ///右侧添加按钮
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemAdd) target:self action:@selector(clickAddButton)];
    
    ///设置表格
    listTable = [[CustomTable alloc] initWithFrame:self.view.frame style:(UITableViewStylePlain)];
    listTable.dataSource = self;
    listTable.delegate = self;
    listTable.backgroundColor = [UIColor colorWithHexString:kDefaultGrayColor];
    listTable.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:listTable];
    
    listArray = [NSMutableArray array];

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
#pragma mark 点击搜索按钮
-(void)clickSearchButton
{

}
#pragma mark 点击添加按钮
-(void)clickAddButton
{
    FriendListController *friendList = [[FriendListController alloc] init];
    friendList.title = @"选择好友";
    friendList.popController = self;
    UINavigationController *friendNavi = [[UINavigationController alloc] initWithRootViewController:friendList];
    [self presentViewController:friendNavi animated:YES completion:nil];
}
#pragma mark UITableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listArray.count;
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    XMPPContactInfo *object = [listArray objectAtIndex:indexPath.row];
    
    [[XMPPHelper sharedHelper] deleteRecentPeople:@[object.bareJid.user]];
    [[RedViewHelper sharedHelper] deleteRedViewFromJID:object.bareJid.user withType:[NSNumber numberWithInt:1]];
    [listArray removeObject:object];
    [listTable reloadData];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66.0f;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }

    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    XMPPContactInfo *object = [listArray objectAtIndex:indexPath.row];
    NSString *name =  [[XMPPRosterHelper sharedHelper] remarkNameOrNickNameForFriend:object.bareJid.user];

    if ([object.bareJid.user isEqualToString:name])
    {
        [TOHttpHelper getUrl:kTOgetInfo parameters:@{@"id":object.bareJid.user,@"type":@"1"} showHUD:NO success:^(NSDictionary *dataDictionary) {
            
            NSString *name = [[[dataDictionary objectForKey:@"info"] objectForKey:@"ServerAppUser"] objectForKey:@"userName"];
            [[XMPPRosterHelper sharedHelper] changeNickForDatabase:name useID:object.bareJid.user];
//            [tableView reloadData];
        }];
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    DialogueCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[DialogueCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellID];
    }
    
    ///最近联系人列表
    XMPPContactInfo *object = [listArray objectAtIndex:indexPath.row];
    
    XMPPRosterHelper *rosterHelper = [XMPPRosterHelper sharedHelper];
    XMPPFriendInfo *roster = [rosterHelper friendInfomationWithUserName:object.bareJid.user];
    
    ///头像
    UIImage *image = [roster photo];
    if (image == nil)
    {
        image = kUserDefaultIcon;
    }
    cell.iconView.image = image;
    
    GroupChatInfoHelper *groupInfo = [GroupChatInfoHelper shared];
    cell.nameLabel.text = [[XMPPRosterHelper sharedHelper] remarkNameOrNickNameForFriend:object.bareJid.user];
    
//    if (roster == nil)
//    {
        //创建的临时会话
        [TOHttpHelper getUrl:kTOgetInfo parameters:@{@"id":object.bareJid.user,@"type":@"1"} showHUD:NO success:^(NSDictionary *dataDictionary) {
            NSString *iconStr = [NSString stringWithFormat:@"%@%@/%@",kTOHOSt,kTOUploadUserIcon,[[[dataDictionary objectForKey:@"info"] objectForKey:@"ServerAppUser"] objectForKey:@"userHeadPicture"]];
//            if (image == nil)
//            {
                [cell.iconView sd_setImageWithURL:[NSURL URLWithString:iconStr] placeholderImage:image];
//            }
            cell.nameLabel.text = [[[dataDictionary objectForKey:@"info"] objectForKey:@"ServerAppUser"] objectForKey:@"userName"];
        }];
//    }
    
    
    if ([object.bareJidStr rangeOfString:kGROUPCHATLOGO].location != NSNotFound)
    {
        ///群聊
        NSString *groupName = [groupInfo searchGroupChatInfo:object.bareJid.user];
        if (groupName.length == 0)
        {
            cell.nameLabel.text = @"群昵称";
        }
        cell.nameLabel.text = groupName;
        cell.iconView.image = [UIImage imageNamed:@"群聊"];
    }
    ///显示的内容
    cell.contentLabel.text = object.mostRecentMessageBody;
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[object.mostRecentMessageBody dataUsingEncoding:NSUTF8StringEncoding] options:(NSJSONReadingMutableLeaves) error:nil];
    if (dict != nil)
    {
        NSString *path = [dict objectForKey:@"itemPicPath"];
//        if ([path rangeOfString:kTOUploadUserIcon].location != NSNotFound)
//        {
//            cell.contentLabel.text = @"[名片]";
//        }
//        else if([path rangeOfString:kTOCompanyPicPath].location != NSNotFound)
//        {
//            cell.contentLabel.text = @"[企业号]";
//        }
//        else if([path rangeOfString:@"/uploads/case_logo_picture/"].location != NSNotFound)
//        {
//            cell.contentLabel.text = @"[案例]";
//        }
//        else if([path rangeOfString:@""].location != NSNotFound)
//        {
//            cell.contentLabel.text = @"[推荐内容]";
//        }
        if (path != nil)
        {
            cell.contentLabel.text = @"[推荐内容]";
        }
    }
    
    
    if ([object.mostRecentMessageBody rangeOfString:kFILEHOST].location != NSNotFound)
    {
        NSString *fileName = [[object.mostRecentMessageBody componentsSeparatedByString:@"/"] lastObject];
        if ([fileName rangeOfString:@".amr"].location != NSNotFound)
        {
            cell.contentLabel.text = @"[语音]";
        }
        else if ([fileName rangeOfString:@".jpg"].location != NSNotFound ||
                 [fileName rangeOfString:@".png"].location != NSNotFound ||
                 [fileName rangeOfString:@".tmp"].location != NSNotFound ||
                 [fileName rangeOfString:@".jpeg"].location != NSNotFound)
        {
            cell.contentLabel.text = @"[图片]";
        }
        else
        {
            cell.contentLabel.text = object.mostRecentMessageBody;
        }
    }
    
    cell.timeLabel.text = [TimeHelper timeForMessage:object.mostRecentMessageTimestamp];
    
    
    ///显示红点
    RedViewInfo *redInfo = [[[RedViewHelper sharedHelper] searchRedViewFromJID:object.bareJid.user withType:[NSNumber numberWithInt:1]] firstObject];
    if (redInfo.showRed.boolValue)
    {
        [cell.redView setHidden:NO];
    }
    else
    {
        [cell.redView setHidden:YES];
    }
    cell.backgroundColor = [UIColor colorWithHexString:kDefaultBackColor];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XMPPContactInfo *object = [listArray objectAtIndex:indexPath.row];
    NSString *userName = object.bareJid.user;
    
    ///修改红点
    [[RedViewHelper sharedHelper] changeRedViewFromJID:userName withType:[NSNumber numberWithInt:1] andShow:NO];
    
    if ([object.bareJidStr rangeOfString:kGROUPCHATLOGO].location != NSNotFound)
    {
        XMPPRoomHelper *roomHelper = [XMPPRoomHelper sharedRoom];
        [roomHelper setDelegate:self];
        
        GroupChatViewController *groupChat = [[GroupChatViewController alloc] init];
        groupChat.roomJID = object.bareJid;
        groupChat.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:groupChat animated:YES];
        
    }
    else
    {
        SingleChatController *singleChat = [[SingleChatController alloc] init];
        XMPPFriendInfo *object = [[XMPPRosterHelper sharedHelper] friendInfomationWithUserName:userName];
        singleChat.currentUser = object;
        singleChat.currentUserName = object.jid.user;
        if (object == nil)
        {
            singleChat.currentUserName = userName;
        }
        singleChat.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:singleChat animated:YES];
    }
}

#pragma mark ProjectDialogueViewDelegate
-(void)clickProjectDialogueView
{
    ProjectDialogueTableController *tableController = [[ProjectDialogueTableController alloc] init];
    tableController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:tableController animated:YES];
}
#pragma mark 更新最近联系人列表
-(void)refreshDialogueView
{
    listArray = [DialogueModel allDialogue];
    
    [listTable reloadData];

}
@end
