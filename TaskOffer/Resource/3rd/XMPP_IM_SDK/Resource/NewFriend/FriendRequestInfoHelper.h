//
//  FriendRequestInfoHelper.h
//  XMPPIM
//
//  Created by BourbonZ on 15/1/20.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FriendRequestInfo.h"
@interface FriendRequestInfoHelper : NSObject

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+(FriendRequestInfoHelper *)shared;

///add
-(void)addFriendRequest:(NSString *)friendJID andMessage:(NSString *)message;
///delete
-(void)deleteFriendRequest:(NSString *)friendJID;
///change
-(void)changeFriendRequest:(NSString *)friendJID type:(NSString *)type;
///select
-(NSArray *)selectAllFriendRequestWithFriendJID:(NSString *)friendJID;
@end
