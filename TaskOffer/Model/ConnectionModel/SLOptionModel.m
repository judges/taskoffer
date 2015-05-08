//
//  SLOptionModel.m
//  TaskOffer
//
//  Created by wshaolin on 15/4/2.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLOptionModel.h"
#import "NSDictionary+NullFilter.h"

@implementation SLOptionModel

+ (instancetype)optionModelWithDictionary:(NSDictionary *)dictionary{
    return [[self alloc] initWithDictionary:dictionary];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    if(self = [super init]){
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}

- (void)setValuesForKeysWithDictionary:(NSDictionary *)dictionary{
    _optionKey = [[dictionary allKeys] firstObject];
    _optionValue = [[dictionary allValues] firstObject];
}

@end
