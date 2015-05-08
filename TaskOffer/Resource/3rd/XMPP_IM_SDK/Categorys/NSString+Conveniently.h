//
//  NSString+Conveniently.h
//  AppFramework
//
//  Created by wshaolin on 14/11/21.
//  Copyright (c) 2014年 wshaolin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Conveniently)

// 要求转换之前的格式yyyy-MM-dd'T'HH:mm:ssZ，转换之后的格式yyyy-MM-dd HH:mm:ss
- (NSString *)UTCDateFormatToLocalDate;

- (NSString *)trim;

- (NSString *)trimWhitespaceAndNewlineCharacterSet;

@end

@interface NSString (DateTime) // 日期、时间

- (NSDate *)dateWithStringFormat:(NSString *)formatter;
- (NSDate *)dateWithDefaultFormat; // yyyy-MM-dd HH:mm:ss

@end

@interface NSString (Validation) // 校验

- (BOOL)validateMobile; // 校验手机号
- (BOOL)validateTelephone; // 校验座机号
- (BOOL)validateMoney; // 校验金额
- (BOOL)validatePassword; // 校验密码
- (BOOL)validateIllegalCharacter; // 校验特殊字符
- (BOOL)validateEmail; // 校验邮箱

@end

@interface NSString (Font)

// limitSize不能为CGSizeZero，如果传入CGSizeZero，则默认为CGSizeMake(MAXFLOAT, MAXFLOAT)
- (CGSize)sizeWithFont:(UIFont *)font limitSize:(CGSize)limitSize;

@end

@interface NSString (Encryption) // 加密

- (NSString *)MD5Encrypt; // MD5
- (NSString *)SHA1Encrypt; // 哈希1

@end

@interface NSString (Character)

- (NSInteger)unicodeStringEncodingLength; // UTF8编码的字符长度，（一个中文占2个字节）
- (NSInteger)chineseCharacterCount; // 中文字数
- (NSInteger)englishCharacterCount; // 英文字数

@end

@interface NSString (Emoji)

- (CGSize)emojiSizeWithFont:(UIFont *)font maximumWidth:(CGFloat)maximumWidth;
- (CGSize)emojiSizDefaultLineSpacingeWithFont:(UIFont *)font maximumWidth:(CGFloat)maximumWidth;
- (CGSize)emojiSizeWithFont:(UIFont *)font lineSpacing:(CGFloat)lineSpacing maximumWidth:(CGFloat)maximumWidth;

- (NSInteger)emojiRowsWithFont:(UIFont *)font lineSpacing:(CGFloat)lineSpacing maximumWidth:(CGFloat)maximumWidth;

@end