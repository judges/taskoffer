//
//  SingleChatInfoViewController.m
//  TaskOffer
//
//  Created by BourbonZ on 15/3/17.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SingleChatInfoViewController.h"
#import "FriendListController.h"
#import "PhotoViewController.h"
#import "XMPPHelper.h"
#import "SLConnectionDetailViewController.h"
#import "TOHttpHelper.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageDownloader.h"
@interface SingleChatInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    NSArray *listArray;
}
@end

@implementation SingleChatInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"对话详情";
    
    ///准备数据
//    listArray = @[@"置顶聊天",@"消息免打扰",@"聊天图片",@"删除聊天记录"];
    listArray = @[@"聊天图片",@"删除聊天记录"];

    CustomTable *infoTable    = [[CustomTable alloc] initWithFrame:self.view.frame style:(UITableViewStyleGrouped)];
    [infoTable setDelegate:self];
    [infoTable setDataSource:self];
    infoTable.backgroundColor = [UIColor colorWithHexString:kDefaultGrayColor];
    [self.view addSubview:infoTable];
    
//    if (self.friendInfo == nil)
//    {
    
        [TOHttpHelper getUrl:kTOgetInfo parameters:@{@"id":_friendID,@"type":@"1"} showHUD:YES success:^(NSDictionary *dataDictionary)
        {
            
            UITableViewCell *cell = [infoTable cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
            NSString *iconStr = [NSString stringWithFormat:@"%@%@/%@",kTOHOSt,kTOUploadUserIcon,[[[dataDictionary objectForKey:@"info"] objectForKey:@"ServerAppUser"] objectForKey:@"userHeadPicture"]];
            
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:iconStr] options:(SDWebImageDownloaderUseNSURLCache) progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                
                UITableViewCell *cell = [infoTable cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
                UIButton *iconButton = (UIButton *)[cell.contentView viewWithTag:3001];
                [iconButton setImage:image forState:(UIControlStateNormal)];
            }];
            
            UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:3002];
            nameLabel.text = [[[dataDictionary objectForKey:@"info"] objectForKey:@"ServerAppUser"] objectForKey:@"userName"];
        }];

//    }
    
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
#pragma mark UITableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    return listArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        ///头像
        UIButton *friendIconButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        friendIconButton.layer.masksToBounds = NO;
        friendIconButton.layer.cornerRadius = 10.0f;
        [friendIconButton setFrame:CGRectMake(17, 17, 60, 60)];
        friendIconButton.tag = 3001;
        [friendIconButton addTarget:self action:@selector(clickFriendIcon:) forControlEvents:(UIControlEventTouchUpInside)];
//        [friendIconButton setImage:self.friendInfo.photo forState:(UIControlStateNormal)];
        
        ///姓名
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, 80, 60, 25)];
        nameLabel.font = [UIFont systemFontOfSize:13.0f];
        nameLabel.tag = 3002;
        nameLabel.textAlignment = NSTextAlignmentCenter;
        NSString *tmpName  = _friendID;
        
        nameLabel.text = [[XMPPRosterHelper sharedHelper] remarkNameOrNickNameForFriend:tmpName];
        
        [TOHttpHelper getUrl:kTOgetInfo parameters:@{@"id":_friendID,@"type":@"1"} showHUD:YES success:^(NSDictionary *dataDictionary) {
           
            NSString *name = [[[dataDictionary objectForKey:@"info"] objectForKey:@"ServerAppUser"] objectForKey:@"userName"];
            [[XMPPRosterHelper sharedHelper] changeNickForDatabase:name useID:_friendID];
            nameLabel.text = name;
            NSString *headPath = [NSString stringWithFormat:@"%@%@/%@",kTOHOSt,kTOUploadUserIcon,[[[dataDictionary objectForKey:@"info"] objectForKey:@"ServerAppUser"] objectForKey:@"userHeadPicture"]];

            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:headPath] options:(SDWebImageDownloaderLowPriority) progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
               
                if (image != nil)
                {
                    [friendIconButton setImage:image forState:(UIControlStateNormal)];
                }
                else
                {
                    [friendIconButton setImage:kDefaultIcon forState:(UIControlStateNormal)];
                }
                
            }];

            
        }];
        
        ///添加按钮
        UIButton *addButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        addButton.layer.masksToBounds = NO;
        addButton.layer.cornerRadius = 10.0f;
        [addButton setFrame:CGRectMake(17*2 + 60, 17, 60, 60)];
        [addButton addTarget:self action:@selector(clickAddButton:) forControlEvents:(UIControlEventTouchUpInside)];
        [addButton setImage:[UIImage imageNamed:@"添加照片"] forState:(UIControlStateNormal)];

        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:nil];
        [cell.contentView addSubview:friendIconButton];
        [cell.contentView addSubview:nameLabel];
//        [cell.contentView addSubview:addButton];
        [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
        return cell;
    }
    else
    {
        static NSString *cellID = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellID];
        }
        
//        if (indexPath.row == 0 || indexPath.row == 1)
//        {
//            UISwitch *switchButton = [[UISwitch alloc] init];
//            [switchButton addTarget:self action:@selector(clickSwitchButton:) forControlEvents:(UIControlEventValueChanged)];
//            switchButton.tag = indexPath.row;
//            [switchButton setCenter:CGPointMake(self.view.frame.size.width-40, cell.frame.size.height/2)];
//            [cell.contentView addSubview:switchButton];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        }
        if (indexPath.row == 0)
        {
            [cell setAccessoryType:(UITableViewCellAccessoryDisclosureIndicator)];
        }
        cell.textLabel.text = [listArray objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
        [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 105;
    }
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            PhotoViewController *photo = [[PhotoViewController alloc] init];
            photo.type = singleChat;
//            photo.currentName = self.friendInfo.jid.user;
//            if (self.friendInfo == nil)
//            {
                photo.currentName = _friendID;
//            }
            [self.navigationController pushViewController:photo animated:YES];
        }
        else if (indexPath.row == 1)
        {
            ///删除聊天记录
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要清空与其的聊天记录吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }
    }
}
#pragma mark 点击开关按钮
-(void)clickSwitchButton:(UISwitch *)switchButton
{

}
#pragma mark 点击好友头像
-(void)clickFriendIcon:(UIButton *)button
{
    SLConnectionDetailViewController *detail = [[SLConnectionDetailViewController alloc] init];
//    if (self.friendInfo.jid.user == nil || [self.friendInfo.jid.user isEqualToString:@""])
//    {
        detail.userID = _friendID;
//    }
//    else
//    {
//        detail.userID = self.friendInfo.jid.user;
//    }
    [self.navigationController pushViewController:detail animated:YES];
}
#pragma mark 点击添加按钮
-(void)clickAddButton:(UIButton *)button
{
    FriendListController *friendList = [[FriendListController alloc] init];
    friendList.title = @"选择好友";
    friendList.popController = self;
//    friendList.defaultArray = [NSMutableArray arrayWithObject:self.friendInfo];
    UINavigationController *friendNavi = [[UINavigationController alloc] initWithRootViewController:friendList];
    [self presentViewController:friendNavi animated:YES completion:nil];
}
#pragma mark UIALertDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        XMPPHelper *helper = [XMPPHelper sharedHelper];
        NSString *tmpID = _friendID;
//        if (self.friendInfo == nil)
//        {
//            tmpID = _friendID;
//        }
        NSError *error = [helper deleteAllMessageWithFriend:tmpID andMessages:nil];
        ///删除最近联系人
        [[XMPPHelper sharedHelper] deleteRecentPeople:@[tmpID]];

        if (error == nil)
        {
            [HUDView showHUDWithText:@"删除成功"];
        }
        else
        {
            [HUDView showHUDWithText:@"删除失败"];

        }
    }
}
@end
