//
//  SLFriendCircleStatusCommentModel.h
//  XMPPIM
//
//  Created by wshaolin on 14/12/19.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLFriendCircleUserModel.h"

typedef NS_ENUM(NSInteger, SLFriendCircleStatusCommentModelMessageType){
    SLFriendCircleStatusCommentModelMessageTypeComment, // 评论
    SLFriendCircleStatusCommentModelMessageTypeReply // 回复
};

@interface SLFriendCircleStatusCommentModel : NSObject

@property (nonatomic, copy, readonly) NSString *commentId;
@property (nonatomic, copy, readonly) NSString *statusId;
@property (nonatomic, copy, readonly) NSString *parentId;
@property (nonatomic, assign, readonly) SLFriendCircleStatusCommentModelMessageType messageType;

@property (nonatomic, strong, readonly) SLFriendCircleUserModel *senderUserModel;
@property (nonatomic, strong, readonly) SLFriendCircleUserModel *recipientUserModel;

@property (nonatomic, copy, readonly) NSString *commentContent;
@property (nonatomic, copy, readonly) NSString *dateTime;
@property (nonatomic, copy, readonly) NSString *formatDateTime;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary;

- (void)setCommentId:(NSString *)commentId;

@end
