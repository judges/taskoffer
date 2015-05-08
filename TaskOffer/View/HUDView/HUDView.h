//
//  HUDView.h
//  TaskOffer
//
//  Created by BourbonZ on 15/4/7.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HUDView : NSObject
+(HUDView *)sharedHUDView;

-(void)showHUDView:(NSString *)content;

-(void)showHUDView:(NSString *)content withDelayTime:(NSTimeInterval)time;

-(void)hideHUDView;

+(void)showHUDWithText:(NSString *)text;

@end
