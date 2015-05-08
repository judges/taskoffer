//
//  SLTimeStampHandler.m
//  TaskOffer
//
//  Created by wshaolin on 15/3/24.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLTimeStampHandler.h"

@implementation SLTimeStampHandler

+ (NSString *)stringWithTimeStamp:(NSTimeInterval)timeStamp{
    return [self stringWithTimeStamp:timeStamp formatter:@"yyyy-MM-dd HH:mm:ss"];
}

+ (NSString *)stringWithTimeStamp:(NSTimeInterval)timeStamp formatter:(NSString *)formatter{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp / 1000.0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = formatter;
    return [dateFormatter stringFromDate:date];
}

+ (NSTimeInterval)timeStampWithTimeString:(NSString *)timeString;{
    return [self timeStampWithTimeString:timeString formatter:@"yyyy-MM-dd HH:mm:ss"];
}

+ (NSTimeInterval)timeStampWithTimeString:(NSString *)timeString formatter:(NSString *)formatter{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = formatter;
    NSDate *date = [dateFormatter dateFromString:timeString];
    return date.timeIntervalSince1970;
}

@end
