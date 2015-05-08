//
//  SLHTTPFileData.m
//  TaskOffer
//
//  Created by wshaolin on 15/3/24.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLHTTPFileData.h"
#import "NSDate+Conveniently.h"

@implementation SLHTTPFileData

+ (instancetype)dataWithData:(NSData *)data mimeType:(NSString *)mimeType{
    return [[self alloc] initWithData:data mimeType:mimeType];
}
+ (instancetype)dataWithData:(NSData *)data fileName:(NSString *)fileName mimeType:(NSString *)mimeType{
    return [[self alloc] initWithData:data fileName:fileName mimeType:mimeType];
}
+ (instancetype)dataWithData:(NSData *)data fileName:(NSString *)fileName mimeType:(NSString *)mimeType parameterName:(NSString *)parameterName{
    return [[self alloc] initWithData:data fileName:fileName mimeType:mimeType parameterName:parameterName];
}

- (instancetype)initWithData:(NSData *)data mimeType:(NSString *)mimeType{
    return [self initWithData:data fileName:nil mimeType:mimeType];
}
- (instancetype)initWithData:(NSData *)data fileName:(NSString *)fileName mimeType:(NSString *)mimeType{
    return [self initWithData:data fileName:fileName mimeType:mimeType parameterName:nil];
}
- (instancetype)initWithData:(NSData *)data fileName:(NSString *)fileName mimeType:(NSString *)mimeType parameterName:(NSString *)parameterName{
    
    NSParameterAssert(data != nil);
    NSParameterAssert(mimeType != nil && mimeType.length > 0);
    
    if(self = [super init]){
        _data = data;
        _fileName = fileName;
        if(_fileName == nil || _fileName.length == 0){
            _fileName = [[NSDate date] stringWithFormat:@"yyyyMMddHHmmss"];
        }
        
        _mimeType = mimeType;
        _parameterName = parameterName;
        if(_parameterName == nil || _parameterName.length == 0){
            _parameterName = _fileName;
        }
    }
    return self;
}

@end

NSString *const kMimeType_Image_PNG = @"image/png";
NSString *const kMimeType_Image_JPEG = @"image/jpeg";
NSString *const kMimeType_Image_GIF = @"image/gif";
NSString *const kMimeType_Image_WEBP = @"image/webp";

NSString *const kMimeType_Audio_WAV = @"audio/x-wav";
NSString *const kMimeType_Audio_AMR = @"audio/amr";

NSString *const kMimeType_Video_AVI = @"video/x-msvideo";
NSString *const kMimeType_Video_MP4 = @"video/mpeg";
NSString *const kMimeType_Video_MOV = @"video/quicktime";

NSString *const kMimeType_Application_XLS = @"application/excel";
NSString *const kMimeType_Application_DOC = @"application/msword";
NSString *const kMimeType_Application_PPT = @"application/powerpoint";
NSString *const kMimeType_Application_PDF = @"application/pdf";
NSString *const kMimeType_Application_ZIP = @"application/zip";
