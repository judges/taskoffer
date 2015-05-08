//
//  SLFriendCircleMessageModel.h
//  XMPPIM
//
//  Created by wshaolin on 14/12/27.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLFriendCircleUserModel.h"

typedef enum{
    SLFriendCircleMessageTypeApplaud, // 点赞
    SLFriendCircleMessageTypeContent // 文本内容
}SLFriendCircleMessageType;

@interface SLFriendCircleMessageModel : NSObject

@property (nonatomic, copy, readonly) NSString *messageId;
@property (nonatomic, copy, readonly) NSString *statusId;
@property (nonatomic, strong, readonly) SLFriendCircleUserModel *userModel;
@property (nonatomic, copy, readonly) NSString *messageContent;
@property (nonatomic, copy, readonly) NSString *statusContent;
@property (nonatomic, copy, readonly) NSString *firstImageUrl;
@property (nonatomic, assign, readonly) NSArray *imageUrls;
@property (nonatomic, copy, readonly) NSString *messageDate;
@property (nonatomic, copy, readonly) NSString *formatDate;
@property (nonatomic, assign, readonly) SLFriendCircleMessageType messageType;
@property (nonatomic, assign, readonly) BOOL isRead; // 是否已读

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary;

@end
