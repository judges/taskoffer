//
//  XMPPVCardHelper.h
//  XMPPIM
//
//  Created by BourbonZ on 14/12/30.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPUserInfo.h"
#import "XMPPFriendInfo.h"
#import "XMPPvCardTempModule.h"
#import "XMPPvCardInfo.h"

#define kNickName @"NICKNAME"
#define kAdr    @"ADR"
#define kNote   @"NOTE"
#define kEmail  @"EMAIL"
#define kDesc   @"DESC"
#define kTel    @"TEL"


@protocol xmppVcardHelperDelegate <NSObject>

@optional
///个人信息更改成功
-(void)myInfoChangeSuccess:(XMPPUserInfo *)temp;
///成功获取某人的详细信息,并且忽略数据库
-(void)fetchSuccessInfo:(XMPPUserInfo *)info andJID:(XMPPJID *)jid;
@end

@interface XMPPVCardHelper : NSObject

@property (nonatomic,weak) id <xmppVcardHelperDelegate>delegate;

+(XMPPVCardHelper *)sharedHelper;

///获取个人信息
-(XMPPUserInfo *)myInfo;

///获取某人的个人信息
-(XMPPvCardTemp *)friendVcardWithName:(NSString *)friendName;

/////在线更新某人的信息
//-(void)updateFriendInfo:(XMPPvCardTemp *)temp;

///修改头像
-(void)changeMyIcon:(UIImage *)icon;
///修改个人成功
-(void)changeSuccess:(XMPPvCardTempModule *)module;

///从数据库中查找某人信息
-(XMPPvCardInfo *)searchFriendFromDB:(NSString *)friendName;

///修改名字
-(void)changeMyVcard:(NSString *)value byType:(NSString *)type;

///查找某人的详细信息
-(void)fetchSomeBodyInfo:(NSString *)userName;
///成功获取某人的详细信息
-(void)someBodyInfo:(XMPPvCardTemp *)temp andJID:(XMPPJID *)jid;

@end
