//
//  XMPPRoomHelper.h
//  XMPPIM
//
//  Created by BourbonZ on 14/12/17.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChartMessage.h"
#import "XMPPDataHelper.h"
#import "XMPPRoomMemberInfo.h"
#import "XMPPIM-Prefix.pch"
#import "XMPPMUC.h"
@protocol XMPPRoomHelperDelegate <NSObject>

@optional
///加入聊天室成功
-(void)joinRoomSuccess:(XMPPRoom *)room;

///查找群成功或失败
-(void)searchRoomSuccess:(XMPPRoom *)room;

///获取到的群的详细信息
-(void)getRoomInfo:(NSArray *)array;

///退出群聊成功
-(void)leaveRoomSuccess:(XMPPRoom *)room;

///接收到群聊的信息
-(void)receiveGroupChatRoom:(XMPPRoom *)sender withMessage:(ChartMessage *)message occupantJID:(XMPPJID *)occupantJID;

///获取群的所有消息的代理
-(void)allGroupMessage:(NSMutableArray *)messageArray;

///获取群设置
-(void)groupChatRoomInfo:(XMPPRoom *)room;

///所有我加入的群
-(void)allMyJoinRoomWithResult:(NSArray *)array;
@end

@interface XMPPRoomHelper : NSObject<XMPPRoomDelegate,XMPPRoomStorage,XMPPMUCDelegate>

@property (nonatomic,weak) id <XMPPRoomHelperDelegate>delegate;


///创建聊天室单例
+(XMPPRoomHelper *)sharedRoom;

///创建聊天室
-(void)createChatRoomWithName:(NSString *)chatRoomName withNickName:(NSString *)nickName;

///聊天数据库
///选择我创建的聊天室
-(NSMutableArray *)allMyCreateChatRoom;

///发送群消息
-(void)sendGroupMessageToName:(NSString *)name withMessage:(NSString *)message messageType:(NSString *)messageType duration:(NSNumber *)duration;

///查找群
-(XMPPRoomMemberInfo *)searchGroupWithName:(NSString *)groupName;

///加入群
-(void)joinGroupWithName:(NSString *)groupName withNickName:(NSString *)nickName;

///离开房间
-(void)leaveRoom:(XMPPJID *)roomJID;

///邀请好友
-(void)inviteFriendToJoinGroup:(XMPPJID *)friendName withGroupName:(NSString *)groupName withMessage:(NSString *)message andRoom:(XMPPRoom *)room;

///获取已经存在的群
-(void)getAllExitsRoom;

///获取我加入的群
-(void)getAllMyExitsRoom;

///获得我加入的群
-(void)allMyJoinRoom:(NSArray *)array;

///获取到的群的详细信息
-(void)roomInfoWith:(NSArray *)array;

///开始获取群的详细信息
-(void)startToGetRoomInfo:(XMPPJID *)roomJID;

///获取全部聊天内容
-(void)allGroupChatMessageWithGroupName:(NSString *)name;

///房间JID
-(XMPPJID *)roomJIDWithName:(NSString *)chatRoomName;

///获取群的人员
-(void)allMemberForRoom:(XMPPRoom *)room;

///更改群主题
-(void)changeGroupChatRoom:(XMPPJID *)roomJID subject:(NSString *)subject;

#pragma 私有方法
-(NSMutableArray *)_allGroupChatMessage:(NSString *)name;
@end
