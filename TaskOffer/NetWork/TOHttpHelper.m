//
//  TOHttpHelper.m
//  TaskOffer
//
//  Created by BourbonZ on 15/3/19.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "TOHttpHelper.h"
#import "DES3Util.h"
#import "HUDView.h"
#define SLHttpRequestHandlerHttpFileDataExceptionMessage @"The elements in the files array is not a SLHttpFileData."

static TOHttpHelper *helper = nil;
@implementation TOHttpHelper

+(TOHttpHelper *)sharedToHTTOHelper
{
    if (helper == nil)
    {
        helper = [[TOHttpHelper alloc] init];
    }
    return helper;
}

+ (AFHTTPRequestOperationManager *)sharedManager{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 15.0f;
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"image/jpeg",@"text/html", nil];
//    [manager.requestSerializer setValue:kKey forHTTPHeaderField:@"Authorization"];
    return manager;
}


+(void)postUrl:(NSString *)urlStr parameters:(NSDictionary *)parameters showHUD:(BOOL)show success:(void (^)(NSDictionary *dataDictionary))success failure:(void (^)(NSError *error))failure;
{
    if (show)
    {
        [[HUDView sharedHUDView] showHUDView:@"正在加载"];
        
    }

    
    
    AFHTTPRequestOperationManager *manager = [self sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", kTOHOSt, urlStr];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        if (show)
        {
            [[HUDView sharedHUDView] hideHUDView];
        }

        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        string = [DES3Util decrypt:string];
        
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:(NSJSONReadingMutableLeaves) error:nil];
        NSString *code = [dict objectForKey:@"code"];
        if (code.intValue == 0)
        {
            success(dict);
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:[dict objectForKey:@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (show)
        {
            [[HUDView sharedHUDView] hideHUDView];
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:error.localizedDescription delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];
}
+(void)postUrl:(NSString *)urlStr parameters:(NSDictionary *)parameters showHUD:(BOOL)show withMedia:(NSArray *)datas success:(void(^)(NSDictionary *dataDictionary))success failure:(void (^)(NSError *error))failure
{
    

    
    for(NSInteger i = 0; i < datas.count; i ++){
        if(![datas[i] isKindOfClass:[SLHttpFileData class]]){
            [NSException raise:SLHttpRequestHandlerHttpFileDataExceptionMessage format:nil];
            return;
        }
    }
    
    if (show)
    {
        [[HUDView sharedHUDView] showHUDView:@"正在加载"];
        
    }
    
    AFHTTPRequestOperationManager *manager = [self sharedManager];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",kTOHOSt,urlStr] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        for(SLHttpFileData *data in datas){
            [formData appendPartWithFileData:data.data name:data.parameterName fileName:data.fileName mimeType:data.mimeType];
        }
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        

        
        if (show)
        {
            [[HUDView sharedHUDView] hideHUDView];
        }
        
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        string = [DES3Util decrypt:string];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:(NSJSONReadingMutableLeaves) error:nil];
        NSString *code = [dict objectForKey:@"code"];
        
        
        if (code.integerValue == 0)
        {
            success(dict);
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:[dict objectForKey:@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (show)
        {
            [[HUDView sharedHUDView] hideHUDView];
        }

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:error.localizedDescription delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
    }];
}

+(void)getUrl:(NSString *)urlStr parameters:(NSDictionary *)parameters showHUD:(BOOL)showHUD success:(void(^)(NSDictionary *dataDictionary))success
{
    

    if (showHUD)
    {
        [[HUDView sharedHUDView] showHUDView:@"正在加载"];
    }

    
    AFHTTPRequestOperationManager *manager = [self sharedManager];
    
    [manager GET:[NSString stringWithFormat:@"%@%@",kTOHOSt,urlStr] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        

        
        if (showHUD)
        {
            [[HUDView sharedHUDView] hideHUDView];
        }
        
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        string = [DES3Util decrypt:string];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:(NSJSONReadingMutableLeaves) error:nil];
        NSString *code = [dict objectForKey:@"code"];
        
        
        if (code.integerValue == 0)
        {
            success(dict);
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:[dict objectForKey:@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (showHUD)
        {
            [[HUDView sharedHUDView] hideHUDView];
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:error.localizedDescription delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];

        
    }];

}
@end
