//
//  SLConnectionDynamicModel.m
//  TaskOffer
//
//  Created by wshaolin on 15/4/25.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLConnectionDynamicModel.h"
#import "NSDictionary+NullFilter.h"
#import "NSString+Conveniently.h"
#import "NSDate+Conveniently.h"
#import "SLHTTPServerHandler.h"

@implementation SLConnectionDynamicModel

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
    _dynamicID = [dictionary stringForKey:@"id"];
    _imageURL = [dictionary stringForKey:@"urls"];
    NSArray *array = [_imageURL componentsSeparatedByString:@","];
    if(array != nil && array.count > 0){
        _imageURL = [array firstObject];
    }
    NSString *sendTimeString = [dictionary stringForKey:@"createtime"];
    NSDate *sendTime = [sendTimeString dateWithDefaultFormat];
    _content = [sendTime stringWithFormat:@"发布于yyyy-M-d"];
}

@end
