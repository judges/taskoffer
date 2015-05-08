//
//  SLTimeStampHandler.h
//  TaskOffer
//
//  Created by wshaolin on 15/3/24.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLTimeStampHandler : NSObject

+ (NSString *)stringWithTimeStamp:(NSTimeInterval)timeStamp; // yyyy-MM-dd HH:mm:ss

+ (NSString *)stringWithTimeStamp:(NSTimeInterval)timeStamp formatter:(NSString *)formatter;

+ (NSTimeInterval)timeStampWithTimeString:(NSString *)timeString; // yyyy-MM-dd HH:mm:ss

+ (NSTimeInterval)timeStampWithTimeString:(NSString *)timeString formatter:(NSString *)formatter;

@end
