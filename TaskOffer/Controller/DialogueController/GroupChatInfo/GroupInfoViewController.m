//
//  ZWGroupInfoViewController.m
//  XMPPIM
//
//  Created by BourbonZ on 14/12/17.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import "GroupInfoViewController.h"
//#import "ComplainController.h"
#import "XMPPRoomHelper.h"
#import "MBProgressHUD.h"
#import "MemberCell.h"
#import "RedViewHelper.h"
#import "FriendInfoController.h"
//#import "SearchViewController.h"
#import "QRCodeViewController.h"
#import "PhotoViewController.h"
#import "FriendListController.h"
#define kAddButton @"添加按钮"
@interface GroupInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,XMPPRoomHelperDelegate,XMPPDataHelperDelegate,UIAlertViewDelegate,xmppDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UITableView *groupInfoTable;
    NSArray *imageArray;
    NSArray *setArray;
    NSArray *nameArray;
    NSArray *messageArray;
    NSArray *complainArray;
    NSArray *menuArray;
    
    UIPickerView *picker;
    NSArray *numArray;
    MBProgressHUD *HUD;

    
    ///数据
    NSString *peopleNum;
    NSString *groupChatName;
    NSString *groupChatMaxNum;
    NSArray *switchArray;
    
    ///群聊人员
    UICollectionView *memberView;
    NSArray *memberArray;
}
@end

@implementation GroupInfoViewController
@synthesize infoArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"群聊信息";
    
    ///表格
    groupInfoTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:(UITableViewStyleGrouped)];
    groupInfoTable.delegate = self;
    groupInfoTable.dataSource = self;
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    UIButton *goOutButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [goOutButton setFrame:CGRectMake(20, 0, self.view.frame.size.width-40, 40)];
    [goOutButton setTitle:@"退出该群" forState:(UIControlStateNormal)];
    goOutButton.layer.cornerRadius = 10.0f;
    [goOutButton setBackgroundColor:[UIColor redColor]];
    [footView addSubview:goOutButton];
    [goOutButton addTarget:self action:@selector(leaveRoom) forControlEvents:(UIControlEventTouchUpInside)];
    groupInfoTable.tableFooterView = footView;
    
    [self.view addSubview:groupInfoTable];
    
    ///数据
    imageArray = [NSArray arrayWithObject:@"图片"];
    infoArray = [NSArray arrayWithObjects:@"群聊名称",@"群二维码",@"群聊大小",@"群聊图片", nil];
    setArray = [NSArray arrayWithObjects:@"置顶聊天",@"消息免打扰", nil];
    nameArray = [NSArray arrayWithObjects:@"我的群昵称",@"显示群成员昵称", nil];
    messageArray = [NSArray arrayWithObjects:@"设置当前聊天背景",@"查找聊天记录",@"清空聊天记录", nil];
    complainArray = [NSArray arrayWithObject:@"投诉"];
    menuArray = [NSArray arrayWithObjects:imageArray,infoArray,setArray,nameArray,messageArray,complainArray, nil];
    
    ///pickerView
    picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-216, self.view.frame.size.width, 216)];
    picker.delegate = self;
    picker.dataSource = self;
    numArray = [NSArray arrayWithObjects:@"10人",@"50人",@"100人",@"500人",@"100人", nil];
    
    XMPPRoomHelper *helper = [XMPPRoomHelper sharedRoom];
    [helper setDelegate:self];
    [helper startToGetRoomInfo:self.roomJID];

    XMPPDataHelper *dataHelper = [XMPPDataHelper shareHelper];
    [dataHelper setDelegate:self];
    
    XMPPHelper *messageHelper = [XMPPHelper sharedHelper];
    [messageHelper setDelegate:self];
    
    UISwitch *switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width-70, 5, 100, 50)];
    switchArray = [NSArray arrayWithObjects:switchButton,switchButton, nil];
    
    ///群聊人员
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    memberView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100) collectionViewLayout:layout];
    [memberView registerClass:[MemberCell class] forCellWithReuseIdentifier:@"collection"];
    memberView.backgroundColor = [UIColor whiteColor];
    [memberView setDataSource:self];
    [memberView setDelegate:self];
    memberArray = [NSArray array];
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
#pragma mark 离开房间
-(void)leaveRoom
{
    XMPPRoomHelper *helper = [XMPPRoomHelper sharedRoom];
    [helper setDelegate:self];
    [helper leaveRoom:self.roomJID];
    [[RedViewHelper sharedHelper] deleteRedViewFromJID:self.roomJID.user withType:[NSNumber numberWithInt:1]];
}
#pragma mark UITableView
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 && indexPath.section == 0)
    {
        return 100;
    }
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return menuArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = [menuArray objectAtIndex:section];
    return array.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
        cell.detailTextLabel.text = nil;
    }
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:cellID];
    }
    
    NSArray *array      = [menuArray objectAtIndex:indexPath.section];
    cell.textLabel.text = [array objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ///头像展示
    if (indexPath.section == 0)
    {
//        cell.detailTextLabel.text = peopleNum;
        cell.textLabel.text = @"";
        [cell.contentView addSubview:memberView];
    }
    ///群聊名称
    else if (indexPath.section == 1 && indexPath.row == 0)
    {
        GroupChatInfoHelper *groupInfo = [GroupChatInfoHelper shared];
        cell.detailTextLabel.text = [groupInfo searchGroupChatInfo:self.roomJID.user];
    }
    ///群聊大小
    else if (indexPath.section == 1 && indexPath.row == 2)
    {
        cell.detailTextLabel.text = groupChatMaxNum;
    }
    ///我的群聊昵称
    else if (indexPath.section == 3 && indexPath.row == 0)
    {
        cell.detailTextLabel.text = kDefaultJID.user;
    }
    ///群聊设置各种开关
    else if (indexPath.section == 2 ||(indexPath.section == 3 && indexPath.row == 1))
    {
        UISwitch *switchButton = [[UISwitch alloc] init];
        [switchButton setCenter:CGPointMake(cell.frame.size.width-40,cell.frame.size.height/2)];
        switchButton.tag = indexPath.row;
        [cell.contentView addSubview:switchButton];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:13.0f];
    

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        
    }
    else if (indexPath.section == 1 && indexPath.row == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"更改群聊名称" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert setAlertViewStyle:(UIAlertViewStylePlainTextInput)];
        [alert show];
    }
    else if (indexPath.section == 1 && indexPath.row == 1)
    {
        QRCodeViewController *qrCode = [[QRCodeViewController alloc] init];
        qrCode.qrString = [kGroupChatSing stringByAppendingString:self.roomJID.user];
        [self.navigationController pushViewController:qrCode animated:YES];
    }
    else if (indexPath.section == 1 && indexPath.row == 3)
    {
        PhotoViewController *photo = [[PhotoViewController alloc] init];
        photo.currentName = self.roomJID.user;
        photo.type = groupChat;
        [self.navigationController pushViewController:photo animated:YES];
    }
    else if (indexPath.section == 4)
    {
        if (indexPath.row == 1)
        {
//            SearchViewController *search = [[SearchViewController alloc] init];
//            search.type = groupSearch;
//            search.bareJID = self.roomJID.user;
//            [self.navigationController pushViewController:search animated:YES];
        }
    }
    else if(indexPath.section == 5)
    {
//        ComplainController *complain = [[ComplainController alloc] initWithNibName:@"ComplainController" bundle:nil];
//        [self.navigationController pushViewController:complain animated:YES];
    }
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([self.view.window.subviews containsObject:picker])
    {
        [self hidePicker];
    }
}
///showpicker
-(void)showPicker
{
    [UIView animateWithDuration:0.25 animations:^{
        
        self.view.transform = CGAffineTransformMakeTranslation(0, -216);
        
    } completion:^(BOOL finished) {
        [self.view.window addSubview:picker];
    }];
}
///hidePicker
-(void)hidePicker
{
    [UIView animateWithDuration:0.25 animations:^{
        self.view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [picker removeFromSuperview];
    }];
}
#pragma mark UIPicker
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return numArray.count;
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [numArray objectAtIndex:row];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *num             = [numArray objectAtIndex:row];
    NSIndexPath *index        = [NSIndexPath indexPathForRow:2 inSection:1];
    UITableViewCell *cell     = [groupInfoTable cellForRowAtIndexPath:index];
    cell.detailTextLabel.text = num;
}
#pragma mark XMPPRoomHelper
-(void)getRoomInfo:(NSArray *)array
{
    
}
-(void)leaveRoomSuccess:(XMPPRoom *)room
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark XMPPDataHelper Delegate
-(void)allGroupMember:(NSArray *)array
{
    NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:array];
    [tmpArray addObject:kAddButton];
    memberArray = tmpArray.copy;
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
  //  UITableViewCell *cell = [groupInfoTable cellForRowAtIndexPath:index];
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d人",array.count];
    peopleNum = [NSString stringWithFormat:@"%d人",tmpArray.count];
    [memberView reloadData];
    
}
#pragma mark UIAlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *subject = [alertView textFieldAtIndex:0].text;
    if (buttonIndex == 1 && subject.length >0)
    {
        if (subject.length > 14)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"房间主题不能超过14个字" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.navigationBar];
        [HUD setLabelText:@"正在设置"];
        [HUD show:YES];
        
        NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:1];
        UITableViewCell *cell = [groupInfoTable cellForRowAtIndexPath:index];
        cell.detailTextLabel.text = subject;
        
        XMPPRoomHelper *roomHelper = [XMPPRoomHelper sharedRoom];
        [roomHelper setDelegate:self];
        [roomHelper changeGroupChatRoom:self.roomJID subject:subject];
        
        GroupChatInfoHelper *groupInfo = [GroupChatInfoHelper shared];
        [groupInfo changeGroupChat:self.roomJID.user subject:subject];
    }
}
#pragma mark XMPPHelper Delegate
-(void)receiveChangeGroupRoomSubject:(XMPPJID *)roomJid subject:(NSString *)subject
{
    if ([self.roomJID isEqualToJID:roomJid])
    {
        [HUD setLabelText:@"设置完成"];
        [HUD hide:YES afterDelay:0.3];
    }
}
#pragma mark UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return peopleNum.integerValue;
}
///定义每个cell的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(55, 55);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *member = [memberArray objectAtIndex:indexPath.row];
    if ([member isEqualToString:kAddButton])
    {
        FriendListController *friendList = [[FriendListController alloc] init];
        friendList.title = @"选择好友";
        friendList.popController = self;
        //    friendList.defaultArray = [NSMutableArray arrayWithObject:self.friendInfo];
        UINavigationController *friendNavi = [[UINavigationController alloc] initWithRootViewController:friendList];
        [self presentViewController:friendNavi animated:YES completion:nil];
        return;
    }
    FriendInfoController *info = [[FriendInfoController alloc] init];
    info.friendName = member;
    info.isFriend = YES;
    [self.navigationController pushViewController:info animated:YES];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *collectionCell = @"collection";
    MemberCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCell forIndexPath:indexPath];

    NSString *member = [memberArray objectAtIndex:indexPath.row];
    if ([member isEqualToString:kAddButton])
    {
        ///添加按钮
        cell.userIcon.image = [UIImage imageNamed:@"添加照片"];
    }
    else
    {
        cell.nameLabel.text = [[XMPPRosterHelper sharedHelper] remarkNameOrNickNameForFriend:member];
        XMPPvCardTemp *item = [[XMPPVCardHelper sharedHelper] friendVcardWithName:member];
        NSData *imageData = [item photo];
        UIImage *image = [UIImage imageWithData:imageData];
        if (!image)
        {
            image = kDefaultIcon;
        }
        cell.userIcon.image = image;
    }
   
    return cell;
}
@end
