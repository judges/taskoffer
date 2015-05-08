//
//  HTTPHelper.h
//  IM
//
//  Created by BourbonZ on 14/12/15.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "MBProgressHUD.h"
@interface HTTPHelper : NSObject
///请求接口
+(void)httpRequestURL:(NSString *)url WithParam:(NSDictionary *)param showProgress:(BOOL)progress success:(void(^)(id data))success failure:(void(^)(id data))failure;
///上传文件
+(void)httpUploadFileURL:(NSString *)url WithFile:(NSMutableArray *)fileArray showProgress:(BOOL)progress success:(void(^)(id data))success failure:(void(^)(id data))failure;

@end
