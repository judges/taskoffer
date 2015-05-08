//
//  SLResultSet.h
//  EnvironmentalAssistant
//
//  Created by wshaolin on 14-6-5.
//  Copyright (c) 2014年 wshaolin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLResultSet : NSObject

@property (nonatomic, assign, readonly) NSUInteger rowCount; // 行数
@property (nonatomic, assign, readonly) NSUInteger columnCount; // 列数
@property (nonatomic, strong, readonly) NSArray *allColumnName;
@property (nonatomic, assign, readonly) BOOL hasNext;

- (instancetype)initWithDataArray:(NSArray *)dataArray columnNameToIndexMap:(NSDictionary *)columnNameToIndexMap;

- (NSInteger)columnIndexForName:(NSString *)columnName;
- (NSString *)columnNameForIndex:(NSInteger)columnIndex;

- (NSInteger)intForColumn:(NSString *)columnName;
- (NSInteger)intForColumnIndex:(NSInteger)columnIndex;

- (long)longForColumn:(NSString *)columnName;
- (long)longForColumnIndex:(NSInteger)columnIndex;

- (long long)longLongIntForColumn:(NSString *)columnName;
- (long long)longLongIntForColumnIndex:(NSInteger)columnIndex;

- (BOOL)boolForColumn:(NSString *)columnName;
- (BOOL)boolForColumnIndex:(NSInteger)columnIndex;

- (double)doubleForColumn:(NSString *)columnName;
- (double)doubleForColumnIndex:(NSInteger)columnIndex;

- (NSString *)stringForColumn:(NSString *)columnName;
- (NSString *)stringForColumnIndex:(NSInteger)columnIndex;

- (NSDate *)dateForColumn:(NSString *)columnName;
- (NSDate *)dateForColumnIndex:(NSInteger)columnIndex;

- (NSData *)dataForColumn:(NSString *)columnName;
- (NSData *)dataForColumnIndex:(NSInteger)columnIndex;

- (id)objectForColumnName:(NSString *)columnName;
- (id)objectForColumnIndex:(NSInteger)columnIndex;

- (BOOL)columnIsNullColumnName:(NSString *)columnName;
- (BOOL)columnIsNullForIndex:(NSInteger)columnIndex;

@end
