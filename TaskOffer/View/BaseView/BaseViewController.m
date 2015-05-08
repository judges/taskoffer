//
//  BaseViewController.m
//  TaskOffer
//
//  Created by BourbonZ on 15/3/12.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "BaseViewController.h"
#import "HexColor.h"
#import "XMPPHelper.h"
#import "XMPPDataHelper.h"
#import "LoginViewController.h"
@interface BaseViewController ()<xmppDelegate, XMPPDataHelperDelegate>

@end

@implementation BaseViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:19.0f],NSForegroundColorAttributeName : [UIColor whiteColor]};
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.tabBarController.tabBar.tintColor = [UIColor colorWithHexString:kDefaultBarColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    self.view.backgroundColor = [UIColor colorWithHexString:kDefaultGrayColor];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:kDefaultBarColor];

    
    
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] init];
    backBarButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backBarButtonItem;
    
    XMPPHelper *xmppHelper = [XMPPHelper sharedHelper];
    [xmppHelper setDelegate:self];
    XMPPDataHelper *tmpdataHelper = [XMPPDataHelper shareHelper];
    [tmpdataHelper setDelegate:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginother:) name:@"loginInOtherPlace" object:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(void)loginother:(NSNotification *)notify
{
    LoginViewController *login = [[LoginViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:login];
    [self presentViewController:navi animated:YES completion:nil];
}

@end
