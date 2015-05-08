//
//  HUDView.m
//  TaskOffer
//
//  Created by BourbonZ on 15/4/7.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "HUDView.h"
#import "MBProgressHUD.h"
static HUDView *hudView = nil;
static MBProgressHUD *HUD = nil;
@implementation HUDView
+(HUDView *)sharedHUDView
{
    if (hudView == nil)
    {
        hudView = [[HUDView alloc] init];
        HUD = [[MBProgressHUD alloc] initWithView:[[UIApplication sharedApplication] keyWindow]];
    }
    return hudView;
}
-(void)showHUDView:(NSString *)content
{
    if (![[[[UIApplication sharedApplication] keyWindow] subviews] containsObject:HUD])
    {
        [[[UIApplication sharedApplication] keyWindow] addSubview:HUD];
    }
    
    HUD.labelText = content;
    [HUD show:YES];
}
+(void)showHUDWithText:(NSString *)text
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    hud.margin = 15.0f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];

}
-(void)showHUDView:(NSString *)content withDelayTime:(NSTimeInterval)time
{
    if (![[[[UIApplication sharedApplication] keyWindow] subviews] containsObject:HUD])
    {
        [[[UIApplication sharedApplication] keyWindow] addSubview:HUD];
    }
    
    HUD.labelText = content;
    [HUD show:YES];
    [HUD hide:YES afterDelay:time];
}

-(void)hideHUDView
{
    [HUD hide:YES];
    [HUD removeFromSuperview];
}
@end
