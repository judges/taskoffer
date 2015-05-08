//
//  NSDate+Conveniently.m
//  AppFramework
//
//  Created by wshaolin on 14/11/21.
//  Copyright (c) 2014年 wshaolin. All rights reserved.
//

#import "NSDate+Conveniently.h"

@implementation NSDate (Conveniently)

- (NSString *)dayLinkMonth{
    if([self isToday]){
        return @"今天";
    }
    NSString *month = [self chineseMonth:[self month]];
    return [NSString stringWithFormat:@"%.2ld%@", (long)[self day], month];
}

- (NSInteger)year{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    return [[gregorian components:NSYearCalendarUnit fromDate:self] year];
}

- (NSInteger)month{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    return [[gregorian components:NSMonthCalendarUnit fromDate:self] month];
}

- (NSInteger)day{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    return [[gregorian components:NSDayCalendarUnit fromDate:self] day];
}

- (NSString *)chineseMonth:(NSInteger)month{
    NSDictionary *monthDictionary = @{@"01" : @"一月",
                                      @"02" : @"二月",
                                      @"03" : @"三月",
                                      @"04" : @"四月",
                                      @"05" : @"五月",
                                      @"06" : @"六月",
                                      @"07" : @"七月",
                                      @"08" : @"八月",
                                      @"09" : @"九月",
                                      @"10" : @"十月",
                                      @"11" : @"十一月",
                                      @"12" : @"十二月"};
    return [monthDictionary objectForKey:[NSString stringWithFormat:@"%.2ld", (long)month]];
}

- (NSString *)intervalTime{
    NSTimeInterval timeInterval = -self.timeIntervalSinceNow;
    if(timeInterval < 60.0){ // 刚刚
        return @"刚刚";
    }else if(timeInterval < 60 * 60.0){ // 一小时内
        return [NSString stringWithFormat:@"%.f分钟前", timeInterval / 60.0];
    }else if(timeInterval < 24 * 60 * 60.0){ // 一天内
        return [NSString stringWithFormat:@"%.f小时前", timeInterval / (60 * 60.0)];
    }else if(timeInterval < 365 * 24 * 60 * 60.0){ // 一年内
        return [NSString stringWithFormat:@"%.f天前", timeInterval / (24 * 60 * 60.0)];
    }else{ // 一年之前
        return [self stringWithFormat:@"yyyy-MM-dd"];
    }
}

- (BOOL)isToday{
    return [self year] == [[NSDate date] year] && [self month] == [[NSDate date] month] && [self day] == [[NSDate date] day];
}

- (BOOL)isThisYear{
    return [self year] == [[NSDate date] year];
}

@end

@implementation NSDate (String)

- (NSString *)defaultFormat{
    return [self stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
}

- (NSString *)stringWithFormat:(NSString *)dateFormat{
    return [self stringWithFormat:dateFormat localeIdentifier:nil];
}

- (NSString *)stringWithFormat:(NSString *)dateFormat localeIdentifier:(NSString *)localeIdentifier{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if(localeIdentifier != nil && localeIdentifier.length > 0){
        NSLocale *locale = [NSLocale localeWithLocaleIdentifier:localeIdentifier];
        if(locale != nil){
            dateFormatter.locale = locale;
        }
    }
    [dateFormatter setDateFormat:dateFormat];
    NSString *dateString = [dateFormatter stringFromDate:self];
    if(dateString == nil){
        dateString = @"";
    }
    return dateString;
}

@end
