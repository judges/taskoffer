//
//  SLTagModel.m
//  TaskOffer
//
//  Created by wshaolin on 15/4/28.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLTagModel.h"
#import "NSDictionary+NullFilter.h"

@implementation SLTagModel

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary{
    return [[self alloc] initWithDictionary:dictionary];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    if(self = [super init]){
        [self setValuesForKeysWithDictionary:dictionary];
    }
    
    return self;
}

- (void)setValuesForKeysWithDictionary:(NSDictionary *)dictionary{
    _tagID = [dictionary stringForKey:@"id"];
    _tagCode = [dictionary stringForKey:@"labelCode"];
    _tagName = [dictionary stringForKey:@"labelName"];
    _tagType = [dictionary integerForKey:@"labelCreateType"];
    _tagStatus = [dictionary integerForKey:@"labelStatus"];
}

@end
