//
//  SLFriendCircleStatusCommentModel.m
//  XMPPIM
//
//  Created by wshaolin on 14/12/19.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import "SLFriendCircleStatusCommentModel.h"
#import "NSDictionary+NullFilter.h"
#import "NSString+Conveniently.h"
#import "NSDate+Conveniently.h"
#import "SLHTTPServerHandler.h"

@implementation SLFriendCircleStatusCommentModel

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
    _commentId = [dictionary stringForKey:@"id"];
    _statusId = [dictionary stringForKey:@"infoId"];
    _parentId = [[dictionary stringForKey:@"parentId"] trim];
    
    NSString *replyTo = [dictionary stringForKey:@"replyTo"];
    NSString *replyDisplayName = [dictionary stringForKey:@"replyToRemark"];
    if(replyDisplayName.length == 0){
        replyDisplayName = [dictionary stringForKey:@"replyToNick"];
    }
    _recipientUserModel = [[SLFriendCircleUserModel alloc] initWithUsername:replyTo displayName:replyDisplayName iconURL:nil];
    
    NSString *username = [dictionary stringForKey:@"username"];
    NSString *displayName = [dictionary stringForKey:@"nickname"];
    if(displayName.length == 0){
        displayName = [dictionary stringForKey:@"remarkname"];
    }
    NSString *iconURL = SLHTTPServerImageURL([dictionary stringForKey:@"headerPic"], SLHTTPServerImageKindUserAvatar);
    _senderUserModel = [[SLFriendCircleUserModel alloc] initWithUsername:username displayName:displayName iconURL:iconURL];
    
    if(_parentId.length == 0 || [_parentId isEqualToString:@"0"] || replyTo.length == 0){
        _messageType = SLFriendCircleStatusCommentModelMessageTypeComment;
    }else{
        _messageType = SLFriendCircleStatusCommentModelMessageTypeReply;
    }
    
    _commentContent = [dictionary stringForKey:@"comment"];
    _dateTime = [dictionary stringForKey:@"createTime"];
    _formatDateTime = [[_dateTime dateWithDefaultFormat] intervalTime];
}

- (void)setCommentId:(NSString *)commentId{
    if(_commentId == nil || _commentId.length == 0){
        _commentId = commentId;
    }
}

@end
