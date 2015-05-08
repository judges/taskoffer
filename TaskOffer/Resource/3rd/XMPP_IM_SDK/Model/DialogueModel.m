//
//  DialogueModel.m
//  XMPPIM
//
//  Created by BourbonZ on 14/12/26.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import "DialogueModel.h"
#import "XMPPIM-Prefix.pch"
#import "XMPPDataHelper.h"
@implementation DialogueModel

@dynamic iconStr;
@dynamic contentStr;
@dynamic nameStr;
@dynamic timeStr;
@dynamic hasRed;
@dynamic myJidStr;
@dynamic otherJidStr;

+(void)checkIfHaveInDialogue:(NSString *)name content:(NSString *)content isGroupChat:(BOOL)groupChat
{
    if (groupChat)
    {
        name = name;
    }
    
//    NSFetchRequest *request = [[NSFetchRequest alloc] init];
//    NSEntityDescription *dialogue = [NSEntityDescription entityForName:NSStringFromClass([DialogueModel class]) inManagedObjectContext:app.managedObjectContext];
//    [request setEntity:dialogue];
//    NSString *myJidStr    = [NSString stringWithFormat:@"%@@%@",kDefaultJID.user,kDefaultJID.domain];
//    NSString *otherJidStr = [NSString stringWithFormat:@"%@@%@",name,kDOMAIN];
//    NSString *sql = [NSString stringWithFormat:@"myJidStr like '%@*' and otherJidStr like '%@*'",myJidStr,otherJidStr];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:sql];
//    [request setPredicate:predicate];
//    NSError *error = nil;
//    NSMutableArray *dialogueArray = [[app.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
//    
//    if (dialogueArray.count != 0)
//    {
//        for (DialogueModel *model in dialogueArray)
//        {
//            [app.managedObjectContext deleteObject:model];
//        }
//    }
//    DialogueModel *model = (DialogueModel *)[NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([DialogueModel class]) inManagedObjectContext:app.managedObjectContext];
//    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:content]])
//    {
//        if ([content rangeOfString:@".amr"].location != NSNotFound)
//        {
//            content = @"[语音]";
//        }
//        else if ([content rangeOfString:@".jpg"].location != NSNotFound)
//        {
//            content = @"[图片]";
//        }
//        else
//        {
//            content = content;
//        }
//    }
//    [model setContentStr:content];
//    [model setNameStr:name];
//    
//    NSString *str = [NSString stringWithFormat:@"%f",[NSDate timeIntervalSinceReferenceDate]];
//
//    [model setTimeStr:str];
//    [model setHasRed:[NSNumber numberWithBool:YES]];
//    [model setMyJidStr:[kDefaultJID.user stringByAppendingFormat:@"@%@",kDefaultJID.domain]];
//    [model setOtherJidStr:[name stringByAppendingFormat:@"@%@",kDOMAIN]];
//    [app.managedObjectContext save:nil];
}

+(NSMutableArray *)allDialogue
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = [[[XMPPDataHelper shareHelper] xmppMessageArchivingCoreDataStorage] mainThreadManagedObjectContext];
    NSEntityDescription *description = [NSEntityDescription entityForName:NSStringFromClass([XMPPMessageArchiving_Contact_CoreDataObject class]) inManagedObjectContext:context];
    [request setEntity:description];
    NSString *sql = [NSString stringWithFormat:@"streamBareJidStr like '%@*' and bareJidStr <> 'admin@%@'",[kDefaultJID.user stringByAppendingFormat:@"@%@",kDOMAIN],kDOMAIN];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:sql];
    [request setPredicate:predicate];
    [request setReturnsObjectsAsFaults:NO];
    NSError *error = nil;
    NSArray *tmpArray = [context executeFetchRequest:request error:&error];
    if (error)
    {
        NSLog(@"%@",error.description);
    }
    NSMutableArray *returnArray = [NSMutableArray arrayWithArray:tmpArray];
    for (XMPPMessageArchiving_Contact_CoreDataObject *object in tmpArray)
    {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[object.mostRecentMessageBody dataUsingEncoding:NSUTF8StringEncoding] options:(NSJSONReadingMutableLeaves) error:nil];
        if (dict != nil && [dict objectForKey:@"itemID"] == nil)
        {
            [returnArray removeObject:object];
        }
    }
    
    return returnArray;
}

@end
