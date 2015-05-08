//
//  SLConnectionHTTPHandler.m
//  TaskOffer
//
//  Created by wshaolin on 15/3/23.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLConnectionHTTPHandler.h"
#import "SLHTTPHandler.h"
#import "SLConnectionURL.h"
#import "NSDictionary+NullFilter.h"
#import "SLConnectionFrameModel.h"
#import "SLConnectionDetailModel.h"
#import "SLProjectModel.h"
#import "SLCaseDetailFrameModel.h"
#import "SLProjectModel.h"
#import "SLOptionModel.h"
#import "SLPersonalCaseFrameModel.h"
#import "SLSelectTagFrameModel.h"

NSString *const kSLSystemDictionaryOptionTypePrice = @"TO_PROJECT_PRICE";
NSString *const kSLSystemDictionaryOptionTypeCompanySize = @"TO_USER_COMPANY_SIZE";

@implementation SLConnectionHTTPHandler

+ (void)GETWithURL:(NSString *)url parameters:(NSDictionary *)parameters showProgressInView:(UIView *)view isHideProgress:(BOOL)isHideProgress success:(void (^)(NSDictionary *))success failure:(void (^)(NSString *))failure{
    [SLHTTPHandler GETWithURL:url parameters:parameters showProgressInView:view isHideProgress:isHideProgress success:^(NSDictionary *dataDictionary) {
        if(success){
            success(dataDictionary);
        }
    } failure:^(NSError *error) {
        if(failure){
            if(error.code == kSLHTTPHandlerRequestFailureCustomCode){
                failure([error.userInfo stringForKey:kSLHTTPHandlerRequestFailureCustomUserInfoKey]);
            }else{
                failure([error localizedDescription]);
            }
        }
    }];
}

+ (void)POSTWithURL:(NSString *)url parameters:(NSDictionary *)parameters showProgressInView:(UIView *)view isHideProgress:(BOOL)isHideProgress success:(void (^)(NSDictionary *))success failure:(void (^)(NSString *))failure{
    [SLHTTPHandler POSTWithURL:url parameters:parameters showProgressInView:view isHideProgress:isHideProgress success:^(NSDictionary *dataDictionary) {
        if(success){
            success(dataDictionary);
        }
    } failure:^(NSError *error) {
        if(failure){
            if(error.code == kSLHTTPHandlerRequestFailureCustomCode){
                failure([error.userInfo stringForKey:kSLHTTPHandlerRequestFailureCustomUserInfoKey]);
            }else{
                failure([error localizedDescription]);
            }
        }
    }];
}

+ (void)POSTWithURL:(NSString *)url parameters:(NSDictionary *)parameters datas:(NSArray *)datas showProgressInView:(UIView *)view isHideProgress:(BOOL)isHideProgress success:(void (^)(NSDictionary *))success failure:(void (^)(NSString *))failure{
    [SLHTTPHandler POSTWithURL:url parameters:parameters datas:datas showProgressInView:view isHideProgress:isHideProgress success:^(NSDictionary *dataDictionary) {
        if(success){
            success(dataDictionary);
        }
    } failure:^(NSError *error) {
        if(failure){
            if(error.code == kSLHTTPHandlerRequestFailureCustomCode){
                failure([error.userInfo stringForKey:kSLHTTPHandlerRequestFailureCustomUserInfoKey]);
            }else{
                failure([error localizedDescription]);
            }
        }
    }];
}

+ (void)PUTWithURL:(NSString *)url parameters:(NSDictionary *)parameters showProgressInView:(UIView *)view isHideProgress:(BOOL)isHideProgress success:(void (^)(NSDictionary *))success failure:(void (^)(NSString *))failure{
    [SLHTTPHandler PUTWithURL:url parameters:parameters showProgressInView:view isHideProgress:isHideProgress success:^(NSDictionary *dataDictionary) {
        if(success){
            success(dataDictionary);
        }
    } failure:^(NSError *error) {
        if(failure){
            if(error.code == kSLHTTPHandlerRequestFailureCustomCode){
                failure([error.userInfo stringForKey:kSLHTTPHandlerRequestFailureCustomUserInfoKey]);
            }else{
                failure([error localizedDescription]);
            }
        }
    }];
}

+ (void)POSTConnectionListWithParameters:(NSDictionary *)parameters success:(void (^)(NSArray *))success failure:(void (^)(NSString *))failure{
    [self POSTWithURL:API_CONNECTION_LIST_URL parameters:parameters showProgressInView:nil isHideProgress:YES success:^(NSDictionary *dataDictionary) {
        if(success){
            NSArray *dataArray = [dataDictionary arrayForKey:@"info"];
            NSMutableArray *tempArray = [NSMutableArray array];
            for(NSDictionary *dictionary in dataArray){
                SLConnectionModel *connectionModel = [[SLConnectionModel alloc] initWithDictionary:dictionary];
                SLConnectionFrameModel *connectionFrameModel = [[SLConnectionFrameModel alloc] initWithConnectionModel:connectionModel];
                [tempArray addObject:connectionFrameModel];
            }
            success([tempArray copy]);
        }
    } failure:^(NSString *errorMessage) {
        if(failure){
            failure(errorMessage);
        }
    }];
}

+ (void)POSTConnectionDetailWithUserID:(NSString *)userID success:(void (^)(SLConnectionDetailModel *))success failure:(void (^)(NSString *))failure{
    [self POSTWithURL:API_CONNECTION_DETAIL_URL parameters:@{@"id" : userID, @"type" : @"1"} showProgressInView:nil isHideProgress:NO success:^(NSDictionary *dataDictionary) {
        if(success){
            NSDictionary *dictionary = [dataDictionary dictionaryForKey:@"info"];
            SLConnectionDetailModel *connectionDetailModel = [[SLConnectionDetailModel alloc] initWithDictionary:dictionary];
            success(connectionDetailModel);
        }
    } failure:^(NSString *errorMessage) {
        if(failure){
            failure(errorMessage);
        }
    }];
}

+ (void)POSTCaseListWithParameters:(NSDictionary *)parameters showProgressInView:(UIView *)view success:(void (^)(NSArray *))success failure:(void (^)(NSString *))failure{
    [self POSTWithURL:API_CONNECTION_CASE_LIST_URL parameters:parameters showProgressInView:view isHideProgress:YES success:^(NSDictionary *dataDictionary) {
        if(success){
            dataDictionary = [dataDictionary dictionaryForKey:@"info"];
            NSArray *dataArray = [dataDictionary arrayForKey:@"rows"];
            NSMutableArray *tempArray = [NSMutableArray array];
            for(NSDictionary *dictionary in dataArray){
                SLCaseDetailModel *caseDetailModel = [[SLCaseDetailModel alloc] initWithDictionary:dictionary];
                SLPersonalCaseFrameModel *personalCaseFrameModel = [[SLPersonalCaseFrameModel alloc] initWithCaseDetailModel:caseDetailModel];
                [tempArray addObject:personalCaseFrameModel];
            }
            success([tempArray copy]);
        }
    } failure:^(NSString *errorMessage) {
        if(failure){
            failure(errorMessage);
        }
    }];
}

+ (void)POSTCaseDetailWithCaseID:(NSString *)caseID showProgressInView:(UIView *)view success:(void (^)(SLCaseDetailFrameModel *))success failure:(void (^)(NSString *))failure{
    [self POSTWithURL:API_CONNECTION_CASE_DETAIL_URL parameters:@{@"caseId" : caseID, @"userId" : [UserInfo sharedInfo].userID} showProgressInView:view isHideProgress:NO success:^(NSDictionary *dataDictionary) {
        if(success){
            dataDictionary = [dataDictionary dictionaryForKey:@"info"];
            NSDictionary *dictionary = [dataDictionary dictionaryForKey:@"serverCases"];
            SLCaseDetailModel *caseDetailModel = [[SLCaseDetailModel alloc] initWithDictionary:dictionary];
            [caseDetailModel setCollectId:[dataDictionary stringForKey:@"collectId"]];
            [caseDetailModel setCollected:[dataDictionary boolForKey:@"isCollect"]];
            SLCaseDetailFrameModel *caseDetailFrameModel = [[SLCaseDetailFrameModel alloc] initWithCaseDetailModel:caseDetailModel];
            success(caseDetailFrameModel);
        }
    } failure:^(NSString *errorMessage) {
        
    }];
}

+ (void)POSTProjectListWithParameters:(NSDictionary *)parameters showProgressInView:(UIView *)view success:(void (^)(NSArray *))success failure:(void (^)(NSString *))failure{
    [self POSTWithURL:API_CONNECTION_DETAIL_PROJECT_LIST_URL parameters:parameters showProgressInView:view isHideProgress:YES success:^(NSDictionary *dataDictionary) {
        if(success){
            dataDictionary = [dataDictionary dictionaryForKey:@"info"];
            NSArray *dataArray = [dataDictionary arrayForKey:@"rows"];
            NSMutableArray *tempArray = [NSMutableArray array];
            for(NSDictionary *dictionary in dataArray){
                SLProjectModel *projectModel = [[SLProjectModel alloc] initWithDictionary:dictionary];
                [tempArray addObject:projectModel];
            }
            success([tempArray copy]);
        }
    } failure:^(NSString *errorMessage) {
        if(failure){
            failure(errorMessage);
        }
    }];
}

+ (void)POSTCollectionCaseListWithParameters:(NSDictionary *)parameters showProgressInView:(UIView *)view success:(void (^)(NSArray *))success failure:(void (^)(NSString *))failure{
    [self POSTWithURL:API_CONNECTION_COLLECTION_CASE_LIST_URL parameters:parameters showProgressInView:view isHideProgress:YES success:^(NSDictionary *dataDictionary) {
        if(success){
            dataDictionary = [dataDictionary dictionaryForKey:@"info"];
            NSArray *dataArray = [dataDictionary arrayForKey:@"rows"];
            NSMutableArray *tempArray = [NSMutableArray array];
            for(NSDictionary *dictionary in dataArray){
                SLCaseDetailModel *caseDetailModel = [[SLCaseDetailModel alloc] initWithDictionary:dictionary];
                SLPersonalCaseFrameModel *personalCaseFrameModel = [[SLPersonalCaseFrameModel alloc] initWithCaseDetailModel:caseDetailModel];
                [tempArray addObject:personalCaseFrameModel];
            }
            success([tempArray copy]);
        }
    } failure:^(NSString *errorMessage) {
        if(failure){
            failure(errorMessage);
        }
    }];
}

+ (void)POSTCollectCaseWithParameters:(NSDictionary *)parameters showProgressInView:(UIView *)view success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure{
    [self POSTWithURL:API_CONNECTION_COLLECT_CASE_URL parameters:parameters showProgressInView:view isHideProgress:NO success:^(NSDictionary *dataDictionary) {
        if(success){
            success([dataDictionary stringForKey:@"info"]);
        }
    } failure:^(NSString *errorMessage) {
        if(failure){
            failure(errorMessage);
        }
    }];
}

+ (void)POSTPublishCaseWithParameters:(NSDictionary *)parameters showProgressInView:(UIView *)view success:(void (^)(SLCaseDetailModel *))success failure:(void (^)(NSString *))failure{
    [self POSTWithURL:API_CONNECTION_PUBLISH_CASE_URL parameters:parameters showProgressInView:view isHideProgress:NO success:^(NSDictionary *dataDictionary) {
        if(success){
            success(nil);
        }
    } failure:^(NSString *errorMessage) {
        if(failure){
            failure(errorMessage);
        }
    }];
}

+ (void)POSTModifyCaseWithParameters:(NSDictionary *)parameters showProgressInView:(UIView *)view success:(void (^)(SLCaseDetailModel *))success failure:(void (^)(NSString *))failure{
    [self POSTWithURL:API_CONNECTION_MODIFY_CASE_URL parameters:parameters showProgressInView:view isHideProgress:NO success:^(NSDictionary *dataDictionary) {
        if(success){
            success(nil);
        }
    } failure:^(NSString *errorMessage) {
        if(failure){
            failure(errorMessage);
        }
    }];
}

+ (void)POSTUploadImageWithUploadImageKind:(SLHTTPServerImageKind)imageKind imgaeDatas:(NSArray *)datas showProgressInView:(UIView *)view success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure{
    [self POSTWithURL:API_CONNECTION_UPLOAD_IMAGE_URL parameters:@{@"type" : [NSString stringWithFormat:@"%ld", (long)imageKind]} datas:datas showProgressInView:view isHideProgress:NO success:^(NSDictionary *dataDictionary) {
        if(success){
            success([dataDictionary stringForKey:@"info"]);
        }
    } failure:^(NSString *errorMessage) {
        if(failure){
            failure(errorMessage);
        }
    }];
}

+ (void)POSTCancelCollectionWithCollectID:(NSString *)collectID showProgressInView:(UIView *)view success:(void (^)(void))success failure:(void (^)(NSString *))failure{
    [self POSTWithURL:API_CONNECTION_CANCEL_COLLECTION_URL parameters:@{@"collectId" : collectID} showProgressInView:view isHideProgress:NO success:^(NSDictionary *dataDictionary) {
        if(success){
            success();
        }
    } failure:^(NSString *errorMessage) {
        if(failure){
            failure(errorMessage);
        }
    }];
}

+ (void)POSTSystemDictionaryOptionWithOptionType:(NSString *)optionType showProgressInView:(UIView *)view success:(void (^)(NSArray *))success failure:(void (^)(NSString *))failure{
    [self POSTWithURL:API_CONNECTION_SYSTEM_DICTIONARY_OPTION_URL parameters:@{@"parentId" : optionType} showProgressInView:view isHideProgress:NO success:^(NSDictionary *dataDictionary) {
        if(success){
            NSArray *dataArray = [dataDictionary arrayForKey:@"info"];
            NSMutableArray *tempArray = [NSMutableArray array];
            for(NSDictionary *dictionary in dataArray){
                SLOptionModel *optionModel = [[SLOptionModel alloc] initWithDictionary:dictionary];
                [tempArray addObject:optionModel];
            }
            success([tempArray copy]);
        }
    } failure:^(NSString *errorMessage) {
        if(failure){
            failure(errorMessage);
        }
    }];
}

+ (void)POSTAllowChatWithParameters:(NSDictionary *)parameters success:(void (^)(BOOL, NSString *))success failure:(void (^)(NSString *))failure{
    [SLHTTPHandler POSTWithURL:API_CONNECTION_ALLOW_CHAT_WITH_STRANGER_URL parameters:parameters showProgressInView:nil isHideProgress:NO success:^(NSDictionary *dataDictionary) {
        if(success){
            success(YES, nil);
        }
    } failure:^(NSError *error) {
        if(error.code == kSLHTTPHandlerRequestFailureCustomCode){
            if(success){
                success(NO, [error.userInfo stringForKey:kSLHTTPHandlerRequestFailureCustomUserInfoKey]);
            }
        }else{
            if(failure){
                failure([error localizedDescription]);
            }
        }
    }];
}

+ (void)POSTCompanyAuthenticationEmployeeWithParameters:(NSDictionary *)parameters success:(void (^)(NSArray *))success failure:(void (^)(NSString *))failure{
    [self POSTWithURL:API_CONNECTION_COMPANY_AUTHENTICATION_EMPLOYEE_URL parameters:parameters showProgressInView:nil isHideProgress:YES success:^(NSDictionary *dataDictionary) {
        if(success){
            NSDictionary *infoDictionary = [dataDictionary dictionaryForKey:@"info"];
            NSArray *infoArray = [infoDictionary arrayForKey:@"rows"];
            NSMutableArray *tempArray = [NSMutableArray array];
            for(NSDictionary *dictionary in infoArray){
                SLConnectionModel *connectionModel = [[SLConnectionModel alloc] initWithDictionary:dictionary];
                SLConnectionFrameModel *connectionFrameModel = [[SLConnectionFrameModel alloc] initWithConnectionModel:connectionModel];
                [tempArray addObject:connectionFrameModel];
            }
            success([tempArray copy]);
        }
    } failure:^(NSString *errorMessage) {
        if(failure){
            failure(errorMessage);
        }
    }];
}

+ (void)GETTAllTagsWithSuccess:(void (^)(SLSelectTagFrameModel *))success failure:(void (^)(NSString *))failure{
    [self GETWithURL:API_CONNECTION_ALL_TAGS_URL parameters:nil showProgressInView:nil isHideProgress:NO success:^(NSDictionary *dataDictionary) {
        if(success){
            NSMutableArray *tempArray = [NSMutableArray array];
            NSArray *dataArray = [dataDictionary arrayForKey:@"info"];
            for(NSDictionary *dictionary in dataArray){
                SLTagModel *tagModel = [[SLTagModel alloc] initWithDictionary:dictionary];
                [tempArray addObject:tagModel];
            }
            
            if(tempArray.count > 0){
                SLSelectTagFrameModel *selectTagFrameModel = [[SLSelectTagFrameModel alloc] initWithTagModels:[tempArray copy]];
                success(selectTagFrameModel);
            }else{
                success(nil);
            }
        }
    } failure:^(NSString *errorMessage) {
        if(failure){
            failure(errorMessage);
        }
    }];
}

@end

