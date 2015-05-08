//
//  SLTaskHandler.m
//  TaskOffer
//
//  Created by wshaolin on 15/4/3.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLTaskHandler.h"
#import "XMPPRosterHelper.h"
#import "XMPPHelper.h"

@implementation SLTaskHandler

+ (BOOL)validateIsFriendWithUserID:(NSString *)userID{
    return [[XMPPRosterHelper sharedHelper] checkIfFriend:userID];
}

+ (void)addFriendWithUserID:(NSString *)userID andSendRequestContent:(NSString *)requestContent{
    [XMPPHelper addFriend:userID withMessage:requestContent];
}

+ (void)removeFriendWithUserID:(NSString *)userID{
    XMPPJID *jid = [XMPPJID jidWithUser:userID domain:kDOMAIN resource:nil];
    [[XMPPRosterHelper sharedHelper] removeFriendFromRoster:jid];
}

@end
