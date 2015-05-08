//
//  SLDes3Handler.m
//  EnvironmentalAssistant
//
//  Created by wshaolin on 15/3/5.
//  Copyright (c) 2015年 rnd. All rights reserved.
//

#import "SLDes3Handler.h"
#import "SLBase64Handler.h"
#import <CommonCrypto/CommonCryptor.h>

@implementation SLDes3Handler

+ (NSString *)des3EncodeBase64EncryptWithString:(NSString *)string{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    size_t dataInLength = [data length];
    
    size_t dataOutAvailable = (dataInLength + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    uint8_t *dataOut = malloc(dataOutAvailable * sizeof(uint8_t));
    memset((void *)dataOut, 0x0, dataOutAvailable);
    
    size_t dataOutMoved = 0;
    
    const void *key = (const void *)[kSLDes3HandlerKey UTF8String];
    const void *iv = (const void *)[kSLDes3HandlerInitVector UTF8String];
    
    CCCrypt(kCCEncrypt,
            kCCAlgorithm3DES,
            kCCOptionPKCS7Padding,
            key,
            kCCKeySize3DES,
            iv,
            [data bytes],
            dataInLength,
            (void *)dataOut,
            dataOutAvailable,
            &dataOutMoved);
    
    data = [NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved];
    return [SLBase64Handler encodeBase64StringWithData:data];
}

+ (NSString *)des3DecodeBase64DecryptWithString:(NSString *)string{
    NSData *data = [SLBase64Handler decodeBase64DataWithString:string];
    size_t dataInLength = [data length];
    
    size_t dataOutAvailable = (dataInLength + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    uint8_t *dataOut = malloc(dataOutAvailable * sizeof(uint8_t));
    memset((void *)dataOut, 0x0, dataOutAvailable);
    
    size_t dataOutMoved = 0;

    const void *key = (const void *)[kSLDes3HandlerKey UTF8String];
    const void *iv = (const void *)[kSLDes3HandlerInitVector UTF8String];
    
    CCCrypt(kCCDecrypt,
            kCCAlgorithm3DES,
            kCCOptionPKCS7Padding,
            key,
            kCCKeySize3DES,
            iv,
            [data bytes],
            dataInLength,
            (void *)dataOut,
            dataOutAvailable,
            &dataOutMoved);
    data = [NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end

NSString *const kSLDes3HandlerKey = @"liuyunqiang@lx100$#365#$";
NSString *const kSLDes3HandlerInitVector = @"01234567";
