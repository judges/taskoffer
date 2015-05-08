//
//  TimeHelper.h
//  XMPPIM
//
//  Created by BourbonZ on 14/12/24.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeHelper : NSObject

///返回音频路径的时间长度
+(NSNumber *)soundsTimeByPath:(NSString *)path;

///返回对话界面的时间
+(NSString *)timeForMessage:(NSDate *)date;
@end
