//
//  AddressViewController.m
//  TaskOffer
//
//  Created by BourbonZ on 15/3/16.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "AddressViewController.h"
#import "ContactCell.h"
#import "SingleChatController.h"
#import "GroupChatViewController.h"
#import "GroupViewController.h"
#import "FriendRequestViewController.h"
#import "AddFriendController.h"
#import "TOHttpHelper.h"
#import "SDWebImageDownloader.h"
#import "RegisterController.h"
#import "SLConnectionDetailViewController.h"
@interface AddressViewController ()<XMPPRoomHelperDelegate,xmppRosertHelperDelegate,UISearchBarDelegate,UISearchDisplayDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UISearchDisplayController *search;
    NSMutableArray *searchArray;
    
    CustomTable *addressTable;
    NSMutableArray *addressArray;
    NSMutableArray *menuArray;
    NSDictionary *valueDict;

}
@end

@implementation AddressViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //好友信息
    addressArray = [[XMPPHelper allMyFriendsWithState:kAllFriend] mutableCopy];
    //    [addressArray addObjectsFromArray:[XMPPHelper allMyFriendsWithState:kAllFriend]];
    valueDict = [ToolHelper arrayToDictionary:addressArray];
    [addressTable reloadData];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"通讯录";
    
//    menuArray = [NSMutableArray arrayWithObjects:@"新的好友",@"群聊", nil];
    menuArray = [NSMutableArray arrayWithObjects:@"新的好友", nil];

    ///表格
    addressTable = [[CustomTable alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:(UITableViewStyleGrouped)];
    addressTable.delegate = self;
    addressTable.dataSource = self;
    [addressTable setSectionIndexBackgroundColor:[UIColor clearColor]];
    [addressTable setSectionIndexColor:[UIColor colorWithHexString:@"004d93"]];
    [self.view addSubview:addressTable];
    
    ///搜索
    UISearchBar *bar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    bar.delegate = self;
//    addressTable.tableHeaderView = bar;
    search = [[UISearchDisplayController alloc] initWithSearchBar:bar contentsController:self];
    [search setSearchResultsDataSource:self];
    [search setSearchResultsDelegate:self];
    ///搜索用到的数组
    searchArray = [NSMutableArray array];
    
    XMPPRosterHelper *rosterHelper = [XMPPRosterHelper sharedHelper];
    [rosterHelper setDelegate:self];
    
    ///点击进入添加好友界面
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemAdd) target:self action:@selector(toAddFriendController)];

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
#pragma mark 添加朋友界面
-(void)toAddFriendController
{
    AddFriendController *add = [[AddFriendController alloc] init];
    [self.navigationController pushViewController:add animated:YES];
}
#pragma mark Tableview Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == addressTable)
    {
        return 1 + [valueDict allKeys].count;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 63.0f;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == addressTable)
    {
        if (section == 0)
        {
            return menuArray.count;
        }
        NSString *key = [[[valueDict allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [obj1 compare:obj2];
        }] objectAtIndex:(section - 1)];
        NSArray *array = [valueDict objectForKey:key];
        return array.count;
    }
    return searchArray.count;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }

    if (tableView == addressTable)
    {
        if (indexPath.section != 0)
        {
            NSString *key = [[[valueDict allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                return [obj1 compare:obj2];
            }] objectAtIndex:(indexPath.section-1)];
            NSArray *array = [valueDict objectForKey:key];
            FriendUserInfo *object = [array objectAtIndex:indexPath.row];
            NSString *name = [[XMPPRosterHelper sharedHelper] remarkNameOrNickNameForFriend:object.userID];
            if ([object.userID isEqualToString:name])
            {
                [TOHttpHelper getUrl:kTOgetInfo parameters:@{@"id":object.userID,@"type":@"1"} showHUD:NO success:^(NSDictionary *dataDictionary) {
                   
                    NSString *name = [[[dataDictionary objectForKey:@"info"] objectForKey:@"ServerAppUser"] objectForKey:@"userName"];
                    [[XMPPRosterHelper sharedHelper] changeNickForDatabase:name useID:object.userID];
                    //好友信息
                    addressArray = [[XMPPHelper allMyFriendsWithState:kAllFriend] mutableCopy];
                    valueDict = [ToolHelper arrayToDictionary:addressArray];
                    NSString *headPath = [NSString stringWithFormat:@"%@%@/%@",kTOHOSt,kTOUploadUserIcon,[[[dataDictionary objectForKey:@"info"] objectForKey:@"ServerAppUser"] objectForKey:@"userHeadPicture"]];
                    [object setHeadPath:headPath];
                    
                    
                    [addressTable reloadData];

                }];
            }
        }
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
    
    if (tableView == addressTable)
    {
        if (indexPath.section == 0)
        {
            NSString *value = [[RedViewHelper sharedHelper] allRedViewWithType:[NSNumber numberWithInt:2]];
            if (indexPath.row == 0)
            {
                cell.redView.hidden = NO;
                if (value == nil)
                {
                    cell.redView.hidden = YES;
                }
            }
            else
            {
                cell.redView.hidden = YES;
            }
            cell.nameLabel.text = [menuArray objectAtIndex:indexPath.row];
            cell.iconView.image = [UIImage imageNamed:[menuArray objectAtIndex:indexPath.row]];
        }
        else
        {
            cell.redView.hidden = YES;
            NSString *key = [[[valueDict allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                return [obj1 compare:obj2];
            }] objectAtIndex:(indexPath.section-1)];
            NSArray *array = [valueDict objectForKey:key];
            FriendUserInfo *object = [array objectAtIndex:indexPath.row];
            cell.nameLabel.text = [[XMPPRosterHelper sharedHelper] remarkNameOrNickNameForFriend:object.userID];
            
            [TOHttpHelper getUrl:kTOgetInfo parameters:@{@"id":object.userID,@"type":@"1"} showHUD:NO success:^(NSDictionary *dataDictionary) {
                
                if ([[[dataDictionary objectForKey:@"info"] objectForKey:@"ServerAppUser"] isKindOfClass:[NSNull class]])
                {
                    cell.iconView.image = kUserDefaultIcon;
                    return ;
                }
                
                NSString *headPath = [NSString stringWithFormat:@"%@%@/%@",kTOHOSt,kTOUploadUserIcon,[[[dataDictionary objectForKey:@"info"] objectForKey:@"ServerAppUser"] objectForKey:@"userHeadPicture"]];

                [cell.iconView sd_setImageWithURL:[NSURL URLWithString:headPath] placeholderImage:kUserDefaultIcon];
                
                
            }];

            
        }
    }
    else
    {
        cell.redView.hidden = YES;
        
        XMPPFriendInfo *object = [searchArray objectAtIndex:indexPath.row];
        cell.iconView.image = kUserDefaultIcon;
        if (object.photo != nil)
        {
            cell.iconView.image = object.photo;
        }
        cell.nameLabel.text = [[XMPPRosterHelper sharedHelper] remarkNameOrNickNameForFriend:object.jid.user];
        
    }
    cell.selectView.hidden = YES;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (![[UserInfo sharedInfo] userInfoIntegrity])
    {
        RegisterController *registerController = [[RegisterController alloc] init];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:registerController];
        [self presentViewController:navi animated:YES completion:nil];

        return;
    }
    
    
    if (tableView == addressTable)
    {
        if (indexPath.section == 0)
        {
            if (indexPath.row == 0)
            {
                [[RedViewHelper sharedHelper] changeRedViewFromJID:nil withType:[NSNumber numberWithInt:2] andShow:NO];
                FriendRequestViewController *request = [[FriendRequestViewController alloc] init];
                request.hidesBottomBarWhenPushed = YES;
                [self.tabBarItem setBadgeValue:nil];
                [self.navigationController pushViewController:request animated:YES];
            }
            else if(indexPath.row == 1)
            {
                
                GroupViewController *groupView = [[GroupViewController alloc] init];
                groupView.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:groupView animated:YES];
            }
        }
        else
        {
            NSString *key = [[[valueDict allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                return [obj1 compare:obj2];
            }] objectAtIndex:(indexPath.section-1)];
            NSArray *array = [valueDict objectForKey:key];
            FriendUserInfo *object = [array objectAtIndex:indexPath.row];
//            SingleChatController *chat = [[SingleChatController alloc] init];
//            chat.hidesBottomBarWhenPushed = YES;
//            chat.currentUser = object;
//            chat.currentUserName = object.jid.user;
//            [self.navigationController pushViewController:chat animated:YES];
            
            SLConnectionDetailViewController *detail = [[SLConnectionDetailViewController alloc] init];
            detail.userID = object.userID;
            detail.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detail animated:YES];
        }
    }
    else
    {
        XMPPFriendInfo *object = [searchArray objectAtIndex:indexPath.row];
        SingleChatController *chat = [[SingleChatController alloc] init];
        chat.hidesBottomBarWhenPushed = YES;
        chat.currentUser = object;
        chat.currentUserName = object.jid.user;
        [self.navigationController pushViewController:chat animated:YES];
        
    }
}
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == addressTable)
    {
        NSArray *array = [[valueDict allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [obj1 compare:obj2];
        }];
        
        NSMutableArray *tmpArray = [NSMutableArray array];
        for (NSString *str in array)
        {
            NSString *tmp = [str uppercaseString];
            [tmpArray addObject:tmp];
        }
        return tmpArray;
    }
    return nil;
}
//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *view = [[UILabel alloc] initWithFrame:CGRectMake(0, -12, 100,12)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, -12, 100, 12)];
    if (section > 0)
    {
        NSString *key = [[[valueDict allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [obj1 compare:obj2];
        }]objectAtIndex:(section - 1)];
        key = [key uppercaseString];
        [label setText:key];
    }
    else
    {
        [label setText:@""];
    }
    [label setFont:[UIFont systemFontOfSize:13.5f]];
    [view addSubview:label];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0.1f;
    }
    return 5.0f;
}
#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark UIAlertView
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        NSString *roomName = [[alertView textFieldAtIndex:0] text];
        if (roomName.length > 0)
        {
            ///创建聊天室，并输入自己在群里的昵称和群的昵称
            XMPPRoomHelper *roomHelper = [XMPPRoomHelper sharedRoom];
            [roomHelper setDelegate:self];
            [roomHelper createChatRoomWithName:roomName withNickName:@"123"];
        }
        return;
    }
}
#pragma mark XMPPRoomHelper Delegate
-(void)joinRoomSuccess:(XMPPRoom *)room
{
    GroupChatViewController *groupChat = [[GroupChatViewController alloc] init];
    groupChat.roomJID = room.roomJID;
    groupChat.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:groupChat animated:YES];
}
#pragma mark xmppRoterHelperDelegate
-(void)friendCallOffRelationship
{
    [addressArray removeAllObjects];
    [addressArray addObjectsFromArray:[XMPPHelper allMyFriendsWithState:kAllFriend]];
    valueDict = [ToolHelper arrayToDictionary:addressArray];
    [addressTable reloadData];
}
#pragma mark UISearchDis Delegate
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length == 0)
    {
        [searchArray removeAllObjects];
    }
    for (int i = 0 ; i < addressArray.count; i++)
    {
        XMPPFriendInfo *info = [addressArray objectAtIndex:i];
        
        if ([info.jid.user rangeOfString:searchText].location != NSNotFound ||
            [info.nickname rangeOfString:searchText].location != NSNotFound ||
            [[[XMPPRosterHelper sharedHelper] remarkNameOrNickNameForFriend:info.jid.user] rangeOfString:searchText].location != NSNotFound)
        {
            if (![searchArray containsObject:info])
            {
                [searchArray addObject:info];
            }
        }
    }
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchArray removeAllObjects];
}

@end
