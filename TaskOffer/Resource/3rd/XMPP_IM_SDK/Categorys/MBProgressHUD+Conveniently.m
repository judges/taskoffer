//
//  MBProgressHUD+Conveniently.m
//  AppFramework
//
//  Created by wshaolin on 14/11/20.
//  Copyright (c) 2014年 wshaolin. All rights reserved.
//

#import "MBProgressHUD+Conveniently.h"

#define MBProgressHUDConvenientlyDefaultDurationTimeInterval 2.0

@implementation MBProgressHUD (Conveniently)

+ (void)showWithText:(NSString *)text icon:(NSString *)icon inView:(UIView *)view durationTimeInterval:(NSTimeInterval)durationTimeInterval{
    if (view == nil) {
        view = [[UIApplication sharedApplication].windows firstObject];
    }
    
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    progressHUD.labelText = text;
    // 设置图片
    progressHUD.customView = [[TouchImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    // 再设置模式
    progressHUD.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    progressHUD.removeFromSuperViewOnHide = YES;
    
    // durationTimeInterval秒之后再消失
    [progressHUD hide:YES afterDelay:durationTimeInterval];
}

+ (void)showWithError:(NSString *)error inView:(UIView *)view durationTimeInterval:(NSTimeInterval)durationTimeInterval{
    [self showWithText:error icon:@"error.png" inView:view durationTimeInterval:durationTimeInterval];
}

+ (void)showWithSuccess:(NSString *)success inView:(UIView *)view durationTimeInterval:(NSTimeInterval)durationTimeInterval{
    [self showWithText:success icon:@"success.png" inView:view durationTimeInterval:durationTimeInterval];
}

+ (instancetype)showWithMessage:(NSString *)message inView:(UIView *)view{
    if (view == nil) {
        view = [[UIApplication sharedApplication].windows firstObject];
    }
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    progressHUD.labelText = message;
    // 隐藏时候从父控件中移除
    progressHUD.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    progressHUD.dimBackground = YES;
    return progressHUD;
}

+ (void)showWithSuccess:(NSString *)success{
    [self showWithSuccess:success durationTimeInterval:MBProgressHUDConvenientlyDefaultDurationTimeInterval];
}

+ (void)showWithSuccess:(NSString *)success durationTimeInterval:(NSTimeInterval)durationTimeInterval{
    [self showWithSuccess:success inView:nil durationTimeInterval:durationTimeInterval];
}

+ (void)showWithError:(NSString *)error{
    [self showWithError:error durationTimeInterval:MBProgressHUDConvenientlyDefaultDurationTimeInterval];
}

+ (void)showWithError:(NSString *)error durationTimeInterval:(NSTimeInterval)durationTimeInterval{
    [self showWithError:error inView:nil durationTimeInterval:durationTimeInterval];
}

+ (instancetype)showWithText:(NSString *)text{
    return [self showWithMessage:text inView:nil];
}

+ (void)hideForView:(UIView *)view{
    if(view == nil){
        view = [[UIApplication sharedApplication].windows firstObject];
    }
    [self hideHUDForView:view animated:YES];
}

+ (void)hide{
    [self hideForView:nil];
}

+ (void)hideAllForView:(UIView *)view{
    if(view == nil){
        view = [[UIApplication sharedApplication].windows firstObject];
    }
    [self hideAllHUDsForView:view animated:YES];
}

+ (void)hideAll{
    [self hideAllForView:nil];
}

@end
