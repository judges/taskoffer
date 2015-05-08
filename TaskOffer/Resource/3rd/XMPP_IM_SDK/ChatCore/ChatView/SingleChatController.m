//
//  SingleChatController.m
//  rndIM
//
//  Created by BourbonZ on 14/12/4.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//


#import "SingleChatController.h"
//#import "ChatInfoController.h"
//#import "FriendInfoController.h"
#import "SLHttpRequestHandler.h"
#import "XMPPMessageInfo.h"
#import "SingleChatInfoViewController.h"
#import "ProjectInfoController.h"
#import "ProjectDialogueDataBaseHelper.h"
#import "TOHttpHelper.h"

@interface SingleChatController ()<xmppDelegate>
{

}
@end

@implementation SingleChatController
@synthesize currentUserName;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    ///修改红点
    if(self.title == nil || self.title.length == 0){
        self.title = [[XMPPRosterHelper sharedHelper] remarkNameOrNickNameForFriend:currentUserName];
    }
    if (self.currendIndex != nil)
    {
        [self scrollToIndex];
    }
    
    ///项目接包部分
    if (self.projectName != nil)
    {
        [[RedViewHelper sharedHelper] changeRedViewFromJID:currentUserName withType:[NSNumber numberWithInt:1] andShow:NO];

        self.title = self.projectOwner;
        UIView *projectView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 44)];
        [projectView setTag:5002];
        [projectView setBackgroundColor:[UIColor colorWithHex:2839163 alpha:0.5]];
        UIImageView *projectIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 34, 34)];
        [projectIcon setImage:kDefaultIcon];
        [projectView addSubview:projectIcon];
        UILabel *projectLabel = [[UILabel alloc] initWithFrame:CGRectMake(54, 5, self.view.frame.size.width-54-25, 34)];
        [projectLabel setText:self.projectName];
        [projectLabel setBackgroundColor:[UIColor clearColor]];
        [projectLabel setTextColor:[UIColor whiteColor]];
        [projectView addSubview:projectLabel];
        UIImageView *projectNextView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-25, 11, 22, 22)];
        [projectNextView setImage:[UIImage imageNamed:@"项目进入"]];
        [projectView addSubview:projectNextView];
        [[[UIApplication sharedApplication] keyWindow] addSubview:projectView];
        projectView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapge = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toProjectInfoController:)];
        [projectView addGestureRecognizer:tapge];
        
        ProjectDialogueInfo *projectInfo = [[ProjectDialogueDataBaseHelper sharedHelper] selectProjectInfo:self.projectID];
        if (projectInfo.projectID != nil)
        {
            [projectLabel setText:projectInfo.projectName];
            [projectIcon sd_setImageWithURL:[NSURL URLWithString:projectInfo.projectIconPath] placeholderImage:kDefaultIcon];
            self.title = projectInfo.projectCreater;
        }
        if (projectInfo.projectID == nil && self.projectID != nil)
        {
            [TOHttpHelper getUrl:kTOGetProjectInfo parameters:@{@"projectId":self.projectID,@"userId":[[UserInfo sharedInfo] userID]} showHUD:NO success:^(NSDictionary *dataDictionary) {
                
                ProjectDialogueInfo *info = [[ProjectDialogueInfo alloc] init];
                
                [info setProjectID:[[[dataDictionary objectForKey:@"info"] objectForKey:@"serverProject"] objectForKey:@"id"]];
                [info setProjectName:[[[dataDictionary objectForKey:@"info"] objectForKey:@"serverProject"] objectForKey:@"projectName"]];
                [info setProjectCreaterID:[[[dataDictionary objectForKey:@"info"] objectForKey:@"serverProject"] objectForKey:@"projectLeadId"]];
                NSInteger type = [[[[dataDictionary objectForKey:@"info"] objectForKey:@"serverProject"] objectForKey:@"projectType"] integerValue];
                ///0是企业号发布，1是个人发布
                if (type == 0)
                {
                    NSString *icon = [NSString stringWithFormat:@"%@%@/%@",kTOHOSt,kTOCompanyPicPath,[[[dataDictionary objectForKey:@"info"] objectForKey:@"serverProject"] objectForKey:@"projectLogo"]];
                    [info setProjectIconPath:icon];
                }
                else
                {
                    NSString *icon = [NSString stringWithFormat:@"%@%@/%@",kTOHOSt,kTOUploadUserIcon,[[[dataDictionary objectForKey:@"info"] objectForKey:@"serverProject"] objectForKey:@"projectLogo"]];
                    [info setProjectIconPath:icon];
                }
                
                [info setProjectTime:[[[[dataDictionary objectForKey:@"info"] objectForKey:@"serverProject"] objectForKey:@"createTime"] stringValue]];
                if ([[[[dataDictionary objectForKey:@"info"] objectForKey:@"serverProject"] objectForKey:@"projectPublishName"] isKindOfClass:[NSNull class]])
                {
                    [info setProjectCreater:@""];
                }
                else
                {
                    [info setProjectCreater:[[[dataDictionary objectForKey:@"info"] objectForKey:@"serverProject"] objectForKey:@"projectPublishName"]];
                }
                [[ProjectDialogueDataBaseHelper sharedHelper] addProjectInfo:info];
                
                ProjectDialogueInfo *projectInfo = [[ProjectDialogueDataBaseHelper sharedHelper] selectProjectInfo:self.projectID];
                [projectLabel setText:projectInfo.projectName];
                [projectIcon sd_setImageWithURL:[NSURL URLWithString:projectInfo.projectIconPath] placeholderImage:kDefaultIcon];
                self.title = projectInfo.projectCreater;

            }];
        }
    }
    NSString *_tmp = self.currentUserName;
    if (_tmp == nil)
    {
        return;
    }
    [TOHttpHelper getUrl:kTOgetInfo parameters:@{@"id":self.currentUserName,@"type":@"1"} showHUD:NO success:^(NSDictionary *dataDictionary) {
        if ([[[dataDictionary objectForKey:@"info"] objectForKey:@"ServerAppUser"] objectForKey:@"userName"] == nil )
        {
            return ;
        }
        self.title = [[[dataDictionary objectForKey:@"info"] objectForKey:@"ServerAppUser"] objectForKey:@"userName"];
    }];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    UIView *view = [[[UIApplication sharedApplication] keyWindow] viewWithTag:5002];
    if (view != nil)
    {
        [view removeFromSuperview];
        view = nil;
    }
}

-(void)scrollToIndex
{
    [self.tableView scrollToRowAtIndexPath:self.currendIndex atScrollPosition:(UITableViewScrollPositionMiddle) animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    XMPPHelper *helper = [XMPPHelper sharedHelper];
    helper.delegate = self;
}
-(void)initwithData
{
    self.cellFrames=[NSMutableArray array];
    
    NSMutableArray *data = [XMPPHelper allMessageWithFriendName:currentUserName];
    
    if (self.projectID == nil)
    {
        NSMutableArray *tmp = [NSMutableArray arrayWithArray:data];
        for (XMPPMessageInfo *info in tmp)
        {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[info.message.body dataUsingEncoding:NSUTF8StringEncoding] options:(NSJSONReadingMutableLeaves) error:nil];
            if ([dict objectForKey:@"projectID"] != nil)
            {
                [data removeObject:info];
            }
        }
    }
    else
    {
        NSMutableArray *tmp = [NSMutableArray arrayWithArray:data];
        for (XMPPMessageInfo *info in tmp)
        {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[info.message.body dataUsingEncoding:NSUTF8StringEncoding] options:(NSJSONReadingMutableLeaves) error:nil];
            if ([dict objectForKey:@"projectID"] == nil || ![self.projectID isEqualToString:[dict objectForKey:@"projectID"]])
            {
                [data removeObject:info];
            }
        }

    }
    
    for(XMPPMessageInfo *object in data)
    {
        NSMutableDictionary *dict  = [NSMutableDictionary dictionaryWithCapacity:0];
        //内容
        [dict setObject:[object body] forKey:@"content"];
        //时间
        [dict setObject:[object timestamp] forKey:@"time"];
        
        ///音频时间
        NSXMLElement *element = [[NSXMLElement alloc] initWithXMLString:[object messageStr] error:nil];
        NSNumber *duration = [element attributeNumberIntValueForName:@"audioDuration"];
        [dict setObject:duration forKey:@"duration"];
        
        

        //icon
        if (object.isOutgoing)
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
            XMPPRosterHelper *rosterHelper = [XMPPRosterHelper sharedHelper];
            XMPPFriendInfo *friendInfo = [rosterHelper friendInfomationWithUserName:[[object bareJid] user]];
            UIImage *image = [friendInfo photo];
            if (image == nil)
            {
                image = kDefaultIcon;
            }
            [dict setObject:image forKey:@"icon"];
            [dict setObject:object.bareJid.user forKey:@"userID"];
            
        }
        
        ChartMessage *chartMessage = [[ChartMessage alloc]init];
        ChartCellFrame *cellFrame  = [[ChartCellFrame alloc]init];
        chartMessage.dict          = dict;
        
        if ([[[object message] attributeStringValueForName:@"messageType"] isEqualToString:kProject] ||
            [[[object message] attributeStringValueForName:@"messageType"] isEqualToString:kCard] ||
            [[[object message] attributeStringValueForName:@"messageType"] isEqualToString:kCase] ||
            [[[object message] attributeStringValueForName:@"messageType"] isEqualToString:kCompany])
        {
            NSDictionary *tmp = [NSJSONSerialization JSONObjectWithData:[[dict objectForKey:@"content"] dataUsingEncoding:NSUTF8StringEncoding] options:(NSJSONReadingMutableLeaves) error:nil];
            chartMessage.itemContent = [tmp objectForKey:@"itemContent"];
            chartMessage.itemID = [tmp objectForKey:@"itemID"];
            chartMessage.itemName = [tmp objectForKey:@"itemName"];
            chartMessage.itemPicPath = [tmp objectForKey:@"itemPicPath"];
            chartMessage.content = @"";
            chartMessage.itemType = [[object message] attributeStringValueForName:@"messageType"];
        }
        
        cellFrame.chartMessage     = chartMessage;
        chartMessage.audioDuration = duration;
        if (object.isOutgoing)
        {
            chartMessage.name = [[XMPPRosterHelper sharedHelper] remarkNameOrNickNameForFriend:kDefaultJID.user];
            chartMessage.userID = kDefaultJID.user;

        }
        else
        {
            chartMessage.name = [[XMPPRosterHelper sharedHelper] remarkNameOrNickNameForFriend:object.bareJid.user];
            chartMessage.userID = object.bareJid.user;
        }
        
        [self.cellFrames addObject:cellFrame];
    }
    
    
    [super initwithData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//点击右上角的按钮
-(void)clickChatRightButton:(UIButton *)button
{
//    ChatInfoController *info = [[ChatInfoController alloc] init];
//    info.currentUser = self.currentUser;
//    [self.navigationController pushViewController:info animated:YES];
    SingleChatInfoViewController *singleChatInfo = [[SingleChatInfoViewController alloc] init];
    singleChatInfo.hidesBottomBarWhenPushed = YES;
//    singleChatInfo.friendInfo = self.currentUser;
//    if (self.currentUser == nil)
//    {
        singleChatInfo.friendID = self.currentUserName;
//    }
    [self.navigationController pushViewController:singleChatInfo animated:YES];
}

//点击键盘的发送按钮
-(void)KeyBordView:(KeyBordVIew *)keyBoardView textFiledReturn:(UITextField *)textFiled
{
    [self finalSend];
}
#pragma mark 发送图片
-(void)finalSendImage:(NSArray *)imageArray
{
    [super finalSendImage:imageArray];
    [SLHttpRequestHandler POSTWithURL:kChatUoload parameters:nil datas:imageArray showProgressInView:self.view isHideProgress:NO success:^(NSDictionary *dataDictionary)
     {
         ChartMessage *chartMessage=[[ChartMessage alloc]init];
         
         XMPPVCardHelper *helper = [XMPPVCardHelper sharedHelper];
         XMPPUserInfo *info = [helper myInfo];
         UIImage *image = [UIImage imageWithData:[info photo]];
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
         
         if (self.projectID != nil)
         {
             ///项目接包聊天
             NSMutableDictionary *value = [NSMutableDictionary dictionary];
             [value setObject:chartMessage.content forKey:@"content"];
             [value setObject:self.projectID forKey:@"projectID"];
             [value setObject:@"1" forKey:@"type"];
             NSData *data = [NSJSONSerialization dataWithJSONObject:value options:(NSJSONWritingPrettyPrinted) error:nil];
             NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             [XMPPHelper sendMessage:currentUserName type:@"chat" message:string messageType:kProjectOutsourcing duration:0];
             
             ProjectDialogue *dialogue = [[ProjectDialogue alloc] init];
             dialogue.projectID = self.projectID;
             dialogue.messageSender = kDefaultJID.user;
             dialogue.messageReceiver = currentUserName;
             dialogue.messageTime = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
             [[ProjectDialogueDataBaseHelper sharedHelper] addProjectDialogue:dialogue];
         }
         else
         {
             [XMPPHelper sendMessage:currentUserName type:@"chat" message:chartMessage.content messageType:kPhoto duration:0];
         }

         
     } failure:^(NSError *error)
     {
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:error.localizedDescription delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
         [alert show];

     }];
}
#pragma mark 开始录音
-(void)beginRecord
{
    [super beginRecord];
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
        UIImage *image = [UIImage imageWithData:[info photo]];
        if (image == nil)
        {
            image = kDefaultIcon;
        }
        
        chartMessage.icon=image;
        chartMessage.messageType=kMessageTo;
        chartMessage.content=[dataDictionary objectForKey:@"data"];
        chartMessage.audioDuration = duration;
        cellFrame.chartMessage=chartMessage;
        chartMessage.name = [[XMPPRosterHelper sharedHelper] remarkNameOrNickNameForFriend:kDefaultJID.user];
        chartMessage.userID = kDefaultJID.user;
        [self.cellFrames addObject:cellFrame];
        [self.tableView reloadData];
        [self tableViewScrollCurrentIndexPath];

        
#warning 更改语音名称
        NSString *_wavPath = [[NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),fileData.fileName] stringByReplacingOccurrencesOfString:@".amr" withString:@".wav"];
        NSString *currentPath = [dataDictionary objectForKey:@"data"];
        currentPath = [[currentPath componentsSeparatedByString:@"/"] lastObject];
        currentPath = [currentPath stringByReplacingOccurrencesOfString:@".amr" withString:@".wav"];
        NSString *currentWavPath = [NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),currentPath];
        [[NSFileManager defaultManager] copyItemAtPath:_wavPath toPath:currentWavPath error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:_wavPath error:nil];

        

        if (self.projectID != nil)
        {
            ///项目接包聊天
            NSMutableDictionary *value = [NSMutableDictionary dictionary];
            [value setObject:chartMessage.content forKey:@"content"];
            [value setObject:self.projectID forKey:@"projectID"];
            [value setObject:@"2" forKey:@"type"];
            NSData *data = [NSJSONSerialization dataWithJSONObject:value options:(NSJSONWritingPrettyPrinted) error:nil];
            NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            [XMPPHelper sendMessage:currentUserName type:@"chat" message:string messageType:kProjectOutsourcing duration:duration];
            
            ProjectDialogue *dialogue = [[ProjectDialogue alloc] init];
            dialogue.projectID = self.projectID;
            dialogue.messageSender = kDefaultJID.user;
            dialogue.messageReceiver = currentUserName;
            dialogue.messageTime = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
            [[ProjectDialogueDataBaseHelper sharedHelper] addProjectDialogue:dialogue];
        }
        else
        {
            [XMPPHelper sendMessage:currentUserName type:@"chat" message:chartMessage.content messageType:kAudio duration:duration];
        }

        
    } failure:^(NSError *error)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:error.localizedDescription delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }];

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender { O
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark 表情键盘上的发送按钮
-(void)faceViewSendButton
{
    [self finalSend];
}
#pragma mark XMPPHelper Delegate
-(void)receiveSingleChatMessage:(ChartMessage *)message friendUserName:(XMPPJID *)friendName
{
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[message.content dataUsingEncoding:NSUTF8StringEncoding] options:(NSJSONReadingMutableLeaves) error:nil];
    if ((self.projectID  == nil && dict != nil) || (self.projectID != nil && dict == nil))
    {
        return;
    }
    
    
    if ([currentUserName isEqualToString:friendName.user])
    {
        
        [[RedViewHelper sharedHelper] deleteRedViewFromJID:currentUserName withType:[NSNumber numberWithInt:1]];
        
        NSString *content = message.content;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[content dataUsingEncoding:NSUTF8StringEncoding] options:(NSJSONReadingMutableLeaves) error:nil];
        if ([dict objectForKey:@"projectID"] != nil && [[dict objectForKey:@"projectID"] isEqualToString:self.projectID])
        {
            ///项目接包聊天
            [message setContent:[dict objectForKey:@"content"]];
            [self sendMessageWithChatMessage:message];
        }
        else if (dict == nil)
        {
            [self sendMessageWithChatMessage:message];
        }
    }
}
#pragma mark 发送文本
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
        chartMessage.icon=image;
        chartMessage.messageType=kMessageTo;
        chartMessage.content=text;
        cellFrame.chartMessage=chartMessage;
        chartMessage.name = [[XMPPRosterHelper sharedHelper] remarkNameOrNickNameForFriend:kDefaultJID.user];
        chartMessage.userID = kDefaultJID.user;
        [self.cellFrames addObject:cellFrame];
        [self.tableView reloadData];
        
        NSString *username = currentUserName;
        if ([username rangeOfString:kDOMAIN].location != NSNotFound)
        {
            username = [username substringToIndex:[username rangeOfString:kDOMAIN].location-1];
        }
        
        if (self.projectID != nil)
        {
            ///项目接包聊天
            NSMutableDictionary *value = [NSMutableDictionary dictionary];
            [value setObject:text forKey:@"content"];
            [value setObject:self.projectID forKey:@"projectID"];
            [value setObject:@"0" forKey:@"type"];
            NSData *data = [NSJSONSerialization dataWithJSONObject:value options:(NSJSONWritingPrettyPrinted) error:nil];
            NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            [XMPPHelper sendMessage:username type:@"chat" message:string messageType:kProjectOutsourcing duration:0];
            
            ProjectDialogue *dialogue = [[ProjectDialogue alloc] init];
            dialogue.projectID = self.projectID;
            dialogue.messageSender = kDefaultJID.user;
            dialogue.messageReceiver = username;
            dialogue.messageTime = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
            [[ProjectDialogueDataBaseHelper sharedHelper] addProjectDialogue:dialogue];
        }
        else
        {
            [XMPPHelper sendMessage:username type:@"chat" message:text messageType:kText duration:0];
        }
        //滚动到当前行
        
        [super tableViewScrollCurrentIndexPath];
        self.keyBordView.textField.text = @"";
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"不能发送空文本" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }

}
#pragma mark 点击头像
-(void)clickOtherIcon:(ChartCell *)cell
{
//    FriendInfoController *info = [[FriendInfoController alloc] init];
//    info.friendName = self.currentUser.jid.user;
//    info.isFriend = YES;
//    [self.navigationController pushViewController:info animated:YES];
}
-(void)clickMyIcon:(ChartCell *)cell
{
//    FriendInfoController *info = [[FriendInfoController alloc] init];
//    info.friendName = kDefaultJID.user;
//    info.isFriend = YES;
//    [self.navigationController pushViewController:info animated:YES];
}
#pragma mark 长按按钮
-(void)clickDeteItemWithLongPress:(ChartCell *)cell
{
    [self.cellFrames removeObjectAtIndex:cell.tag];
    NSArray *array = [NSArray arrayWithObject:[NSNumber numberWithInteger:cell.tag]];
    [[XMPPHelper sharedHelper] deleteSomeChatMessages:array messageType:singleChat friendName:currentUserName];
    [self.tableView reloadData];
}
-(void)deleteMessagesWithTags
{
    [super deleteMessagesWithTags];
    for (NSIndexPath *index in self.itemMessageArray)
    {
        [self.cellFrames removeObjectAtIndex:index.row];
    }
    NSMutableArray *tmpArray = [NSMutableArray array];
    for (NSIndexPath *index in self.itemMessageArray)
    {
        [tmpArray addObject:[NSNumber numberWithInteger:index.row]];
    }
    [[XMPPHelper sharedHelper] deleteSomeChatMessages:tmpArray messageType:singleChat friendName:currentUserName];
    [self.tableView reloadData];
}
#pragma mark 跳转进入到项目详情
-(void)toProjectInfoController:(UITapGestureRecognizer *)tapg
{
    BOOL hasController = NO;
    NSArray *array = self.navigationController.viewControllers;
    for (UIViewController *controller  in array)
    {
        if ([controller isKindOfClass:[ProjectInfoController class]])
        {
            hasController = YES;
            [self.navigationController popToViewController:controller animated:YES];
            break;
        }
    }
    if (!hasController)
    {
        ProjectInfoController *info = [[ProjectInfoController alloc] init];
        info.projectID = self.projectID;
        [self.navigationController pushViewController:info animated:YES];
    }
}

@end
