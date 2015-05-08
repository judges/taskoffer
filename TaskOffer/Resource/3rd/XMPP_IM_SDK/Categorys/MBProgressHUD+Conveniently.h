//
//  MBProgressHUD+Conveniently.h
//  AppFramework
//
//  Created by wshaolin on 14/11/20.
//  Copyright (c) 2014年 wshaolin. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Conveniently)

+ (void)showWithError:(NSString *)error inView:(UIView *)view durationTimeInterval:(NSTimeInterval)durationTimeInterval;
+ (void)showWithSuccess:(NSString *)success inView:(UIView *)view durationTimeInterval:(NSTimeInterval)durationTimeInterval;

+ (instancetype)showWithMessage:(NSString *)message inView:(UIView *)view;

+ (void)showWithSuccess:(NSString *)success;
+ (void)showWithError:(NSString *)error;
+ (void)showWithSuccess:(NSString *)success durationTimeInterval:(NSTimeInterval)durationTimeInterval;
+ (void)showWithError:(NSString *)error durationTimeInterval:(NSTimeInterval)durationTimeInterval;

+ (instancetype)showWithText:(NSString *)text;

+ (void)hideForView:(UIView *)view;
+ (void)hide;

+ (void)hideAllForView:(UIView *)view;
+ (void)hideAll;

@end
