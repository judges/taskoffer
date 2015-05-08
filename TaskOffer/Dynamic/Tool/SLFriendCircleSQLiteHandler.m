//
//  SLFriendCircleSQLiteHandler.m
//  XMPPIM
//
//  Created by wshaolin on 15/1/5.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLFriendCircleSQLiteHandler.h"
#import "SLSQLiteHandler.h"
#import "SLFriendCircleStatusCommentModel.h"
#import "SLFriendCircleStatusCommentFrameModel.h"
#import "SLFriendCircleStatusFrameModel.h"
#import "SLFriendCircleStatusModel.h"
#import "SLFriendCirclePersonStatusFrameModel.h"
#import "SLFriendCircleMessageModel.h"
#import "SLFriendCircleMessageFrameModel.h"
#import "NSDictionary+NullFilter.h"
#import "NSArray+String.h"
#import "SLFriendCircleUserModel.h"

@implementation SLFriendCircleSQLiteHandler

+ (BOOL)insertWithStatusModel:(SLFriendCircleStatusModel *)statusModel{
    SLSQLiteHandler *SQLiteHandler = [SLSQLiteHandler defaultHandler];
    NSString *insertSql = @"insert into t_status(status_id, username, content, type, urls, names, likenum, commentnum, createtime, owner) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    [self deleteWithStatusModelId:statusModel.statusId];
    NSArray *arguments = @[statusModel.statusId,
                           statusModel.userModel.username,
                           statusModel.content,
                           @(statusModel.messageType),
                           [statusModel.imageUrls stringByCommaSeparate],
                           statusModel.applaudNicknameString,
                           @(statusModel.applaudCount),
                           @(statusModel.commtentCount),
                           statusModel.originalDateTime,
                           [UserInfo sharedInfo].userID];
    for(SLFriendCircleStatusCommentFrameModel *statusCommentFrameModel in statusModel.commentArray){
        [self insertWithStatusCommentModel:statusCommentFrameModel.friendCircleStatusCommentModel];
    }
    return [SQLiteHandler executeUpdate:insertSql withArguments:arguments];
}

+ (BOOL)updateWithStatusModel:(SLFriendCircleStatusModel *)statusModel{
    SLSQLiteHandler *SQLiteHandler = [SLSQLiteHandler defaultHandler];
    NSString *updateSql = @"update t_status set username = ?, content = ?, type = ?, urls = ?, names = ?, likenum = ?, commentnum = ?, createtime = ? where status_id = ?";
    NSArray *arguments = @[statusModel.userModel.username,
                           statusModel.content,
                           @(statusModel.messageType),
                           [statusModel.imageUrls stringByCommaSeparate],
                           statusModel.applaudNicknameString,
                           @(statusModel.applaudCount),
                           @(statusModel.commtentCount),
                           statusModel.originalDateTime,
                           statusModel.statusId];
    return [SQLiteHandler executeUpdate:updateSql withArguments:arguments];
}

+ (BOOL)deleteWithStatusModelId:(NSString *)statusModelId{
    // 先删除评论
    [self deleteDataWithTableName:@"t_comment" whereColunmNames:@[@"status_id"] whereColunmValues:@[statusModelId]];
    return [self deleteDataWithTableName:@"t_status" whereColunmNames:@[@"status_id"] whereColunmValues:@[statusModelId]];
}

+ (SLFriendCircleStatusModel *)statusModelWithId:(NSString *)statusModelId{
    NSString *querySql = @"select status_id, username, content, type, urls, names, likenum, commentnum, createtime from t_status  where status_id = ?";
    SLSQLiteHandler *SQLiteHandler = [SLSQLiteHandler defaultHandler];
    SLResultSet *resultSet = [SQLiteHandler executeQuery:querySql, statusModelId, nil];
    if([resultSet hasNext]){
        return [self statusModelWithResultSet:resultSet];
    }
    return nil;
}

+ (NSArray *)personStatusModelsWithParameters:(NSDictionary *)parameters{
    NSMutableString *querySql = [NSMutableString stringWithString:@"select status_id, username, content, type, urls, names, likenum, commentnum, createtime from t_status where username = ? order by cast(status_id as integer) desc limit ?, ?"];
    
    NSInteger pageSize = [parameters integerForKey:@"pageSize"];
    if(pageSize < 1){
        pageSize = 20;
    }
    
    NSInteger currentPage = [parameters integerForKey:@"pageNum"];
    if(currentPage < 1){
        currentPage = 1;
    }
    
    NSArray *arguments = @[[parameters stringForKey:@"username"],
                           @((currentPage - 1) * pageSize),
                           @(pageSize)];
    
    SLSQLiteHandler *SQLiteHandler = [SLSQLiteHandler defaultHandler];
    SLResultSet *resultSet = [SQLiteHandler executeQuery:querySql withArguments:arguments];
    NSMutableArray *statusModels = [NSMutableArray array];
    while ([resultSet hasNext]) {
        SLFriendCircleStatusModel *friendCircleStatusModel = [self statusModelWithResultSet:resultSet];
        [statusModels addObject:friendCircleStatusModel];
    }
    
    return [statusModels copy];
}

+ (NSArray *)statusFrameModelsWithParameters:(NSDictionary *)parameters{
    NSMutableString *querySql = [NSMutableString stringWithString:@"select status_id, username, content, type, urls, names, likenum, commentnum, createtime from t_status where owner = ? order by cast(status_id as integer) desc limit ?, ?"];
    
    NSInteger pageSize = [parameters integerForKey:@"pageSize"];
    if(pageSize < 1){
        pageSize = 20;
    }
    NSInteger currentPage = [parameters integerForKey:@"pageNum"];
    if(currentPage < 1){
        currentPage = 1;
    }
    
    NSArray *arguments = @[[UserInfo sharedInfo].userID,
                           @((currentPage - 1) * pageSize),
                           @(pageSize)];
    
    SLSQLiteHandler *SQLiteHandler = [SLSQLiteHandler defaultHandler];
    SLResultSet *resultSet = [SQLiteHandler executeQuery:querySql withArguments:arguments];
    NSMutableArray *statusModels = [NSMutableArray array];
    while ([resultSet hasNext]) {
        SLFriendCircleStatusModel *friendCircleStatusModel = [self statusModelWithResultSet:resultSet];
        SLFriendCircleStatusFrameModel *friendCircleStatusFrameModel = [[SLFriendCircleStatusFrameModel alloc] initWithFriendCircleStatusModel:friendCircleStatusModel];
        [statusModels addObject:friendCircleStatusFrameModel];
    }
    
    return [statusModels copy];
}

+ (SLFriendCircleStatusModel *)statusModelWithResultSet:(SLResultSet *)resultSet{
    NSArray *names = [self componentsByCommaWithString:[resultSet stringForColumn:@"names"]];
    NSArray *urls = [self componentsByCommaWithString:[resultSet stringForColumn:@"urls"]];
    NSString *statusId = [resultSet stringForColumn:@"status_id"];
    
    NSDictionary *dictionary = @{@"id" : statusId,
                                 @"username" : [resultSet stringForColumn:@"username"],
                                 @"content" : [resultSet stringForColumn:@"content"],
                                 @"type" : @([resultSet intForColumn:@"type"]),
                                 @"names" : names,
                                 @"urls" : urls,
                                 @"commList" : @[],
                                 @"likeNum" : @([resultSet intForColumn:@"likenum"]),
                                 @"commentNum" : @([resultSet intForColumn:@"commentnum"]),
                                 @"createTime" : [resultSet stringForColumn:@"createtime"]};
    SLFriendCircleStatusModel *friendCircleStatusModel = [[SLFriendCircleStatusModel alloc] initWithDictionary:dictionary];
    friendCircleStatusModel.commentArray = [self statusCommentModelsWithStatusId:statusId];
    return friendCircleStatusModel;
}

+ (NSArray *)personFrameStatusModelsWithParameters:(NSDictionary *)parameters{
    NSArray *statusModels = [self personStatusModelsWithParameters:parameters];
    NSMutableArray *personStatusModels = [NSMutableArray array];
    for(SLFriendCircleStatusModel *friendCircleStatusModel in statusModels){
        SLFriendCirclePersonStatusFrameModel *friendCirclePersonStatusFrameModel = [[SLFriendCirclePersonStatusFrameModel alloc] initWithFriendCircleStatusModel:friendCircleStatusModel];
        [personStatusModels addObject:friendCirclePersonStatusFrameModel];
    }
    
    return [personStatusModels copy];
}

+ (BOOL)insertWithStatusCommentModel:(SLFriendCircleStatusCommentModel *)statusCommentModel{
    [self deleteWithStatusCommentModelId:statusCommentModel.commentId];
    SLSQLiteHandler *SQLiteHandler = [SLSQLiteHandler defaultHandler];
    
    NSString *insertSql = @"insert into t_comment (comment_id, status_id, comment, parentid, senderuser, recipientuser, createtime) values (?, ?, ?, ?, ?, ?, ?)";
    NSArray *arguments = @[statusCommentModel.commentId,
                           statusCommentModel.statusId,
                           statusCommentModel.commentContent,
                           statusCommentModel.parentId,
                           statusCommentModel.senderUserModel.username,
                           statusCommentModel.recipientUserModel.username,
                           statusCommentModel.dateTime];
    return [SQLiteHandler executeUpdate:insertSql withArguments:arguments];
}

+ (BOOL)deleteWithStatusCommentModelId:(NSString *)statusCommentModelId{
    return NO;
    return [self deleteDataWithTableName:@"t_comment" whereColunmNames:@[@"comment_id"] whereColunmValues:@[statusCommentModelId]];
}

+ (NSArray *)statusCommentModelsWithStatusId:(NSString *)statusId{
    SLSQLiteHandler *SQLiteHandler = [SLSQLiteHandler defaultHandler];
    NSString *querySql = @"select comment_id, status_id, comment, parentid, senderuser, recipientuser, createtime from t_comment where status_id = ?";
    SLResultSet *resultSet = [SQLiteHandler executeQuery:querySql, statusId, nil];
    NSMutableArray *statusCommentModels = [NSMutableArray array];
    while ([resultSet hasNext]) {
        NSDictionary *dictionary = @{@"id" : [resultSet stringForColumn:@"comment_id"],
                                     @"parentid": [resultSet stringForColumn:@"parentid"],
                                     @"username" : [resultSet stringForColumn:@"senderuser"],
                                     @"replyTo" : [resultSet stringForColumn:@"recipientuser"],
                                     @"comment" : [resultSet stringForColumn:@"comment"],
                                     @"createTime" : [resultSet stringForColumn:@"createtime"],
                                     @"infoId" : [resultSet stringForColumn:@"status_id"]};
        SLFriendCircleStatusCommentModel *statusCommentModel = [[SLFriendCircleStatusCommentModel alloc]  initWithDictionary:dictionary];
        SLFriendCircleStatusCommentFrameModel *statusCommentFrameModel = [[SLFriendCircleStatusCommentFrameModel alloc] initWithFriendCircleStatusCommentModel:statusCommentModel];
        [statusCommentModels addObject:statusCommentFrameModel];
    }
    
    return [statusCommentModels copy];
}

+ (NSArray *)statusCommentModelsWithParameters:(NSDictionary *)parameters{
    return nil;
}

+ (BOOL)insertWithMessageModel:(SLFriendCircleMessageModel *)messageModel{
    NSString *insertSql = @"insert into t_message(status_id, username, message_content, status_content, status_urls, message_type, messagedate, is_read) values (?, ?, ?, ?, ?, ?, ?, ?);";
    SLSQLiteHandler *SQLiteHandler = [SLSQLiteHandler defaultHandler];
    NSArray *arguments = @[messageModel.statusId,
                           messageModel.userModel.username,
                           messageModel.messageContent,
                           messageModel.statusContent,
                           [messageModel.imageUrls stringByCommaSeparate],
                           @(messageModel.messageType),
                           messageModel.messageDate,
                           @(messageModel.isRead)];
    return [SQLiteHandler executeUpdate:insertSql withArguments:arguments];
}

+ (BOOL)deleteWithMessageModelId:(NSString *)messageModelId{
    if(messageModelId == nil){
        NSString *deleteSql = @"delete from t_message";
        SLSQLiteHandler *SQLiteHandler = [SLSQLiteHandler defaultHandler];
        return [SQLiteHandler executeUpdate:deleteSql, nil];
    }
    
    return [self deleteDataWithTableName:@"t_message" whereColunmNames:@[@"id"] whereColunmValues:@[messageModelId]];
}

+ (BOOL)updateAllUnreadMessageToRead{
    NSString *updateSql = @"update t_message set is_read = 1 where is_read = 0";
    SLSQLiteHandler *SQLiteHandler = [SLSQLiteHandler defaultHandler];
    return [SQLiteHandler executeUpdate:updateSql, nil];
}

+ (NSInteger)allUnreadMessageCount{
    NSString *querySql = @"select count(id) as unread_message_count from t_message where is_read = 0";
    SLSQLiteHandler *SQLiteHandler = [SLSQLiteHandler defaultHandler];
    SLResultSet *resultSet = [SQLiteHandler executeQuery:querySql, nil];
    if([resultSet hasNext]){
        return [resultSet intForColumn:@"unread_message_count"];
    }
    return 0;
}

+ (NSInteger)allMessageCount{
    NSString *querySql = @"select count(id) as unread_message_count from t_message";
    SLSQLiteHandler *SQLiteHandler = [SLSQLiteHandler defaultHandler];
    SLResultSet *resultSet = [SQLiteHandler executeQuery:querySql, nil];
    if([resultSet hasNext]){
        return [resultSet intForColumn:@"unread_message_count"];
    }
    return 0;
}

+ (NSArray *)messageFrameModelWithParameters:(NSDictionary *)parameters{
    NSString *isRead = [parameters stringForKey:@"isRead"];
    NSMutableString *querySql = [NSMutableString stringWithString:@"select id, status_id, username, message_content, status_content, status_urls, message_type, messagedate, is_read from t_message"];
    NSArray *arguments = nil;
    if([isRead isEqualToString:@"ALL"]){
       [querySql appendString:@" order by id desc limit ?, ?"];
        NSInteger pageSize = [parameters integerForKey:@"pageSize"];
        if(pageSize < 1){
            pageSize = 20;
        }
        NSInteger currentPage = [parameters integerForKey:@"pageNum"];
        if(currentPage < 1){
            currentPage = 1;
        }
        arguments = @[@((currentPage - 1) * pageSize),
                      @(pageSize)];
    }else{
        [querySql appendString:@" where is_read = ?"];
        arguments = @[@"0"];
    }
    
    SLSQLiteHandler *SQLiteHandler = [SLSQLiteHandler defaultHandler];
    SLResultSet *resultSet = [SQLiteHandler executeQuery:[querySql copy] withArguments:arguments];
    NSMutableArray *messageFrameModels = [NSMutableArray array];
    while ([resultSet hasNext]) {
        NSArray *status_urls = [self componentsByCommaWithString:[resultSet stringForColumn:@"status_urls"]];
        NSDictionary *dictionary = @{@"id" : @([resultSet intForColumn:@"id"]),
                                     @"status_id" : [resultSet stringForColumn:@"status_id"],
                                     @"username" : [resultSet stringForColumn:@"username"],
                                     @"message_content" : [resultSet stringForColumn:@"message_content"],
                                     @"status_content" : [resultSet stringForColumn:@"status_content"],
                                     @"status_urls" : status_urls,
                                     @"message_type" : @([resultSet intForColumn:@"message_type"]),
                                     @"messagedate" : [resultSet stringForColumn:@"messagedate"],
                                     @"is_read" : @([resultSet intForColumn:@"is_read"])};
        
        SLFriendCircleMessageModel *messageModel = [[SLFriendCircleMessageModel alloc] initWithDictionary:dictionary];
        SLFriendCircleMessageFrameModel *messageFrameModel = [[SLFriendCircleMessageFrameModel alloc] initWithFriendCircleMessageModel:messageModel];
        [messageFrameModels addObject:messageFrameModel];
    }
    
    return [messageFrameModels copy];
}

// 根据表明和字段值删除数据，字段名和指段值必须对应
+ (BOOL)deleteDataWithTableName:(NSString *)tableName whereColunmNames:(NSArray *)colunmNames whereColunmValues:(NSArray *)colunmValues{
    if(colunmValues == nil || colunmValues.count == 0){
        return NO;
    }
    
    if(colunmValues.count != colunmValues.count){
        return NO;
    }
    NSMutableString *deleteSql = [NSMutableString stringWithFormat:@"delete from %@ where 1 = 1", tableName];
    for(NSInteger index = 0; index < colunmNames.count; index ++){
        [deleteSql appendFormat:@" and %@ = ?", colunmNames[index]];
    }
    
    SLSQLiteHandler *SQLiteHandler = [SLSQLiteHandler defaultHandler];
    
    return [SQLiteHandler executeUpdate:[deleteSql copy] withArguments:colunmValues];
}

+ (NSArray *)componentsByCommaWithString:(NSString *)string{
    if(string != nil && string.length > 0){
        return [string componentsSeparatedByString:@"，"];
    }
    return @[];
}

@end
