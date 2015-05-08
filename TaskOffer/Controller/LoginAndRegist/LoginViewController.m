//
//  LoginViewController.m
//  TaskOffer
//
//  Created by BourbonZ on 15/3/19.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "LoginViewController.h"
#import "ForgetPasswordViewController.h"
#import "RegistViewController.h"
#import "AppDelegate.h"
#import "TOHttpHelper.h"
#import "APService.h"
#import "ToToolHelper.h"
#import "XMPPHelper.h"
@interface LoginViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,xmppDelegate>
{
    UITableView *loginTable;
}
@end

@implementation LoginViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"登录";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    ///设置表格
    loginTable = [[UITableView alloc] initWithFrame:self.view.frame style:(UITableViewStyleGrouped)];
    [loginTable setDelegate:self];
    [loginTable setDataSource:self];
    [loginTable setBackgroundColor:[UIColor colorWithHexString:kDefaultGrayColor]];
    
    ///忘记密码按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"忘记密码" style:(UIBarButtonItemStylePlain) target:self action:@selector(clickForgetPasswordButton)];
    
    ///表格下方的登录和注册按钮
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 125)];
    [bottomView setBackgroundColor:[UIColor colorWithHexString:kDefaultBackColor]];
    UIButton *loginButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [loginButton setTitle:@"登    录" forState:(UIControlStateNormal)];
    [loginButton setBackgroundColor:[UIColor colorWithHexString:kDefaultTextColor]];
    [loginButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [loginButton addTarget:self action:@selector(clickLoginButton) forControlEvents:(UIControlEventTouchUpInside)];
    [loginButton setBounds:CGRectMake(0, 0, 200, 40)];
    [loginButton setCenter:CGPointMake(self.view.frame.size.width/2, 45)];
    loginButton.layer.masksToBounds = NO;
    loginButton.layer.cornerRadius = 5.0f;
    [bottomView addSubview:loginButton];
    
    UIButton *registButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [registButton setTitle:@"注    册" forState:(UIControlStateNormal)];
    [registButton setBackgroundColor:[UIColor colorWithHexString:kDefaultBackColor]];
    [registButton setTitleColor:[UIColor colorWithHexString:kDefaultTextColor] forState:(UIControlStateNormal)];
    [registButton addTarget:self action:@selector(clickRegistButton) forControlEvents:(UIControlEventTouchUpInside)];
    [registButton setBounds:CGRectMake(0, 0, 200, 40)];
    [registButton setCenter:CGPointMake(self.view.frame.size.width/2, 105)];
    registButton.layer.masksToBounds = NO;
    registButton.layer.cornerRadius = 5.0f;
    registButton.layer.borderColor = [[UIColor colorWithHexString:kDefaultTextColor] CGColor];
    registButton.layer.borderWidth = 1.0f;
//    [bottomView addSubview:registButton];
    bottomView.backgroundColor = [UIColor colorWithHexString:kDefaultGrayColor];
    loginTable.tableFooterView = bottomView;
    [self.view addSubview:loginTable];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark 点击忘记密码
-(void)clickForgetPasswordButton
{
    ForgetPasswordViewController *forget = [[ForgetPasswordViewController alloc] init];
    [self.navigationController pushViewController:forget animated:YES];
}
#pragma mark 点击登录按钮
-(void)clickLoginButton
{
    [self.view endEditing:YES];
    UITableViewCell *userNameCell = [loginTable cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    UITextField *userNameField = (UITextField *)[userNameCell viewWithTag:9002];
    
    UITableViewCell *passwordCell = [loginTable cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]];
    UITextField *passwordField = (UITextField *)[passwordCell viewWithTag:9002];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:userNameField.text forKeyedSubscript:@"userPhone"];
    [dict setObject:passwordField.text forKeyedSubscript:@"userPassword"];
    [dict setObject:[APService registrationID] forKey:@"pushId"];
    [dict setObject:@"1" forKeyedSubscript:@"phoneType"];
    if (userNameField.text.length == 0 || passwordField.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"用户名或密码不能为空" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    
    [TOHttpHelper postUrl:kTOLogin parameters:dict showHUD:YES success:^(NSDictionary *dataDictionary) {
        
        UserInfo *info = [UserInfo sharedInfo];
        [info setInfoDict:[dataDictionary objectForKey:@"info"]];
        
        
        [[NSUserDefaults standardUserDefaults] setObject:userNameField.text forKey:@"toUserName"];
        [[NSUserDefaults standardUserDefaults] setObject:passwordField.text forKey:@"toPassWord"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        [[XMPPHelper sharedHelper] setDelegate:self];
        
        [[HUDView sharedHUDView] showHUDView:@"正在加载"];
        
        [XMPPHelper loginWithJidWithUserName:[info userID] passWord:[info userID]];
//        [XMPPHelper loginWithJidWithUserName:@"wqz" passWord:@"wqz"];
    
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark 点击注册按钮
-(void)clickRegistButton
{
    RegistViewController *regist = [[RegistViewController alloc] init];
    [self.navigationController pushViewController:regist animated:YES];
}
#pragma mark 隐藏键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
#pragma mark UITableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellID];
        UIImageView *iconView = [[TouchImageView alloc] init];
        [iconView setFrame:CGRectMake(10, 12, 23, 23)];
        [iconView setTag:9001];
        [cell.contentView addSubview:iconView];
        
        UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(43, 0, self.view.frame.size.width-43, 44)];
        [field setTag:9002];
        [field setDelegate:self];
        [field setReturnKeyType:(UIReturnKeyDone)];
        [cell.contentView addSubview:field];
    }
    UIImageView *icon = (UIImageView *)[cell.contentView viewWithTag:9001];
    UITextField *field = (UITextField *)[cell.contentView viewWithTag:9002];

    if (indexPath.section == 0)
    {
        [icon setImage:[UIImage imageNamed:@"用户名"]];
        [field setPlaceholder:@"请输入用户名/手机号"];
        [field setKeyboardType:(UIKeyboardTypeNumberPad)];
    }
    else
    {
        [field setSecureTextEntry:YES];
        [icon setImage:[UIImage imageNamed:@"密码"]];
        [field setPlaceholder:@"请输入密码"];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
#pragma mark UITextField Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField endEditing:YES];
    return YES;
}
#pragma mark 登录返回结果
-(void)loginWithResult:(resultFromServer)result
{
    if (result == loginSuccess)
    {
        [ToToolHelper getPrivtePlist];
        
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [[HUDView sharedHUDView] hideHUDView];

        UIViewController *tmp = self.presentingViewController;
        if (tmp == nil)
        {
            [self presentViewController:[app sharedTabbarController] animated:YES completion:^{
            }];
        }
        else
        {
            [self dismissViewControllerAnimated:YES completion:^{
            }];
        }

    }
    else if (result == loginError)
    {
        [HUDView showHUDWithText:@"登录失败，请检查"];
    }
}
@end
