//
//  SLHTTPHandler.m
//  TaskOffer
//
//  Created by wshaolin on 15/3/24.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLHTTPHandler.h"
#import "MBProgressHUD+Conveniently.h"
#import "NSDictionary+NullFilter.h"
#import "SLDes3Handler.h"
#import "SLHTTPFileData.h"
#import "SLHTTPServerHandler.h"

#define SLHTTPHandlerRequestFailureErrorMessage @"网络状况不良，请检查网络"
#define SLHTTPHandlerFileDataExceptionMessage @"The elements in the files array is not a SLHTTPFileData."
#define HTTP_REQUEST_ERROR_MESSAGE(error, operation) NSLog(@"网络请求错误：\n%@\n\n错误信息：\n%@", error, operation.responseString)

#define SLHTTPHandlerResponseCodeSuccess @"0"

NSInteger const kSLHTTPHandlerRequestFailureCustomCode = 10000;
NSString *const kSLHTTPHandlerRequestFailureCustomUserInfoKey = @"SLHTTPHandlerRequestFailureCustomUserInfoKey";

@implementation SLHTTPHandler

+ (void)GETWithURL:(NSString *)url parameters:(NSDictionary *)parameters showProgressInView:(UIView *)view isHideProgress:(BOOL)isHideProgress success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure{
    
    if(!isHideProgress){
        [MBProgressHUD showWithMessage:nil inView:view];
    }
    
    AFHTTPRequestOperationManager *manager = [self requestOperationManager];
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, NSData *data) {
        if(!isHideProgress){
            [MBProgressHUD hideForView:view];
        }
        
        NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        dataString = [SLDes3Handler des3DecodeBase64DecryptWithString:dataString];
        NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:[dataString dataUsingEncoding:NSUTF8StringEncoding] options:(NSJSONReadingMutableLeaves) error:nil];
        
        if([[dataDictionary stringForKey:@"code"] isEqualToString:SLHTTPHandlerResponseCodeSuccess]){
            if(success){
                success(dataDictionary);
            }
        }else{
            if(failure){
                NSError *error = [[NSError alloc] initWithDomain:url code:kSLHTTPHandlerRequestFailureCustomCode userInfo:@{kSLHTTPHandlerRequestFailureCustomUserInfoKey : [NSString stringWithFormat:@"%@", [dataDictionary stringForKey:@"message"]]}];
                failure(error);
            }
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(!isHideProgress){
            [MBProgressHUD hideForView:view];
            [MBProgressHUD showWithError:SLHTTPHandlerRequestFailureErrorMessage];
        }
        
        if(failure){
            failure(error);
        }
        HTTP_REQUEST_ERROR_MESSAGE(error, operation);
    }];
}

+ (void)POSTWithURL:(NSString *)url parameters:(NSDictionary *)parameters showProgressInView:(UIView *)view isHideProgress:(BOOL)isHideProgress success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure{
    
    if(!isHideProgress){
        [MBProgressHUD showWithMessage:nil inView:view];
    }
    
    AFHTTPRequestOperationManager *manager = [self requestOperationManager];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, NSData *data) {
        if(!isHideProgress){
            [MBProgressHUD hideForView:view];
        }
        
        NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        dataString = [SLDes3Handler des3DecodeBase64DecryptWithString:dataString];
        NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:[dataString dataUsingEncoding:NSUTF8StringEncoding] options:(NSJSONReadingMutableLeaves) error:nil];
        
        if([[dataDictionary stringForKey:@"code"] isEqualToString:SLHTTPHandlerResponseCodeSuccess]){
            if(success){
                success(dataDictionary);
            }
        }else{
            if(failure){
                NSError *error = [[NSError alloc] initWithDomain:url code:kSLHTTPHandlerRequestFailureCustomCode userInfo:@{kSLHTTPHandlerRequestFailureCustomUserInfoKey : [NSString stringWithFormat:@"%@", [dataDictionary stringForKey:@"message"]]}];
                failure(error);
            }
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(!isHideProgress){
            [MBProgressHUD hideForView:view];
            [MBProgressHUD showWithError:SLHTTPHandlerRequestFailureErrorMessage];
        }
        
        if(failure){
            failure(error);
        }
        HTTP_REQUEST_ERROR_MESSAGE(error, operation);
    }];
}

+ (void)POSTWithURL:(NSString *)url parameters:(NSDictionary *)parameters datas:(NSArray *)datas showProgressInView:(UIView *)view isHideProgress:(BOOL)isHideProgress success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure{
    for(NSInteger i = 0; i < datas.count; i ++){
        if(![datas[i] isKindOfClass:[SLHTTPFileData class]]){
            [NSException raise:SLHTTPHandlerFileDataExceptionMessage format:nil];
            return;
        }
    }
    
    if(!isHideProgress){
        [MBProgressHUD showWithMessage:nil inView:view];
    }
    
    AFHTTPRequestOperationManager *manager = [self requestOperationManager];
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
        for(SLHTTPFileData *data in datas){
            [formData appendPartWithFileData:data.data name:data.parameterName fileName:data.fileName mimeType:data.mimeType];
        }
    }success:^(AFHTTPRequestOperation *operation, NSData *data){
        if(!isHideProgress){
            [MBProgressHUD hideForView:view];
        }
        
        NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        dataString = [SLDes3Handler des3DecodeBase64DecryptWithString:dataString];
        NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:[dataString dataUsingEncoding:NSUTF8StringEncoding] options:(NSJSONReadingMutableLeaves) error:nil];
        
        if([[dataDictionary stringForKey:@"code"] isEqualToString:SLHTTPHandlerResponseCodeSuccess]){
            if(success){
                success(dataDictionary);
            }
        }else{
            if(failure){
                NSError *error = [[NSError alloc] initWithDomain:url code:kSLHTTPHandlerRequestFailureCustomCode userInfo:@{kSLHTTPHandlerRequestFailureCustomUserInfoKey : [NSString stringWithFormat:@"%@", [dataDictionary stringForKey:@"message"]]}];
                failure(error);
            }
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(!isHideProgress){
            [MBProgressHUD hideForView:view];
            [MBProgressHUD showWithError:SLHTTPHandlerRequestFailureErrorMessage];
        }
        
        if(failure){
            failure(error);
        }
        HTTP_REQUEST_ERROR_MESSAGE(error, operation);
    }];
}

+ (void)PUTWithURL:(NSString *)url parameters:(NSDictionary *)parameters showProgressInView:(UIView *)view isHideProgress:(BOOL)isHideProgress success:(void (^)(NSDictionary *dataDictionary))success failure:(void (^)(NSError *error))failure{
    if(!isHideProgress){
        [MBProgressHUD showWithMessage:nil inView:view];
    }
    
    AFHTTPRequestOperationManager *manager = [self requestOperationManager];
    [manager PUT:url parameters:parameters success:^(AFHTTPRequestOperation *operation, NSData *data) {
        if(!isHideProgress){
            [MBProgressHUD hideForView:view];
        }
        
        NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        dataString = [SLDes3Handler des3DecodeBase64DecryptWithString:dataString];
        NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:[dataString dataUsingEncoding:NSUTF8StringEncoding] options:(NSJSONReadingMutableLeaves) error:nil];
        
        if([[dataDictionary stringForKey:@"code"] isEqualToString:SLHTTPHandlerResponseCodeSuccess]){
            if(success){
                success(dataDictionary);
            }
        }else{
            if(failure){
                NSError *error = [[NSError alloc] initWithDomain:url code:kSLHTTPHandlerRequestFailureCustomCode userInfo:@{kSLHTTPHandlerRequestFailureCustomUserInfoKey : [NSString stringWithFormat:@"%@", [dataDictionary stringForKey:@"message"]]}];
                failure(error);
            }
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(!isHideProgress){
            [MBProgressHUD hideForView:view];
            [MBProgressHUD showWithError:SLHTTPHandlerRequestFailureErrorMessage];
        }
        
        if(failure){
            failure(error);
        }
        HTTP_REQUEST_ERROR_MESSAGE(error, operation);
    }];
}

+ (void)cancelAllRequest{
    AFHTTPRequestOperationManager *manager = [self requestOperationManager];
    [manager.operationQueue cancelAllOperations];
    
    // 取消请求时需要隐藏HUD
    [MBProgressHUD hideAll];
}

+ (void)cancelCurrentRequest{
    AFHTTPRequestOperationManager *manager = [self requestOperationManager];
    if(manager.operationQueue.operationCount > 0){
        NSOperation *operation = (NSOperation *)[[manager.operationQueue operations] lastObject];
        [operation cancel];
        
        // 取消请求时需要隐藏HUD
        [MBProgressHUD hide];
    }
}

+ (AFHTTPRequestOperationManager *)requestOperationManager{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = SLHTTPHandlerRequestTimeoutInterval;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    return manager;
}

@end
