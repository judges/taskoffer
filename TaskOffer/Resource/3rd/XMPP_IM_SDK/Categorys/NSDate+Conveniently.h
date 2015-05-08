//
//  NSDate+Conveniently.h
//  AppFramework
//
//  Created by wshaolin on 14/11/21.
//  Copyright (c) 2014年 wshaolin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Conveniently)

- (NSString *)dayLinkMonth; // return 02十二月
- (NSString *)intervalTime; // 距离现在的时间，例如：1天前
- (BOOL)isToday;
- (BOOL)isThisYear;

@end

@interface NSDate (String)

- (NSString *)defaultFormat; // yyyy-MM-dd HH:mm:ss

- (NSString *)stringWithFormat:(NSString *)dateFormat;

- (NSString *)stringWithFormat:(NSString *)dateFormat localeIdentifier:(NSString *)localeIdentifier;

@end
