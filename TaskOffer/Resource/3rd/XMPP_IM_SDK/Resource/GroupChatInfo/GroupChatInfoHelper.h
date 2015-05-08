//
//  GroupChatInfoHelper.h
//  XMPPIM
//
//  Created by BourbonZ on 15/1/6.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GroupChatInfo.h"
@interface GroupChatInfoHelper : NSObject

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+(GroupChatInfoHelper *)shared;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

///增加群信息
-(void)addGroupChat:(NSString *)groupChat subject:(NSString *)subject;

///查找群信息
-(NSString *)searchGroupChatInfo:(NSString *)groupChat;

///更改群信息
-(void)changeGroupChat:(NSString *)groupChat subject:(NSString *)subject;
@end
