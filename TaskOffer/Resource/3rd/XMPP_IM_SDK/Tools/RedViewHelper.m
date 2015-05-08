//
//  RedViewHelper.m
//  XMPPIM
//
//  Created by BourbonZ on 15/1/19.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "RedViewHelper.h"
#import "XMPPIM-Prefix.pch"
#import "AppDelegate.h"
static RedViewHelper *_helper;

@implementation RedViewHelper

@synthesize managedObjectContext=__managedObjectContext;//session

@synthesize managedObjectModel=__managedObjectModel;

@synthesize persistentStoreCoordinator=__persistentStoreCoordinator;

+(RedViewHelper *)sharedHelper
{
    @synchronized(self)
    {
        if (_helper == nil)
        {
            _helper = [[RedViewHelper alloc] init];
            [_helper saveContext];
        }
        return _helper;
    }
}



///创建数据库管理红点
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
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"RedView" withExtension:@"momd"];
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
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"RedViewHelper.sqlite"];
    
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



#pragma mark 对数据库的增删改查
///增加红点
-(void)insertRedViewFromJID:(NSString *)jid withType:(NSNumber *)type
{
    
    if (type.intValue == 2)
    {
        NSArray *array = [self searchRedViewFromJID:jid withType:type];
        if (array.count > 0)
        {
            [self deleteRedViewFromJID:jid withType:type];
        }
    }
    
    RedViewInfo *entity = (RedViewInfo *)[NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([RedViewInfo class]) inManagedObjectContext:self.managedObjectContext];
    [entity setShowRed:[NSNumber numberWithBool:YES]];
    [entity setBardJidStr:jid];
    [entity setStreamJidStr:kDefaultJID.user];
    [entity setType:type];
    
    NSError *error = nil;
    BOOL success = [self.managedObjectContext save:&error];
    if (!success)
    {
        DLog(@"保存红点数据失败:%@",error);
        return;
    }
    if ([jid isEqualToString:kDefaultJID.user])
    {
        return;
    }
    NSString *string = @"chat";
    if (type.intValue == 2)
    {
        string = @"addFriend";
    }
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"num" object:string];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        UITabBarController *tabbar = [app sharedTabbarController];
        UIViewController *viewcontroller = [[tabbar viewControllers] objectAtIndex:2];
        viewcontroller.tabBarItem.badgeValue = [self allRedViewWithType:[NSNumber numberWithInt:1]];
        
        UIViewController *friendListController = [[tabbar viewControllers] objectAtIndex:3];
        friendListController.tabBarItem.badgeValue = [self allRedViewWithType:[NSNumber numberWithInt:2]];
    });
    
}
///查找红点
-(NSArray *)searchRedViewFromJID:(NSString *)jid withType:(NSNumber *)type
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([RedViewInfo class]) inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    NSString *sql = [NSString stringWithFormat:@"bardJidStr = '%@' and streamJidStr = '%@' and type = %@",jid,kDefaultJID.user,type];
    if (jid == nil)
    {
        sql = [NSString stringWithFormat:@"streamJidStr = '%@' and type = %@ and showRed = %@",kDefaultJID.user,type,[NSNumber numberWithBool:YES]];
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:sql];
    [request setPredicate:predicate];
    NSError *error = nil;
    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
    return array;
}
///修改红点
-(void)changeRedViewFromJID:(NSString *)jid withType:(NSNumber *)type andShow:(BOOL)show
{
    NSArray *array = [self searchRedViewFromJID:jid withType:type];
    for (RedViewInfo *info in array)
    {
        [info setShowRed:[NSNumber numberWithBool:show]];
    }
    NSError *error = nil;
    BOOL success = [self.managedObjectContext save:&error];
    if (!success)
    {
        DLog(@"修改红点失败:%@",error);
    }
    if ([jid isEqualToString:kDefaultJID.user])
    {
        return;
    }
    if (show)
    {
        NSString *string = @"chat";
        if (type.intValue == 2)
        {
            string = @"addFriend";
        }
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"num" object:string];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        UITabBarController *tabbar = [app sharedTabbarController];
        UIViewController *viewcontroller = [[tabbar viewControllers] objectAtIndex:2];
        viewcontroller.tabBarItem.badgeValue = [self allRedViewWithType:[NSNumber numberWithInt:1]];
    });


}
///删除红点
-(void)deleteRedViewFromJID:(NSString *)jid withType:(NSNumber *)type
{
    NSArray *array = [self searchRedViewFromJID:jid withType:type];
    for (RedViewInfo *info in array)
    {
        [self.managedObjectContext deleteObject:info];
    }
    NSError *error = nil;
    BOOL success = [self.managedObjectContext save:&error];
    if (!success)
    {
        DLog("删除红点失败:%@",error);
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        UITabBarController *tabbar = [app sharedTabbarController];
        UIViewController *viewcontroller = [[tabbar viewControllers] objectAtIndex:2];
        viewcontroller.tabBarItem.badgeValue = [self allRedViewWithType:[NSNumber numberWithInt:1]];
    });
}
///选择所有红点
-(NSString *)allRedViewWithType:(NSNumber *)type
{
    NSArray *array = [self searchRedViewFromJID:nil withType:type];

    if (array.count == 0)
    {
        return nil;
    }
    else
    {
        return [NSString stringWithFormat:@"%lu",(unsigned long)array.count];
    }
}














@end
