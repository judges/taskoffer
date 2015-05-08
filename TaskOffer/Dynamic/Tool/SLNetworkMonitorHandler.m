//
//  SLNetworkMonitorHandler.m
//  AppFramework
//
//  Created by wshaolin on 14/11/20.
//  Copyright (c) 2014年 wshaolin. All rights reserved.
//

#import "SLNetworkMonitorHandler.h"
#import "AFNetworkReachabilityManager.h"

@interface SLNetworkMonitorHandler()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign, getter = isLastNetworkAvailableFlag) BOOL lastNetworkAvailableFlag; // 网络上一次是否可用的标记
@property (nonatomic, assign, getter = isSendNetworkStatusDidChangeNotification) BOOL sendNetworkStatusDidChangeNotification; // 是否发送过网络状态变化的通知

@end

@implementation SLNetworkMonitorHandler

+ (instancetype)sharedMonitorHandler{
    static SLNetworkMonitorHandler *_networkMonitorHandler = nil;
    static dispatch_once_t t;
    dispatch_once(&t, ^{
        _networkMonitorHandler = [[self alloc] init];
    });
    return _networkMonitorHandler;
}

- (void)startNetworkMonitoring{
    AFNetworkReachabilityManager *networkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [networkReachabilityManager startMonitoring];
    
    // 网络状态变化的监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkingReachabilityDidChangeNotification:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
}

- (void)stopNetworkMonitoring{
    AFNetworkReachabilityManager *networkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [networkReachabilityManager stopMonitoring];
}

- (void)networkingReachabilityDidChangeNotification:(NSNotification *)notification{
    AFNetworkReachabilityManager *networkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
    
    // 网络是否可用
    _isAvailableNetwork = networkReachabilityManager.networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWWAN || networkReachabilityManager.networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi;
    
    // 网络状态
    _networkReachabilityStatus = (SLNetworkReachabilityStatus)networkReachabilityManager.networkReachabilityStatus;
    
    // 第一次网络状态发生变化时发送通知
    // 或者当前这次网络的状态与上一次不一样时也发送同时
    if(!self.isSendNetworkStatusDidChangeNotification || self.isLastNetworkAvailableFlag != self.isAvailableNetwork){
        self.sendNetworkStatusDidChangeNotification = YES;
        self.lastNetworkAvailableFlag = self.isAvailableNetwork;
        // 发送网络状态变化的通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kSLNetworkMonitorReachabilityDidChangeNotification object:self];
        // 单独发送一次网络可用的通知
        if(_isAvailableNetwork){
            [[NSNotificationCenter defaultCenter] postNotificationName:kSLNetworkMonitorReachabilityAvailableNotification object:self];
        }
    }
}

- (CLLocationManager *)locationManager{
    if(_locationManager == nil){
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    return _locationManager;
}

- (void)startUserLocation{
    if([CLLocationManager locationServicesEnabled]){
        [self.locationManager startUpdatingLocation];
    }else{
        NSLog(@"未开启定位服务，无法获取位置信息");
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    if(locations.count > 0){
        CLLocation *location = [locations firstObject];
        _coordinate = location.coordinate;
        _isLocateSuccess = YES;
        // 发送定位 成功的通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kSLNetworkMonitorLocateSuccessNotification object:self];
    }
    [self.locationManager stopUpdatingLocation];
}

- (void)dealloc{
    self.locationManager.delegate = nil;
    self.locationManager = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

NSString *const kSLNetworkMonitorReachabilityDidChangeNotification = @"kSLNetworkMonitorReachabilityDidChangeNotification";
NSString *const kSLNetworkMonitorReachabilityAvailableNotification = @"kSLNetworkMonitorReachabilityAvailableNotification";
NSString *const kSLNetworkMonitorLocateSuccessNotification = @"kSLNetworkMonitorLocateSuccessNotification";