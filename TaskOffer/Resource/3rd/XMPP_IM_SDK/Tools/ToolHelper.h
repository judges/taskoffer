//
//  ToolHelper.h
//  rndIM
//
//  Created by BourbonZ on 14/12/10.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPDataHelper.h"
@interface ToolHelper : NSObject

///获取所有手机通讯录
+(NSMutableDictionary *)allPhoneDict;
///获取唯一标示UUID
+(NSString *)deviceUUID;
///将联系人数组转换成字典
+(NSDictionary *)arrayToDictionary:(NSArray *)array;
+(void)sendDeviceToken;
@end
