//
//  SLFriendCirclePersonStatusModel.m
//  XMPPIM
//
//  Created by wshaolin on 14/12/26.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import "SLFriendCirclePersonStatusModel.h"
#import "NSDictionary+NullFilter.h"
#import "NSString+Conveniently.h"
#import "NSDate+Conveniently.h"
#import "SLHTTPServerHandler.h"

@implementation SLFriendCirclePersonStatusModel

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
    _dateTime = [dictionary stringForKey:@"datetime"];
    _position = [dictionary stringForKey:@"position"];
    _imageUrl = [dictionary arrayForKey:@"imageurl"];
    _content = [dictionary stringForKey:@"content"];
    _content = [_content trimWhitespaceAndNewlineCharacterSet];
    NSDate *date = [_dateTime dateWithDefaultFormat];
    _dayLinkMonth = [date dayLinkMonth];
}

@end
