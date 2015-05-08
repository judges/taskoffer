//
//  XMPPDataHelper.m
//  XMPPIM
//
//  Created by BourbonZ on 14/12/25.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import "XMPPDataHelper.h"
#import "ToolHelper.h"
#import "XMPPMessage+XEP0045.h"
#import "RedViewHelper.h"
#import "FriendRequestInfoHelper.h"
#import "XMPPFileHelper.h"
#import "ToToolHelper.h"
static XMPPDataHelper *_dataHelper;
@implementation XMPPDataHelper
@synthesize xmppMessageArchivingCoreDataStorage;
@synthesize xmppMessageArchivingModule;
@synthesize xmppRoom;
@synthesize xmppRoomStorage;
@synthesize xmppRoster;
@synthesize xmppRosterStorage;
@synthesize xmppStream;
@synthesize xmppvCardAvatarModule;
@synthesize xmppvCardStorage;
@synthesize xmppvCardTempModule;
@synthesize autoPing;
@synthesize heartTimer;
#pragma mark - xmpp
+(XMPPDataHelper *)shareHelper
{
    @synchronized(self)
    {
        if (_dataHelper == nil)
        {
            _dataHelper = [[XMPPDataHelper alloc] init];
        }
        return _dataHelper;
    }
}

- (void)setupStream{
    xmppStream = [[XMPPStream alloc]init];
    xmppStream.enableBackgroundingOnSocket = YES;
    [xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    xmppRosterStorage = [XMPPRosterCoreDataStorage sharedInstance];
    xmppRosterStorage.autoRemovePreviousDatabaseFile = NO;
    xmppRosterStorage.autoRecreateDatabaseFile = YES;
    
    xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:xmppRosterStorage dispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    xmppRoster.autoFetchRoster = YES;
    xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
    xmppRoster.autoClearAllUsersAndResources = NO;
    [xmppRoster activate:self.xmppStream];
    dispatch_queue_t rosterQueue = dispatch_queue_create("roster", 0);
    [xmppRoster addDelegate:self delegateQueue:rosterQueue];
    
    
    xmppReconnect = [[XMPPReconnect alloc] init];
    xmppReconnect.reconnectTimerInterval = 30.0f;
    xmppReconnect.autoReconnect = YES;
    [xmppReconnect addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [xmppReconnect activate:self.xmppStream];
    
    
    xmppMessageArchivingCoreDataStorage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
    xmppMessageArchivingModule = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:xmppMessageArchivingCoreDataStorage];
    [xmppMessageArchivingModule setClientSideMessageArchivingOnly:YES];
    [xmppMessageArchivingModule activate:xmppStream];
    dispatch_queue_t archivingQueue = dispatch_queue_create("archiving", 0);
    [xmppMessageArchivingModule addDelegate:self delegateQueue:archivingQueue];
    
    
    xmppvCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
    xmppvCardTempModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:xmppvCardStorage];
    xmppvCardAvatarModule = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:xmppvCardTempModule];
    dispatch_queue_t vCradTempQueue = dispatch_queue_create("vcardTemp", 0);
    [xmppvCardTempModule addDelegate:self delegateQueue:vCradTempQueue];
    dispatch_queue_t vCradAvatarQueue = dispatch_queue_create("vcardAvatar", 0);
    [xmppvCardAvatarModule addDelegate:self delegateQueue:vCradAvatarQueue];
    [xmppvCardTempModule activate:xmppStream];
    [xmppvCardAvatarModule activate:xmppStream];
    
    
    GroupChatInfoHelper *helper = [GroupChatInfoHelper shared];
    [helper saveContext];
    
    
//    autoPing = [[XMPPAutoPing alloc] init];
//    [autoPing activate:xmppStream];
//    dispatch_queue_t pingQueue = dispatch_queue_create("ping", 0);
//    [autoPing addDelegate:self delegateQueue:pingQueue];
//    autoPing.pingInterval = 3;
//    autoPing.pingTimeout = 120;
//    autoPing.targetJID = [XMPPJID jidWithString:kDOMAIN];


    
    xmppRoomStorage = [XMPPRoomCoreDataStorage sharedInstance];
    
    
    [XMPPNetReachHelper checkNetwork];
    
}

///注册
-(void)registerWithUserName:(NSString *)username andPassWord:(NSString *)password
{
    if ([[self xmppStream] isConnected] && [[self xmppStream] supportsInBandRegistration])
    {
        NSError *error ;
        [[self xmppStream] setMyJID:[XMPPJID jidWithUser:username domain:kDOMAIN resource:kRESOURCE]];
        [[self xmppStream] setHostName:kHOSTNAME];
        [[self xmppStream] setHostPort:kPORT];
        if (![[self xmppStream] registerWithPassword:password error:&error])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

- (BOOL)myConnect{
    NSString *jid = [[NSUserDefaults standardUserDefaults]objectForKey:kMyJID];
    NSString *ps = [[NSUserDefaults standardUserDefaults]objectForKey:kPS];
    if (jid == nil || ps == nil) {
        return NO;
    }
    XMPPJID *myjid = [XMPPJID jidWithUser:[[NSUserDefaults standardUserDefaults] objectForKey:kMyJID] domain:kDOMAIN resource:kRESOURCE];
    
    NSError *error ;
    [xmppStream setMyJID:myjid];
    if ([xmppStream isConnected])
    {
        return YES;
    }
    else
    {
        if (![xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error]) {
            DLog(@"my connected error : %@",error.description);
            return NO;
        }
        return YES;
    }
}
#pragma mark - XMPPStreamDelegate

- (void)xmppStreamWillConnect:(XMPPStream *)sender
{
    DLog(@"xmppStreamWillConnect");
}
- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    DLog(@"xmppStreamDidConnect");
    ///链接成功
    [[XMPPHelper sharedHelper] receiveResult:connectSuccess];
}
- (void)xmppStreamDidRegister:(XMPPStream *)sender
{
    DLog(@"xmppStreamDidRegister");
    _isRegistration = YES;
    ///注册成功
    [[XMPPHelper sharedHelper] receiveResult:registerSuccess];
}
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error
{
    ///注册失败
    [[XMPPHelper sharedHelper] receiveResult:registerError];
}
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    XMPPJID *myJID = [sender myJID];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@@%@/%@",myJID.user,myJID.domain,myJID.resource] forKey:kJID];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    DLog(@"xmppStreamDidAuthenticate");
    XMPPPresence *presence = [XMPPPresence presence];
    [[self xmppStream] sendElement:presence];
    
    ///登录成功
    [[XMPPHelper sharedHelper] receiveResult:loginSuccess];
    ///发送iOS的token
    if ([[UIDevice currentDevice] systemName]) {
        
    }
    [ToolHelper sendDeviceToken];
    
    heartTimer = [NSTimer scheduledTimerWithTimeInterval:180 target:self selector:@selector(sendHeart) userInfo:nil repeats:YES];
    
}
-(void)sendHeart
{
    DLog(@"发送一次心跳");
    [xmppStream sendHeartBeat];
}
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
    DLog(@"didNotAuthenticate:%@",error.description);
    ///登录失败
    [[XMPPHelper sharedHelper] receiveResult:loginError];
}
- (NSString *)xmppStream:(XMPPStream *)sender alternativeResourceForConflictingResource:(NSString *)conflictingResource
{
    DLog(@"alternativeResourceForConflictingResource: %@",conflictingResource);
    return kRESOURCE;
}
- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
    DLog(@"didReceiveIQ: %@",iq.description);
    if ([iq isErrorIQ])
    {
        DDXMLElement *element = [iq childErrorElement];
        
        NSString *errorID = [element attributeStringValueForName:@"code"];
        NSString *errorReason = [[element childAtIndex:0] name];
        NSString *message = [NSString stringWithFormat:@"状态码为:%@ and 错误原因为:%@",errorID,errorReason];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"发生错误" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
        return YES;
    }
    
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kVcard object:iq];
    
    DDXMLElement *element = [iq childElement];
    DDXMLNode *node = [[element namespaces] firstObject];
    if ([element.name isEqualToString:@"query"] && [node.description isEqualToString:@"xmlns=\"http://jabber.org/protocol/disco#items\""])
    {
        ///判断是否是查询群成员
        NSArray *itemArray = [element children];
        
        NSString *nodeStr = [element attributeStringValueForName:@"node"];
        if ([nodeStr isEqualToString:kGetMyRoom])
        {
            ///查询我加入的群
            XMPPRoomHelper *roomHelper = [XMPPRoomHelper sharedRoom];
            [roomHelper allMyJoinRoom:itemArray];
            XMPPHelper *helper = [XMPPHelper sharedHelper];
            [helper reloadChatView];
        }
        else
        {
     
            XMPPJID *tmpJID = [itemArray firstObject];
            if ([tmpJID.description rangeOfString:@"@"].location != NSNotFound)
            {
                ///查询群成员
                NSMutableArray *array = [NSMutableArray array];
                for (DDXMLElement *item in itemArray)
                {
                    NSString *jidStr = [item attributeStringValueForName:@"jid"];
                    XMPPJID *jid = [XMPPJID jidWithString:jidStr];
                    [array addObject:jid.resource];
                }
                
                if (self.delegate != nil && [self.delegate respondsToSelector:@selector(allGroupMember:)])
                {
                    [self.delegate allGroupMember:array];
                }
            }
            else
            {
                ///查询到的服务器代理
                NSMutableArray *array = [NSMutableArray array];
                for (DDXMLElement *item in itemArray)
                {
                    NSString *jidStr = [item attributeStringValueForName:@"jid"];
                    XMPPJID *jid = [XMPPJID jidWithString:jidStr];
                    [array addObject:jid];
                }
                [[XMPPFileHelper shared] _serverProxy:array];
            }
        }
    }
    else if ([[iq xmlns] isEqualToString:@"jabber:client"] && [element.name isEqualToString:@"vCard"] && [element.xmlns isEqualToString:@"vcard-temp"])
    {
        XMPPvCardTemp *temp = [XMPPvCardTemp vCardTempFromElement:element];
        [self.xmppvCardTempModule _updatevCardTemp:temp forJID:iq.from];
    }
    else
    {
        DDXMLElement *vCard = [iq childElement];
        NSArray *array = [vCard children];
        
        for (int i = 0; i < array.count; i++)
        {
            DDXMLDocument *photo = [array objectAtIndex:i];
            NSArray *tmp = photo.children;
            for (int j = 0; j < tmp.count ; j ++)
            {
                DDXMLNode *node = [tmp objectAtIndex:j];
                if ([node.name isEqualToString:@"BINVAL"] && [[iq attributeStringValueForName:@"from"] rangeOfString:self.xmppStream.myJID.user].location != NSNotFound)
                {
//                    NSString *string = [node stringValue];
//                    NSData *data = [[NSData alloc] initWithBase64EncodedString:string options:(NSDataBase64DecodingIgnoreUnknownCharacters)];
//                    NSString *keyPath = [NSString stringWithFormat:@"%@/Documents/head.jpg",NSHomeDirectory()];
//                    [data writeToFile:keyPath atomically:YES];
                }
                else if ([node.name isEqualToString:@"title"] && [[node stringValue] isEqualToString:@"房间配置"])
                {
                    XMPPRoomHelper *helper = [XMPPRoomHelper sharedRoom];
                    [helper roomInfoWith:tmp];
                }
                
            }
            
        }
    }
    
    return YES;
}
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    DLog(@"didReceiveMessage: %@",message.description);
    
    NSXMLElement *request = [message elementForName:@"request"];
    if (request)
    {
        ///消息回执
        if ([request.xmlns isEqualToString:@"urn:xmpp:receipts"])
        {
            XMPPMessage *msg = [XMPPMessage messageWithType:[message attributeStringValueForName:@"type"] to:message.from elementID:[xmppStream generateUUID]];
            NSXMLElement *recieved = [NSXMLElement elementWithName:@"received" xmlns:@"urn:xmpp:receipts"];
            [recieved addAttributeWithName:@"id" stringValue:[message attributeStringValueForName:@"id"]];
            [msg addChild:recieved];
            //发送回执
            tmpMessage = message;
            [self.xmppStream sendElement:msg];
        }
    }
    ///如果消息是修改房间主题成功的消息
    if ([message isGroupChatMessageWithSubject])
    {
        XMPPHelper *helper = [XMPPHelper sharedHelper];
        [helper changeGroupChatRoomSubject:message];
    }
    ///如果是系统推送消息
    else
    {
        NSString *from = [message fromStr];
        if ([from isEqualToString:kSystemPush])
        {
            NSArray *array = [message children];
            DDXMLElement *subjectElement = [array objectAtIndex:1];
            NSString *subject = [subjectElement stringValue];
            DDXMLElement *contentElement = [array objectAtIndex:0];
            NSString *content = [contentElement stringValue];
            NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];

            NSMutableDictionary *retuDic = [NSMutableDictionary dictionary];
            [retuDic setObject:subject forKey:@"key"];
            [retuDic setObject:dict forKey:@"data"];
            [[NSNotificationCenter defaultCenter] postNotificationName:kPUSH object:retuDic];
        }
    }
}
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
    DLog(@"didReceivePresence: %@",presence.description);
//    dispatch_queue_t queue = dispatch_queue_create("suo", 0);
//    dispatch_async(queue, ^{
//        ///接收到加好友或者删除好友
//        XMPPRosterHelper *rosterHelper = [XMPPRosterHelper sharedHelper];
//        [rosterHelper receivePresence:presence fomStream:sender];
//    });
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        ///接收到加好友或者删除好友
//        XMPPRosterHelper *rosterHelper = [XMPPRosterHelper sharedHelper];
//        [rosterHelper receivePresence:presence fomStream:sender];
//    });

}
- (void)xmppStream:(XMPPStream *)sender didReceiveError:(NSXMLElement *)error
{
    DLog(@"didReceiveError: %@",error.description);
    
    if (error)
    {
        for (NSXMLNode *node in [error children])
        {
            if ([[node name] isEqualToString:@"conflict"])
            {
                //异地登录
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的账号可能在其他地方登录了,请检查密码是否被泄露,点击确认后将退出该软件" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                alert.tag = 8001;
                [alert show];
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"toPassWord"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [ToToolHelper changeLoginState];
                [[XMPPHelper sharedHelper] receiveResult:loginInOtherPlace];
            }
        }
    }
}
- (void)xmppStream:(XMPPStream *)sender didSendIQ:(XMPPIQ *)iq
{
    DLog(@"didSendIQ:%@",iq.description);
}
- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message
{
    DLog(@"didSendMessage:%@",message.description);
    NSXMLElement *received = [message elementForName:@"received"];
    if (received)
    {
        if ([received.xmlns isEqualToString:@"urn:xmpp:receipts"])//消息回执
        {
            //发送成功
            DLog(@"%@",tmpMessage);
            if ([tmpMessage isChatMessageWithBody] || [tmpMessage isGroupChatMessageWithBody])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"back" object:[tmpMessage body]];
                
                NSArray *array = [[RedViewHelper sharedHelper] searchRedViewFromJID:tmpMessage.from.user withType:[NSNumber numberWithInt:1]];
                if (array.count > 0)
                {
                    [[RedViewHelper sharedHelper] changeRedViewFromJID:tmpMessage.from.user withType:[NSNumber numberWithInt:1] andShow:YES];
                }
                else
                {
                    [[RedViewHelper sharedHelper] insertRedViewFromJID:tmpMessage.from.user withType:[NSNumber numberWithInt:1]];
                }
                
                //接收消息的地方
                XMPPHelper *helper = [XMPPHelper sharedHelper];
                [helper receiveMessageWithMessage:tmpMessage];
            }
        }
    }

}
- (void)xmppStream:(XMPPStream *)sender didSendPresence:(XMPPPresence *)presence
{
    DLog(@"didSendPresence:%@",presence.description);
}
- (void)xmppStream:(XMPPStream *)sender didFailToSendIQ:(XMPPIQ *)iq error:(NSError *)error
{
    DLog(@"didFailToSendIQ:%@",error.description);
}
- (void)xmppStream:(XMPPStream *)sender didFailToSendMessage:(XMPPMessage *)message error:(NSError *)error
{
    DLog(@"didFailToSendMessage:%@ withMessage:%@",error.description,message.description);
}
- (void)xmppStream:(XMPPStream *)sender didFailToSendPresence:(XMPPPresence *)presence error:(NSError *)error
{
    DLog(@"didFailToSendPresence:%@",error.description);
}
- (void)xmppStreamWasToldToDisconnect:(XMPPStream *)sender
{
    DLog(@"xmppStreamWasToldToDisconnect:退出登录");
    [heartTimer invalidate];
    heartTimer = nil;
    [[XMPPHelper sharedHelper] logOutWithResult];
}
- (void)xmppStreamConnectDidTimeout:(XMPPStream *)sender
{
    DLog(@"xmppStreamConnectDidTimeout");
}
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    if (error)
    {
        DLog(@"xmppStreamDidDisconnect: %@",error.description);
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[error localizedDescription] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"重试", nil];
//        [alert show];
        [self myConnect];
        [heartTimer invalidate];
        heartTimer = nil;
    }
}
#pragma mark xmppRoster
-(void)xmppRoster:(XMPPRoster *)sender didReceiveRosterItem:(DDXMLElement *)item
{
    NSString *jidStr = [item attributeStringValueForName:@"jid"];
    XMPPJID *jid = [XMPPJID jidWithString:jidStr];
    [xmppvCardTempModule fetchvCardTempForJID:jid ignoreStorage:YES];
    DLog(@"didReceiveRosterItem %@ and %@",sender,item.XMLString);
}
-(void)xmppRosterDidBeginPopulating:(XMPPRoster *)sender
{
    DLog(@"xmppRosterDidBeginPopulating %@",sender);
}
-(void)xmppRosterDidEndPopulating:(XMPPRoster *)sender
{
    DLog(@"xmppRosterDidEndPopulating %@",sender);
}
-(void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{
    DLog(@"%@",presence);
    NSString *type = [presence type];
    if ([type isEqualToString:@"subscribe"])
    {
        ///接收到加好友或者删除好友
        XMPPRosterHelper *rosterHelper = [XMPPRosterHelper sharedHelper];
        [rosterHelper receivePresence:presence fomStream:nil];
        [[RedViewHelper sharedHelper] insertRedViewFromJID:presence.from.user withType:[NSNumber numberWithInt:2]];
    }
}
-(void)xmppRoster:(XMPPRoster *)sender didReceiveRosterPush:(XMPPIQ *)iq
{
    DLog(@"%@",iq);
    
    DDXMLElement *element = [iq childElement];
    
    NSString *xmlns = [element xmlns];
    if ([xmlns isEqualToString:@"jabber:iq:roster"])
    {
        DDXMLElement *item = [[element children] firstObject];
        NSString *subscription = [item attributeStringValueForName:@"subscription"];
        if ([subscription isEqualToString:@"remove"] || [subscription isEqualToString:@"none"])
        {
            ///删除好友
            DLog(@"%@已经将您删除",[item attributeStringValueForName:@"jid"]);
            [[XMPPRosterHelper sharedHelper] friendDeleteYou:[item attributeStringValueForName:@"jid"]];
        }
        
    }
    
}
#pragma mark vcard的代理
- (void)xmppvCardTempModuleDidUpdateMyvCard:(XMPPvCardTempModule *)vCardTempModule
{
    DLog(@"%@",vCardTempModule.description);
    XMPPVCardHelper *helper = [XMPPVCardHelper sharedHelper];
    [helper changeSuccess:vCardTempModule];
    
}
-(void)xmppvCardTempModule:(XMPPvCardTempModule *)vCardTempModule didReceivevCardTemp:(XMPPvCardTemp *)vCardTemp forJID:(XMPPJID *)jid
{
    DLog(@"接收到vcard xmppvCardTempModuledidReceivevCardTemp and JID:%@",jid.description);
    
//    [[XMPPVCardHelper sharedHelper] updateFriendInfo:vCardTemp];
    
    [[XMPPVCardHelper sharedHelper] someBodyInfo:vCardTemp andJID:jid];
}
-(void)xmppvCardTempModule:(XMPPvCardTempModule *)vCardTempModule failedToUpdateMyvCard:(DDXMLElement *)error
{
    DLog(@"failedToUpdateMyvCard %@",error.description);
}
-(void)showAlertView:(NSString *)message{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    [alertView show];
}
#pragma mark UIAlertView
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 8001)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginInOtherPlace" object:nil];
    }
    else
    {
        if (buttonIndex == 1)
        {
            [self myConnect];
        }

    }
}
#pragma mark AUTO Ping
- (void)xmppAutoPingDidSendPing:(XMPPAutoPing *)sender
{
    DLog(@"%@",sender.targetJID.description);
}
- (void)xmppAutoPingDidReceivePong:(XMPPAutoPing *)sender
{
    DLog(@"%@",sender.targetJID.description);
}

- (void)xmppAutoPingDidTimeout:(XMPPAutoPing *)sender
{
    DLog(@"%@",sender.targetJID.description);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您可能已经与服务器断开连接(测试功能)" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark XMPPReconect
-(void)xmppReconnect:(XMPPReconnect *)sender didDetectAccidentalDisconnect:(SCNetworkConnectionFlags)connectionFlags
{
    DLog(@"%u",connectionFlags);
}
-(BOOL)xmppReconnect:(XMPPReconnect *)sender shouldAttemptAutoReconnect:(SCNetworkConnectionFlags)connectionFlags
{
    DLog(@"%d",connectionFlags);
    return YES;
}
#pragma mark 流量检测
-(void)byteSendAndReceive
{
    NSLog(@"发送的流量%llu和就受到的流量:%llu",self.xmppStream.numberOfBytesSent,self.xmppStream.numberOfBytesReceived);
}



@end
