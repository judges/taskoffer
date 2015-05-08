//
//  SLDynamicHTTPHandler.h
//  TaskOffer
//
//  Created by wshaolin on 15/4/7.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SLDynamicHTTPHandlerRequestPageSize 20

@class SLFriendCircleStatusModel, SLFriendCircleStatusCommentModel;

@interface SLDynamicHTTPHandler : NSObject

#pragma -mark 动态列表

/***********************************************************
 ** @parameters:{
 **        username,       // 当前登录用户的id
 **        pageSize,       // 页大小
 **        pageNum         // 当前页号
 ** }
 ***********************************************************/
+ (void)POSTFriendCircleAllMessageListWithParameters:(NSDictionary *)parameters showProgressInView:(UIView *)view success:(void (^)(NSArray *dataArray))success failure:(void (^)(NSString *errorMessage))failure;

#pragma -mark 动态圈（个人）

/***********************************************************
 ** @parameters:{
 **        username,       // 当前登录用户的id
 **        pageSize,       // 页大小
 **        pageNum         // 当前页号
 ** }
 ***********************************************************/
+ (void)POSTFriendCirclePersonMessageListWithParameters:(NSDictionary *)parameters showProgressInView:(UIView *)view success:(void (^)(NSArray *dataArray))success failure:(void (^)(NSString *errorMessage))failure;

#pragma -mark 发布动态

/***********************************************************************
 ** @parameters:{
 **        username,       // 当前登录用户的id
 **        content,        // 消息内容
 **        ishidden        // 可见性（1:所有人可见, 0:好友可见, -1:尽自己可见）
 ** }
 **********************************************************************/
+ (void)POSTFriendCircleSendMessageWithParameters:(NSDictionary *)parameters imageDatas:(NSArray *)imageDatas showProgressInView:(UIView *)view success:(void (^)(void))success failure:(void (^)(NSString *errorMessage))failure;

#pragma -mark 点赞

/***********************************************************
 ** @parameters:{
 **        username,       // 当前登录用户的id
 **        infoId          // 消息id
 ** }
 ***********************************************************/
+ (void)POSTFriendCircleApplaudWithParameters:(NSDictionary *)parameters isCancel:(BOOL)cancel showProgressInView:(UIView *)view success:(void (^)(void))success failure:(void (^)(NSString *errorMessage))failure;

#pragma -mark 评论或回复

/***********************************************************
 ** @parameters:{
 **        username,       // 当前登录用户的id
 **        infoId,         // 消息状态的id
 **        comment,        // 评论内容
 **        parentId        // 评论时值为"", 回复时值为回复的评论id
 ** }
 ***********************************************************/
+ (void)POSTFriendCircleCommentWithParameters:(NSDictionary *)parameters showProgressInView:(UIView *)view success:(void (^)(SLFriendCircleStatusCommentModel *statusCommentModel))success failure:(void (^)(NSString *errorMessage))failure;

#pragma -mark 删除状态

/***********************************************************
 ** @parameters:{
 **        username,       // 当前登录用户的id
 **        infoId,         // 消息状态的id
 ** }
 ***********************************************************/
+ (void)POSTFriendCircleDeleteStatusWithParameters:(NSDictionary *)parameters showProgressInView:(UIView *)view success:(void (^)(void))success failure:(void (^)(NSString *errorMessage))failure;

#pragma -mark 状态详情

/***********************************************************
 ** @parameters:{
 **        username,       // 当前登录用户的id
 **        infoId,         // 消息状态的id
 ** }
 ***********************************************************/
+ (void)POSTFriendCircleStatusDetailWithParameters:(NSDictionary *)parameters showProgressInView:(UIView *)view success:(void (^)(SLFriendCircleStatusModel *friendCircleStatusModel))success failure:(void (^)(NSString *errorMessage))failure;

#pragma -mark 是否有好友的新动态

/***********************************************************
 ** @parameters:{
 **        username,       // 当前登录用户的id
 **        lastTime,       // 上一次的刷新时间
 ** }
 ***********************************************************/
+ (void)POSTFriendCircleHasNewRefreshStatusWithParameters:(NSDictionary *)parameters showProgressInView:(UIView *)view success:(void (^)(BOOL isRefresh))success failure:(void (^)(NSString *errorMessage))failure;

@end
