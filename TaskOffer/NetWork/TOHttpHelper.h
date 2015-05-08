//
//  TOHttpHelper.h
//  TaskOffer
//
//  Created by BourbonZ on 15/3/19.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
@interface TOHttpHelper : NSObject
+(void)postUrl:(NSString *)urlStr parameters:(NSDictionary *)parameters showHUD:(BOOL)show success:(void (^)(NSDictionary *dataDictionary))success failure:(void (^)(NSError *error))failure;

+(void)postUrl:(NSString *)urlStr parameters:(NSDictionary *)parameters showHUD:(BOOL)show withMedia:(NSArray *)datas success:(void(^)(NSDictionary *dataDictionary))success failure:(void (^)(NSError *error))failure;

+(void)getUrl:(NSString *)urlStr parameters:(NSDictionary *)parameters showHUD:(BOOL)showHUD success:(void(^)(NSDictionary *dataDictionary))success;

@end
