//
//  ProjectDialogueDataBaseHelper.m
//  TaskOffer
//
//  Created by BourbonZ on 15/4/10.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "ProjectDialogueDataBaseHelper.h"
#import "FMDB.h"
static ProjectDialogueDataBaseHelper *helper = nil;
static FMDatabase *projectInfoDatabase;
@implementation ProjectDialogueDataBaseHelper

+(ProjectDialogueDataBaseHelper *)sharedHelper
{
    if (helper == nil)
    {
        helper = [[ProjectDialogueDataBaseHelper alloc] init];
    }
    return helper;
}

-(void)createDatabase
{
    NSString *string = [NSString stringWithFormat:@"%@/Documents/projectinfo.sqlite",NSHomeDirectory()];

    projectInfoDatabase = [FMDatabase databaseWithPath:string];
    
    [projectInfoDatabase open];
    if ([[NSFileManager defaultManager] fileExistsAtPath:string])
    {
        [projectInfoDatabase executeUpdate:@"create table if not exists projectinfo(id integer primary key autoincrement,projectID text,projectName text,projectIconPath text,projectTime text,projectCreater text,projectCreaterID text);"];
        [projectInfoDatabase executeUpdate:@"create table if not exists projectdialogue(id integer primary key autoincrement,projectID text,messageSender text ,messageReceiver text,messageTime text);"];
    }
    [projectInfoDatabase close];
}

//--------------------------------------项目的数据操作--------------------------------------//
-(void)addProjectInfo:(ProjectDialogueInfo *)info
{
    NSString *insertSql = [NSString stringWithFormat:@"insert into projectinfo(projectID,projectName,projectIconPath,projectTime,projectCreater,projectCreaterID)values('%@','%@','%@','%@','%@','%@');",info.projectID,info.projectName,info.projectIconPath,info.projectTime,info.projectCreater,info.projectCreaterID];
    
    ProjectDialogueInfo *tmpInfo = [self selectProjectInfo:info.projectID];
    if (tmpInfo.projectID == nil || [tmpInfo.projectID isEqualToString:@""])
    {
        [projectInfoDatabase open];
        [projectInfoDatabase executeUpdate:insertSql];
        [projectInfoDatabase close];
    }
}
-(ProjectDialogueInfo *)selectProjectInfo:(NSString *)projectID
{
    NSString *sql = [NSString stringWithFormat:@"select *from projectinfo where projectID = '%@';",projectID];
    [projectInfoDatabase open];
    FMResultSet *result = [projectInfoDatabase executeQuery:sql];
    ProjectDialogueInfo *info = [[ProjectDialogueInfo alloc] init];
    while ([result next])
    {
        info.projectID = [result stringForColumn:@"projectID"];
        info.projectName = [result stringForColumn:@"projectName"];
        info.projectIconPath = [result stringForColumn:@"projectIconPath"];
        info.projectTime = [result stringForColumn:@"projectTime"];
        info.projectCreater = [result stringForColumn:@"projectCreater"];
        info.projectCreaterID = [result stringForColumn:@"projectCreaterID"];
    }
    [projectInfoDatabase class];
    return info;
}
//--------------------------------------项目的数据操作--------------------------------------//

//--------------------------------------对话的数据操作--------------------------------------//
-(NSMutableArray *)allDialogueArrayWithProjectID:(NSString *)projectID
{
    NSMutableArray *returnArray = [NSMutableArray array];
    
//    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM projectdialogue a where id=(select min(id) from projectdialogue where projectID = a.projectID) and messageSender = '%@' and projectID = '%@' or messageReceiver = '%@' and projectID = '%@';",kDefaultJID.user,projectID,kDefaultJID.user,projectID];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM projectdialogue where messageSender = '%@' and projectID = '%@' or messageReceiver = '%@' and projectID = '%@' order by messageTime;",kDefaultJID.user,projectID,kDefaultJID.user,projectID];
  
    [projectInfoDatabase open];
    FMResultSet *result = [projectInfoDatabase executeQuery:sql];
    while ([result next])
    {
        ProjectDialogue *dialogue = [[ProjectDialogue alloc] init];
        dialogue.projectID = [result stringForColumn:@"projectID"];
        dialogue.messageSender = [result stringForColumn:@"messageSender"];
        dialogue.messageReceiver = [result stringForColumn:@"messageReceiver"];
        dialogue.messageTime = [result stringForColumn:@"messageTime"];
        [returnArray addObject:dialogue];
    }
    [projectInfoDatabase close];
    
    return returnArray;
    
}

//--------------------------------------对话的数据操作--------------------------------------//

//--------------------------------------对话的数据操作--------------------------------------//
-(void)addProjectDialogue:(ProjectDialogue *)dialogue
{
    NSArray *array = [self selectProjectDialogueWithReceiver:dialogue.messageReceiver andSender:dialogue.messageSender andProjectID:dialogue.projectID];
    if (array.count != 0)
    {
        [self deleteProjectDialogueWithReceiver:dialogue.messageReceiver andSender:dialogue.messageSender andProjectID:dialogue.projectID];
    }

    NSString *insert = [NSString stringWithFormat:@"insert into projectdialogue(projectID,messageSender,messageReceiver,messageTime)values('%@','%@','%@','%@');",dialogue.projectID,dialogue.messageSender,dialogue.messageReceiver,dialogue.messageTime];
    [projectInfoDatabase open];
    [projectInfoDatabase executeUpdate:insert];
    [projectInfoDatabase close];
}
///如果接收方为空，则表示选择的是全部项目接包聊天,否则指的是单个的
-(NSArray *)selectProjectDialogueWithReceiver:(NSString *)receiver andSender:(NSString *)sender andProjectID:(NSString *)projectID
{
    NSString *sql = @"";
    if (receiver == nil)
    {
//        sql = [NSString stringWithFormat:@"SELECT * FROM projectdialogue a where id=(select min(id) from projectdialogue where projectID = a.projectID) and messageSender = '%@' or messageReceiver = '%@';",sender,sender];
        sql = [NSString stringWithFormat:@"SELECT * FROM projectdialogue where messageSender = '%@' or messageReceiver = '%@' group by projectID order by messageTime;",sender,sender];
    }
    else
    {
        sql = [NSString stringWithFormat:@"select *from projectdialogue where projectID = '%@' and messageSender = '%@' and messageReceiver = '%@' or projectID = '%@' and messageSender = '%@' and messageReceiver = '%@' order by messageTime;",projectID,sender,receiver,projectID,receiver,sender];
    }
    [projectInfoDatabase open];
    FMResultSet *result = [projectInfoDatabase executeQuery:sql];
    NSMutableArray *array = [NSMutableArray array];
    while ([result next])
    {
        ProjectDialogue *dialogue = [[ProjectDialogue alloc] init];
        dialogue.projectID = [result stringForColumn:@"projectID"];
        dialogue.messageSender = [result stringForColumn:@"messageSender"];
        dialogue.messageReceiver = [result stringForColumn:@"messageReceiver"];
        dialogue.messageTime = [result stringForColumn:@"messageTime"];
        [array addObject:dialogue];
    }
    [projectInfoDatabase close];
    return array;

}
-(void)deleteProjectDialogueWithReceiver:(NSString *)receiver andSender:(NSString *)sender andProjectID:(NSString *)projectID
{
    NSString *sql = [NSString stringWithFormat:@"delete from projectdialogue where projectID = '%@' and messageReceiver = '%@' and messageSender = '%@' or projectID = '%@' and messageReceiver = '%@' and messageSender = '%@';",projectID,receiver,sender,projectID,sender,receiver];
    [projectInfoDatabase open];
    [projectInfoDatabase executeUpdate:sql];
    [projectInfoDatabase close];
}
//--------------------------------------对话的数据操作--------------------------------------//

@end
