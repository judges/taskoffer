//
//  SLHTTPFileData.h
//  TaskOffer
//
//  Created by wshaolin on 15/3/24.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLHTTPFileData : NSObject

@property (nonatomic, strong, readonly) NSData *data; // 文件的二进制数据
@property (nonatomic, copy, readonly) NSString *parameterName; // 参数名
@property (nonatomic, copy, readonly) NSString *fileName; // 文件名称
@property (nonatomic, copy, readonly) NSString *mimeType; // 文件的mimeType

+ (instancetype)dataWithData:(NSData *)data mimeType:(NSString *)mimeType;
+ (instancetype)dataWithData:(NSData *)data fileName:(NSString *)fileName mimeType:(NSString *)mimeType;
+ (instancetype)dataWithData:(NSData *)data fileName:(NSString *)fileName mimeType:(NSString *)mimeType parameterName:(NSString *)parameterName;

- (instancetype)initWithData:(NSData *)data mimeType:(NSString *)mimeType;
- (instancetype)initWithData:(NSData *)data fileName:(NSString *)fileName mimeType:(NSString *)mimeType;
- (instancetype)initWithData:(NSData *)data fileName:(NSString *)fileName mimeType:(NSString *)mimeType parameterName:(NSString *)parameterName;

@end

FOUNDATION_EXPORT NSString *const kMimeType_Image_PNG; // png
FOUNDATION_EXPORT NSString *const kMimeType_Image_JPEG; // jpg
FOUNDATION_EXPORT NSString *const kMimeType_Image_GIF; // gif
FOUNDATION_EXPORT NSString *const kMimeType_Image_WEBP; // webp

FOUNDATION_EXPORT NSString *const kMimeType_Audio_WAV; // wav
FOUNDATION_EXPORT NSString *const kMimeType_Audio_AMR; // amr

FOUNDATION_EXPORT NSString *const kMimeType_Video_AVI; // avi
FOUNDATION_EXPORT NSString *const kMimeType_Video_MP4; // mp4
FOUNDATION_EXPORT NSString *const kMimeType_Video_MOV; // quicktime

FOUNDATION_EXPORT NSString *const kMimeType_Application_XLS; // excel
FOUNDATION_EXPORT NSString *const kMimeType_Application_DOC; // word
FOUNDATION_EXPORT NSString *const kMimeType_Application_PPT; // ppt
FOUNDATION_EXPORT NSString *const kMimeType_Application_PDF; // pdf
FOUNDATION_EXPORT NSString *const kMimeType_Application_ZIP; // zip
