//
//  XMPPRosterHelper.m
//  XMPPIM
//
//  Created by BourbonZ on 14/12/25.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import "XMPPRosterHelper.h"
#import "XMPPFriendInfo.h"
#import "FriendRequestInfoHelper.h"
static XMPPRosterHelper *_helper;

@interface XMPPRosterHelper()<xmppDelegate>

@end

@implementation XMPPRosterHelper

+(XMPPRosterHelper *)sharedHelper
{
    @synchronized(self)
    {
        if (_helper == nil)
        {
            _helper = [[XMPPRosterHelper alloc] init];
        }
        return _helper;
    }
}

///查询是否是注册好友
-(void)userIfExitsOnServer:(NSString *)userName
{
#warning 检测用户是否注册
    XMPPJID *jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"search.%@",kDOMAIN]];
    XMPPIQ *iq = [XMPPIQ iqWithType:@"set" to:jid];
    [iq addAttributeWithName:[ToolHelper deviceUUID] stringValue:@"id"];
    DDXMLElement *query = [DDXMLElement elementWithName:@"query" xmlns:@"jabber:iq:search"];
    DDXMLElement *x = [DDXMLElement elementWithName:@"x" xmlns:@"jabber:x:data"];
    [x addAttributeWithName:@"type" stringValue:@"submit"];
    
    DDXMLElement *field = [DDXMLElement elementWithName:@"field"];
    [field addAttributeWithName:@"var" stringValue:@"search"];
    [field addAttributeWithName:@"type" stringValue:@"text-single"];
    
    DDXMLNode *node = [DDXMLNode elementWithName:@"value" stringValue:userName];

    [field addChild:node];
    [x addChild:field];
    [query addChild:x];
    [iq addChild:query];
    
    [[[XMPPDataHelper shareHelper] xmppStream] sendElement:iq];

}

///接收到roster 和 presence
-(void)receivePresence:(XMPPPresence *)presence fomStream:(XMPPStream *)stream
{
    dispatch_queue_t queue = dispatch_queue_create("queue", 0);
    dispatch_async(queue, ^{
        NSString *type = [presence type];
        NSString *friendJidStr = [presence fromStr];
        NSString *myJidStr = [presence toStr];
        
        XMPPJID *friendJid = [XMPPJID jidWithString:friendJidStr];
        XMPPJID *myJid = [XMPPJID jidWithString:myJidStr];
        
        tmpFriendJID = friendJid;
        tmpMyJID = myJid;
        
        if ([type isEqualToString:@"subscribe"])
        {
            DLog(@"收到了一个请求:%@",presence);
//            XMPPHelper *helper = [XMPPHelper sharedHelper];
//            [helper setDelegate:self];
//            [helper searchDataFromDB:friendJid];
            NSString *message = [[[presence childAtIndex:0] childAtIndex:0] stringValue];
            if (message == nil)
            {
                message = @"";
            }
            [[FriendRequestInfoHelper shared] addFriendRequest:presence.from.user andMessage:message];
            
        }
        else if ([type isEqualToString:@"unavailable"])
        {
            ///对方删除好友
            DLog(@"对方删除好友:%@",presence);
        }
        else if ([type isEqualToString:@"available"])
        {
            ///接收到的消息不包含type值，可能为其他消息
            DDXMLElement *element = [[presence children] firstObject];
            if ([element.xmlns isEqualToString:@"vcard-temp:x:update"])
            {
                DLog(@"开始查找:%@",presence);
//                XMPPVCardHelper *vCardHelper = [XMPPVCardHelper sharedHelper];
//                [vCardHelper fetchSomeBodyInfo:presence.from.user];
            }
        }
        
    });
}
///删除好友
-(void)removeFriendFromRoster:(XMPPJID *)jid
{
    ///删除联系人
    [[[XMPPDataHelper shareHelper] xmppRoster] removeUser:jid];
    ///删除与其的聊天记录
     [[XMPPHelper sharedHelper] deleteAllMessageWithFriend:jid.user andMessages:nil];
    ///删除最近联系人
    [[XMPPHelper sharedHelper] deleteRecentPeople:@[jid.user]];    
}

///获取好友信息
-(XMPPFriendInfo *)friendInfomationWithUserName:(NSString *)userName
{
    NSManagedObjectContext *context = [[[XMPPDataHelper shareHelper] xmppRosterStorage] mainThreadManagedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([XMPPUserCoreDataStorageObject class]) inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSString *sql = [NSString stringWithFormat:@"jidStr like '%@*' and streamBareJidStr = '%@@%@'",[userName stringByAppendingFormat:@"@%@",kDOMAIN],kDefaultJID.user,kDOMAIN];
    request.predicate = [NSPredicate predicateWithFormat:sql];
    [request setEntity:entity];
    NSError *error = nil;
    NSArray *array = [context executeFetchRequest:request error:&error];
    XMPPFriendInfo *object = (XMPPFriendInfo *)[array firstObject];
    return object;
}

///更改好友的备注
-(void)changeFrienInfomationWithFriendName:(NSString *)friendName remarkName:(NSString *)remarkName
{
    XMPPJID *jid = [XMPPJID jidWithUser:friendName domain:kDOMAIN resource:kRESOURCE];
    [[[XMPPDataHelper shareHelper] xmppRoster] setNickname:remarkName forUser:jid];
}

///返回结果
-(void)searchResultWithArray:(NSArray *)array andFriendJID:(XMPPJID *)jid
{
    if (array.count == 0)
    {
        ///接受好友的代码
        [XMPPHelper addFriendRequestToDbFriendJid:jid myJid:tmpMyJID];
    }
}
///修改数据库中的昵称
-(void)changeNickForDatabase:(NSString *)nickName useID:(NSString *)userID
{
    NSManagedObjectContext *context = [[[XMPPDataHelper shareHelper] xmppRosterStorage] mainThreadManagedObjectContext];
    NSEntityDescription *object = [NSEntityDescription entityForName:NSStringFromClass([XMPPUserCoreDataStorageObject class]) inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:object];
    NSString *sql = [NSString stringWithFormat:@"jidStr like '%@@%@*' and streamBareJidStr like '%@@%@*'",userID,kDOMAIN,kDefaultJID.user,kDOMAIN];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:sql];
    [request setPredicate:predicate];
    
    NSArray *array = [context executeFetchRequest:request error:nil];
    
    for (XMPPUserCoreDataStorageObject *tmp in array)
    {
        [tmp setNickname:nickName];
    }
    [context save:nil];
    
}
///获取好友的备注或名称
-(NSString *)remarkNameOrNickNameForFriend:(NSString *)friendName
{
    NSString *tmpStr = [@"@" stringByAppendingString:kDOMAIN];
    if ([friendName isEqualToString:kDefaultJID.user])
    {
        //自己的昵称
        NSString *nick = [[XMPPVCardHelper sharedHelper] myInfo].nickname;
        if (nick.length == 0)
        {
            return friendName;
        }
        return nick;
    }
    else
    {
        ///备注
        NSString *remark = [self friendInfomationWithUserName:friendName].nickname;
        if (remark.length == 0)
        {
            ///昵称
            NSString *nick = [[XMPPVCardHelper sharedHelper] friendVcardWithName:friendName].nickname;
            if (nick.length == 0)
            {
                return friendName;
            }
            return nick;
        }
        if ([remark rangeOfString:tmpStr].location != NSNotFound)
        {
            remark = [remark substringToIndex:[remark rangeOfString:tmpStr].location];
        }
        
        return remark;
    }
}
///对方把你删除
-(void)friendDeleteYou:(NSString *)friendJID
{
    NSString *string = friendJID;
    if ([string rangeOfString:kDOMAIN].location != NSNotFound)
    {
        string = [string stringByReplacingOccurrencesOfString:@"@imserver" withString:@""];
    }
    [[FriendRequestInfoHelper shared] deleteFriendRequest:string];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSManagedObjectContext *context = [[[XMPPDataHelper shareHelper] xmppRosterStorage] mainThreadManagedObjectContext];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([XMPPUserCoreDataStorageObject class]) inManagedObjectContext:context];
        [request setEntity:entity];
        
        NSString *sql = [NSString stringWithFormat:@"streamBareJidStr like '%@@%@*' and jidStr like '%@*'",kDefaultJID.user,kDefaultJID.domain,friendJID];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:sql];
        [request setPredicate:predicate];
        
        NSError *error = nil;
        NSMutableArray *array = [[context executeFetchRequest:request error:&error] mutableCopy];
        for (XMPPUserCoreDataStorageObject *object in array)
        {
            [context deleteObject:object];
        }
        if (error)
        {
            DLog(@"删除数据失败:%@",error);
            return;
        }
        DLog(@"删除数据成功");
        
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(friendCallOffRelationship)])
        {
            [self.delegate friendCallOffRelationship];
        }
        
        
        
    });
}


///查询是否是好友
-(BOOL)checkIfFriend:(NSString *)userName
{
    BOOL isNotFriend = NO;
    NSManagedObjectContext *context = [[[XMPPDataHelper shareHelper] xmppRosterStorage] mainThreadManagedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPUserCoreDataStorageObject" inManagedObjectContext:context];
    [request setEntity:entity];
    NSString *sql = [NSString stringWithFormat:@"jidStr = '%@@%@' and subscription = 'both'",userName,kDOMAIN];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:sql];
    [request setPredicate:predicate];
    NSError *error = nil;
    NSArray *array = [context executeFetchRequest:request error:&error];
    if (array.count == 0)
    {
        DLog(@"不是好友;%@",error);
        return isNotFriend;
    }
    DLog(@"是好友");
    return !isNotFriend;
}
@end
