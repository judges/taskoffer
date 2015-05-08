//
//  BaseViewController.m
//  rndIM
//
//  Created by BourbonZ on 14/12/2.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import "BaseViewController.h"
#import "XMPPHelper.h"
#import "XMPPRoomHelper.h"
#import "HexColor.h"
//#import "VideoController.h"
//#import "PhoneController.h"
@interface BaseViewController ()<
        XMPPRoomHelperDelegate,
        xmppDelegate,
        UIGestureRecognizerDelegate
        >

@end

@implementation BaseViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    XMPPHelper *basexmpp = [XMPPHelper sharedHelper];
    [basexmpp setDelegate:self];
    XMPPRoomHelper *baseroom = [XMPPRoomHelper sharedRoom];
    [baseroom setDelegate:self];
    
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回剪头"] style:(UIBarButtonItemStylePlain) target:self action:@selector(goBackToTop)];
    
    

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"show" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showViwe:) name:@"show" object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"video" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoShow:) name:@"video" object:nil];
    
}

- (void)goBackToTop{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark
-(void)showViwe:(NSNotification *)notify
{

//    PhoneController *video = [[PhoneController alloc] init];
//    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:video];
//    [self presentViewController:navi animated:YES completion:nil];
    
//    PhoneController *phone = [[PhoneController alloc] init];
//    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:phone];
//    navi.view.tag = 1111;
//    [self presentViewController:navi animated:YES completion:nil];
}

#pragma mark 
-(void)videoShow:(NSNotification *)notify
{
//    VideoController *video = [[VideoController alloc] init];
//    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:video];
//    [self presentViewController:navi animated:YES completion:nil];
}


@end
