//
//  FriendRequestViewController.m
//  rndIM
//
//  Created by BourbonZ on 14/12/6.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import "FriendRequestViewController.h"
#import "XMPPHelper.h"
#import "XMPPVCardHelper.h"
#import "XMPPFriendInfo.h"
#import "XMPPDataHelper.h"
#import "FriendRequestInfoHelper.h"
#import "TOHttpHelper.h"
#import "UIImageView+WebCache.h"
@interface FriendRequestViewController ()
{
    NSString *tmpObject;
}
@end

@implementation FriendRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"好友请求";
    listTable = [[UITableView alloc] initWithFrame:self.view.frame style:(UITableViewStylePlain)];
    listTable.delegate = self;
    listTable.dataSource = self;
    listTable.backgroundColor = [UIColor colorWithHexString:kDefaultGrayColor];
    listTable.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:listTable];
//    requestArray = [NSMutableArray arrayWithArray:[XMPPHelper allMyFriendsWithState:kFriendRequest]];
    requestArray = [[FriendRequestInfoHelper shared] selectAllFriendRequestWithFriendJID:nil];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return requestArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:cellID];
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.size.width-100, 10, 80, cell.frame.size.height)];
        messageLabel.tag = 9001;
        messageLabel.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:messageLabel];
        
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        [iconView setTag:4001];
        [cell.contentView addSubview:iconView];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, self.view.frame.size.width-60-100, 20)];
        nameLabel.tag = 4002;
        [nameLabel setFont:[UIFont systemFontOfSize:15.0f]];
        [cell.contentView addSubview:nameLabel];
        
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 30, self.view.frame.size.width-60-100, 20)];
        [contentLabel setTag:4003];
        [contentLabel setFont:[UIFont systemFontOfSize:13.0f]];
        [cell.contentView addSubview:contentLabel];
    }
    
    FriendRequestInfo *object = [requestArray objectAtIndex:indexPath.row];
    
    UILabel *contentLabel = (UILabel *)[cell.contentView viewWithTag:4003];
    contentLabel.text = object.state;
    if ([object.state isEqualToString:kRequest])
    {
        contentLabel.text = @"是否添加对方为好友?";
    }
    else if ([object.state isEqualToString:kAgree])
    {
        contentLabel.text = @"已添加";
    }
    else if ([object.state isEqualToString:kReject])
    {
        contentLabel.text = @"已拒绝";
    }
    
    UILabel *tmpLabel = (UILabel *)[cell.contentView viewWithTag:9001];
    tmpLabel.text = object.body;
    
    
    
//    cell.textLabel.text = [[XMPPRosterHelper sharedHelper] remarkNameOrNickNameForFriend:object.requestJID];
//    XMPPJID *jid = [XMPPJID jidWithUser:object.requestJID domain:kDOMAIN resource:kRESOURCE];
//    NSData *data = [[[XMPPDataHelper shareHelper] xmppvCardAvatarModule] photoDataForJID:jid];
//    if (data != nil)
//    {
//        UIImage *tm = [UIImage imageWithData:data];
//        cell.imageView.image = tm;
//        return cell;
//    }
//    XMPPvCardTemp *temp = [[XMPPVCardHelper sharedHelper] friendVcardWithName:object.requestJID];
//    UIImage *image = [UIImage imageWithData:temp.photo];
//    if (!image)
//    {
//        image = kDefaultIcon;
//    }
//    cell.imageView.image = image;
    
    [TOHttpHelper getUrl:kTOgetInfo parameters:@{@"id":object.requestJID,@"type":@"1"} showHUD:NO success:^(NSDictionary *dataDictionary) {
       
        NSString *path = @"";
        if (![[[[dataDictionary objectForKey:@"info"] objectForKey:@"ServerAppUser"] objectForKey:@"userHeadPicture"] isKindOfClass:[NSNull class]])
        {
            path = [[[dataDictionary objectForKey:@"info"] objectForKey:@"ServerAppUser"] objectForKey:@"userHeadPicture"];
        }
        path = [NSString stringWithFormat:@"%@%@/%@",kTOHOSt,kTOUploadUserIcon,path];
        
        UIImageView *iconView = (UIImageView *)[cell.contentView viewWithTag:4001];
        
        [iconView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:kDefaultIcon];
        UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:4002];
        NSString *name = @"";
        if (![[[[dataDictionary objectForKey:@"info"] objectForKey:@"ServerAppUser"] objectForKey:@"userName"] isKindOfClass:[NSNull class]])
        {
            name = [[[dataDictionary objectForKey:@"info"] objectForKey:@"ServerAppUser"] objectForKey:@"userName"];
        }
        nameLabel.text = name;
//        [listTable reloadData];
    }];
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendRequestInfo *info = [requestArray objectAtIndex:indexPath.row];
    tmpObject = info.requestJID;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *msgLabel = (UILabel *)[cell.contentView viewWithTag:4003];
    if ([msgLabel.text isEqualToString:@"是否添加对方为好友?"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"是否添加对方为好友" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",@"拒绝", nil];
        [alert show];   
    }
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
#pragma mark UIAlert View Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    NSString *username = tmpObject;
    if ([title isEqualToString:@"确定"])
    {
        [XMPPHelper agreeOrRefuseFriendRequest:username type:agreeFriend];
        
    }
    else if ([title isEqualToString:@"拒绝"])
    {
        [XMPPHelper agreeOrRefuseFriendRequest:username type:rejectFriend];
    }
    requestArray = [NSMutableArray arrayWithArray:[[FriendRequestInfoHelper shared] selectAllFriendRequestWithFriendJID:nil]];
    [listTable reloadData];
}

@end
