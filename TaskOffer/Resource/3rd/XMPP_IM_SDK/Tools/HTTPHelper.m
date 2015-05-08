//
//  HTTPHelper.m
//  IM
//
//  Created by BourbonZ on 14/12/15.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import "HTTPHelper.h"
#import "XMPPIM-Prefix.pch"
@implementation HTTPHelper

///请求接口
+(void)httpRequestURL:(NSString *)url WithParam:(NSDictionary *)param showProgress:(BOOL)progress
              success:(void (^)(id))success
              failure:(void (^)(id))failure
{
    if (progress)
    {
        
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    manager.requestSerializer.timeoutInterval = 5;
    [manager POST:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success)
        {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(failure);
        }
    }];
}

///上传文件
+(void)httpUploadFileURL:(NSString *)url WithFile:(NSMutableArray *)fileArray showProgress:(BOOL)progress success:(void (^)(id))success failure:(void (^)(id))failure
{
    if (progress)
    {
        
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"image/jpeg", nil];
    [manager.requestSerializer setValue:kKey forHTTPHeaderField:@"Authorization"];
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        for (int i = 0 ; i < fileArray.count; i++)
        {
            NSString *fileName = [fileArray objectAtIndex:i];
            NSData *data = [NSData dataWithContentsOfFile:fileName];
            [formData appendPartWithFileData:data name:[NSString stringWithFormat:@"tyui%d",i] fileName:[NSString stringWithFormat:@"tyui%d.jpg",i] mimeType:@"image/webp"];
        }
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         success(success);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         DLog(@"上传文件失败:%@",error.description);
         failure(failure);
    }];
}

@end
