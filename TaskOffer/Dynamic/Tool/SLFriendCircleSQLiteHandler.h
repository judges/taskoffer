//
//  SLFriendCircleSQLiteHandler.h
//  XMPPIM
//
//  Created by wshaolin on 15/1/5.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SLFriendCircleStatusModel, SLFriendCircleStatusCommentModel, SLFriendCircleMessageModel;

@interface SLFriendCircleSQLiteHandler : NSObject

+ (BOOL)insertWithStatusModel:(SLFriendCircleStatusModel *)statusModel;
+ (BOOL)updateWithStatusModel:(SLFriendCircleStatusModel *)statusModel;
+ (BOOL)deleteWithStatusModelId:(NSString *)statusModelId;
+ (SLFriendCircleStatusModel *)statusModelWithId:(NSString *)statusModelId;

// 数组中为SLFriendCircleStatusFrameModel
+ (NSArray *)statusFrameModelsWithParameters:(NSDictionary *)parameters;
+ (NSArray *)personFrameStatusModelsWithParameters:(NSDictionary *)parameters;

+ (BOOL)insertWithStatusCommentModel:(SLFriendCircleStatusCommentModel *)statusCommentModel;
+ (BOOL)deleteWithStatusCommentModelId:(NSString *)statusCommentModelId;

// 数组中为SLFriendCircleStatusCommentFrameModel，未实现
+ (NSArray *)statusCommentModelsWithParameters:(NSDictionary *)parameters;

+ (BOOL)insertWithMessageModel:(SLFriendCircleMessageModel *)messageModel;
+ (BOOL)deleteWithMessageModelId:(NSString *)messageModelId; // messageModelId为nil时清空整个表
+ (BOOL)updateAllUnreadMessageToRead; // 设置所有未读消息为已读
+ (NSInteger)allUnreadMessageCount; // 所有未读消息数量
+ (NSInteger)allMessageCount; // 所有消息的数量
+ (NSArray *)messageFrameModelWithParameters:(NSDictionary *)parameters;

@end
