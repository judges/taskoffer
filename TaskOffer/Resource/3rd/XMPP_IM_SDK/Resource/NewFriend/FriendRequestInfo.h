//
//  FriendRequestInfo.h
//  XMPPIM
//
//  Created by BourbonZ on 15/1/20.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#define kAgree   @"agree"
#define kReject  @"reject"
#define kRequest @"request"

@interface FriendRequestInfo : NSManagedObject

@property (nonatomic, retain) NSString * streamJID;
@property (nonatomic, retain) NSString * requestJID;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * body;
@end
