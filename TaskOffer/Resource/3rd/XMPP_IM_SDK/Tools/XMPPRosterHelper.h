//
//  XMPPRosterHelper.h
//  XMPPIM
//
//  Created by BourbonZ on 14/12/25.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPHelper.h"
#import "XMPPDataHelper.h"
#import "ToolHelper.h"
#import "XMPPFriendInfo.h"
@protocol xmppRosertHelperDelegate <NSObject>

///对方接触跟自己的好友关系
-(void)friendCallOffRelationship;

@end


@interface XMPPRosterHelper : NSObject
{
    XMPPJID *tmpFriendJID;
    XMPPJID *tmpMyJID;
}

@property (nonatomic,weak) id <xmppRosertHelperDelegate>delegate;

+(XMPPRosterHelper *)sharedHelper;

///查询是否是注册好友
-(void)userIfExitsOnServer:(NSString *)userName;

///接收到roster 和 presence
-(void)receivePresence:(XMPPPresence *)presence fomStream:(XMPPStream *)stream;

///查询是否是好友
-(BOOL)checkIfFriend:(NSString *)userName;
///修改数据库中的昵称
-(void)changeNickForDatabase:(NSString *)nickName useID:(NSString *)userID;
///删除好友
-(void)removeFriendFromRoster:(XMPPJID *)jid;

///获取好友信息
-(XMPPFriendInfo *)friendInfomationWithUserName:(NSString *)userName;

///对好友信息的更改
-(void)changeFrienInfomationWithFriendName:(NSString *)friendName remarkName:(NSString *)remarkName;

///获取好友的名字
-(NSString *)remarkNameOrNickNameForFriend:(NSString *)friendName;

///对方把你删除
-(void)friendDeleteYou:(NSString *)friendJID;

@end
