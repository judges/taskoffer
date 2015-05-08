//
//  XMPPHelper.m
//  rndIM
//
//  Created by BourbonZ on 14/12/3.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import "XMPPHelper.h"
#import "XMPPMessage.h"
#import "SLHttpRequestHandler.h"
#import "DialogueModel.h"
#import "XMPPMessage+XEP0045.h"
#import "ACPReminder.h"
#import "RedViewHelper.h"
#import "FriendRequestInfoHelper.h"
#import "ProjectDialogueDataBaseHelper.h"
#import "ToToolHelper.h"
#import "FMDB.h"
static XMPPHelper *helper = nil;
@implementation XMPPHelper

+(XMPPHelper *)sharedHelper
{
    @synchronized(self)
    {
        if (helper == nil)
        {
            helper = [[XMPPHelper alloc] init];
        }
        return helper;
    }
}
-(instancetype)init
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveVard:) name:kVcard object:nil];

    return [super init];
}
///接收到vcard
-(void)receiveVard:(NSNotification *)notify
{
    XMPPIQ *iq = [notify object];
    DDXMLElement *vCard = [iq childElement];
    NSArray *array = [vCard children];
    UIImage *image = nil;
    for (int i = 0; i < array.count; i++)
    {
        DDXMLDocument *photo = [array objectAtIndex:i];
        NSArray *tmp = photo.children;
        for (int j = 0; j < tmp.count ; j ++)
        {
            DDXMLNode *node = [tmp objectAtIndex:j];
            if ([node.name isEqualToString:@"BINVAL"])
            {
                NSString *string = [node stringValue];
                NSData *data = [[NSData alloc] initWithBase64EncodedString:string options:(NSDataBase64DecodingIgnoreUnknownCharacters)];
                image = [UIImage imageWithData:data];
            }
        }
    }
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(receiveFriendVcard:)])
    {
        [self.delegate receiveFriendVcard:image];
    }

}

///发送消息
+(void)sendMessage:(NSString *)name type:(NSString *)type message:(NSString *)message messageType:(NSString *)messageType duration:(NSNumber *)duration
{
    
    ///查询对话界面是否包含和此人的聊天
    [DialogueModel checkIfHaveInDialogue:name content:message isGroupChat:NO];
    
    if ([name rangeOfString:kDOMAIN].location != NSNotFound)
    {
        name = [name substringToIndex:[name rangeOfString:kDOMAIN].location-1];
    }
    XMPPJID *jid = [XMPPJID jidWithUser:name domain:kDOMAIN resource:kRESOURCE];
    XMPPMessage *messageXMPP = [XMPPMessage messageWithType:type to:jid elementID:[XMPPStream generateUUID]];
    [messageXMPP addBody:message];
    if (duration != 0)
    {
        [messageXMPP addAttributeWithName:@"audioDuration" numberValue:duration];
    }
    [messageXMPP addAttributeWithName:@"messageType" stringValue:messageType];
    NSXMLElement *receipt = [NSXMLElement elementWithName:@"request" xmlns:@"urn:xmpp:receipts"];
    [messageXMPP addChild:receipt];
    [[[XMPPDataHelper shareHelper] xmppStream] sendElement:messageXMPP];
}
///接收消息
-(void)receiveMessageWithMessage:(XMPPMessage *)message
{
    ChartMessage *chartMessage  = [[ChartMessage alloc]init];

    XMPPRosterHelper *helper = [XMPPRosterHelper sharedHelper];
    XMPPFriendInfo *object = [helper friendInfomationWithUserName:message.from.user];
    NSString *otherName = message.from.user;
    if ([message isGroupChatMessage]) {
        otherName = message.from.resource;
    }

    UIImage *image = [object photo];
    if (image == nil)
    {
        image = kDefaultIcon;
        XMPPvCardInfo *info = [[XMPPVCardHelper sharedHelper] searchFriendFromDB:otherName];
        if ([UIImage imageWithData:info.photoData])
        {
            image = [UIImage imageWithData:info.photoData];
        }
    }
    chartMessage.icon           = image;
    chartMessage.messageType    = kMessageFrom;
    chartMessage.content        = [message body];
    chartMessage.time           = @"上午 10:25";
    chartMessage.audioDuration  = [message attributeNumberIntValueForName:@"audioDuration"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[message body] forKey:@"content"];
    [dict setObject:chartMessage.icon forKey:@"icon"];
    [dict setObject:chartMessage.time forKey:@"time"];
    [dict setObject:[message attributeNumberIntValueForName:@"audioDuration"] forKey:@"duration"];
    [dict setObject:[NSString stringWithFormat:@"%d",kMessageFrom] forKey:@"type"];
    chartMessage.dict         = dict;
    chartMessage.name = [[XMPPRosterHelper sharedHelper] remarkNameOrNickNameForFriend:otherName];
    if ([message isGroupChatMessage])
    {
        chartMessage.userID = message.from.resource;
        
//        BOOL isFriend = [[XMPPRosterHelper sharedHelper] checkIfFriend:message.from.resource];
//        if (!isFriend)
//        {
//            [[XMPPVCardHelper sharedHelper] fetchSomeBodyInfo:message.from.resource];        
//        }
    }
    else
    {
        chartMessage.userID = message.from.user;
    }
    ///如果是语音则后台下载录音
    NSString *type = [message attributeStringValueForName:@"messageType"];
    NSDictionary *_tmpDict = [NSJSONSerialization JSONObjectWithData:[chartMessage.content dataUsingEncoding:NSUTF8StringEncoding] options:(NSJSONReadingMutableLeaves) error:nil];
    if ([type isEqualToString:kAudio] ||
        ([type isEqualToString:kProjectOutsourcing] && [[_tmpDict objectForKey:@"type"] intValue] == 2))
    {
        NSString *urlStr = [message body];
        if (_tmpDict != nil)
        {
            urlStr = [_tmpDict objectForKey:@"content"];
        }
        [SLHttpRequestHandler GETWithURL:urlStr success:^(NSString *wavName)
         {
             chartMessage.content = [urlStr stringByReplacingOccurrencesOfString:@".amr" withString:@".wav"];
             [dict setObject:[urlStr stringByReplacingOccurrencesOfString:@".amr" withString:@".wav"] forKey:@"content"];
             
             [self receiveMessage:message andChartMessage:chartMessage];
             
        } failure:^(NSError *error) {
#warning 多媒体文件下载失败
        }];
    }
    else if ([type isEqualToString:kProject] ||
             [type isEqualToString:kCase] ||
             [type isEqualToString:kCompany] ||
             [type isEqualToString:kCard])
    {
    
        ///接收到推荐的项目
        NSString *messageBody = [message body];
        NSDictionary *messageDict = [NSJSONSerialization JSONObjectWithData:[messageBody dataUsingEncoding:NSUTF8StringEncoding] options:(NSJSONReadingMutableLeaves) error:nil];
        chartMessage.itemContent = [messageDict objectForKey:@"itemContent"];
        chartMessage.itemID = [messageDict objectForKey:@"itemContent"];
        chartMessage.itemName = [messageDict objectForKey:@"itemName"];
        chartMessage.itemPicPath = [messageDict objectForKey:@"itemPicPath"];
        chartMessage.content = @"";
        chartMessage.itemType = type;
        [self receiveMessage:message andChartMessage:chartMessage];

    }
    else if ([type isEqualToString:kProjectOutsourcing])
    {
        ///项目接包
        ProjectDialogue *dialogue = [[ProjectDialogue alloc] init];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[chartMessage.content dataUsingEncoding:NSUTF8StringEncoding] options:(NSJSONReadingMutableLeaves) error:nil];
        dialogue.projectID = [dict objectForKey:@"projectID"];
        dialogue.messageReceiver = kDefaultJID.user;
        dialogue.messageSender = message.from.user;
        dialogue.messageTime = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
        [[ProjectDialogueDataBaseHelper sharedHelper] addProjectDialogue:dialogue];

        [self receiveMessage:message andChartMessage:chartMessage];
    }
    else
    {
        [self receiveMessage:message andChartMessage:chartMessage];
    }
    [self reloadChatView];
}
///刷新对话界面
-(void)reloadChatView
{
    ///刷新对话界面
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(refreshDialogueView)])
    {
        [self.delegate refreshDialogueView];
    }

}
///接收到消息
-(void)receiveMessage:(XMPPMessage *)message andChartMessage:(ChartMessage *)chartMessage
{
    if ([message isChatMessage])
    {
        ///单聊
        if ([self.delegate respondsToSelector:@selector(receiveSingleChatMessage:friendUserName:)] && self.delegate != nil)
        {
            [self.delegate receiveSingleChatMessage:chartMessage friendUserName:message.from];
        }
    }
    else if([message isGroupChatMessage])
    {
        ///群聊
        if ([self.delegate respondsToSelector:@selector(receiveGroupChatMessage:friendUserName:)] && self.delegate != nil)
        {
            [self.delegate receiveGroupChatMessage:chartMessage friendUserName:message.from];
        }
    }
}
///获取当前的所有好友
+(NSArray *)allMyFriendsWithState:(NSString *)state
{
    //好友信息
    NSManagedObjectContext *context = [[[XMPPDataHelper shareHelper] xmppRosterStorage] mainThreadManagedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPUserCoreDataStorageObject" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    
    if([state isEqualToString:kFriendRequest])
    {
        NSString *sql = [NSString stringWithFormat:@"subscription = '%@' and streamBareJidStr like '%@@%@*'",@"from",kDefaultJID.user,kDOMAIN];
        request.predicate = [NSPredicate predicateWithFormat:sql];
        
        [request setEntity:entity];
        NSError *error = nil;
        NSArray *friends = [context executeFetchRequest:request error:&error];

        return friends;

        
    }
    else
    {
//        NSString *string = [NSString stringWithFormat:@"%@/Library/Application Support/托付/XMPPRoster.sqlite",NSHomeDirectory()];
//        NSString *path = [NSString stringWithFormat:@"%@/Documents/XMPPRoster.sqlite",NSHomeDirectory()];
//        NSFileManager *manager = [NSFileManager defaultManager];
//        [manager removeItemAtPath:path error:nil];
//        [manager copyItemAtPath:string toPath:path error:nil];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docDir = [paths objectAtIndex:0];
        NSString *name = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
        docDir = [docDir stringByAppendingFormat:@"/%@/XMPPRoster.sqlite",name];
        FMDatabase *projectInfoDatabase = [FMDatabase databaseWithPath:docDir];

        [projectInfoDatabase open];
        NSMutableArray *tmpArray = [NSMutableArray array];

        if ([[NSFileManager defaultManager] fileExistsAtPath:docDir])
        {
            NSString *sql = [NSString stringWithFormat:@"select *from ZXMPPUSERCOREDATASTORAGEOBJECT where zsubscription = '%@' and zstreamBareJidStr = '%@@%@'",@"both",kDefaultJID.user,kDOMAIN];
            FMResultSet *result = [projectInfoDatabase executeQuery:sql];
            while ([result next])
            {
                FriendUserInfo *friendInfo = [[FriendUserInfo alloc] init];
                NSString *userID = [result stringForColumn:@"ZJIDSTR"];
                XMPPJID *jid = [XMPPJID jidWithString:userID];
                friendInfo.userID = jid.user;
                [tmpArray addObject:friendInfo];
            }
        }
        [projectInfoDatabase close];
        return tmpArray;
    }
    

    
}
//增加好友请求

///获取聊天信息
+(NSMutableArray *)allMessageWithFriendName:(NSString *)name
{
    //聊天信息
    NSManagedObjectContext *context = [[[XMPPDataHelper shareHelper] xmppMessageArchivingCoreDataStorage] mainThreadManagedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject" inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    

    NSString *value = name;
    if ([value rangeOfString:kDOMAIN].location == NSNotFound)
    {
        value = [NSString stringWithFormat:@"%@@%@",name,kDOMAIN];

    }
    NSString *sql = [NSString stringWithFormat:@"bareJidStr = '%@' and streamBareJidStr = '%@@%@'",value,kDefaultJID.user,kDOMAIN];
    request.predicate = [NSPredicate predicateWithFormat:sql];
    [request setEntity:entity];
    NSError *error = nil;
    NSMutableArray *messages = [NSMutableArray arrayWithArray:[context executeFetchRequest:request error:&error]];
    return messages;
}
///获取某种类型的全部消息
-(NSArray *)selectAllSomeModelMessageWithWho:(NSString *)name andChatType:(chatType)chatType andMessageType:(NSString *)messageType
{
    NSManagedObjectContext *context = [[[XMPPDataHelper shareHelper] xmppMessageArchivingCoreDataStorage] mainThreadManagedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([XMPPMessageArchiving_Message_CoreDataObject class]) inManagedObjectContext:context];
    [request setEntity:entity];
    NSString *sql = @"";
    
    NSString *message = @"";
    if ([messageType isEqualToString:kAudio])
    {
        ///语音
        message = [NSString stringWithFormat:@"%@*.amr",kFILEHOST];
    }
    else if ([messageType isEqualToString:kPhoto])
    {
        ///图片
        message = [NSString stringWithFormat:@"%@*.jpg",kFILEHOST];
    }
    
    if (chatType == groupChat)
    {
        ///群聊
        name = [name stringByAppendingFormat:@"@%@",kGROUPCHATLOGO];
        sql = [NSString stringWithFormat:@"bareJidStr = '%@' and streamBareJidStr = '%@@%@' and body like '%@' and outgoing = '%@'",name,kDefaultJID.user,kDOMAIN,message,[NSNumber numberWithBool:NO]];

    }
    else if (chatType == singleChat)
    {
        ///单聊
        name = [name stringByAppendingFormat:@"@%@",kDOMAIN];
        sql = [NSString stringWithFormat:@"bareJidStr = '%@' and streamBareJidStr = '%@@%@' and body like '%@'",name,kDefaultJID.user,kDOMAIN,message];

    }

    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:sql];
    [request setPredicate:predicate];
    NSArray *array = [context executeFetchRequest:request error:nil];

    return array;
}
///删除与某人的消息记录
-(NSError *)deleteAllMessageWithFriend:(NSString *)username andMessages:(NSArray *)messages
{
    NSManagedObjectContext *context = [[[XMPPDataHelper shareHelper] xmppMessageArchivingCoreDataStorage] mainThreadManagedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([XMPPMessageArchiving_Message_CoreDataObject class]) inManagedObjectContext:context];
    
    NSString *sql = [NSString stringWithFormat:@"streamBareJidStr like '%@@%@*' and bareJidStr like '%@@%@*'",kDefaultJID.user,kDefaultJID.domain,username,kDOMAIN];
    if (messages.count != 0)
    {
        if (messages.count == 1)
        {
            ///删除某一条聊天信息
            sql = [NSString stringWithFormat:@"streamBareJidStr like '%@@%@*' and bareJidStr like '%@@%@*' and body = '%@'",kDefaultJID.user,kDefaultJID.domain,username,kDOMAIN,messages.firstObject];
        }
        else
        {
            ///删除多条联系信息
#warning 删除多条联系信息
        }
    }

    NSPredicate *predicate = [NSPredicate predicateWithFormat:sql];
    
    [request setEntity:entity];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *array = [context executeFetchRequest:request error:&error];
    for (XMPPMessageArchiving_Message_CoreDataObject *object in array) {
        [context deleteObject:object];
    }
    
    if (error)
    {
        DLog(@"删除聊天信息失败:%@",error);
        return error;
    }
    DLog(@"删除聊天信息成功");
    return error;
}

///删除最近联系人
-(NSError *)deleteRecentPeople:(NSArray *)peopleArray
{
    NSManagedObjectContext *context = [[[XMPPDataHelper shareHelper] xmppMessageArchivingCoreDataStorage] mainThreadManagedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([XMPPMessageArchiving_Contact_CoreDataObject class]) inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSString *sql = [NSString stringWithFormat:@"streamBareJidStr = '%@@%@'",kDefaultJID.user,kDefaultJID.domain];
    if (peopleArray.count != 0)
    {
        sql = [NSString stringWithFormat:@"streamBareJidStr = '%@@%@' and bareJidStr = '%@@%@'",kDefaultJID.user,kDefaultJID.domain,peopleArray.firstObject,kDOMAIN];
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:sql];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *array = [context executeFetchRequest:request error:&error];

    DLog(@"sql语句:%@,数组:%@",sql,array);
    
    for (XMPPMessageArchiving_Contact_CoreDataObject *object in array)
    {
        [context deleteObject:object];
    }
    [context save:&error];
    if (error)
    {
        DLog(@"删除最近联系人失败%@",error);
        return error;
    }
    DLog(@"删除最近联系人成功");
    return error;
}

///检测信息是否完整
+(BOOL)allInformationReadyUserName:(NSString *)username passWord:(NSString *)password
{
    if (username && password)
    {
        [[[XMPPDataHelper shareHelper] xmppStream] setHostName:kHOSTNAME];
        [[[XMPPDataHelper shareHelper] xmppStream] setHostPort:kPORT];
        [[NSUserDefaults standardUserDefaults] setObject:kHOSTNAME forKey:kHost];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@@%@",username,kDOMAIN] forKey:kMyJID];
        [[NSUserDefaults standardUserDefaults] setObject:password forKey:kPS];
        return YES;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"信息不完整" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    return NO;
}


///连接服务器
+(void)connectToServer
{
    [[XMPPDataHelper shareHelper] myConnect];
}


///返回当前XMPPStream 对象
+(XMPPStream *)currentXMPPStream
{
    return [[XMPPDataHelper shareHelper] xmppStream];
}

///登录事件
+(BOOL)loginWithJidWithUserName:(NSString *)username passWord:(NSString *)passWord
{
    if ([[self currentXMPPStream] isConnected])
    {
        NSError *error ;
        [[XMPPHelper currentXMPPStream] setMyJID:[XMPPJID jidWithUser:username domain:kDOMAIN resource:kRESOURCE]];
        [[XMPPHelper currentXMPPStream] setHostName:kHOSTNAME];
        [[XMPPHelper currentXMPPStream] setHostPort:kPORT];
        if (![[XMPPDataHelper shareHelper].xmppStream authenticateWithPassword:passWord error:&error])
        {
            NSLog(@"error authenticate : %@",error.description);
            return NO;
        }
        return YES;
    }
    else
    {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请先链接" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
//        [alert show];

        ///链接IMf服务器
//        XMPPDataHelper *dataHelper = [XMPPDataHelper shareHelper];
//        [dataHelper setDelegate:self];
//        [dataHelper setupStream];
//        XMPPHelper *helper = [XMPPHelper sharedHelper];
//        [helper setDelegate:self];
        if ([self allInformationReadyUserName:@"" passWord:@""])
        {
            [self connectToServer];
        }

        
        return NO;
    }
}

///退出服务器
+(void)logOut
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kFirstLog];
    
    [[XMPPDataHelper shareHelper].xmppStream disconnectAfterSending];
    
    ///卸载ping
    [[[XMPPDataHelper shareHelper] autoPing] deactivate];
    [[[XMPPDataHelper shareHelper] autoPing] removeDelegate:self];
}

///添加好友
+(void)addFriend:(NSString *)name withMessage:(NSString *)message
{
    if (message == nil)
    {
        message = @"";
    }
    
//    <presence id="lEQnR-25" to="wqz@imserver" type="subscribe"><x xmlns="urn:rndchina:validationmessage"><body>求加好友啊</body></x></presence>
    
    XMPPJID *jid = [XMPPJID jidWithUser:name domain:kDOMAIN resource:kRESOURCE];
//    [[[XMPPDataHelper shareHelper] xmppRoster] addUser:<#(XMPPJID *)#> withNickname:<#(NSString *)#>:jid];
    
    // <iq type="set">
    //   <query xmlns="jabber:iq:roster">
    //     <item jid="bareJID" name="optionalName">
    //      <group>family</group>
    //     </item>
    //   </query>
    // </iq>
    
    DDXMLElement *x = [DDXMLElement elementWithName:@"x" xmlns:@"urn:rndchina:validationmessage"];
    DDXMLElement *body = [DDXMLElement elementWithName:@"body" stringValue:message];
    [x addChild:body];

    
    XMPPIQ *iq = [XMPPIQ iqWithType:@"set" elementID:[XMPPStream generateUUID]];
    DDXMLElement *query = [DDXMLElement elementWithName:@"query" xmlns:@"jabber:iq:roster"];
    DDXMLElement *item = [DDXMLElement elementWithName:@"item"];
    [item addAttributeWithName:@"jid" stringValue:jid.bare];
    [query addChild:item];
    [iq addChild:query];
    [iq addChild:x];
    [[[XMPPDataHelper shareHelper] xmppStream] sendElement:iq];
    
    
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"subscribe" to:jid];
    [presence addAttributeWithName:@"id" stringValue:[XMPPStream generateUUID]];
    
    DDXMLElement *x1 = [DDXMLElement elementWithName:@"x" xmlns:@"urn:rndchina:validationmessage"];
    DDXMLElement *body1 = [DDXMLElement elementWithName:@"body" stringValue:message];
    [x1 addChild:body1];

    
    [presence addChild:x1];
    [[[XMPPDataHelper shareHelper] xmppStream] sendElement:presence];
}

///获取好友信息
+(void)getFriendInfo:(NSString *)name
{
    if ([name rangeOfString:kDOMAIN].location == NSNotFound)
    {
        XMPPJID *jid = [XMPPJID jidWithUser:name domain:kDOMAIN resource:kRESOURCE];
        [[[XMPPDataHelper shareHelper] xmppvCardTempModule] fetchvCardTempForJID:jid ignoreStorage:YES];
    }
    else
    {
        XMPPJID *jid = [XMPPJID jidWithString:name];
        [[[XMPPDataHelper shareHelper] xmppvCardTempModule] fetchvCardTempForJID:jid ignoreStorage:YES];
    }

}
///更改密码
+(void)changePassword
{

}

///同意或拒绝好友请求
+(void)agreeOrRefuseFriendRequest:(NSString *)username type:(friendRequestType)type
{
    
    [[RedViewHelper sharedHelper] deleteRedViewFromJID:username withType:[NSNumber numberWithInt:2]];

    
    XMPPJID *jid = [XMPPJID jidWithString:username];

    if ([username rangeOfString:@"@imserver"].location == NSNotFound)
    {
        jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",username,kDOMAIN]];
    }
    if (type == agreeFriend)
    {
        [[[XMPPDataHelper shareHelper] xmppRoster] acceptPresenceSubscriptionRequestFrom:jid andAddToRoster:YES];
    }
    else
    {
        [[[XMPPDataHelper shareHelper] xmppRoster] rejectPresenceSubscriptionRequestFrom:jid];
    }
    
    NSString *tmp = @"";
    if (type == agreeFriend)
    {
        tmp = kAgree;
    }
    else
    {
        tmp = kReject;
    }
    [[FriendRequestInfoHelper shared] changeFriendRequest:username type:tmp];
    
}

///向数据库中添加好友请求信息
+(void)addFriendRequestToDbFriendJid:(XMPPJID *)friendJid myJid:(XMPPJID *)myJid
{
    dispatch_async(dispatch_get_main_queue(), ^{

        NSManagedObjectContext *context = [[[XMPPDataHelper shareHelper] xmppRosterStorage] mainThreadManagedObjectContext];
        XMPPUserCoreDataStorageObject *info = (XMPPUserCoreDataStorageObject *)[NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([XMPPUserCoreDataStorageObject class]) inManagedObjectContext:context];
        [info setAsk:@"subscribe"];
        [info setDisplayName:[friendJid user]];
        [info setJid:friendJid];
        [info setNickname:[friendJid user]];
        [info setStreamBareJidStr:[NSString stringWithFormat:@"%@@%@/%@",myJid.user,myJid.domain,myJid.resource]];
        [info setSubscription:@"none"];
        NSError *error = nil;
        BOOL result = [context save:&error];
        if (result)
        {
            DLog(@"插入数据成功:%@",info.jidStr);
        }
        else
        {
            DLog(@"插入数据失败:%@",error.description);
        }
    });

}
///从数据库中删除好友
+(void)deleteFriendFromDB:(XMPPJID *)friendJid myJid:(XMPPJID *)myJid
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSManagedObjectContext *context = [[[XMPPDataHelper shareHelper] xmppRoomStorage] mainThreadManagedObjectContext];
        NSEntityDescription *userDescription = [NSEntityDescription entityForName:NSStringFromClass([XMPPUserCoreDataStorageObject class]) inManagedObjectContext:context];
        [request setEntity:userDescription];
        NSString *sql = [NSString stringWithFormat:@"jidStr like '%@*' and streamBareJidStr like '%@*'",[friendJid.user stringByAppendingString:friendJid.domain],[myJid.user stringByAppendingString:myJid.domain]];
        NSPredicate *userPredicate = [NSPredicate predicateWithFormat:sql];
        [request setPredicate:userPredicate];
        NSError *error = nil;
        NSMutableArray *userArray = [[context executeFetchRequest:request error:&error] mutableCopy];
        for (XMPPUserCoreDataStorageObject *tmp in userArray)
        {
            [context deleteObject:tmp];
        }
        [context save:&error];     //先把数据查出来，然后逐一删除，最后做一次保存数据,what the fuck?!apple 竟然这么复杂？！
    });
}
///从数据库中查找数据
-(void)searchDataFromDB:(XMPPJID *)friendJID
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSManagedObjectContext *context = [[[XMPPDataHelper shareHelper] xmppRosterStorage] mainThreadManagedObjectContext];
        NSEntityDescription *object = [NSEntityDescription entityForName:NSStringFromClass([XMPPUserCoreDataStorageObject class]) inManagedObjectContext:context];
        [request setEntity:object];
        NSString *jidStr = [NSString stringWithFormat:@"%@@%@",friendJID.user,friendJID.domain];
        NSString *myJidStr = [NSString stringWithFormat:@"%@@%@",kDefaultJID.user,kDefaultJID.domain];
        NSString *string = [NSString stringWithFormat:@"jidStr like '%@*' and streamBareJidStr like '%@*'",jidStr,myJidStr];
        DLog(@"sql:%@",string);
        NSPredicate *presicate = [NSPredicate predicateWithFormat:string];
        [request setPredicate:presicate];
        NSError *error = nil;
        NSMutableArray *resultArray = [[context executeFetchRequest:request error:&error] mutableCopy];
        
        if (resultArray.count == 0)
        {
            resultArray = [NSMutableArray array];
        }
        
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(searchResultWithArray:andFriendJID:)])
        {
            [self.delegate searchResultWithArray:[resultArray copy] andFriendJID:friendJID];
        }
        
    });
}

///链接、注册、登录、异地登录
-(void)receiveResult:(resultFromServer)result
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (result == connectSuccess || result == conncetError)
        {
            [HUDView showHUDWithText:@"链接成功了"];
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(connectToServerWithResult:)])
            {
                [self.delegate connectToServerWithResult:result];
                return ;
            }
            if (result == connectSuccess)
            {
                if ([ToToolHelper checkIfLogin])
                {
                    [HUDView showHUDWithText:@"登录成功了"];
                    NSString *passWord = [[NSUserDefaults standardUserDefaults] objectForKey:@"toPassWord"];
                    if (passWord.length > 0 && [[UserInfo sharedInfo] userID].length > 0) {
                        [XMPPHelper loginWithJidWithUserName:[[UserInfo sharedInfo] userID] passWord:[[UserInfo sharedInfo] userID]];
                    }
                }
                
            }
        }
        else if (result == registerError || result == registerSuccess)
        {
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(registerWithResult:)])
            {
                [self.delegate registerWithResult:result];
            }
        }
        else if (result == loginError || result == loginSuccess)
        {
            if (result == loginSuccess)
            {
                XMPPRoomHelper *helper = [XMPPRoomHelper sharedRoom];
                [helper getAllMyExitsRoom];
            }
            
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(loginWithResult:)])
            {
                [self.delegate loginWithResult:result];
            }
        }
        else if (result == loginInOtherPlace)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"error" object:@"您的账户在其他地方登录"];
        }
    });
}

///房间更改主题成功
-(void)changeGroupChatRoomSubject:(XMPPMessage *)message
{
    NSString *groupName = [[[message attributeStringValueForName:@"from"] componentsSeparatedByString:@"/"] firstObject];

    NSString *tmp = [[message from] user];
    
    GroupChatInfoHelper *groupInfo = [GroupChatInfoHelper shared];
    [groupInfo changeGroupChat:tmp subject:[message subject]];
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(receiveChangeGroupRoomSubject:subject:)])
    {
        XMPPJID *jid = [XMPPJID jidWithString:groupName];
        [self.delegate receiveChangeGroupRoomSubject:jid subject:[message subject]];
    }
}

///退出
-(void)logOutWithResult
{
    [XMPPHelper connectToServer];

    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(logoutSuccess)])
        {
            [self.delegate logoutSuccess];
        }
    });
}

///删除部分聊天记录
-(void)deleteSomeChatMessages:(NSArray *)messagesID messageType:(chatType)chatType friendName:(NSString *)friendName
{
    NSManagedObjectContext *context = [[[XMPPDataHelper shareHelper] xmppMessageArchivingCoreDataStorage] mainThreadManagedObjectContext];
    
    NSMutableArray *array = [NSMutableArray array];
    if (chatType == singleChat)
    {
        array = [XMPPHelper allMessageWithFriendName:friendName];
    }
    else if (chatType == groupChat)
    {
        array = [[XMPPRoomHelper sharedRoom] _allGroupChatMessage:friendName];
    }
    
    for (NSNumber *number in messagesID)
    {
        XMPPMessageArchiving_Message_CoreDataObject *object = [array objectAtIndex:[number integerValue]];
        [context deleteObject:object];
    }
    
    NSError *error = nil;
    BOOL success = [context save:&error];
    if (!success)
    {
        DLog(@"删除失败:%@",error);
        return;
    }
    DLog(@"删除成功");
}
///搜索所有类似的消息
-(NSArray *)searchAllLikeMessage:(NSString *)key withJID:(NSString *)bareJIDUser type:(chatType)type
{
    NSManagedObjectContext *context = [[[XMPPDataHelper shareHelper] xmppMessageArchivingCoreDataStorage] mainThreadManagedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([XMPPMessageArchiving_Message_CoreDataObject class]) inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSString *sql = @"";
    if (bareJIDUser == nil)
    {
        ///所有的类似消息
        sql = [NSString stringWithFormat:@"streamBareJidStr = '%@@%@' and body like '*%@*' and bareJidStr like '*@%@' or streamBareJidStr = '%@@%@' and body like '*%@*' and bareJidStr like '*@conference.%@' and outgoing = '%@'",kDefaultJID.user,kDefaultJID.domain,key,kDOMAIN,kDefaultJID.user,kDefaultJID.domain,key,kDOMAIN,[NSNumber numberWithBool:YES]];
    }
    else
    {
        if (type == singleChat)
        {
            ///单聊的类似消息
            sql = [NSString stringWithFormat:@"streamBareJidStr = '%@@%@' and body like '*%@*' and bareJidStr = '%@@%@'",kDefaultJID.user,kDefaultJID.domain,key,bareJIDUser,kDOMAIN];
        }
        else if (type == groupChat)
        {
            ///群聊的类似消息
             sql = [NSString stringWithFormat:@"streamBareJidStr = '%@@%@' and body like '*%@*' and bareJidStr like '%@@conference.%@' and outgoing = '%@'",kDefaultJID.user,kDefaultJID.domain,key,bareJIDUser,kDOMAIN,[NSNumber numberWithBool:YES]];
        }
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:sql];
    [request setPredicate:predicate];
    NSArray *array = [context executeFetchRequest:request error:nil];
    
    NSMutableArray *tmpArray = [array mutableCopy];
    for (XMPPMessageArchiving_Message_CoreDataObject *message in array)
    {
        NSString *type = [[message message] attributeStringValueForName:@"messageType"];
        if (![type isEqualToString:@"text"])
        {
            [tmpArray removeObject:message];
        }
    }
    
    array = [tmpArray copy];
    return array;
}
@end
