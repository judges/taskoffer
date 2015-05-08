//
//  SLFriendCircleStatusModel.h
//  XMPPIM
//
//  Created by wshaolin on 14/12/17.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLFriendCircleStatusCommentFrameModel.h"
#import "SLFriendCircleUserModel.h"

typedef NS_ENUM(NSInteger, SLFriendCircleStatusModelMessageType){
    SLFriendCircleStatusModelMessageTypeOriginal = 1, // 原创
    SLFriendCircleStatusModelMessageTypeForward = 2 // 转发
};

@interface SLFriendCircleStatusModel : NSObject

@property (nonatomic, copy, readonly) NSString *statusId;
@property (nonatomic, strong, readonly) SLFriendCircleUserModel *userModel;

@property (nonatomic, copy, readonly) NSString *originalDateTime;
@property (nonatomic, copy, readonly) NSString *formatDateTime;
@property (nonatomic, copy, readonly) NSString *dayLinkMonth;

@property (nonatomic, copy, readonly) NSString *companyAndJob;

@property (nonatomic, copy, readonly) NSString *content;
@property (nonatomic, strong, readonly) NSArray *imageUrls;
@property (nonatomic, assign, readonly) SLFriendCircleStatusModelMessageType messageType;
@property (nonatomic, assign, readonly) BOOL applauded; // 当前登录人是否点过赞
@property (nonatomic, copy, readonly) NSString *position;

@property (nonatomic, strong) NSArray *commentArray; // 评论
@property (nonatomic, copy, readonly) NSAttributedString *applaudNicknameString; // 点赞人的昵称字符串
@property (nonatomic, copy, readonly) NSString *allApplaudNicknameString;

@property (nonatomic, strong) NSArray *applaudUsernameArray; // 点赞人的用户名数组
@property (nonatomic, strong) NSArray *applaudNicknameArray; // 点赞人的昵称数组

@property (nonatomic, assign, readonly) NSInteger applaudCount;
@property (nonatomic, assign, readonly) NSInteger commtentCount;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary;

- (void)setFriendCircleUserModel:(SLFriendCircleUserModel *)userModel;

@end
