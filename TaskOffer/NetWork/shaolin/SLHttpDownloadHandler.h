//
//  SLHttpDownloadHandler.h
//  EnvironmentalAssistant
//
//  Created by wshaolin on 15/1/20.
//  Copyright (c) 2015年 rnd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLHttpDownloadHandler : NSObject

#define SLHttpDownloadHandlerDownloadErrorDataCode 9998 // 不是NSData
#define SLHttpDownloadHandlerDownloadErrorImageCode 9999 // 不是UIImage

@property (nonatomic, assign) NSInteger maxConcurrentOperationCount; // default 3

+ (instancetype)sharedHandler;

/**
 *  下载二进制数据
 *
 *  @param url                  下载URL
 *  @param progress             下载进度
 *  @param success              下载成功的回调
 *  @param failure              下载失败的回调
 */
- (void)downloadDataWithURL:(NSString *)url progress:(void (^)(CGFloat value))progress success:(void (^)(NSData *data))success failure:(void (^)(NSError *error))failure;

/**
 *  下载图片数据
 *
 *  @param url                  下载URL
 *  @param progress             下载进度
 *  @param success              下载成功的回调
 *  @param failure              下载失败的回调
 */
- (void)downloadImageWithURL:(NSString *)url progress:(void (^)(CGFloat value))progress success:(void (^)(UIImage *image))success failure:(void (^)(NSError *error))failure;

@end
