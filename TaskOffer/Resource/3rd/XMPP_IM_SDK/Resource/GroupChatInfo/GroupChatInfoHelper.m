//
//  GroupChatInfoHelper.m
//  XMPPIM
//
//  Created by BourbonZ on 15/1/6.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "GroupChatInfoHelper.h"
#import "XMPPIM-Prefix.pch"
static GroupChatInfoHelper *_helper;
@implementation GroupChatInfoHelper
@synthesize managedObjectContext=__managedObjectContext;//session

@synthesize managedObjectModel=__managedObjectModel;

@synthesize persistentStoreCoordinator=__persistentStoreCoordinator;

+(GroupChatInfoHelper *)shared
{
    @synchronized(self)
    {
        if (_helper == nil)
        {
            _helper = [[GroupChatInfoHelper alloc] init];
        }
        return _helper;
    }
}

//相当与持久化方法
- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
//初始化context对象
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
//这里的URLForResource:@"lich" 的url名字（lich）要和你建立datamodel时候取的名字是一样的，至于怎么建datamodel很多教程讲的很清楚
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"GroupChatInfo" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}
/**
  Returns the persistent store coordinator for the application.
  If the coordinator doesn't already exist, it is created and the application's store added to it.
  */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    //这个地方的lich.sqlite名字没有限制，就是一个数据库文件的名字
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"GroupChatInfo.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark 数据库的增删改查
-(void)addGroupChat:(NSString *)groupChat subject:(NSString *)subject
{
    NSManagedObjectContext *context = [self managedObjectContext];
    GroupChatInfo *info = (GroupChatInfo *)[NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([GroupChatInfo class]) inManagedObjectContext:context];
    [info setGroupChatID:groupChat];
    [info setGroupChatSubject:subject];

    NSError *error = nil;
    BOOL saveSuccess = [context save:&error];
    if (!saveSuccess)
    {
        DLog(@"存储到数据库失败");
    }
}
-(NSString *)searchGroupChatInfo:(NSString *)groupChat
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([GroupChatInfo class]) inManagedObjectContext:context];
    [request setEntity:entity];
    NSString *sql = [NSString stringWithFormat:@"groupChatID like '%@*'",groupChat];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:sql];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *array = [context executeFetchRequest:request error:&error];
    GroupChatInfo *info = [array firstObject];
    NSString *subject = info.groupChatSubject;
    return subject;
}
-(void)changeGroupChat:(NSString *)groupChat subject:(NSString *)subject
{
    
    NSString *tmp = [self searchGroupChatInfo:groupChat];
    if (tmp.length == 0)
    {
        [self addGroupChat:groupChat subject:subject];
        return;
    }
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSEntityDescription *info = [NSEntityDescription entityForName:NSStringFromClass([GroupChatInfo class]) inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:info];
    
    NSString *sql = [NSString stringWithFormat:@"groupChatID == '%@'",groupChat];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:sql];
    [request setPredicate:predicate];

    NSError *error = nil;

    NSArray *array = [context executeFetchRequest:request error:&error];
    for (GroupChatInfo *info in array)
    {
        [info setGroupChatID:groupChat];
        [info setGroupChatSubject:subject];
    }
    
    BOOL success = [context save:&error];
    if (!success)
    {
        DLog(@"更改群主题失败:%@",error);
    }
}
@end
