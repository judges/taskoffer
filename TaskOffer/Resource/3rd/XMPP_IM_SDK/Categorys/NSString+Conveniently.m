//
//  NSString+Conveniently.m
//  AppFramework
//
//  Created by wshaolin on 14/11/21.
//  Copyright (c) 2014年 wshaolin. All rights reserved.
//

#import "NSString+Conveniently.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Conveniently)

- (NSString *)UTCDateFormatToLocalDate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    NSDate *date = [dateFormatter dateFromString:self];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter stringFromDate:date];
}

- (NSString *)trim{
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (NSString *)trimWhitespaceAndNewlineCharacterSet{
    if(self == nil || self.length == 0){
        return self;
    }
    
    NSString *string = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    while ([string hasPrefix:@" "]) {
        string = [string stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
    }
    
    while ([string hasPrefix:@"\n"]) {
        string = [string stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
    }
    
    while ([string hasSuffix:@" "]) {
        string = [string stringByReplacingCharactersInRange:NSMakeRange(string.length - 1, 1) withString:@""];
    }
    
    while ([string hasSuffix:@"\n"]) {
        string = [string stringByReplacingCharactersInRange:NSMakeRange(string.length - 1, 1) withString:@""];
    }
    
    return string;
}

@end

@implementation NSString (DateTime)

- (NSDate *)dateWithStringFormat:(NSString *)formatter{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    return [dateFormatter dateFromString:self];
}

- (NSDate *)dateWithDefaultFormat{
    return [self dateWithStringFormat:@"yyyy-MM-dd HH:mm:ss"];
}

@end

@implementation NSString (Validation)

- (BOOL)matchRegex:(NSString *)regex{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

- (BOOL)validateMobile{
    NSString *regex = @"^1[3|4|5|7|8][0-9]\\d{8}$";
    return [self matchRegex:regex];
}

- (BOOL)validateTelephone{
    NSString *regex = @"^(0[0-9]{2,3}\\-)?([2-9][0-9]{6,7})+(\\-[0-9]{1,4})?$";
    return [self matchRegex:regex];
}

- (BOOL)validateMoney{
    NSString *regex = @"^[0-9]+(.[0-9]{2})?$";
    return [self matchRegex:regex];
}

- (BOOL)validatePassword{
    NSString *regex = @"^[a-zA-Z0-9]{6,20}+$";
    return [self matchRegex:regex];
}

- (BOOL)validateIllegalCharacter{
    NSString *regex = @"^[A-Za-z0-9\u4E00-\u9FA5]+$";
    return ![self matchRegex:regex];
}

- (BOOL)validateEmail{
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    return [self matchRegex:regex];
}

@end

@implementation NSString (Font)

- (CGSize)sizeWithFont:(UIFont *)font limitSize:(CGSize)limitSize{
    CGSize limitFontSize = limitSize;
    if(__CGSizeEqualToSize(limitFontSize, CGSizeZero)){
            limitFontSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
    }
    
    return [self boundingRectWithSize:limitFontSize
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{NSFontAttributeName : font}
                              context:nil].size;
}

@end

@implementation NSString (Encryption)

- (NSString *)MD5Encrypt{
    const char* input = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *encryptString = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [encryptString appendFormat:@"%02x", result[i]];
    }
    
    return [encryptString copy];
}

- (NSString *)SHA1Encrypt{
    const char* input = [self UTF8String];
    unsigned char result[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *encryptString = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [encryptString appendFormat:@"%02x", result[i]];
    }
    
    return [encryptString copy];
}

@end

@implementation NSString (Character)

- (NSInteger)unicodeStringEncodingLength{
    NSInteger length = 0;
    for (NSInteger index = 0; index < [self length]; index ++){ // 循环取每一个字符
        NSString *string = [self substringWithRange:NSMakeRange(index, 1)];
        if ([string lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3){ // 中文
            length += 2;
        }else{ // 其他
            length ++;
        }
    }
    return length;
}

- (NSInteger)chineseCharacterCount{
    NSInteger characterCount = 0;
    for (NSInteger index = 0; index < [self length]; index ++){
        NSString *string = [self substringWithRange:NSMakeRange(index, 1)];
        if ([string lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3){
            characterCount ++;
        }
    }
    return characterCount;
}

- (NSInteger)englishCharacterCount{
    NSInteger characterCount = 0;
    for (NSInteger index = 0; index < [self length]; index ++){
        NSString *string = [self substringWithRange:NSMakeRange(index, 1)];
        if ([string lengthOfBytesUsingEncoding:NSUTF8StringEncoding] != 3){
            characterCount ++;
        }
    }
    return characterCount;
}

@end

@implementation NSString (Emoji)

- (CGSize)emojiSizeWithFont:(UIFont *)font maximumWidth:(CGFloat)maximumWidth{
    return [self emojiSizeWithFont:font lineSpacing:0.0 maximumWidth:maximumWidth];
}

- (CGSize)emojiSizDefaultLineSpacingeWithFont:(UIFont *)font maximumWidth:(CGFloat)maximumWidth{
    return [self emojiSizeWithFont:font lineSpacing:3.0 maximumWidth:maximumWidth];
}

- (CGSize)emojiSizeWithFont:(UIFont *)font lineSpacing:(CGFloat)lineSpacing maximumWidth:(CGFloat)maximumWidth{
    // 匹配emoji表情的正则
    NSRegularExpression *regularExpression = [[NSRegularExpression alloc] initWithPattern:@"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]" options:NSRegularExpressionCaseInsensitive error:nil];
    
    // 使用一个汉字替换匹配到的表情字符，用于计算正确的size
    NSString *string = [regularExpression stringByReplacingMatchesInString:self options:0 range:NSMakeRange(0, self.length) withTemplate:@"中"];
    
    CGSize contentSize = [string sizeWithFont:font limitSize:CGSizeMake(maximumWidth, MAXFLOAT)];
    // 加上行间距
    NSInteger row = (NSInteger)(contentSize.height / font.lineHeight);
    
    if(row > 1){
        contentSize.height += lineSpacing * row;
    }
    
    return contentSize;
}

- (NSInteger)emojiRowsWithFont:(UIFont *)font lineSpacing:(CGFloat)lineSpacing maximumWidth:(CGFloat)maximumWidth{
    // 匹配emoji表情的正则
    NSRegularExpression *regularExpression = [[NSRegularExpression alloc] initWithPattern:@"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]" options:NSRegularExpressionCaseInsensitive error:nil];
    
    // 使用一个汉字替换匹配到的表情字符，用于计算正确的size
    NSString *string = [regularExpression stringByReplacingMatchesInString:self options:0 range:NSMakeRange(0, self.length) withTemplate:@"中"];
    
    CGSize contentSize = [string sizeWithFont:font limitSize:CGSizeMake(maximumWidth, MAXFLOAT)];
    
    return lrintf(contentSize.height / font.lineHeight);
}

@end
