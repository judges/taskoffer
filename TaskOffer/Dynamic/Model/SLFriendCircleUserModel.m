//
//  SLFriendCircleUserModel.m
//  XMPPIM
//
//  Created by wshaolin on 15/1/9.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLFriendCircleUserModel.h"
#import "UserInfo.h"

@implementation SLFriendCircleUserModel

+ (instancetype)modelWithUsername:(NSString *)username displayName:(NSString *)displayName iconURL:(NSString *)iconURL{
    return [[self alloc] initWithUsername:username displayName:displayName iconURL:iconURL];
}

- (instancetype)initWithUsername:(NSString *)username displayName:(NSString *)displayName iconURL:(NSString *)iconURL{
    if(self = [super init]){
        _username = username;
        _displayName = displayName;
        _iconURL = iconURL;
        _isCurrentUser = [_username isEqualToString:[UserInfo sharedInfo].userID];
        
        if(_displayName == nil){
            _displayName = @"";
        }
    }
    return self;
}

@end
