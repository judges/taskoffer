//
//  NSMutableArray+MoveElement.m
//  AppFramework
//
//  Created by wshaolin on 14/11/21.
//  Copyright (c) 2014年 wshaolin. All rights reserved.
//

#import "NSMutableArray+MoveElement.h"

@implementation NSMutableArray (MoveElement)

- (void)moveObjectFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex{
    if (toIndex != fromIndex) {
        id element = [self objectAtIndex:fromIndex];
        [self removeObjectAtIndex:fromIndex];
        if (toIndex >= [self count]) {
            [self addObject:element];
        } else {
            [self insertObject:element atIndex:toIndex];
        }
    }
}

@end
