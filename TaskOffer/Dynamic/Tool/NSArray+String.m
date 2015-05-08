//
//  NSArray+String.m
//  XMPPIM
//
//  Created by wshaolin on 15/1/7.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "NSArray+String.h"

@implementation NSArray (String)

- (NSString *)stringByCommaSeparate{
    NSMutableString *string = [NSMutableString string];
    for(id element in self){
        [string appendFormat:@"%@，", element];
    }
    if(string.length > 0){
        // 删除最后多余的逗号
        [string deleteCharactersInRange:NSMakeRange(string.length - 1, 1)];
        return [string copy];
    }
    return @"";
}

@end
