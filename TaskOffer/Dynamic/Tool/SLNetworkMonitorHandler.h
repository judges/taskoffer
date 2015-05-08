//
//  SLNetworkMonitorHandler.h
//  AppFramework
//
//  Created by wshaolin on 14/11/20.
//  Copyright (c) 2014年 wshaolin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef NS_ENUM(NSInteger, SLNetworkReachabilityStatus) {
    SLNetworkReachabilityStatusUnknown          = -1,
    SLNetworkReachabilityStatusNotReachable     = 0,
    SLNetworkReachabilityStatusReachableViaWWAN = 1,
    SLNetworkReachabilityStatusReachableViaWiFi = 2,
};

@interface SLNetworkMonitorHandler : NSObject

@property (nonatomic, assign, readonly) BOOL isLocateSuccess; // 是否定位成功，只有定位成功之后coordinate才有正确的值
@property (nonatomic, assign, readonly) CLLocationCoordinate2D coordinate; // 经纬度
@property (nonatomic, assign, readonly) BOOL isAvailableNetwork; // 网络是否可用
@property (nonatomic, assign, readonly) SLNetworkReachabilityStatus networkReachabilityStatus;

+ (instancetype)sharedMonitorHandler;

- (void)startNetworkMonitoring; // 启动网络监控

- (void)stopNetworkMonitoring; // 关闭网络监控

- (void)startUserLocation; // 开始定位

@end

FOUNDATION_EXPORT NSString *const kSLNetworkMonitorReachabilityDidChangeNotification; // 网络变化通知
FOUNDATION_EXPORT NSString *const kSLNetworkMonitorReachabilityAvailableNotification; // 网络可用的通知
FOUNDATION_EXPORT NSString *const kSLNetworkMonitorLocateSuccessNotification; // 定位成功的通知

