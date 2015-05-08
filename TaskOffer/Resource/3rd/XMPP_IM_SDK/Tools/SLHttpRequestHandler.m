//
//  SLHttpRequestHandler.m
//  AppFramework
//
//  Created by wshaolin on 14/11/20.
//  Copyright (c) 2014年 wshaolin. All rights reserved.
//

#import "SLHttpRequestHandler.h"
#import "AFNetworking.h"
#import "MBProgressHUD+Conveniently.h"
#import "NSString+Conveniently.h"
#import "NSDictionary+NullFilter.h"
#import "VoiceConverter.h"
#import "XMPPIM-Prefix.pch"
#define SLHttpRequestHandlerRequestFailureErrorMessage @"网络状况不良，请检查网络"
#define SLHttpRequestHandlerHttpFileDataExceptionMessage @"The elements in the files array is not a SLHttpFileData."
#define HTTP_REQUEST_ERROR_MESSAGE(operation) DLog(@"网络请求错误：%@", operation.responseString)

typedef enum{
    SLHttpRequestHandlerRequestResultFailure = 1, // 请求失败
    SLHttpRequestHandlerRequestResultSuccess = 0  // 请求成功
}SLHttpRequestHandlerRequestResult;

@interface SLHttpRequestHandler()

@end

@implementation SLHttpRequestHandler

+ (instancetype)httpRequestHandlerWithDelegate:(id<SLHttpRequestHandlerDelegate>)deledate{
    return [[self alloc] initWithDelegate:deledate];
}

- (instancetype)initWithDelegate:(id<SLHttpRequestHandlerDelegate>)deledate{
    if(self = [super init]){
        self.deledate = deledate;
    }
    return self;
}

- (void)GETWithURL:(NSString *)url parameters:(NSDictionary *)parameters showProgressInView:(UIView *)view isHideProgress:(BOOL)isHideProgress{
    
    AFHTTPRequestOperationManager *manager = [SLHttpRequestHandler getAFHTTPRequestOperationManager];
    if(!isHideProgress){
        [MBProgressHUD showWithMessage:nil inView:view];
    }
    
    __block typeof(self) bself = self;
    
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDictionary) {
        if(!isHideProgress){
            [MBProgressHUD hideForView:view];
        }
        
        if([dataDictionary integerForKey:@"code"] == SLHttpRequestHandlerRequestResultSuccess){
            if(bself.deledate && [bself.deledate respondsToSelector:@selector(httpRequestHandler:didFinishedRequestSuccessData:)]){
                [bself.deledate httpRequestHandler:bself didFinishedRequestSuccessData:dataDictionary];
            }
        }else{
            if(bself.deledate && [bself.deledate respondsToSelector:@selector(httpRequestHandler:didFinishedRequestFailure:)]){
                [bself.deledate httpRequestHandler:bself didFinishedRequestFailure:nil];
            }
        }
//        DLog("%@", dataDictionary);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(!isHideProgress){
            [MBProgressHUD hideForView:view];
            [MBProgressHUD showWithError:SLHttpRequestHandlerRequestFailureErrorMessage];
        }
        
        if(bself.deledate && [bself.deledate respondsToSelector:@selector(httpRequestHandler:didFinishedRequestFailure:)]){
            [bself.deledate httpRequestHandler:bself didFinishedRequestFailure:error];
        }
        HTTP_REQUEST_ERROR_MESSAGE(operation);
    }];
}

+ (void)GETWithURL:(NSString *)url parameters:(NSDictionary *)parameters showProgressInView:(UIView *)view isHideProgress:(BOOL)isHideProgress success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure{
    
    AFHTTPRequestOperationManager *manager = [SLHttpRequestHandler getAFHTTPRequestOperationManager];
    if(!isHideProgress){
        [MBProgressHUD showWithMessage:nil inView:view];
    }
    
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDictionary) {
        if(!isHideProgress){
            [MBProgressHUD hideForView:view];
        }
        
        if([dataDictionary integerForKey:@"code"] == SLHttpRequestHandlerRequestResultSuccess){
            if(success){
                success(dataDictionary);
            }
        }else{
            if(failure){
                failure(nil);
            }
        }
        DLog("%@", dataDictionary);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(!isHideProgress){
            [MBProgressHUD hideForView:view];
            [MBProgressHUD showWithError:SLHttpRequestHandlerRequestFailureErrorMessage];
        }
        
        if(failure){
            failure(error);
        }
        HTTP_REQUEST_ERROR_MESSAGE(operation);
    }];
}

+(void)GETWithURL:(NSString *)urlStr success:(void (^)(NSString *))success failure:(void (^)(NSError *))failure
{
    //下载附件
    NSURL *url = [[NSURL alloc] initWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.inputStream   = [NSInputStream inputStreamWithURL:url];
    
    //下载进度控制
    /*
     [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
     NSLog(@"is download：%f", (float)totalBytesRead/totalBytesExpectedToRead);
     }];
     */
    NSArray *array = [urlStr componentsSeparatedByString:@"/"];
    NSString *fileName = [array lastObject];
    
    //已完成下载
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *amrPath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@",fileName];
        NSString *wavPath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@",[fileName stringByReplacingOccurrencesOfString:@".amr" withString:@".wav"]];
        NSData *data = (NSData *)responseObject;
        if ([data writeToFile:amrPath atomically:YES])
        {
            [VoiceConverter amrToWav:amrPath wavSavePath:wavPath];
        }
        
        if (success) {
            success([fileName stringByReplacingOccurrencesOfString:@".amr" withString:@".wav"]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //下载失败
        if (failure)
        {
            failure(error);
        }

    }];
    
    [operation start];
}




- (void)POSTWithURL:(NSString *)url parameters:(NSDictionary *)parameters showProgressInView:(UIView *)view isHideProgress:(BOOL)isHideProgress{
    
    AFHTTPRequestOperationManager *manager = [SLHttpRequestHandler getAFHTTPRequestOperationManager];
    if(!isHideProgress){
        [MBProgressHUD showWithMessage:nil inView:view];
    }
    
    __block typeof(self) bself = self;
    
    [manager POST:[NSString stringWithFormat:@"%@%@", kFILEHOST, url] parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDictionary){
        if(!isHideProgress){
            [MBProgressHUD hideForView:view];
        }
        if([dataDictionary integerForKey:@"code"] == SLHttpRequestHandlerRequestResultSuccess){
            if(bself.deledate && [bself.deledate respondsToSelector:@selector(httpRequestHandler:didFinishedRequestSuccessData:)]){
                [bself.deledate httpRequestHandler:bself didFinishedRequestSuccessData:dataDictionary];
            }
        }else{
            if(bself.deledate && [bself.deledate respondsToSelector:@selector(httpRequestHandler:didFinishedRequestFailure:)]){
                [bself.deledate httpRequestHandler:bself didFinishedRequestFailure:nil];
            }
        }
        DLog("%@", dataDictionary);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(!isHideProgress){
            [MBProgressHUD hideForView:view];
            [MBProgressHUD showWithError:SLHttpRequestHandlerRequestFailureErrorMessage];
        }
        
        if(bself.deledate && [bself.deledate respondsToSelector:@selector(httpRequestHandler:didFinishedRequestFailure:)]){
            [bself.deledate httpRequestHandler:bself didFinishedRequestFailure:error];
        }
        HTTP_REQUEST_ERROR_MESSAGE(operation);
    }];
}

- (void)POSTWithURL:(NSString *)url parameters:(NSDictionary *)parameters datas:(NSArray *)datas showProgressInView:(UIView *)view isHideProgress:(BOOL)isHideProgress{
    
    for(NSInteger i = 0; i < datas.count; i ++){
        if(![datas[i] isKindOfClass:[SLHttpFileData class]]){
            [NSException raise:SLHttpRequestHandlerHttpFileDataExceptionMessage format:nil];
            return;
        }
    }
    
    AFHTTPRequestOperationManager *manager = [SLHttpRequestHandler getAFHTTPRequestOperationManager];
    if(!isHideProgress){
        [MBProgressHUD showWithMessage:nil inView:view];
    }
    
    __block typeof(self) bself = self;
    
    [manager POST:[NSString stringWithFormat:@"%@%@", kFILEHOST, url] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
        for(SLHttpFileData *data in datas){
            [formData appendPartWithFileData:data.data name:data.parameterName fileName:data.fileName mimeType:data.mimeType];
        }
    }success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDictionary){
        if(!isHideProgress){
            [MBProgressHUD hideForView:view];
        }
        if([dataDictionary integerForKey:@"code"] == SLHttpRequestHandlerRequestResultSuccess){
            if(bself.deledate && [bself.deledate respondsToSelector:@selector(httpRequestHandler:didFinishedRequestSuccessData:)]){
                [bself.deledate httpRequestHandler:bself didFinishedRequestSuccessData:dataDictionary];
            }
        }else{
            if(bself.deledate && [bself.deledate respondsToSelector:@selector(httpRequestHandler:didFinishedRequestFailure:)]){
                [bself.deledate httpRequestHandler:bself didFinishedRequestFailure:nil];
            }
        }
        DLog("%@", dataDictionary);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(!isHideProgress){
            [MBProgressHUD hideForView:view];
            [MBProgressHUD showWithError:SLHttpRequestHandlerRequestFailureErrorMessage];
        }
        
        if(bself.deledate && [bself.deledate respondsToSelector:@selector(httpRequestHandler:didFinishedRequestFailure:)]){
            [bself.deledate httpRequestHandler:bself didFinishedRequestFailure:error];
        }
        HTTP_REQUEST_ERROR_MESSAGE(operation);
    }];
}

+ (void)POSTWithURL:(NSString *)url parameters:(NSDictionary *)parameters showProgressInView:(UIView *)view isHideProgress:(BOOL)isHideProgress success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure{

    if(!isHideProgress){
        [MBProgressHUD showWithMessage:nil inView:view];
    }
    
    AFHTTPRequestOperationManager *manager = [self getAFHTTPRequestOperationManager];
    url = [NSString stringWithFormat:@"%@%@", kFILEHOST, url];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDictionary){
        if(!isHideProgress){
            [MBProgressHUD hideForView:view];
        }
        
        if([dataDictionary integerForKey:@"code"] == SLHttpRequestHandlerRequestResultSuccess){
            if(success){
                success(dataDictionary);
            }
        }else{
            if(failure){
                failure(nil);
            }
        }
        DLog("%@", dataDictionary);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(!isHideProgress){
            [MBProgressHUD hideForView:view];
            [MBProgressHUD showWithError:SLHttpRequestHandlerRequestFailureErrorMessage];
        }
        
        if(failure){
            failure(error);
        }
        HTTP_REQUEST_ERROR_MESSAGE(operation);
    }];
}

+ (void)POSTWithURL:(NSString *)url parameters:(NSDictionary *)parameters datas:(NSArray *)datas showProgressInView:(UIView *)view isHideProgress:(BOOL)isHideProgress success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure{
    for(NSInteger i = 0; i < datas.count; i ++){
        if(![datas[i] isKindOfClass:[SLHttpFileData class]]){
            [NSException raise:SLHttpRequestHandlerHttpFileDataExceptionMessage format:nil];
            return;
        }
    }
    
    if(!isHideProgress){
        [MBProgressHUD showWithMessage:nil inView:view];
    }
    
    AFHTTPRequestOperationManager *manager = [self getAFHTTPRequestOperationManager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"image/jpeg", nil];

    [manager POST:[NSString stringWithFormat:@"%@%@", kFILEHOST, url] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
        for(SLHttpFileData *data in datas){
            [formData appendPartWithFileData:data.data name:data.parameterName fileName:data.fileName mimeType:data.mimeType];
        }
    }success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDictionary){
        if(!isHideProgress){
            [MBProgressHUD hideForView:view];
        }
        
        if([dataDictionary integerForKey:@"code"] == SLHttpRequestHandlerRequestResultSuccess){
            if(success){
                success(dataDictionary);
            }
        }else{
            if(failure){
                failure(nil);
            }
        }
        DLog("%@", dataDictionary);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(!isHideProgress){
            [MBProgressHUD hideForView:view];
            [MBProgressHUD showWithError:SLHttpRequestHandlerRequestFailureErrorMessage];
        }
        
        if(failure){
            failure(error);
        }
        HTTP_REQUEST_ERROR_MESSAGE(operation);
    }];
}

+ (AFHTTPRequestOperationManager *)getAFHTTPRequestOperationManager{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = SLHttpRequestTimeoutInterval;
    [manager.requestSerializer setValue:kKey forHTTPHeaderField:@"Authorization"];
    return manager;
}

@end

@implementation SLHttpFileData

- (NSString *)fileName{
    if(_fileName == nil){
        _fileName = @"";
    }
    return _fileName;
}

- (NSString *)parameterName{
    if(_parameterName == nil){
        _parameterName = @"";
    }
    return _parameterName;
}

@end
