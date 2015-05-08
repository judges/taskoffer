//
//  XMPPDataHelper.h
//  XMPPIM
//
//  Created by BourbonZ on 14/12/25.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPRoomHelper.h"
#import "XMPPRosterHelper.h"
#import "XMPPHelper.h"
#import "XMPPVCardHelper.h"
#import "GroupChatInfoHelper.h"
#import "XMPPReconnect.h"
#import "XMPPRoster.h"
#import "XMPPRosterCoreDataStorage.h"
#import "XMPPMessageArchiving.h"
#import "XMPPMessageArchivingCoreDataStorage.h"
#import "XMPPvCardCoreDataStorage.h"
#import "XMPPvCardTempModule.h"
#import "XMPPRoomCoreDataStorage.h"
#import "XMPPAutoPing.h"
#import "XMPPNetReachHelper.h"

@protocol XMPPDataHelperDelegate <NSObject>

@optional
-(void)allGroupMember:(NSArray *)array;

@end
@interface XMPPDataHelper : NSObject<XMPPStreamDelegate,XMPPRosterDelegate,XMPPvCardTempModuleDelegate,XMPPAutoPingDelegate,XMPPAutoPingDelegate,XMPPReconnectDelegate,UIAlertViewDelegate>
{
    XMPPStream *xmppStream;
    XMPPReconnect *xmppReconnect;
    
    XMPPRoster *xmppRoster;
    XMPPRosterCoreDataStorage *xmppRosterStorage;
   
    XMPPMessageArchivingCoreDataStorage *xmppMessageArchivingCoreDataStorage;
    XMPPMessageArchiving *xmppMessageArchivingModule;
    
    XMPPvCardCoreDataStorage *xmppvCardStorage;
    XMPPvCardTempModule *xmppvCardTempModule;
    XMPPvCardAvatarModule *xmppvCardAvatarModule;
    
    XMPPRoom *xmppRoom;
    XMPPRoomCoreDataStorage *xmppRoomStorage;
    
    XMPPAutoPing *autoPing;
    
    XMPPMessage *tmpMessage;

}

@property (nonatomic, strong) XMPPStream *xmppStream;
@property (nonatomic) BOOL isRegistration;
@property (nonatomic,strong) XMPPRosterCoreDataStorage *xmppRosterStorage;
@property (nonatomic,strong) XMPPRoster *xmppRoster;
@property (nonatomic,strong) XMPPMessageArchivingCoreDataStorage *xmppMessageArchivingCoreDataStorage;
@property (nonatomic,strong) XMPPMessageArchiving *xmppMessageArchivingModule;
@property (nonatomic,strong) XMPPvCardCoreDataStorage *xmppvCardStorage;
@property (nonatomic,strong) XMPPvCardTempModule *xmppvCardTempModule;
@property (nonatomic,strong) XMPPvCardAvatarModule *xmppvCardAvatarModule;
@property (nonatomic,strong) XMPPRoom *xmppRoom;
@property (nonatomic,strong) XMPPRoomCoreDataStorage *xmppRoomStorage;


@property (nonatomic,strong) XMPPAutoPing *autoPing;

@property (nonatomic,weak) id <XMPPDataHelperDelegate>delegate;

@property (nonatomic,strong) NSTimer *heartTimer;

+(XMPPDataHelper *)shareHelper;
///初始化流
- (void)setupStream;

///注册
-(void)registerWithUserName:(NSString *)username andPassWord:(NSString *)password;

- (BOOL)myConnect;

@end
