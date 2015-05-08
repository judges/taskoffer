//
//  SLHttpRequestHandler.h
//  AppFramework
//
//  Created by wshaolin on 14/11/20.
//  Copyright (c) 2014年 wshaolin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define SLHttpRequestTimeoutInterval 10.0f

@class SLHttpRequestHandler;

@protocol SLHttpRequestHandlerDelegate <NSObject>

@optional

/**
 *  数据加载成功的代理
 *
 */
- (void)httpRequestHandler:(SLHttpRequestHandler *)httpRequestHandler didFinishedRequestSuccessData:(NSDictionary *)dataDictionary;

/**
 *  数据加载失败的代理
 *
 */
- (void)httpRequestHandler:(SLHttpRequestHandler *)httpRequestHandler didFinishedRequestFailure:(NSError *)failure;

@end

@interface SLHttpRequestHandler : NSObject

@property (nonatomic, weak) id<SLHttpRequestHandlerDelegate> deledate;
@property (nonatomic, assign) NSInteger maxConcurrentOperationCount;

- (instancetype)initWithDelegate:(id<SLHttpRequestHandlerDelegate>) deledate;

+ (instancetype)httpRequestHandlerWithDelegate:(id<SLHttpRequestHandlerDelegate>) deledate;

/**
 *  GET方式请求数据
 *
 *  @param url                  请求URL
 *  @param parameters           请求参数
 *  @param showProgressInView   显示网络加载提示框的view，为nil时显示在window上
 *  @param isHideProgress       是否隐藏数据加载提示框
 */
- (void)GETWithURL:(NSString *)url parameters:(NSDictionary *)parameters showProgressInView:(UIView *)view isHideProgress:(BOOL)isHideProgress;

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
 *  GET方式请求数据
 *
 *  @param url                  请求URL
 *  @param parameters           请求参数
 *  @param showProgressInView   显示网络加载提示框的view，为nil时显示在window上
 *  @param isHideProgress       是否隐藏数据加载提示框
 *  @param success              请求成功的回调
 *  @param failure              请求失败的回调
 */
+ (void)GETWithURL:(NSString *)url success:(void (^)(NSString *wavName))success failure:(void (^)(NSError *error))failure;


/**
 *  POST方式请求数据
 *
 *  @param url                  请求URL
 *  @param parameters           请求参数
 *  @param showProgressInView   显示网络加载提示框的view，为nil时显示在window上
 *  @param isHideProgress       是否隐藏数据加载提示框
 */
- (void)POSTWithURL:(NSString *)url parameters:(NSDictionary *)parameters showProgressInView:(UIView *)view isHideProgress:(BOOL)isHideProgress;

/**
 *  POST方式请求数据
 *
 *  @param url                  请求URL
 *  @param parameters           请求的基本参数
 *  @param datas                文件数据，为SLHttpFileData类型的数组，如果数组中的元素类型错误，则抛出异常
 *  @param showProgressInView   显示网络加载提示框的view，为nil时显示在window上
 *  @param isHideProgress       是否隐藏数据加载提示框
 */
- (void)POSTWithURL:(NSString *)url parameters:(NSDictionary *)parameters datas:(NSArray *)datas showProgressInView:(UIView *)view isHideProgress:(BOOL)isHideProgress;

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
 *  @param datas                文件数据，为SLHttpFileData类型的数组，如果数组中的元素类型错误，则抛出异常
 *  @param showProgressInView   显示网络加载提示框的view，为nil时显示在window上
 *  @param isHideProgress       是否隐藏数据加载提示框
 *  @param success              请求成功的回调
 *  @param failure              请求失败的回调
 */
+ (void)POSTWithURL:(NSString *)url parameters:(NSDictionary *)parameters datas:(NSArray *)datas showProgressInView:(UIView *)view isHideProgress:(BOOL)isHideProgress success:(void (^)(NSDictionary *dataDictionary))success failure:(void (^)(NSError *error))failure;

@end

// 上传的文件数据
@interface SLHttpFileData : NSObject

@property (nonatomic, strong) NSData *data; // 文件的二进制数据

@property (nonatomic, copy) NSString *parameterName; // 参数名

@property (nonatomic, copy) NSString *fileName; // 文件名称

@property (nonatomic, copy) NSString *mimeType; // 文件的mimeType

@end
