//
//  SLSQLiteHandler.h
//  EnvironmentalAssistant
//
//  Created by wshaolin on 14/11/21.
//  Copyright (c) 2014年 wshaolin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLResultSet.h"

@interface SLSQLiteHandler : NSObject

@property (nonatomic, copy, readonly) NSString *databaseName;

+ (instancetype)defaultHandler;

- (BOOL)executeUpdate:(NSString *)sql, ... NS_REQUIRES_NIL_TERMINATION; // 必须以nil结尾

- (BOOL)executeUpdate:(NSString *)sql withArguments:(NSArray *)arguments;

- (SLResultSet *)executeQuery:(NSString *)sql, ... NS_REQUIRES_NIL_TERMINATION; // 必须以nil结尾

- (SLResultSet *)executeQuery:(NSString *)sql withArguments:(NSArray *)arguments;

- (BOOL)executeStatements:(NSString *)sql;

@end
