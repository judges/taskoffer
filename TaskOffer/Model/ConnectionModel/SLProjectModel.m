//
//  SLProjectModel.m
//  TaskOffer
//
//  Created by wshaolin on 15/3/24.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLProjectModel.h"
#import "NSDictionary+NullFilter.h"
#import "SLTimeStampHandler.h"
#import "SLHTTPServerHandler.h"

@implementation SLProjectModel

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
    _projectID = [dictionary stringForKey:@"id"];
    _projectName = [dictionary stringForKey:@"projectName"];
    _projectDesc = [dictionary stringForKey:@"projectDescibe"];
    _projectLogo = [dictionary stringForKey:@"projectLogo"];
    _projectType = [dictionary stringForKey:@"projectType"];
    if([_projectType isEqualToString:@"1"]){
        _projectLogo = SLHTTPServerImageURL(_projectLogo, SLHTTPServerImageKindUserAvatar);
    }else{
        _projectLogo = SLHTTPServerImageURL(_projectLogo, SLHTTPServerImageKindEnterpriseLogo);
    }
    _projectPrice = [dictionary stringForKey:@"projectPrice"];
    _projectTag = [[dictionary stringForKey:@"projectTags"] componentsSeparatedByString:@","];
    _projectEndTime = [SLTimeStampHandler stringWithTimeStamp:[dictionary doubleForKey:@"projectEndTime"] formatter:@"yyyy.MM.dd"];
    
    _projectPublisher = [NSString stringWithFormat:@"%@%@", [dictionary stringForKey:@"projectPublishName"], [dictionary stringForKey:@"projectPublishCompanyName"]];
}

@end
