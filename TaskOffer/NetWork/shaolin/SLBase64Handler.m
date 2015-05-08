//
//  SLBase64Handler.m
//  EnvironmentalAssistant
//
//  Created by wshaolin on 15/1/28.
//  Copyright (c) 2015年 rnd. All rights reserved.
//

#import "SLBase64Handler.h"

@implementation SLBase64Handler

+ (NSString *)encodeBase64WithString:(NSString *)string{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [self encodeBase64StringWithData:data];
}

+ (NSString *)decodeBase64WithString:(NSString *)string{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

+ (NSString *)encodeBase64StringWithData:(NSData *)data{
    return [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
}

+ (NSData *)decodeBase64DataWithData:(NSData *)data{
    return [[NSData alloc] initWithBase64EncodedData:data options:NSDataBase64DecodingIgnoreUnknownCharacters];
}

+ (NSData *)decodeBase64DataWithString:(NSString *)string{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [self decodeBase64DataWithData:data];
}

@end
