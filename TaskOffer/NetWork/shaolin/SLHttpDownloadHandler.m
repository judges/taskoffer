//
//  SLHttpDownloadHandler.m
//  EnvironmentalAssistant
//
//  Created by wshaolin on 15/1/20.
//  Copyright (c) 2015年 rnd. All rights reserved.
//

#import "SLHttpDownloadHandler.h"
#import "AFNetworking.h"
#import "SDImageCache.h"
#import "NSString+Conveniently.h"

#define SLHttpDownloadMaxMask 3

#define HTTP_DOWNLOAD_ERROR_MESSAGE(operation) NSLog(@"网络请求错误：%@", operation.responseString)

@interface SLHttpDownloadHandler()

@property (nonatomic, strong) AFURLSessionManager *sessionManager;

@end

@implementation SLHttpDownloadHandler

+ (instancetype)sharedHandler{
    static SLHttpDownloadHandler *_downloadHandler = nil;
    if(_downloadHandler == nil){
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _downloadHandler = [[self alloc] init];
        });
    }
    return _downloadHandler;
}

- (instancetype)init{
    if(self = [super init]){
        [self setMaxConcurrentOperationCount:SLHttpDownloadMaxMask];
    }
    return self;
}

- (AFURLSessionManager *)sessionManager{
    if(_sessionManager == nil){
        _sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    return _sessionManager;
}

- (void)setMaxConcurrentOperationCount:(NSInteger)maxConcurrentOperationCount{
    _maxConcurrentOperationCount = maxConcurrentOperationCount;
    [self.sessionManager.operationQueue setMaxConcurrentOperationCount:maxConcurrentOperationCount];
}

- (void)downloadDataWithURL:(NSString *)url progress:(void (^)(CGFloat))progress success:(void (^)(NSData *))success failure:(void (^)(NSError *))failure{
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    __block long long totalBytesToRead = 0;
    [requestOperation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        if (totalBytesToRead == 0) {
            totalBytesToRead = totalBytesExpectedToRead;
        }
        
        if(progress && totalBytesToRead > 0){
            progress((CGFloat)totalBytesRead / totalBytesToRead);
        }
    }];
    
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([responseObject isKindOfClass:[NSData class]]){
            if(success){
                success(responseObject);
            }
        }else{
            if(failure){
                NSDictionary *userInfo = @{@"downloadDataError" : @"Returns the result is not a binary data."};
                NSError *error = [[NSError alloc] initWithDomain:url code:SLHttpDownloadHandlerDownloadErrorDataCode userInfo:userInfo];
                failure(error);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failure){
            failure(error);
        }
        HTTP_DOWNLOAD_ERROR_MESSAGE(operation);
    }];
    
    [self.sessionManager.operationQueue addOperation:requestOperation];
}

- (void)downloadImageWithURL:(NSString *)url progress:(void (^)(CGFloat))progress success:(void (^)(UIImage *))success failure:(void (^)(NSError *))failure{
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *imageCacheKey = [url MD5Encrypt];
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    UIImage *image = [imageCache imageFromMemoryCacheForKey:imageCacheKey];
    
    if(image == nil){
        image = [imageCache imageFromDiskCacheForKey:imageCacheKey];
    }
    
    if(image != nil){
        if(success){
            success(image);
        }
        return;
    }
    
    [self downloadDataWithURL:url progress:^(CGFloat value) {
        if(progress){
            progress(value);
        }
    } success:^(NSData *data) {
        UIImage *image = [UIImage imageWithData:data];
        if(image != nil){
            if(success){
                success(image);
            }
            [imageCache storeImage:image forKey:imageCacheKey toDisk:NO];
        }else{
            if(failure){
                NSDictionary *userInfo = @{@"downloadDataError" : @"Returns the result is not a image data."};
                NSError *error = [[NSError alloc] initWithDomain:url code:SLHttpDownloadHandlerDownloadErrorImageCode userInfo:userInfo];
                failure(error);
            }
        }
    } failure:^(NSError *error) {
        if(failure){
            failure(error);
        }
    }];
}

@end
