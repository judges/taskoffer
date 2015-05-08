//
//  SLEnterpriseInformationModel.m
//  TaskOffer
//
//  Created by wshaolin on 15/3/20.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLEnterpriseInformationModel.h"
#import "NSDictionary+NullFilter.h"

@implementation SLEnterpriseInformationModel

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
    _department = [dictionary stringForKey:@"companyName"];
    _staffSize = [dictionary stringForKey:@"companySize"];
    _address = [dictionary stringForKey:@"companyAddress"];
    _introduction = [dictionary stringForKey:@"companyDescibe"];
    _companyID = [dictionary stringForKey:@"id"];
    _companyName = [dictionary stringForKey:@"companyName"];
    _enterpriseName = [dictionary stringForKey:@"enterpriseName"];
    _companyLogo = [dictionary stringForKey:@"companyLogo"];
}

@end
