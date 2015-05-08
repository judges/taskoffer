//
//  SLTaskHandler.h
//  TaskOffer
//
//  Created by wshaolin on 15/4/3.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLTaskHandler : NSObject

// 校验用户是否好友
+ (BOOL)validateIsFriendWithUserID:(NSString *)userID;

// 发送添加好友的请求
+ (void)addFriendWithUserID:(NSString *)userID andSendRequestContent:(NSString *)requestContent;

// 删除好友
+ (void)removeFriendWithUserID:(NSString *)userID;

@end
