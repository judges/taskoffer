//
//  SLPostionModel.m
//  XMPPIM
//
//  Created by wshaolin on 14/12/26.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import "SLPostionModel.h"

@implementation SLPostionModel

+ (instancetype)modelWithLocationCoordinate:(CLLocationCoordinate2D)locationCoordinate postionName:(NSString *)postionName{
    return [[self alloc] initWithLocationCoordinate:locationCoordinate postionName:postionName];
}

- (instancetype)initWithLocationCoordinate:(CLLocationCoordinate2D)locationCoordinate postionName:(NSString *)postionName{
    if(self = [super init]){
        _locationCoordinate = locationCoordinate;
        _postionName = postionName;
        _latitude = [NSString stringWithFormat:@"%f", locationCoordinate.latitude];
        _longitude = [NSString stringWithFormat:@"%f", locationCoordinate.longitude];
    }
    return self;
}

@end
