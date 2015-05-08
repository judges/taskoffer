//
//  SLResultSet.m
//  EnvironmentalAssistant
//
//  Created by wshaolin on 14-6-5.
//  Copyright (c) 2014年 wshaolin. All rights reserved.
//

#import "SLResultSet.h"
#import "NSDictionary+NullFilter.h"

@interface SLResultSet(){
    NSUInteger _rowCount;
    NSUInteger _columnCount;
}

@property (nonatomic, assign) NSInteger currentRow;
@property (nonatomic, strong) NSMutableDictionary *columnIndexToNameMap;
@property (nonatomic, strong) NSDictionary *columnNameToIndexMap;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation SLResultSet

static NSString *columnIndexToNameKey = @"ColumnIndexToNameKey";

- (instancetype)initWithDataArray:(NSArray *)dataArray columnNameToIndexMap:(NSDictionary *)columnNameToIndexMap{
    if(self = [super init]){
        _columnCount = 0;
        _rowCount = [dataArray count];
        _currentRow = -1;
        self.columnNameToIndexMap = columnNameToIndexMap;
        self.dataArray = dataArray;
    }
    return self;
}

- (NSMutableDictionary *)columnIndexToNameMap{
    if(_columnIndexToNameMap == nil){
        _columnIndexToNameMap = [NSMutableDictionary dictionary];
    }
    return _columnIndexToNameMap;
}

- (void)setColumnNameToIndexMap:(NSMutableDictionary *)columnNameToIndexMap{
    if(_columnNameToIndexMap == nil){
        _columnCount = [columnNameToIndexMap count];
        _columnNameToIndexMap = columnNameToIndexMap;
        NSArray *values = [columnNameToIndexMap allValues];
        NSArray *keys = [columnNameToIndexMap allKeys];
        for(NSInteger index = 0; index < keys.count; index ++){
            NSString *key = [NSString stringWithFormat:@"%@%@", columnIndexToNameKey, values[index]];
            [self.columnIndexToNameMap setValue:keys[index] forKey:key];
        }
    }
}

- (BOOL)hasNext{
    
    NSInteger currentRow = [[NSNumber numberWithInteger:self.currentRow] integerValue];
    NSInteger rowCount = [[NSNumber numberWithInteger:self.rowCount] integerValue];
    BOOL hasNextRow = (rowCount > 0 && currentRow < rowCount - 1);
    if(hasNextRow){
        self.currentRow ++;
    }
    return hasNextRow;
}

- (NSUInteger)rowCount{
    return _rowCount;
}

- (NSUInteger)columnCount{
    return _columnCount;
}

- (NSArray *)allColumnName{
    return [_columnNameToIndexMap allKeys];
}

- (NSInteger)columnIndexForName:(NSString*)columnName{
    return [_columnNameToIndexMap integerForKey:[columnName lowercaseString]];
}

- (NSString *)columnNameForIndex:(NSInteger)columnIndex{
    NSString *name = [NSString stringWithFormat:@"%@%ld", columnIndexToNameKey, (long)columnIndex];
    return [self.columnIndexToNameMap stringForKey:name];
}

- (NSInteger)intForColumn:(NSString *)columnName{
    NSDictionary *valueDictionary = self.dataArray[self.currentRow];
    return [valueDictionary integerForKey:[columnName lowercaseString]];
}

- (NSInteger)intForColumnIndex:(NSInteger)columnIndex{
    NSString *columnName = [self columnNameForIndex:columnIndex];
    return [self intForColumn:columnName];
}

- (long)longForColumn:(NSString *)columnName{
    NSDictionary *valueDictionary = self.dataArray[self.currentRow];
    return [valueDictionary longForKey:[columnName lowercaseString]];
}

- (long)longForColumnIndex:(NSInteger)columnIndex{
    NSString *columnName = [self columnNameForIndex:columnIndex];
    return [self longForColumn:columnName];
}

- (long long)longLongIntForColumn:(NSString *)columnName{
    NSDictionary *valueDictionary = self.dataArray[self.currentRow];
    return [valueDictionary longLongForKey:[columnName lowercaseString]];
}

- (long long)longLongIntForColumnIndex:(NSInteger)columnIndex{
    NSString *columnName = [self columnNameForIndex:columnIndex];
    return [self longLongIntForColumn:columnName];
}

- (BOOL)boolForColumn:(NSString *)columnName{
    NSDictionary *valueDictionary = self.dataArray[self.currentRow];
    return [valueDictionary boolForKey:[columnName lowercaseString]];
}

- (BOOL)boolForColumnIndex:(NSInteger)columnIndex{
    NSString *columnName = [self columnNameForIndex:columnIndex];
    return [self boolForColumn:columnName];
}

- (double)doubleForColumn:(NSString *)columnName{
    NSDictionary *valueDictionary = self.dataArray[self.currentRow];
    return [valueDictionary doubleForKey:[columnName lowercaseString]];
}

- (double)doubleForColumnIndex:(NSInteger)columnIndex{
    NSString *columnName = [self columnNameForIndex:columnIndex];
    return [self doubleForColumn:columnName];
}

- (NSString *)stringForColumn:(NSString *)columnName{
    NSDictionary *valueDictionary = self.dataArray[self.currentRow];
    return [valueDictionary stringForKey:[columnName lowercaseString]];
}

- (NSString *)stringForColumnIndex:(NSInteger)columnIndex{
    NSString *columnName = [self columnNameForIndex:columnIndex];
    return [self stringForColumn:columnName];
}

- (NSDate *)dateForColumn:(NSString *)columnName{
    NSDictionary *valueDictionary = self.dataArray[self.currentRow];
    return [valueDictionary dateForKey:[columnName lowercaseString]];
}

- (NSDate *)dateForColumnIndex:(NSInteger)columnIndex{
    NSString *columnName = [self columnNameForIndex:columnIndex];
    return [self dateForColumn:columnName];
}

- (NSData *)dataForColumn:(NSString *)columnName{
    NSDictionary *valueDictionary = self.dataArray[self.currentRow];
    return [valueDictionary dataForKey:[columnName lowercaseString]];
}

- (NSData *)dataForColumnIndex:(NSInteger)columnIndex{
    NSString *columnName = [self columnNameForIndex:columnIndex];
    return [self dataForColumn:columnName];
}

- (id)objectForColumnName:(NSString *)columnName{
    NSDictionary *valueDictionary = self.dataArray[self.currentRow];
    return [valueDictionary objectValueForKey:[columnName lowercaseString]];
}

- (id)objectForColumnIndex:(NSInteger)columnIndex{
    NSString *columnName = [self columnNameForIndex:columnIndex];
    return [self objectForColumnName:columnName];
}

- (BOOL)columnIsNullForIndex:(NSInteger)columnIndex{
    NSString *columnName = [self columnNameForIndex:columnIndex];
    return [self columnIsNullColumnName:columnName];
}

- (BOOL)columnIsNullColumnName:(NSString *)columnName{
    NSDictionary *valueDictionary = self.dataArray[self.currentRow];
    return [valueDictionary isNullForKey:[columnName lowercaseString]];
}

- (NSString *)description{
    return [NSString stringWithFormat:@"\n{\n\t\"rowCount\" : \"%lu\", \n\t\"columnCount\" : \"%lu\", \n\t\"data\" : \"%@\"\n}", (unsigned long)[self rowCount], (unsigned long)[self columnCount], [self arrayToString:self.dataArray]];
}

- (NSString *)arrayToString:(NSArray *)array{
    NSMutableString *mutableString = [NSMutableString string];
    [mutableString appendString:@"["];
    for(NSInteger index = 0; index < array.count; index ++){
        NSDictionary *dictionary = array[index];
        if(index != 0){
            [mutableString appendFormat:@"\t%@", [self dictionaryToString:dictionary]];
        }else{
            [mutableString appendString:[self dictionaryToString:dictionary]];
        }
        
        if(index != array.count - 1){
            [mutableString appendString:@", \n"];
        }
    }
    
    [mutableString appendString:@"]"];
    return [mutableString copy];
}

- (NSString *)dictionaryToString:(NSDictionary *)dictionary{
    NSMutableString *mutableString = [NSMutableString string];
    NSArray *keys = [dictionary allKeys];
    [mutableString appendString:@"{\n"];
    for(NSInteger index = 0; index < keys.count; index ++){
        NSString *key = keys[index];
        if([dictionary[key] isKindOfClass:[NSData class]]){
            // 字典中的二进制数据显示为'<blob>'
            [mutableString appendFormat:@"\t\t\"%@\" : <blob>", key];
        }else{
            [mutableString appendFormat:@"\t\t\"%@\" : \"%@\"", key, [dictionary stringForKey:key]];
        }
        
        if(index != keys.count - 1){
            [mutableString appendString:@", \n"];
        }
    }
    
    [mutableString appendString:@"\n\t}"];
    return [mutableString copy];
}

@end
