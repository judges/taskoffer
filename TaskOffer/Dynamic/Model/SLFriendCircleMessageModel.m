//
//  SLFriendCircleMessageModel.m
//  XMPPIM
//
//  Created by wshaolin on 14/12/27.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import "SLFriendCircleMessageModel.h"
#import "NSString+Conveniently.h"
#import "NSDate+Conveniently.h"
#import "NSDictionary+NullFilter.h"
#import "SLHTTPServerHandler.h"

@implementation SLFriendCircleMessageModel

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
    _messageId = [dictionary stringForKey:@"id"];
    _statusId = [dictionary stringForKey:@"status_id"];
    _messageType = (int)[dictionary integerForKey:@"message_type"];
    _messageContent = [dictionary stringForKey:@"message_content"];
    _statusContent = [dictionary stringForKey:@"status_content"];
    _imageUrls = [dictionary arrayForKey:@"status_urls"];
    if(_imageUrls != nil && _imageUrls.count > 0){
        for(NSString *url in _imageUrls){
            if(url.length > 0){
                _firstImageUrl = url;
                break;
            }
        }
    }
    
    _messageDate = [dictionary stringForKey:@"messagedate"];
    _isRead = [dictionary boolForKey:@"is_read"];
    
    NSDate *formatDate = [_messageDate dateWithDefaultFormat];
    if([formatDate isToday]){
        _formatDate = [formatDate stringWithFormat:@"HH:mm"];
    }else if([formatDate isThisYear]){
       _formatDate = [formatDate stringWithFormat:@"MM月dd日 HH:mm"];
    }else{
        _formatDate = [formatDate stringWithFormat:@"yyyy年MM月dd日 HH:mm"];
    }
}

@end
