//
//  SLHTTPHandler.h
//  TaskOffer
//
//  Created by wshaolin on 15/3/24.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SLHTTPHandlerRequestTimeoutInterval 15.0 // 超时时间

FOUNDATION_EXPORT NSInteger const kSLHTTPHandlerRequestFailureCustomCode;
FOUNDATION_EXPORT NSString *const kSLHTTPHandlerRequestFailureCustomUserInfoKey;

@interface SLHTTPHandler : NSObject

/**
 *  GET方式请求数据
 *
 *  @param url                  请求URL
 *  @param parameters           请求参数
 *  @param showProgressInView   显示网络加载提示框的view，为nil时显示在window上
 *  @param isHideProgress       是否隐藏数据加载提示框
 *  @param success              请求成功的回调
 *  @param failure              请求失败的回调
 */
+ (void)GETWithURL:(NSString *)url parameters:(NSDictionary *)parameters showProgressInView:(UIView *)view isHideProgress:(BOOL)isHideProgress success:(void (^)(NSDictionary *dataDictionary))success failure:(void (^)(NSError *error))failure;

/**
 *  POST方式请求数据
 *
 *  @param url                  请求URL
 *  @param parameters           请求参数
 *  @param showProgressInView   显示网络加载提示框的view，为nil时显示在window上
 *  @param isHideProgress       是否隐藏数据加载提示框
 *  @param success              请求成功的回调
 *  @param failure              请求失败的回调
 */
+ (void)POSTWithURL:(NSString *)url parameters:(NSDictionary *)parameters showProgressInView:(UIView *)view isHideProgress:(BOOL)isHideProgress success:(void (^)(NSDictionary *dataDictionary))success failure:(void (^)(NSError *error))failure;

/**
 *  POST方式请求数据
 *
 *  @param url                  请求URL
 *  @param parameters           请求的基本参数
 *  @param datas                文件数据，为SLHTTPFileData类型的数组，如果数组中的元素类型错误，则抛出异常
 *  @param showProgressInView   显示网络加载提示框的view，为nil时显示在window上
 *  @param isHideProgress       是否隐藏数据加载提示框
 *  @param success              请求成功的回调
 *  @param failure              请求失败的回调
 */
+ (void)POSTWithURL:(NSString *)url parameters:(NSDictionary *)parameters datas:(NSArray *)datas showProgressInView:(UIView *)view isHideProgress:(BOOL)isHideProgress success:(void (^)(NSDictionary *dataDictionary))success failure:(void (^)(NSError *error))failure;

/**
 *  PUT方式请求数据
 *
 *  @param url                  请求URL
 *  @param parameters           请求参数
 *  @param showProgressInView   显示网络加载提示框的view，为nil时显示在window上
 *  @param isHideProgress       是否隐藏数据加载提示框
 *  @param success              请求成功的回调
 *  @param failure              请求失败的回调
 */
+ (void)PUTWithURL:(NSString *)url parameters:(NSDictionary *)parameters showProgressInView:(UIView *)view isHideProgress:(BOOL)isHideProgress success:(void (^)(NSDictionary *dataDictionary))success failure:(void (^)(NSError *error))failure;

/**
 *  取消所有请求
 *
 */
+ (void)cancelAllRequest;

/**
 *  取消当前请求
 *
 */
+ (void)cancelCurrentRequest;

@end
