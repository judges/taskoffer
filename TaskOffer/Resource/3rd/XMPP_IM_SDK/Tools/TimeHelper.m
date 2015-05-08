//
//  TimeHelper.m
//  XMPPIM
//
//  Created by BourbonZ on 14/12/24.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import "TimeHelper.h"
#import <AudioToolbox/AudioToolbox.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@implementation TimeHelper
+(NSNumber *)soundsTimeByPath:(NSString *)path
{
    AVURLAsset *audioAsset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:path]];
    CMTime audioDuration = audioAsset.duration;
    float audioDurationSeconds = CMTimeGetSeconds(audioDuration);
    NSString *time = [NSString stringWithFormat:@"%.0f",audioDurationSeconds];
    NSNumber *number = [NSNumber numberWithInt:[time intValue]];
    return number;
}

///iOS 8下的方法
+(NSString *)timeForMessage:(NSDate *)date
{
    NSString *time = @"";
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)
    {
        time = [self timeForMessageWithIOS8:date];
    }
    else
    {
        time = [self timeForMessageWithIOS7:date];
    }
    return time;
}
///iOS7下的方法
+(NSString *)timeForMessageWithIOS7:(NSDate *)date
{
    NSString *resultStr        = @"";
    NSDate *nowDate            = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yy/MM/dd"];
    
    int num = [nowDate timeIntervalSince1970] - [date timeIntervalSince1970];
    int day = 60*60*24;
    if (num < day)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm"];
        resultStr = [dateFormatter stringFromDate:date];
    }
    else if (num >= day && num < 2 * day)
    {
        resultStr = @"昨天";
    }
    else if(num >= 2 * day && num < 3 * day)
    {
        resultStr = @"前天";
    }
    else if(num >= 3 * day && num < 7 * day)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd"];
        resultStr = [dateFormatter stringFromDate:date];
    }
    else
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yy/MM"];
        resultStr = [dateFormatter stringFromDate:date];
    }
    

    return resultStr;
}
///iOS8下的时间转换方法
+(NSString *)timeForMessageWithIOS8:(NSDate *)date
{
    NSString *time = @"";
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *dateNow = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSComparisonResult result = [calendar compareDate:dateNow toDate:date toUnitGranularity:(NSCalendarUnitDay)];
    if (result == NSOrderedSame)
    {
        ///同一天
        [formatter setDateFormat:@"HH:mm"];
        time = [formatter stringFromDate:date];
        
    }
    else
    {
        ///不同一天
        ///判断是否是一周时间内
        if ([calendar isDateInYesterday:date])
        {
            time = @"昨天";
        }
        else
        {
            NSDateComponents *dateComponent = [calendar componentsInTimeZone:[NSTimeZone localTimeZone] fromDate:date];
            NSDateComponents *nowComponent = [calendar componentsInTimeZone:[NSTimeZone localTimeZone] fromDate:dateNow];
            
            //判断是否是同一周
            if ([dateComponent weekOfYear] == [nowComponent weekOfYear])
            {
                NSInteger week = [dateComponent weekday];
                NSArray *weekArray = @[@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六"];
                time = [weekArray objectAtIndex:week];
            }
            else
            {
                [formatter setDateFormat:@"yy/MM/dd"];
                time = [formatter stringFromDate:date];
            }
        }
    }
    return time;
}
@end
