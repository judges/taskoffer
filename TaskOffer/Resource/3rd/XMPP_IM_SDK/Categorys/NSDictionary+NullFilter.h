//
//  NSDictionary+NullFilter.h
//  AppFramework
//
//  Created by wshaolin on 14/11/11.
//  Copyright (c) 2014年 haihang. All rights reserved.
//  根据key取值时过滤值类型为NSNull类型的情况

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface NSDictionary (NullFilter)

- (NSInteger)integerForKey:(NSString *)key;

- (long)longForKey:(NSString *)key;

- (long long)longLongForKey:(NSString *)key;

- (CGFloat)floatForKey:(NSString *)key;

- (double)doubleForKey:(NSString *)key;

- (NSNumber *)numberForKey:(NSString *)key;

- (NSString *)stringForKey:(NSString *)key; // 值为nil时返回""

- (BOOL)boolForKey:(NSString *)key;

- (NSArray *)arrayForKey:(NSString *)key; // 值不是数组时返回nil

- (NSDictionary *)dictionaryForKey:(NSString *)key; // 值不是字典时返回nil

- (id)objectValueForKey:(NSString *)key;

- (NSData *)dataForKey:(NSString *)key;

- (NSDate *)dateForKey:(NSString *)key;

- (BOOL)isNullForKey:(NSString *)key;

@end
