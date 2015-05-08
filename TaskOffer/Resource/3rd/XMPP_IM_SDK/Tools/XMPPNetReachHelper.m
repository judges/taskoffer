//
//  XMPPNetReachHelper.m
//  XMPPIM
//
//  Created by BourbonZ on 15/1/16.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "XMPPNetReachHelper.h"

@implementation XMPPNetReachHelper

+(void)checkNetwork
{
    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        DLog(@"%d", status);
    }];  }


@end
