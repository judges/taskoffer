//
//  AppDelegate.m
//  TaskOffer
//
//  Created by BourbonZ on 15/3/11.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "ProjectController.h"
#import "SLConnectionViewController.h"
#import "DialogueController.h"
#import "MineController.h"
#import "XMPPDataHelper.h"
#import "LoginViewController.h"
#import "APService.h"
#import "TOHttpHelper.h"
#import "ToToolHelper.h"
#import "SetInfoViewController.h"
#import "QRCodeViewController.h"
#import "ProjectDialogueDataBaseHelper.h"
#import "ViewController.h"
static UITabBarController *tab = nil;

@interface AppDelegate ()<XMPPDataHelperDelegate,xmppDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [application setStatusBarHidden:NO];
    [application setStatusBarStyle:UIStatusBarStyleLightContent];

    
    ///链接IMf服务器
    XMPPDataHelper *dataHelper = [XMPPDataHelper shareHelper];
    [dataHelper setDelegate:self];
    [dataHelper setupStream];
    XMPPHelper *helper = [XMPPHelper sharedHelper];
    [helper setDelegate:self];
    if ([XMPPHelper allInformationReadyUserName:@"" passWord:@""])
    {
        [XMPPHelper connectToServer];
    }

//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"mybase.sqlite"];
    
    
    [[ProjectDialogueDataBaseHelper sharedHelper] createDatabase];
    
    if ([ToToolHelper checkIfLogin])
    {
        NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"toUserName"];
        NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"toPassWord"];
        
        if ([username isEqualToString:@""] || username == nil ||
            [password isEqualToString:@""] || password == nil)
        {
            
        }
        else
        {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:username forKeyedSubscript:@"userPhone"];
            [dict setObject:password forKeyedSubscript:@"userPassword"];
            [dict setObject:[APService registrationID] forKey:@"pushId"];
            [dict setObject:@"1" forKeyedSubscript:@"phoneType"];
            
            [TOHttpHelper postUrl:kTOLogin parameters:dict showHUD:NO success:^(NSDictionary *dataDictionary) {
                
                UserInfo *info = [UserInfo sharedInfo];
                [info setInfoDict:[dataDictionary objectForKey:@"info"]];
                
                
                [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"toUserName"];
                [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"toPassWord"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                
                [[XMPPHelper sharedHelper] setDelegate:self];
                
                [XMPPHelper loginWithJidWithUserName:[info userID] passWord:[info userID]];
                
            } failure:^(NSError *error) {
                
            }];
            
            
            UITabBarController *naviLogin = [self sharedTabbarController];
            self.window.rootViewController = naviLogin;
        }
    }
    else
    {
//        LoginViewController *login = [[LoginViewController alloc] init];
//        UINavigationController *naviLogin = [[UINavigationController alloc] initWithRootViewController:login];
//        self.window.rootViewController = naviLogin;
        ViewController *viewController = [[ViewController alloc] init];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:viewController];
        self.window.rootViewController = navi;
    }
    
    [self configureJPushPlatformWithOptions:launchOptions];
    
    [ToToolHelper createPrivatePlist];
    NSLog(@"%@",NSHomeDirectory());
 

    [self.window makeKeyAndVisible];
    return YES;
}

- (void)configureJPushPlatformWithOptions:(NSDictionary *)launchOptions{
    // Required
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil];
    } else {
        // categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert) categories:nil];
    }
#else
    // categories 必须为nil
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert) categories:nil];
#endif
    // Required
    [APService setupWithOption:launchOptions];
    //[APService setDebugMode];
    [APService crashLogON];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNetworkDidLoginNotification:) name:kJPFNetworkDidLoginNotification object:nil];
}

- (void)didReceiveNetworkDidLoginNotification:(NSNotification *)notification {
    
    if ([APService registrationID]) {
        NSLog(@"APService RegistrationID: %@",[APService registrationID]);//获取registrationID
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma 链接结果
-(void)connectToServerWithResult:(resultFromServer)result
{
    if (result == connectSuccess)
    {
        NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"toUserName"];
        NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"toPassWord"];
        if (username.length > 0 && password.length > 0)
        {
            [[ToToolHelper sharedHelper]loginWithUserName:username password:password];            
        }
    }
    else if (result == conncetError)
    {

        [HUDView showHUDWithText:@"链接IM服务器失败,请重试"];
        
    }
}

#pragma mark 主界面的TabBarController
-(UITabBarController *)sharedTabbarController
{
    @synchronized(self)
    {
        if (tab == nil)
        {
            ProjectController *progect = [[ProjectController alloc] init];
            UINavigationController *progectNavi = [[UINavigationController alloc] initWithRootViewController:progect];
            progectNavi.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"项目" image:[UIImage imageNamed:@"项目3"] selectedImage:[UIImage imageNamed:@"项目选中"]];
            
            SLConnectionViewController *connection = [[SLConnectionViewController alloc] init];
            UINavigationController *conncetionNavi = [[UINavigationController alloc] initWithRootViewController:connection];
            conncetionNavi.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"人脉" image:[UIImage imageNamed:@"人脉"] selectedImage:[UIImage imageNamed:@"人脉选中"]];
            
            DialogueController *dialogue = [[DialogueController alloc] init];
            UINavigationController *dialogueNavi = [[UINavigationController alloc] initWithRootViewController:dialogue];
            dialogue.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"对话" image:[UIImage imageNamed:@"对话"] selectedImage:[UIImage imageNamed:@"对话选中"]];
            dialogue.title = @"对话";
            
            MineController *mine = [[MineController alloc] init];
            UINavigationController *mineNavi = [[UINavigationController alloc] initWithRootViewController:mine];
            mineNavi.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:[UIImage imageNamed:@"我的"] selectedImage:[UIImage imageNamed:@"我的选中"]];
            mine.title = @"个人中心";
            mineNavi.tabBarItem.title = @"我的";
            tab = [[UITabBarController alloc] init];
            tab.viewControllers = @[progectNavi,conncetionNavi,dialogueNavi,mineNavi];
        }
        return tab;
    }
}
#pragma mark JPush
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Required
    [APService registerDeviceToken:deviceToken];

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required
    [APService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    
    // IOS 7 Support Required
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

@end
