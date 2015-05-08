//
//  SLSettingModel.m
//  TaskOffer
//
//  Created by wshaolin on 15/4/28.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLSettingModel.h"

@implementation SLSettingModel

+ (instancetype)modelWithIcon:(UIImage *)icon title:(NSString *)title{
    return [[self alloc] initWithIcon:icon title:title];
}

- (instancetype)initWithIcon:(UIImage *)icon title:(NSString *)title{
    if(self = [super init]){
        _icon = icon;
        _title = title;
    }
    return self;
}

@end
