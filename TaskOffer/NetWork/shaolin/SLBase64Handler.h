//
//  SLBase64Handler.h
//  EnvironmentalAssistant
//
//  Created by wshaolin on 15/1/28.
//  Copyright (c) 2015年 rnd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLBase64Handler : NSObject

// 普通字符串转Base64字符串
+ (NSString *)encodeBase64WithString:(NSString *)string;
// Base64字符串转普通字符串
+ (NSString *)decodeBase64WithString:(NSString *)string;

// 普遍data转Base64字符串
+ (NSString *)encodeBase64StringWithData:(NSData *)data;
// 普遍data转Base64Data
+ (NSData *)decodeBase64DataWithData:(NSData *)data;

// Base64字符串转Base64Data
+ (NSData *)decodeBase64DataWithString:(NSString *)string;

@end
