//
//  GroupChatViewController.h
//  XMPPIM
//
//  Created by BourbonZ on 14/12/17.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import "ChatCoreController.h"
#import "XMPPRoomMemberInfo.h"
#import "FriendInfoController.h"
@interface GroupChatViewController : ChatCoreController

@property (nonatomic,strong) XMPPJID *roomJID;
@property (nonatomic,strong) XMPPFriendInfo *currentUser;
///设置群的详细信息
@property (nonatomic,weak) NSArray *infoArray;

@end
