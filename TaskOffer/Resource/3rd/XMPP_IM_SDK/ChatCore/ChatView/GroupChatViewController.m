//
//  GroupChatViewController.m
//  XMPPIM
//
//  Created by BourbonZ on 14/12/17.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import "GroupChatViewController.h"
#import "GroupInfoViewController.h"
#import "XMPPRoomHelper.h"
#import "SLHttpRequestHandler.h"
#import "GroupChatInfoHelper.h"
#import "XMPPMessageInfo.h"
@interface GroupChatViewController ()<XMPPRoomHelperDelegate,xmppDelegate>

@end

@implementation GroupChatViewController
@synthesize roomJID;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    XMPPRoomHelper *helper = [XMPPRoomHelper sharedRoom];
    [helper setDelegate:self];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    ///房间主题
    GroupChatInfoHelper *groupInfo = [GroupChatInfoHelper shared];
    self.title = [groupInfo searchGroupChatInfo:self.roomJID.user];

    if (self.currendIndex != nil)
    {
        [self scrollToIndex];
    }
}
-(void)scrollToIndex
{
    [self.tableView scrollToRowAtIndexPath:self.currendIndex atScrollPosition:(UITableViewScrollPositionMiddle) animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    XMPPRoomHelper *helper = [XMPPRoomHelper sharedRoom];
    [helper setDelegate:self];
//    [helper leaveRoom:self.groupChatRoom];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)goBackToTop
{
    ///群聊返回到主界面
   [self.navigationController popToRootViewControllerAnimated:YES];
}

///初始化数据
-(void)initwithData
{
    self.cellFrames=[NSMutableArray array];
    
    XMPPRoomHelper *helper = [XMPPRoomHelper sharedRoom];
    [helper setDelegate:self];

    [helper allGroupChatMessageWithGroupName:self.roomJID.user];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

///点击右上角的button
-(void)clickChatRightButton:(UIButton *)button
{
    GroupInfoViewController *groupInfo = [[GroupInfoViewController alloc] init];
    groupInfo.roomJID = self.roomJID;
    [self.navigationController pushViewController:groupInfo animated:YES];
}
#pragma mark 获取所有聊天信息
-(void)allGroupMessage:(NSMutableArray *)messageArray
{
    for(XMPPMessageInfo *object in messageArray)
    {
        NSMutableDictionary *dict  = [NSMutableDictionary dictionaryWithCapacity:0];
        //内容
        [dict setObject:[object body] forKey:@"content"];
        //时间
        [dict setObject:[object timestamp] forKey:@"time"];
        //icon
        NSString *user = [[[object message] from] resource];
        if ([user isEqualToString:kDefaultJID.user])
        {
            //发送出去的
            [dict setObject:[NSString stringWithFormat:@"%d",kMessageTo] forKey:@"type"];
            XMPPUserInfo *info = [[XMPPVCardHelper sharedHelper] myInfo];
            UIImage *image = [UIImage imageWithData:info.photo];
            if (image == nil)
            {
                image = kDefaultIcon;
            }
            [dict setObject:image forKey:@"icon"];
            [dict setObject:kDefaultJID.user forKey:@"userID"];
        }
        else
        {
            //接收到的
            [dict setObject:[NSString stringWithFormat:@"%d",kMessageFrom] forKey:@"type"];
//            XMPPRosterHelper *rosterHelper = [XMPPRosterHelper sharedHelper];
//            XMPPFriendInfo *friendInfo = [rosterHelper friendInfomationWithUserName:object.bareJid.user];
            

            XMPPvCardInfo *friendVcard = [[XMPPVCardHelper sharedHelper] searchFriendFromDB:user];
            UIImage *image = [UIImage imageWithData:[friendVcard photoData]];
            if (image == nil)
            {
                image = kDefaultIcon;
            }
            [dict setObject:image forKey:@"icon"];
            [dict setObject:user forKey:@"userID"];
        }
        
        ChartCellFrame *cellFrame  = [[ChartCellFrame alloc]init];
        ChartMessage *chartMessage = [[ChartMessage alloc]init];
        chartMessage.dict          = dict;
        cellFrame.chartMessage     = chartMessage;
        ///音频时间
        NSXMLElement *element = [[NSXMLElement alloc] initWithXMLString:[object messageStr] error:nil];
        NSNumber *duration = [element attributeNumberIntValueForName:@"audioDuration"];
        [dict setObject:duration forKey:@"duration"];
        chartMessage.audioDuration = duration;
        if (object.isOutgoing)
        {
            chartMessage.name = [[XMPPRosterHelper sharedHelper] remarkNameOrNickNameForFriend:kDefaultJID.user];
            chartMessage.userID = kDefaultJID.user;
        }
        else
        {
            chartMessage.name = [[XMPPRosterHelper sharedHelper] remarkNameOrNickNameForFriend:object.message.from.resource];
            chartMessage.userID = object.message.from.resource;
        }

        [self.cellFrames addObject:cellFrame];
    }
    
    [super tableViewScrollCurrentIndexPath];
}
#pragma mark 发送文本
-(void)KeyBordView:(KeyBordVIew *)keyBoardView textFiledReturn:(UITextField *)textFiled
{
    [self finalSend];
}
#pragma mark 群聊发送图片
-(void)finalSendImage:(NSArray *)imageArray
{
    [super finalSendImage:imageArray];
    [SLHttpRequestHandler POSTWithURL:kChatUoload parameters:nil datas:imageArray showProgressInView:self.view isHideProgress:NO success:^(NSDictionary *dataDictionary)
     {
         ChartMessage *chartMessage=[[ChartMessage alloc]init];
         XMPPUserInfo *info = [[XMPPVCardHelper sharedHelper] myInfo];
         UIImage *image = [UIImage imageWithData:info.photo];
         if (image == nil)
         {
             image = kDefaultIcon;
         }
         chartMessage.icon=image;
         chartMessage.messageType=kMessageTo;
         chartMessage.content = [dataDictionary objectForKey:@"data"];
         chartMessage.name = [[XMPPRosterHelper sharedHelper] remarkNameOrNickNameForFriend:kDefaultJID.user];
         chartMessage.userID = kDefaultJID.user;
         [self sendMessageWithChatMessage:chartMessage];
         XMPPRoomHelper *helper = [XMPPRoomHelper sharedRoom];
         [helper setDelegate:self];
         [helper sendGroupMessageToName:self.roomJID.user withMessage:chartMessage.content messageType:kPhoto duration:0];
         
     } failure:^(NSError *error)
     {
         [HUDView showHUDWithText:error.localizedDescription];

     }];

}
#pragma mark 发送录音
-(void)finishRecord
{
    [super finishRecord];
    
    NSData *data = [NSData dataWithContentsOfFile:[NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@",self.amrFile]];
    
    NSNumber *duration = [TimeHelper soundsTimeByPath:[NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@",self.amrFile]];
    
    if (!data)
    {
        return;
    }
    
    if (duration.intValue == 0)
    {
        [HUDView showHUDWithText:@"不能发送空语音"];
        NSString *wav = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@",self.fileName];
        NSString *amr = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@",self.amrFile];
        [[NSFileManager defaultManager] removeItemAtPath:wav error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:amr error:nil];
        return;
    }
    
    
    SLHttpFileData *fileData = [[SLHttpFileData alloc] init];
    [fileData setData:data];
    [fileData setParameterName:self.amrFile];
    [fileData setFileName:self.amrFile];
    [fileData setMimeType:@"audio/amr"];
    
    NSArray *dataArray = [NSArray arrayWithObject:fileData];
    [SLHttpRequestHandler POSTWithURL:kChatUoload parameters:nil datas:dataArray showProgressInView:self.view.window isHideProgress:NO success:^(NSDictionary *dataDictionary)
     {
         ChartCellFrame *cellFrame=[[ChartCellFrame alloc]init];
         ChartMessage *chartMessage=[[ChartMessage alloc]init];
         
         XMPPUserInfo *info = [[XMPPVCardHelper sharedHelper] myInfo];
         UIImage *image = [UIImage imageWithData:info.photo];
         if (image == nil)
         {
             image = kDefaultIcon;
         }
         chartMessage.icon=image;
         chartMessage.messageType=kMessageTo;
         chartMessage.content=[dataDictionary objectForKey:@"data"];
         cellFrame.chartMessage=chartMessage;
         chartMessage.audioDuration = duration;
         chartMessage.name = [[XMPPRosterHelper sharedHelper] remarkNameOrNickNameForFriend:kDefaultJID.user];
         chartMessage.userID = kDefaultJID.user;
         [self.cellFrames addObject:cellFrame];
         [self.tableView reloadData];
         [self tableViewScrollCurrentIndexPath];
         
//         [XMPPHelper sendMessage:self.currentUser.jid.user type:@"chat" message:chartMessage.content messageType:kAudio];
         XMPPRoomHelper *helper = [XMPPRoomHelper sharedRoom];
         [helper setDelegate:self];
         [helper sendGroupMessageToName:self.roomJID.user withMessage:chartMessage.content messageType:kAudio duration:duration];
         
     } failure:^(NSError *error)
     {
         [HUDView showHUDWithText:error.localizedDescription];
     }];
    

}
#pragma mark 接收到文本信息
-(void)receiveGroupChatRoom:(XMPPRoom *)sender withMessage:(ChartMessage *)message occupantJID:(XMPPJID *)occupantJID
{
    if ([sender.myRoomJID.user isEqualToString:self.roomJID.user] && ![occupantJID.resource isEqualToString:self.currentUser.jid.user])
    {
        [self sendMessageWithChatMessage:message];
    }
}
#pragma mark 表情键盘上的发送按钮
-(void)faceViewSendButton
{
    [self finalSend];
}
#pragma mark 最后发送文本
-(void)finalSend
{
    NSString *text = self.keyBordView.textField.text;
    if (text.length > 0)
    {
        ChartCellFrame *cellFrame=[[ChartCellFrame alloc]init];
        ChartMessage *chartMessage=[[ChartMessage alloc]init];
        
        XMPPUserInfo *info = [[XMPPVCardHelper sharedHelper] myInfo];
        UIImage *image = [UIImage imageWithData:info.photo];
        if (image == nil)
        {
            image = kDefaultIcon;
        }
        chartMessage.icon=image;        chartMessage.messageType=kMessageTo;
        chartMessage.content=text;
        cellFrame.chartMessage=chartMessage;
        chartMessage.name = [[XMPPRosterHelper sharedHelper] remarkNameOrNickNameForFriend:kDefaultJID.user];
        chartMessage.userID = kDefaultJID.user;
        [self.cellFrames addObject:cellFrame];
        [self.tableView reloadData];
        
        XMPPRoomHelper *helper = [XMPPRoomHelper sharedRoom];
        [helper setDelegate:self];
        [helper sendGroupMessageToName:self.roomJID.user withMessage:self.keyBordView.textField.text messageType:kText duration:0];

        //滚动到当前行
        
        [super tableViewScrollCurrentIndexPath];
        self.keyBordView.textField.text = @"";
    }
    else
    {
        [HUDView showHUDWithText:@"不能发送空文本"];
    }
}
#pragma mark XMPPHelper Delegate
-(void)receiveGroupChatMessage:(ChartMessage *)message friendUserName:(XMPPJID *)friendName
{
    NSString *nickName = [[[friendName description] componentsSeparatedByString:@"/"] lastObject];
    if (![kDefaultJID.user isEqualToString:nickName])
    {
        [self sendMessageWithChatMessage:message];
    }
}

#pragma mark 点击头像
-(void)clickMyIcon:(ChartCell *)cell
{
    FriendInfoController *info = [[FriendInfoController alloc] init];
    info.friendName = kDefaultJID.user;
    info.isFriend = YES;
    [self.navigationController pushViewController:info animated:YES];

}
-(void)clickOtherIcon:(ChartCell *)cell
{
    FriendInfoController *info = [[FriendInfoController alloc] init];
    info.friendName = cell.cellFrame.chartMessage.userID;
    info.isFriend = YES;
    [self.navigationController pushViewController:info animated:YES];
}
#pragma mark 长按按钮
-(void)clickDeteItemWithLongPress:(ChartCell *)cell
{
    [self.cellFrames removeObjectAtIndex:cell.tag];
    NSArray *array = [NSArray arrayWithObject:[NSNumber numberWithInteger:cell.tag]];
    [[XMPPHelper sharedHelper] deleteSomeChatMessages:array messageType:groupChat friendName:self.roomJID.user];
    [self.tableView reloadData];
}
-(void)clickEditItemWithLongPress:(ChartCell *)cell
{
    
}


@end
