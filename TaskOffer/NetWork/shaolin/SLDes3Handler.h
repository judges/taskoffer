//
//  SLDes3Handler.h
//  EnvironmentalAssistant
//
//  Created by wshaolin on 15/3/5.
//  Copyright (c) 2015年 rnd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLDes3Handler : NSObject

+ (NSString *)des3EncodeBase64EncryptWithString:(NSString *)string; // 加密

+ (NSString *)des3DecodeBase64DecryptWithString:(NSString *)string; // 解密

@end

FOUNDATION_EXPORT NSString *const kSLDes3HandlerKey;
FOUNDATION_EXPORT NSString *const kSLDes3HandlerInitVector;