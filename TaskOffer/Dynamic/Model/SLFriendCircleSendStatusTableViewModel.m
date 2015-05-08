//
//  SLFriendCircleSendStatusTableViewModel.m
//  XMPPIM
//
//  Created by wshaolin on 14/12/25.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import "SLFriendCircleSendStatusTableViewModel.h"

@implementation SLFriendCircleSendStatusTableViewModel

+ (instancetype)modelWithTitle:(NSString *)title iconName:(NSString *)iconName{
    return [[self alloc] initWithTitle:title iconName:iconName];
}

- (instancetype)initWithTitle:(NSString *)title iconName:(NSString *)iconName{
    if(self = [super init]){
        _title = title;
        _iconName = iconName;
    }
    return self;
}

@end
