//
//  RedViewHelper.h
//  XMPPIM
//
//  Created by BourbonZ on 15/1/19.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//
#import "RedViewInfo.h"
#import <Foundation/Foundation.h>

@interface RedViewHelper : NSObject

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+(RedViewHelper *)sharedHelper;
- (void)saveContext;


///增加红点
-(void)insertRedViewFromJID:(NSString *)jid withType:(NSNumber *)type;
///查找红点
-(NSArray *)searchRedViewFromJID:(NSString *)jid withType:(NSNumber *)type;
///修改红点
-(void)changeRedViewFromJID:(NSString *)jid withType:(NSNumber *)type andShow:(BOOL)show;
///删除红点
-(void)deleteRedViewFromJID:(NSString *)jid withType:(NSNumber *)type;
///选择所有红点
-(NSString *)allRedViewWithType:(NSNumber *)type;
@end
