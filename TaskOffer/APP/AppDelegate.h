//
//  AppDelegate.h
//  TaskOffer
//
//  Created by BourbonZ on 15/3/11.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

///获取主界面
-(UITabBarController *)sharedTabbarController;

@end

