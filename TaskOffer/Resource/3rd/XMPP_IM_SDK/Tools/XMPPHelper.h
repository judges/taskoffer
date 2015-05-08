//
//  XMPPHelper.h
//  rndIM
//
//  Created by BourbonZ on 14/12/3.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChartMessage.h"
#import "XMPPDataHelper.h"
#import "XMPPIM-Prefix.pch"
typedef enum {
    
    agreeFriend,
    rejectFriend
    
}friendRequestType;

typedef enum {
    ///链接
    conncetError,
    connectSuccess,
    ///注册
    registerError,
    registerSuccess,
    ///登录
    loginError,
    loginSuccess,
    ///异地登录
    loginInOtherPlace
    
}resultFromServer;

typedef enum {
    
    ///单聊
    singleChat,
    ///群聊
    groupChat
    
}chatType;


@protocol xmppDelegate <NSObject>

@optional
-(void)receiveFriendVcard:(UIImage *)icon;
///接收到单聊的消息
-(void)receiveSingleChatMessage:(ChartMessage *)message friendUserName:(XMPPJID *)friendName;
///接收到群聊的消息
-(void)receiveGroupChatMessage:(ChartMessage *)message friendUserName:(XMPPJID *)friendName;

///连接
-(void)connectToServerWithResult:(resultFromServer)result;
///登录
-(void)loginWithResult:(resultFromServer)result;
///注册
-(void)registerWithResult:(resultFromServer)result;
///异地登录
-(void)loginOnOtherPlaceWithResult:(resultFromServer)result;

///更改房间主题
-(void)receiveChangeGroupRoomSubject:(XMPPJID *)roomJid subject:(NSString *)subject;

///搜索结果
-(void)searchResultWithArray:(NSArray *)array andFriendJID:(XMPPJID *)jid;

///退出登录成功
-(void)logoutSuccess;

///刷新对话界面
-(void)refreshDialogueView;
@end

@interface XMPPHelper : NSObject<xmppDelegate>

@property (nonatomic,weak) id<xmppDelegate>delegate;

///获取单例
+(XMPPHelper *)sharedHelper;

///发送消息
+(void)sendMessage:(NSString *)name type:(NSString *)type message:(NSString *)message messageType:(NSString *)messageType duration:(NSNumber *)duration;

///接收消息
-(void)receiveMessageWithMessage:(XMPPMessage *)message;

///获取当前的所有好友或者好友请求
+(NSArray *)allMyFriendsWithState:(NSString *)state;

///检测信息是否完整
+(BOOL)allInformationReadyUserName:(NSString *)username passWord:(NSString *)password;

///连接服务器
+(void)connectToServer;

///返回XMPPStream对象
+(XMPPStream *)currentXMPPStream;

///登录事件
+(BOOL)loginWithJidWithUserName:(NSString *)username passWord:(NSString *)passWord;

///退出服务器
+(void)logOut;

///添加好友
+(void)addFriend:(NSString *)name withMessage:(NSString *)message;

///获取聊天信息
+(NSMutableArray *)allMessageWithFriendName:(NSString *)name;

///获取好友信息
+(void)getFriendInfo:(NSString *)name;

///同意或拒绝好友请求
+(void)agreeOrRefuseFriendRequest:(NSString *)username type:(friendRequestType)type;

///向数据库中添加好友请求信息
+(void)addFriendRequestToDbFriendJid:(XMPPJID *)friendJid myJid:(XMPPJID *)myJid;

///从数据库中查找数据
-(void)searchDataFromDB:(XMPPJID *)friendJID;

///接收到链接、注册、登录、异地登录的返回结果
-(void)receiveResult:(resultFromServer)result;

///房间更改主题成功
-(void)changeGroupChatRoomSubject:(XMPPMessage *)message;

///退出登录成功
-(void)logOutWithResult;

///删除与某人的消息记录
/**
 
 @param 好友的用户名，不包含jid的domain.
 
 @param 需要删除的数据，如果是全部则messages为nil
 
 */
-(NSError *)deleteAllMessageWithFriend:(NSString *)username andMessages:(NSArray *)messages;

///删除最近联系人
/**
 
 @param 需要删除的最近联系记录,如果是清空，则数据位nil
 
 */
-(NSError *)deleteRecentPeople:(NSArray *)peopleArray;

///删除部分聊天记录
-(void)deleteSomeChatMessages:(NSArray *)messagesID messageType:(chatType)chatType friendName:(NSString *)friendName;

///搜索所有类似的消息
-(NSArray *)searchAllLikeMessage:(NSString *)key withJID:(NSString *)bareJIDUser type:(chatType)type;

///获取某种类型的全部消息
-(NSArray *)selectAllSomeModelMessageWithWho:(NSString *)name andChatType:(chatType)chatType andMessageType:(NSString *)messageType;

///刷新对话界面
-(void)reloadChatView;
@end
