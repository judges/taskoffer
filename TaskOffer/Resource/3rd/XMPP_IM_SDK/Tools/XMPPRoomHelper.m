//
//  XMPPRoomHelper.m
//  XMPPIM
//
//  Created by BourbonZ on 14/12/17.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import "XMPPRoomHelper.h"
#import "SLHttpRequestHandler.h"
#import "VoiceConverter.h"
#import "ToolHelper.h"
static XMPPRoomHelper *_helper;
@implementation XMPPRoomHelper

///房间JID
-(XMPPJID *)roomJIDWithName:(NSString *)chatRoomName
{
    return [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@conference.%@",chatRoomName,kDOMAIN]];

}
///返回房间
-(XMPPRoom *)getRoomWithRoomID:(XMPPJID *)roomJID
{
    XMPPRoom *room = [[XMPPRoom alloc] initWithRoomStorage:[[XMPPDataHelper shareHelper] xmppRoomStorage] jid:roomJID];
    dispatch_queue_t queue = dispatch_queue_create("room", 0);
    [room addDelegate:self delegateQueue:queue];
    [room activate:[[XMPPDataHelper shareHelper] xmppStream]];
    return room;
}
///创建单例
+(XMPPRoomHelper *)sharedRoom
{
    @synchronized(self)
    {
        if (_helper == nil)
        {
            _helper = [[XMPPRoomHelper alloc] init];
            dispatch_queue_t queue = dispatch_queue_create("群聊发送消息", 0);
            XMPPMUC *muc = [[XMPPMUC alloc] initWithDispatchQueue:queue];

            [muc activate:[[XMPPDataHelper shareHelper] xmppStream]];
            [muc addDelegate:self delegateQueue:queue];
            
        }
        return _helper;
    }
}

///创建聊天室
-(void)createChatRoomWithName:(NSString *)chatRoomName withNickName:(NSString *)nickName
{
    XMPPJID *jid = [self roomJIDWithName:chatRoomName];
    dispatch_queue_t roomQueue = dispatch_queue_create("roomQueue", 0);
    XMPPRoom *room = [[XMPPRoom alloc] initWithRoomStorage:[[XMPPDataHelper shareHelper] xmppRoomStorage] jid:jid dispatchQueue:roomQueue];
    [room activate:[XMPPDataHelper shareHelper].xmppStream];
    [room addDelegate:self delegateQueue:roomQueue];
    [room joinRoomUsingNickname:nickName history:nil];
}
///所有我创建的聊天室
-(NSMutableArray *)allMyCreateChatRoom
{
    
    NSManagedObjectContext *context = [[[XMPPDataHelper shareHelper] xmppRoomStorage] mainThreadManagedObjectContext];

    NSFetchRequest *request         = [[NSFetchRequest alloc] init];
    NSEntityDescription *roomList   = [NSEntityDescription entityForName:NSStringFromClass([XMPPRoomOccupantCoreDataStorageObject class]) inManagedObjectContext:context];
    [request setEntity:roomList];
        
        ///查询条件
    NSString *sql = [NSString stringWithFormat:@"realJIDStr like '%@@%@*'",kDefaultJID.user,kDefaultJID.domain];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:sql];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSMutableArray *resultArray = [[context executeFetchRequest:request error:&error] mutableCopy];
    return resultArray;

}

///发送群消息
-(void)sendGroupMessageToName:(NSString *)name withMessage:(NSString *)message messageType:(NSString *)messageType duration:(NSNumber *)duration
{
    dispatch_queue_t queue = dispatch_queue_create("room", 0);
    XMPPRoom *room = [[XMPPRoom alloc] initWithRoomStorage:[[XMPPDataHelper shareHelper] xmppRoomStorage]
                                                       jid:[self roomJIDWithName:name]
                                             dispatchQueue:queue];
    [room activate:[XMPPDataHelper shareHelper].xmppStream];
    [room addDelegate:self delegateQueue:queue];
    
    XMPPJID *roomJID = [self roomJIDWithName:name];
    XMPPMessage *messageXMPP = [XMPPMessage messageWithType:@"groupchat" to:roomJID];
    [messageXMPP addBody:message];
    [messageXMPP addAttributeWithName:@"audioDuration" numberValue:duration];
    [messageXMPP addAttributeWithName:@"messageType" stringValue:messageType];
    
    [room sendMessage:messageXMPP];
    
}

//第二次进入群聊天时的地方，但是由于openfire，所以前台要根据jid去拿room，所以这里只是做了一个简单查询，查询房间被禁止人员，减少了流量，因为基本不设置禁止人员。但是个问题
-(XMPPRoomMemberInfo *)searchGroupWithName:(NSString *)groupName
{
    NSManagedObjectContext *context = [[[XMPPDataHelper shareHelper] xmppRoomStorage] mainThreadManagedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *description = [NSEntityDescription entityForName:NSStringFromClass([XMPPRoomOccupantCoreDataStorageObject class]) inManagedObjectContext:context];
    [request setEntity:description];
    NSString *sql = [NSString stringWithFormat:@"roomJIDStr = '%@@conference.%@' and realJIDStr like '%@@%@*'",groupName,kDOMAIN,kDefaultJID.user,kDefaultJID.domain];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:sql];
    [request setPredicate:predicate];
    NSError *error = nil;
    NSArray *array = [context executeFetchRequest:request error:&error];
    
    XMPPRoomMemberInfo *object = (XMPPRoomMemberInfo *)[array firstObject];
    return object;
}
///获取已经存在的群
-(void)getAllExitsRoom
{
    NSXMLElement *queryElement= [NSXMLElement elementWithName:@"query" xmlns:@"http://jabber.org/protocol/disco#items"];
    NSXMLElement *iqElement = [NSXMLElement elementWithName:@"iq"];
    [iqElement addAttributeWithName:@"type" stringValue:@"get"];
    XMPPJID *jid = kDefaultJID;
    [iqElement addAttributeWithName:@"from" stringValue:[NSString stringWithFormat:@"%@@%@/%@",jid.user,jid.domain,jid.resource]];
    [iqElement addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"conference.%@",kDOMAIN]];
    [iqElement addAttributeWithName:@"id" stringValue:@"getexistroomid"];
    [iqElement addChild:queryElement];
    [[[XMPPDataHelper shareHelper] xmppStream] sendElement:iqElement];
}

///获取我加入的群
-(void)getAllMyExitsRoom
{
    DDXMLElement *query = [DDXMLElement elementWithName:@"query" xmlns:@"http://jabber.org/protocol/disco#items"];
    [query addAttributeWithName:@"node" stringValue:kGetMyRoom];
    XMPPJID *jid = [XMPPJID jidWithString:@"conference.imserver"];
    XMPPIQ *iq = [[XMPPIQ alloc] initWithType:@"get" to:jid elementID:[ToolHelper deviceUUID] child:query];
    [[[XMPPDataHelper shareHelper] xmppStream] sendElement:iq];
}

///获得我加入的群
-(void)allMyJoinRoom:(NSArray *)array
{
    NSMutableArray *itemArray = [NSMutableArray array];
    GroupChatInfoHelper *infoHelper = [GroupChatInfoHelper shared];
    for (DDXMLElement *item in array)
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        XMPPJID *roomJID = [XMPPJID jidWithString:[item attributeStringValueForName:@"jid"]];
        NSString *roomName = [item attributeStringValueForName:@"name"];
        [dict setObject:roomJID forKey:kRoomID];
        [dict setObject:roomName forKey:kRoomName];
        [itemArray addObject:dict];
        
        NSString *subject = [infoHelper searchGroupChatInfo:roomJID.user];
        if (subject.length > 0)
        {
            [infoHelper changeGroupChat:roomJID.user subject:roomName];
        }
        else
        {
            [infoHelper addGroupChat:roomJID.user subject:roomName];
        }
    }
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(allMyJoinRoomWithResult:)])
    {
        [self.delegate allMyJoinRoomWithResult:itemArray];
    }
}

///加入群
-(void)joinGroupWithName:(NSString *)groupName withNickName:(NSString *)nickName
{
    
    DDXMLElement *query = [DDXMLElement elementWithName:@"query" xmlns:@"http://jabber.org/protocol/disco#info"];
    XMPPJID *jid = [self roomJIDWithName:groupName];
    XMPPIQ *iq = [XMPPIQ iqWithType:@"get" to:jid elementID:[ToolHelper deviceUUID] child:query];
    [[[XMPPDataHelper shareHelper] xmppStream] sendElement:iq];
    
}

///离开房间
-(void)leaveRoom:(XMPPJID *)roomJID
{
    if (roomJID == nil)
    {
        return;
    }
    XMPPRoom *room = [self getRoomWithRoomID:roomJID];
    [room leaveRoom];
}

///邀请好友
-(void)inviteFriendToJoinGroup:(XMPPJID *)friendName withGroupName:(NSString *)groupName withMessage:(NSString *)message andRoom:(XMPPRoom *)room
{
    [room inviteUser:friendName withMessage:message];
}
///获取群的人员
-(void)allMemberForRoom:(XMPPRoom *)room
{
    [room fetchMembersList];
}
///群的详细设置
-(void)roomInfoWith:(NSArray *)array
{
    if ([self.delegate respondsToSelector:@selector(getRoomInfo:)] && self.delegate != nil)
    {
        [self.delegate getRoomInfo:array];
    }
}

///开始获取群的详细信息
-(void)startToGetRoomInfo:(XMPPJID *)roomJID
{
    XMPPRoom *room = [[XMPPRoom alloc] initWithRoomStorage:[[XMPPDataHelper shareHelper] xmppRoomStorage] jid:roomJID];
    dispatch_queue_t roomQueue = dispatch_queue_create("room", 0);
    [room addDelegate:self delegateQueue:roomQueue];
    [room activate:[[XMPPDataHelper shareHelper] xmppStream]];
//    [room fetchConfigurationForm];
//    [room fetchMembersList];
//    [room fetchModeratorsList];
    
    DDXMLElement *element = [DDXMLElement elementWithName:@"query"];
    [element addAttributeWithName:@"xmlns" stringValue:@"http://jabber.org/protocol/disco#items"];

    XMPPIQ *iq = [XMPPIQ iqWithType:@"get" to:room.roomJID elementID:[ToolHelper deviceUUID] child:element];
    [[[XMPPDataHelper shareHelper] xmppStream] sendElement:iq];
    
    
    DDXMLElement *query = [DDXMLElement elementWithName:@"query" xmlns:@"http://jabber.org/protocol/disco#info"];
    XMPPIQ *infoIq = [XMPPIQ iqWithType:@"get" to:roomJID elementID:[ToolHelper deviceUUID] child:query];
    [[[XMPPDataHelper shareHelper] xmppStream] sendElement:infoIq];
}

///获取全部聊天内容
-(void)allGroupChatMessageWithGroupName:(NSString *)name
{
    [self performSelectorOnMainThread:@selector(allMes:) withObject:name waitUntilDone:YES];
}
-(void)allMes:(NSString *)name
{

    NSMutableArray *messages = [self _allGroupChatMessage:name];
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(allGroupMessage:)])
    {
        [self.delegate allGroupMessage:messages];
    }
}
-(NSMutableArray *)_allGroupChatMessage:(NSString *)name
{
    //聊天信息
    NSManagedObjectContext *context = [[[XMPPDataHelper shareHelper] xmppMessageArchivingCoreDataStorage] mainThreadManagedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject" inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSString *value = name;
    if ([value rangeOfString:kDOMAIN].location == NSNotFound)
    {
        value = [NSString stringWithFormat:@"%@@conference.%@",name,kDOMAIN];
    }
    XMPPJID *userJID = kDefaultJID;
    NSString *userStr = [NSString stringWithFormat:@"%@@%@",userJID.user,userJID.domain];
    NSString *string = [NSString stringWithFormat:@"bareJidStr == '%@' and outgoing = %hhd",value,NO];
    request.predicate = [NSPredicate predicateWithFormat:string];
    
    [request setEntity:entity];
    NSError *error = nil;
    NSMutableArray *messages = [NSMutableArray arrayWithArray:[context executeFetchRequest:request error:&error]];
    return messages;
}


///更改群聊房间主题
-(void)changeGroupChatRoom:(XMPPJID *)roomJID subject:(NSString *)subject
{
    XMPPRoom *room = [self getRoomWithRoomID:roomJID];
    [room changeRoomSubject:subject];
}

#pragma mark 配置房间为永久房间
-(void)sendDefaultRoomConfig:(XMPPRoom *)room myJID:(NSString *)myJid
{
    NSXMLElement *x = [NSXMLElement elementWithName:@"x" xmlns:@"jabber:x:data"];
    
    NSXMLElement *field = [NSXMLElement elementWithName:@"field"];
    NSXMLElement *value = [NSXMLElement elementWithName:@"value"];
    
    NSXMLElement *fieldowners = [NSXMLElement elementWithName:@"field"];
    NSXMLElement *valueowners = [NSXMLElement elementWithName:@"value"];
    
    NSXMLElement *allowChangeSubjectField = [NSXMLElement elementWithName:@"field"];
    NSXMLElement *allowChangeSubjectValue = [NSXMLElement elementWithName:@"value"];
    
    NSXMLElement *subjectField = [NSXMLElement elementWithName:@"field"];
    NSXMLElement *subjectValue = [NSXMLElement elementWithName:@"value"];
    
    NSXMLElement *descField = [NSXMLElement elementWithName:@"field"];
    NSXMLElement *descValue = [NSXMLElement elementWithName:@"value"];
    
    
    [field addAttributeWithName:@"var" stringValue:@"muc#roomconfig_persistentroom"];  // 永久属性
    [fieldowners addAttributeWithName:@"var" stringValue:@"muc#roomconfig_roomowners"];  // 谁创建的房间
    
    
    [field addAttributeWithName:@"type" stringValue:@"boolean"];
    [fieldowners addAttributeWithName:@"type" stringValue:@"jid-multi"];
    
    
    [value setStringValue:@"1"];
    [valueowners setStringValue:myJid]; //创建者的Jid
    
    ///允许占有者更改主题
    [allowChangeSubjectField addAttributeWithName:@"var" stringValue:@"muc#roomconfig_changesubject"];
    [allowChangeSubjectField addAttributeWithName:@"type" stringValue:@"bolean"];
    [allowChangeSubjectField addAttributeWithName:@"label" stringValue:@"允许占有者更改主题"];
    [allowChangeSubjectValue setStringValue:@"1"];
    
    ///设置房间主题
    [subjectField addAttributeWithName:@"var" stringValue:@"roomconfig_roomdesc"];
    [subjectValue addAttributeWithName:@"type" stringValue:@"text-single"];
    [subjectField setStringValue:@"hhh"];
    
     //房间描述
    [descField addAttributeWithName:@"var" stringValue:@"muc#roomconfig_roomdesc"];
    [descField addAttributeWithName:@"type" stringValue:@"text-single"];
    [descField addAttributeWithName:@"label" stringValue:@"描述"];
    [descValue setStringValue:@"iOS房间"];

#warning 修改房间配置信息
    [field addChild:value];
    [x addChild:field];

    
    [fieldowners addChild:valueowners];
    [x addChild:fieldowners];
    
    [subjectField addChild:subjectValue];
    [x addChild:subjectField];

    
    [descField addChild:descValue];
    [x addChild:descField];
    
    [allowChangeSubjectField addChild:allowChangeSubjectValue];
    [x addChild:allowChangeSubjectField];
    
    
    DLog(@"发送配置信息:%@",x);
    [room configureRoomUsingOptions:x];
    
}


#pragma mark XMPPRoomDelegate
#pragma mark - xmpproom delegate
- (void)xmppRoomDidCreate:(XMPPRoom *)sender
{
    DLog(@"%@",sender.description);
//        [sender fetchConfigurationForm];
    XMPPJID *jid = kDefaultJID;
    NSString *jidStr = [NSString stringWithFormat:@"%@@%@/%@",jid.user,jid.domain,jid.resource];
    [self sendDefaultRoomConfig:sender myJID:jidStr];
    
//    [sender configureRoomUsingOptions:nil];
}
- (void)xmppRoom:(XMPPRoom *)sender didFetchConfigurationForm:(NSXMLElement *)configForm
{
    DLog(@"%@",configForm);
}

- (void)xmppRoom:(XMPPRoom *)sender willSendConfiguration:(XMPPIQ *)roomConfigForm
{
    DLog(@"%@",roomConfigForm);
}

- (void)xmppRoom:(XMPPRoom *)sender didConfigure:(XMPPIQ *)iqResult
{
    DLog(@"%@",iqResult);
}
- (void)xmppRoom:(XMPPRoom *)sender didNotConfigure:(XMPPIQ *)iqResult
{
    DLog(@"%@",iqResult);
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"failed" message:iqResult.description delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)xmppRoomDidJoin:(XMPPRoom *)sender
{
    DLog(@"%@",sender.description);
    dispatch_async(dispatch_get_main_queue(), ^{

        if ([self.delegate respondsToSelector:@selector(joinRoomSuccess:)] && self.delegate != nil)
        {
                [self.delegate joinRoomSuccess:sender];
        }
    });

//    [sender fetchConfigurationForm];
//    [sender fetchMembersList];
//    [sender fetchModeratorsList];
}
- (void)xmppRoomDidLeave:(XMPPRoom *)sender
{
    DLog(@"%@",sender.description);
    if ([self.delegate respondsToSelector:@selector(leaveRoomSuccess:)] && self.delegate != nil)
    {
        [self.delegate leaveRoomSuccess:sender];
    }
//    else if ([self.delegate respondsToSelector:@selector(joinRoomSuccess:)] && self.delegate != nil)
//    {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.delegate joinRoomSuccess:sender];            
//        });
//    }
}

- (void)xmppRoomDidDestroy:(XMPPRoom *)sender
{
    DLog(@"%@",sender.description);
}

- (void)xmppRoom:(XMPPRoom *)sender occupantDidJoin:(XMPPJID *)occupantJID withPresence:(XMPPPresence *)presence
{
    DLog(@"jid:%@  presence ; %@",occupantJID,presence);
}
- (void)xmppRoom:(XMPPRoom *)sender occupantDidLeave:(XMPPJID *)occupantJID withPresence:(XMPPPresence *)presence
{
    DLog(@"jid:%@  presence ; %@",occupantJID,presence);
    
}
- (void)xmppRoom:(XMPPRoom *)sender occupantDidUpdate:(XMPPJID *)occupantJID withPresence:(XMPPPresence *)presence
{
    DLog(@"jid:%@  presence ; %@",occupantJID,presence);
    
}

/**
 * Invoked when a message is received.
 * The occupant parameter may be nil if the message came directly from the room, or from a non-occupant.
 **/
- (void)xmppRoom:(XMPPRoom *)sender didReceiveMessage:(XMPPMessage *)message fromOccupant:(XMPPJID *)occupantJID
{
    DLog(@"sender:%@ and message:%@ and occupantID:%@",sender.roomJID,message,occupantJID);
//    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(receiveGroupChatRoom:withMessage:occupantJID:)])
//    {
//        ChartMessage *chat  = [[ChartMessage alloc]init];
//        chat.icon           = [NSString stringWithFormat:@"icon%02d.jpg",kMessageFrom+1];
//        chat.messageType    = kMessageFrom;
//        chat.content        = [message body];
//        chat.time           = @"上午 10:25";
//        chat.audioDuration  = [message attributeNumberIntValueForName:@"audioDuration"];
//
//        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//        [dict setObject:[message body] forKey:@"content"];
//        [dict setObject:chat.icon forKey:@"icon"];
//        [dict setObject:chat.time forKey:@"time"];
//        [dict setObject:[NSString stringWithFormat:@"%d",kMessageFrom] forKey:@"type"];
//        [dict setObject:[message attributeNumberIntValueForName:@"audioDuration"] forKey:@"duration"];
//
//        chat.dict         = dict;
//        
//        
//        ///如果是语音则后台下载录音
//        NSString *type = [message attributeStringValueForName:@"messageType"];
//        if ([type isEqualToString:kAudio])
//        {
//            NSString *urlStr = [message body];
//            [SLHttpRequestHandler GETWithURL:urlStr success:^(NSString *wavName)
//             {
//                 chat.content = [urlStr stringByReplacingOccurrencesOfString:@".amr" withString:@".wav"];
//                 [dict setObject:[urlStr stringByReplacingOccurrencesOfString:@".amr" withString:@".wav"] forKey:@"content"];
//                 if ([self.delegate respondsToSelector:@selector(receiveGroupChatRoom:withMessage:occupantJID:)] && self.delegate != nil)
//                 {
//                     dispatch_async(dispatch_get_main_queue(), ^{
//                         [self.delegate receiveGroupChatRoom:sender withMessage:chat occupantJID:occupantJID];
//                     });
//                 }
//             } failure:^(NSError *error) {
//                 
//             }];
//            return;
//        }
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.delegate receiveGroupChatRoom:sender withMessage:chat occupantJID:occupantJID];
//        });
//    }
}

- (void)xmppRoom:(XMPPRoom *)sender didFetchBanList:(NSArray *)items
{
    DLog(@"%@",items);
}
- (void)xmppRoom:(XMPPRoom *)sender didNotFetchBanList:(XMPPIQ *)iqError
{
    DLog(@"%@",iqError);
}

- (void)xmppRoom:(XMPPRoom *)sender didFetchMembersList:(NSArray *)items
{
    DLog(@"%@",items);
}
- (void)xmppRoom:(XMPPRoom *)sender didNotFetchMembersList:(XMPPIQ *)iqError
{
    DLog(@"%@",iqError);
    
}

- (void)xmppRoom:(XMPPRoom *)sender didFetchModeratorsList:(NSArray *)items
{
    DLog(@"%@",items);
}
- (void)xmppRoom:(XMPPRoom *)sender didNotFetchModeratorsList:(XMPPIQ *)iqError
{
    DLog(@"%@",iqError);
    
}

- (void)xmppRoom:(XMPPRoom *)sender didEditPrivileges:(XMPPIQ *)iqResult
{
    DLog(@"%@",iqResult);
}
- (void)xmppRoom:(XMPPRoom *)sender didNotEditPrivileges:(XMPPIQ *)iqError
{
    DLog(@"%@",iqError);
}

#pragma mark - XMPPRoom storage
- (BOOL)configureWithParent:(XMPPRoom *)aParent queue:(dispatch_queue_t)queue
{
    return YES;
}

/**
 * Updates and returns the occupant for the given presence element.
 * If the presence type is "available", and the occupant doesn't already exist, then one should be created.
 **/
- (void)handlePresence:(XMPPPresence *)presence room:(XMPPRoom *)room
{
    DLog(@"%@",presence);
}

/**
 * Stores or otherwise handles the given message element.
 **/
- (void)handleIncomingMessage:(XMPPMessage *)message room:(XMPPRoom *)room
{
    DLog(@"%@",message.XMLString);
}
- (void)handleOutgoingMessage:(XMPPMessage *)message room:(XMPPRoom *)room
{
    DLog(@"%@",message.XMLString);
    
}

/**
 * Handles leaving the room, which generally means clearing the list of occupants.
 **/
- (void)handleDidLeaveRoom:(XMPPRoom *)room
{
    DLog(@"%@",room);
}
#pragma mark MUC Delegate
-(void)xmppMUC:(XMPPMUC *)sender didDiscoverRooms:(NSArray *)rooms forServiceNamed:(NSString *)serviceName
{
    DLog(@"%@,%@",rooms,serviceName);
}
-(void)xmppMUC:(XMPPMUC *)sender didDiscoverServices:(NSArray *)services
{
    DLog(@"%@",services);
}
-(void)xmppMUC:(XMPPMUC *)sender failedToDiscoverRoomsForServiceNamed:(NSString *)serviceName withError:(NSError *)error
{
    DLog(@"%@,%@",serviceName,error.localizedDescription);
}
-(void)xmppMUC:(XMPPMUC *)sender roomJID:(XMPPJID *)roomJID didReceiveInvitation:(XMPPMessage *)message
{
    DLog(@"%@,%@",roomJID.description,message.description);
}
-(void)xmppMUC:(XMPPMUC *)sender roomJID:(XMPPJID *)roomJID didReceiveInvitationDecline:(XMPPMessage *)message
{
    DLog(@"%@,%@",roomJID.description,message.description);
}
-(void)xmppMUCFailedToDiscoverServices:(XMPPMUC *)sender withError:(NSError *)error
{
    DLog(@"%@",error.description);
}
@end
