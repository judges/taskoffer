//
//  NSDictionary+NullFilter.m
//  AppFramework
//
//  Created by wshaolin on 14/11/11.
//  Copyright (c) 2014年 haihang. All rights reserved.
//

#import "NSDictionary+NullFilter.h"

@implementation NSDictionary (NullFilter)

- (NSInteger)integerForKey:(NSString *)key{
    return [[self objectValueForKey:key] integerValue];
}

- (long)longForKey:(NSString *)key{
    return [[self objectValueForKey:key] longValue];
}

- (long long)longLongForKey:(NSString *)key{
    return [[self objectValueForKey:key] longLongValue];
}

- (CGFloat)floatForKey:(NSString *)key{
    return [[self objectValueForKey:key] floatValue];
}

- (double)doubleForKey:(NSString *)key{
    return [[self objectValueForKey:key] doubleValue];
}

- (NSNumber *)numberForKey:(NSString *)key{
    if([[self objectValueForKey:key] isKindOfClass:[NSNumber class]]){
        return [self objectValueForKey:key];
    }
    return nil;
}

- (NSString *)stringForKey:(NSString *)key{
    if([self objectValueForKey:key] != nil){
        if([[self objectValueForKey:key] isKindOfClass:[NSString class]]){
            return [self objectValueForKey:key];
        }else if([[self objectValueForKey:key] isKindOfClass:[NSNumber class]]){
            return [[self objectValueForKey:key] stringValue];
        }else{
            return [NSString stringWithFormat:@"%@", [self objectValueForKey:key]];
        }
    }
    return @"";
}

- (BOOL)boolForKey:(NSString *)key{
    return [[self objectValueForKey:key] boolValue];
}

- (NSArray *)arrayForKey:(NSString *)key{
    if([[self objectValueForKey:key] isKindOfClass:[NSArray class]]){
        return [self objectValueForKey:key];
    }
    return nil;
}

- (NSDictionary *)dictionaryForKey:(NSString *)key{
    if([[self objectValueForKey:key] isKindOfClass:[NSDictionary class]]){
        return [self objectValueForKey:key];
    }
    return nil;
}

- (id)objectValueForKey:(NSString *)key{
    if(![self isNullForKey:key]){
        return [self objectForKey:key];
    }
    return nil;
}

- (NSData *)dataForKey:(NSString *)key{
    if([[self objectForKey:key] isKindOfClass:[NSData class]]){
        return [self objectForKey:key];
    }
    
    return nil;
}

- (NSDate *)dateForKey:(NSString *)key{
    if([[self objectForKey:key] isKindOfClass:[NSDate class]]){
        return [self objectForKey:key];
    }
    
    return nil;
}

- (BOOL)isNullForKey:(NSString *)key{
    return [[self objectForKey:key] isKindOfClass:[NSNull class]];
}

@end
