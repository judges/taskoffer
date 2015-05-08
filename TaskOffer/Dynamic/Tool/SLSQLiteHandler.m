//
//  SLSQLiteHandler.m
//  EnvironmentalAssistant
//
//  Created by wshaolin on 14/11/21.
//  Copyright (c) 2014年 wshaolin. All rights reserved.
//

#import "SLSQLiteHandler.h"
#import "FMDB.h"

// documents的沙盒路径
#define SLDocumentsFilePath(fileName) [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:(fileName)]

@interface SLSQLiteHandler(){
    FMDatabaseQueue *_databaseQueue;
}

@end

@implementation SLSQLiteHandler

+ (instancetype)defaultHandler{
    static SLSQLiteHandler *_SQLiteHandler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _SQLiteHandler = [[self alloc] init];
        [_SQLiteHandler setDatabaseName:@"dynamic_data.sqlite"];
    });
    return _SQLiteHandler;
}

- (void)loadDatabaseQueue{
    _databaseQueue = [FMDatabaseQueue databaseQueueWithPath:SLDocumentsFilePath(self.databaseName)];
}

- (void)setDatabaseName:(NSString *)databaseName{
    _databaseName = databaseName;
    // 1.创建状态表
    NSString *createTableSQL = @"create table if not exists t_status(status_id text, username text, content text, type integer, urls text, names text, likenum integer, commentnum integer, createtime text, owner text);";
    [self createTable:@"t_status" withSQL:createTableSQL];
    
    // 2.创建评论表
    createTableSQL = @"create table if not exists t_comment(comment_id text, status_id text, comment text, parentid text, senderuser text, recipientuser text, createtime text);";
    [self createTable:@"t_comment" withSQL:createTableSQL];
    
    // 3.创建消息表
    createTableSQL = @"create table if not exists t_message(id integer primary key autoincrement, status_id text, username text, message_content text, status_content text, status_urls text, message_type integer, messagedate text, is_read integer);";
    [self createTable:@"t_message" withSQL:createTableSQL];
}

- (void)createTable:(NSString *)tableName withSQL:(NSString *)sql{
    NSString *querySQL = [NSString stringWithFormat:@"select count(*) as table_count from sqlite_master t where t.type = 'table' and t.name = '%@'", tableName];
    
    [self loadDatabaseQueue];
    
    [_databaseQueue inDatabase:^(FMDatabase *database) {
        BOOL isExist = NO;
        FMResultSet *resultSet = [database executeQuery:querySQL];
        if([resultSet next]){
            isExist = [resultSet intForColumn:@"table_count"];
        }
        
        // 表不存在则创建表
        if(!isExist){
            NSError *error = nil;
            if (![database executeUpdate:sql withErrorAndBindings:&error]) {
                NSLog(@"执行SQL语句: '%@'失败. \n失败原因: %@", sql, [error localizedDescription]);
            }
        }
        [database close];
    }];
    
    [_databaseQueue close];
}

- (BOOL)executeUpdate:(NSString *)sql, ... NS_REQUIRES_NIL_TERMINATION{
    va_list args;
    // 初始化va_list指针变量，即将args指向sql
    va_start(args, sql);
    NSArray *arguments = [self arrayWithVaList:args];
    // 清空参数列表，置指针args无效
    va_end(args);
    
    return [self executeUpdate:sql withArguments:arguments];
}

- (BOOL)executeUpdate:(NSString *)sql withArguments:(NSArray *)arguments{
    __block BOOL isSuccess = NO;
    [self loadDatabaseQueue];
    [_databaseQueue inDatabase:^(FMDatabase *database) {
        isSuccess = [database executeUpdate:sql withArgumentsInArray:arguments];
        [database close];
    }];
    
    [_databaseQueue close];
    return isSuccess;
}

- (SLResultSet *)executeQuery:(NSString *)sql, ... NS_REQUIRES_NIL_TERMINATION{
    va_list args;
    // 初始化va_list指针变量，即将args指向sql
    va_start(args, sql);
    
    NSArray *arguments = [self arrayWithVaList:args];
    // 清空参数列表，置指针args无效
    va_end(args);
    
    return [self executeQuery:sql withArguments:arguments];
}

- (SLResultSet *)executeQuery:(NSString *)sql withArguments:(NSArray *)arguments{
    __block SLResultSet *resultSet = nil;
    [self loadDatabaseQueue];
    [_databaseQueue inDatabase:^(FMDatabase *database) {
        FMResultSet *rs = [database executeQuery:sql withArgumentsInArray:arguments];
        resultSet = [self convertResultSet:rs];
        [database close];
    }];
    
    [_databaseQueue close];
    return resultSet;
}

- (BOOL)executeStatements:(NSString *)sql{
    __block BOOL isSuccess = NO;
    [self loadDatabaseQueue];
    [_databaseQueue inDatabase:^(FMDatabase *database) {
        isSuccess = [database executeStatements:sql];
        [database close];
    }];
    
    [_databaseQueue close];
    return isSuccess;
}

#pragma -mark 结果集转换

- (SLResultSet *)convertResultSet:(FMResultSet *)resultSet{
    NSMutableArray *resultSetArray = [NSMutableArray array];
    NSInteger columnCount = [resultSet columnCount];
    
    while ([resultSet next]) {
        NSMutableDictionary *valuesMap = [NSMutableDictionary dictionary];
        for(int index = 0; index < columnCount; index ++){
            // 以小写key存储
            NSString *columnName = [[resultSet columnNameForIndex:index] lowercaseString];
            [valuesMap setValue:[resultSet objectForColumnIndex:index] forKey:columnName];
        }
        [resultSetArray addObject:[valuesMap copy]];
    }
    
    return [[SLResultSet alloc] initWithDataArray:[resultSetArray copy] columnNameToIndexMap:resultSet.columnNameToIndexMap];
}

- (NSArray *)arrayWithVaList:(va_list)vaList{
    NSMutableArray *mutableArray = [NSMutableArray array];
    id va;
    while((va = va_arg(vaList, id)))  {
        if(va){
            [mutableArray addObject:va];
        }
    }
    
    return [mutableArray copy];
}

@end
