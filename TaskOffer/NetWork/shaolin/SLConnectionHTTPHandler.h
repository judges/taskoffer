//
//  SLConnectionHTTPHandler.h
//  TaskOffer
//
//  Created by wshaolin on 15/3/23.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLHTTPFileData.h"
#import "SLHTTPServerHandler.h"

#define SLConnectionHTTPHandlerRequestPageSize 20

FOUNDATION_EXPORT NSString *const kSLSystemDictionaryOptionTypePrice;
FOUNDATION_EXPORT NSString *const kSLSystemDictionaryOptionTypeCompanySize;

@class SLConnectionDetailModel, SLCaseDetailFrameModel, SLCaseDetailModel, SLSelectTagFrameModel;

@interface SLConnectionHTTPHandler : NSObject

+ (void)GETWithURL:(NSString *)url
        parameters:(NSDictionary *)parameters
showProgressInView:(UIView *)view
    isHideProgress:(BOOL)isHideProgress
           success:(void (^)(NSDictionary *dataDictionary))success
           failure:(void (^)(NSString *errorMessage))failure;

+ (void)POSTWithURL:(NSString *)url
         parameters:(NSDictionary *)parameters
 showProgressInView:(UIView *)view
     isHideProgress:(BOOL)isHideProgress
            success:(void (^)(NSDictionary *dataDictionary))success
            failure:(void (^)(NSString *errorMessage))failure;

+ (void)POSTWithURL:(NSString *)url
         parameters:(NSDictionary *)parameters
              datas:(NSArray *)datas
 showProgressInView:(UIView *)view
     isHideProgress:(BOOL)isHideProgress
            success:(void (^)(NSDictionary *dataDictionary))success
            failure:(void (^)(NSString *errorMessage))failure;

+ (void)PUTWithURL:(NSString *)url
        parameters:(NSDictionary *)parameters
showProgressInView:(UIView *)view
    isHideProgress:(BOOL)isHideProgress
           success:(void (^)(NSDictionary *dataDictionary))success
           failure:(void (^)(NSString *errorMessage))failure;

#pragma mark - 人脉列表

+ (void)POSTConnectionListWithParameters:(NSDictionary *)parameters
                                 success:(void (^)(NSArray *dataArray))success
                                 failure:(void (^)(NSString *errorMessage))failure;

#pragma mark - 人脉详情

+ (void)POSTConnectionDetailWithUserID:(NSString *)userID
                               success:(void (^)(SLConnectionDetailModel *connectionDetailModel))success
                               failure:(void (^)(NSString *errorMessage))failure;

#pragma mark - 案例列表

+ (void)POSTCaseListWithParameters:(NSDictionary *)parameters
                showProgressInView:(UIView *)view
                           success:(void (^)(NSArray *dataArray))success
                           failure:(void (^)(NSString *errorMessage))failure;

#pragma mark - 案例详情

+ (void)POSTCaseDetailWithCaseID:(NSString *)caseID
              showProgressInView:(UIView *)view
                         success:(void (^)(SLCaseDetailFrameModel *caseDetailFrameModel))success
                         failure:(void (^)(NSString *errorMessage))failure;

#pragma mark - 项目列表

+ (void)POSTProjectListWithParameters:(NSDictionary *)parameters
                   showProgressInView:(UIView *)view
                              success:(void (^)(NSArray *dataArray))success
                              failure:(void (^)(NSString *errorMessage))failure;

#pragma mark - 收藏的案例列表

+ (void)POSTCollectionCaseListWithParameters:(NSDictionary *)parameters
                          showProgressInView:(UIView *)view
                                     success:(void (^)(NSArray *dataArray))success
                                     failure:(void (^)(NSString *errorMessage))failure;

#pragma mark - 收藏案例

+ (void)POSTCollectCaseWithParameters:(NSDictionary *)parameters
                   showProgressInView:(UIView *)view
                              success:(void (^)(NSString *collectionID))success
                              failure:(void (^)(NSString *errorMessage))failure;

#pragma mark - 发布案例

+ (void)POSTPublishCaseWithParameters:(NSDictionary *)parameters
                   showProgressInView:(UIView *)view
                              success:(void (^)(SLCaseDetailModel *caseDetailModel))success
                              failure:(void (^)(NSString *errorMessage))failure;

#pragma mark - 修改案例

+ (void)POSTModifyCaseWithParameters:(NSDictionary *)parameters
                  showProgressInView:(UIView *)view
                             success:(void (^)(SLCaseDetailModel *caseDetailModel))success
                             failure:(void (^)(NSString *errorMessage))failure;

#pragma mark - 上传图片

+ (void)POSTUploadImageWithUploadImageKind:(SLHTTPServerImageKind)imageKind
                                imgaeDatas:(NSArray *)datas
                        showProgressInView:(UIView *)view
                                   success:(void (^)(NSString *imageName))success
                                   failure:(void (^)(NSString *errorMessage))failure;

#pragma mark - 取消收藏

+ (void)POSTCancelCollectionWithCollectID:(NSString *)collectID
                       showProgressInView:(UIView *)view
                                  success:(void (^)(void))success
                                  failure:(void (^)(NSString *errorMessage))failure;

#pragma mark - 系统字典项

+ (void)POSTSystemDictionaryOptionWithOptionType:(NSString *)optionType
                              showProgressInView:(UIView *)view
                                         success:(void (^)(NSArray *dataArray))success
                                         failure:(void (^)(NSString *errorMessage))failure;

#pragma mark - 是否允许陌生人发起聊天

+ (void)POSTAllowChatWithParameters:(NSDictionary *)parameters
                            success:(void (^)(BOOL isAllow, NSString *message))success
                            failure:(void (^)(NSString *errorMessage))failure;

#pragma mark - 查询企业认证员工

+ (void)POSTCompanyAuthenticationEmployeeWithParameters:(NSDictionary *)parameters
                                                success:(void (^)(NSArray *dataArray))success
                                                failure:(void (^)(NSString *errorMessage))failure;

#pragma mark - 查询所有标签

+ (void)GETTAllTagsWithSuccess:(void (^)(SLSelectTagFrameModel *selectTagFrameModel))success
                       failure:(void (^)(NSString *errorMessage))failure;

@end
