//
//  ViewController.m
//  TaskOffer
//
//  Created by BourbonZ on 15/3/11.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "ViewController.h"
#import "LoginViewController.h"
#import "RegistViewController.h"
@interface ViewController ()

@end

@implementation ViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIImageView *backView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"托付"]];
    [backView setFrame:self.view.frame];
    [self.view addSubview:backView];

    

    UIButton *registerButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [registerButton setFrame:CGRectMake((self.view.frame.size.width-40-240)/2, self.view.frame.size.height-150, 120, 35)];
    [registerButton setBackgroundImage:[UIImage imageNamed:@"注册"] forState:(UIControlStateNormal)];
    [registerButton addTarget:self action:@selector(clickRegiter) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:registerButton];
    
    UIButton *loginButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [loginButton setFrame:CGRectMake(registerButton.frame.size.width + registerButton.frame.origin.x + 40, self.view.frame.size.height-150, 120, 35)];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"登录"] forState:(UIControlStateNormal)];
    [loginButton addTarget:self action:@selector(clickLogin) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:loginButton];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)clickRegiter
{
    RegistViewController *registerView = [[RegistViewController alloc] init];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:(UIBarButtonItemStylePlain) target:self action:nil];
    [self.navigationController pushViewController:registerView animated:YES];
}
-(void)clickLogin
{
    LoginViewController *login = [[LoginViewController alloc] init];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:(UIBarButtonItemStylePlain) target:self action:nil];
    [self.navigationController pushViewController:login animated:YES];
}

@end
