//
//  RegistViewController.m
//  TaskOffer
//
//  Created by BourbonZ on 15/3/19.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "RegistViewController.h"
#import "LBorderHelper.h"
#import "ToToolHelper.h"
#import "TOHttpHelper.h"
#import "APService.h"
#import "AppDelegate.h"
#import "RegisterController.h"
@interface RegistViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,xmppDelegate>
{
    NSArray *titleArray;
    NSArray *placeArray;
    UIButton *getVerifyButton;
    UITableView *registTable;
    NSString *verifyString;
    
    int numTime;
}
@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"注册";
    
    ///数据
    titleArray = [NSArray arrayWithObjects:@"手机号",@"验证码",@"密码",@"确认密码", nil];
    placeArray = [NSArray arrayWithObjects:@"请输入绑定的手机号",@"请输入验证码",@"请输入密码",@"请再次输入密码", nil];
    
    ///表格
    registTable = [[UITableView alloc] initWithFrame:self.view.frame style:(UITableViewStyleGrouped)];
    [registTable setDelegate:self];
    [registTable setDataSource:self];
    [registTable setBackgroundColor:[UIColor colorWithHexString:kDefaultGrayColor]];
    [self.view addSubview:registTable];
    
    ///表格下方的完成注册按钮
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 125)];
    [bottomView setBackgroundColor:[UIColor colorWithHexString:kDefaultGrayColor]];
    UIButton *registDoneButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [registDoneButton setTitle:@"完成注册" forState:(UIControlStateNormal)];
    [registDoneButton setBackgroundColor:[UIColor colorWithHexString:kDefaultTextColor]];
    [registDoneButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [registDoneButton addTarget:self action:@selector(clickRegistDoneButton) forControlEvents:(UIControlEventTouchUpInside)];
    [registDoneButton setBounds:CGRectMake(0, 0, 200, 40)];
    [registDoneButton setCenter:CGPointMake(self.view.frame.size.width/2, 45)];
    registDoneButton.layer.masksToBounds = NO;
    registDoneButton.layer.cornerRadius = 5.0f;
    [bottomView addSubview:registDoneButton];
    registTable.tableFooterView = bottomView;
    
    
    ///设置获取验证码的button
    getVerifyButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [getVerifyButton setTitle:@"获取验证码" forState:(UIControlStateNormal)];
    [getVerifyButton setTitleColor:[UIColor colorWithHexString:kDefaultTextColor] forState:(UIControlStateNormal)];
    [getVerifyButton addTarget:self action:@selector(clickGetVerifyCodeButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [getVerifyButton setBounds:CGRectMake(0, 0, 70, 30)];
    getVerifyButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    ///设置虚线
    CAShapeLayer *border = [LBorderHelper getLayerWithColor:[UIColor colorWithHexString:kDefaultTextColor] withBounds:getVerifyButton.bounds];
    [getVerifyButton.layer addSublayer:border];

    
    numTime = 60;
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
#pragma mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return titleArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
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
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 60, 15)];
        [titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
        [titleLabel setTag:9001];
        [cell.contentView addSubview:titleLabel];
        
        UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(80, 15, self.view.frame.size.width-80-80, 15)];
        [field setFont:[UIFont systemFontOfSize:15.0f]];
        [field setTag:9002];
        [field setReturnKeyType:(UIReturnKeyDone)];
        [field setDelegate:self];
        [cell.contentView addSubview:field];
        
        [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
        
    }
    
    UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:9001];
    [titleLabel setText:[titleArray objectAtIndex:indexPath.section]];
    
    UITextField *field = (UITextField *)[cell.contentView viewWithTag:9002];
    [field setPlaceholder:[placeArray objectAtIndex:indexPath.section]];
    
    if (indexPath.section == 1)
    {
        [getVerifyButton setCenter:CGPointMake(self.view.frame.size.width-40, 22)];
        [cell.contentView addSubview:getVerifyButton];
    }
    
    if (indexPath.section == 0 || indexPath.section == 1)
    {
        [field setKeyboardType:(UIKeyboardTypeNumberPad)];
    }
    else
    {
        [field setSecureTextEntry:YES];
    }
    
    return cell;

}
#pragma mark UITextField Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField endEditing:YES];
    return YES;
}
#pragma mark 获取验证码
-(void)clickGetVerifyCodeButton:(UIButton *)button
{
    UITableViewCell *phoneCell = [registTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UITextField *phoneField = (UITextField *)[phoneCell.contentView viewWithTag:9002];
    
    if (![ToToolHelper isMobileNumber:phoneField.text])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"请输入正确的手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:phoneField.text,@"userPhone",@"0",@"type", nil];
    [TOHttpHelper postUrl:kTOGetVerifyCode parameters:dict showHUD:YES success:^(NSDictionary *dataDictionary) {
        
        verifyString = [dataDictionary objectForKey:@"info"];

        NSString *str = [NSString stringWithFormat:@"%@",@"验证码已发送，请输入验证码"];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:str delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
//        [alert show];
        
        [HUDView showHUDWithText:str];
        
        NSLog(@"接收到的验证码:%@",verifyString);
        
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeTitle) userInfo:nil repeats:YES];
        
        
    } failure:^(NSError *error) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:error.localizedDescription delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
        [HUDView showHUDWithText:error.localizedDescription];
        
        [getVerifyButton setTitle:@"获取验证码" forState:(UIControlStateNormal)];
        getVerifyButton.userInteractionEnabled = YES;
    }];
}
#pragma mark 更改获取验证码按钮上的文字
-(void)changeTitle
{
    
    numTime = numTime -1;
    if (numTime < 0)
    {
        [getVerifyButton setTitle:@"获取验证码" forState:(UIControlStateNormal)];
        getVerifyButton.userInteractionEnabled = YES;
    }
    else
    {
        NSString *time = [NSString stringWithFormat:@"剩余%d秒",numTime];
        [getVerifyButton setTitle:time forState:(UIControlStateNormal)];
        getVerifyButton.userInteractionEnabled = NO;
    }
}

#pragma mark 点击完成注册
-(void)clickRegistDoneButton
{
    ///检测手机号
    UITableViewCell *phoneCell = [registTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UITextField *phoneField = (UITextField *)[phoneCell.contentView viewWithTag:9002];
    if (![ToToolHelper isMobileNumber:phoneField.text])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"请输入正确的手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    ///检测验证码
    UITableViewCell *verifyCell = [registTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    UITextField *verifyField = (UITextField *)[verifyCell.contentView viewWithTag:9002];
    if (![verifyField.text isEqualToString:verifyString])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"验证码输入不正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    ///检测密码输入是否一样
    UITableViewCell *passwordCell = [registTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    UITextField *passwordField = (UITextField *)[passwordCell.contentView viewWithTag:9002];
    
    UITableViewCell *examineCell = [registTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
    UITextField *examineField = (UITextField *)[examineCell.contentView viewWithTag:9002];
    
    if (passwordField.text.length < 6)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"密码要大于或等于6位" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    
    if ([passwordField.text isEqualToString:examineField.text] && passwordField.text != nil && passwordField.text.length >= 6)
    {
        ///进行注册
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:phoneField.text forKey:@"userPhone"];
        [dict setObject:passwordField.text forKey:@"userPassword"];
        [dict setObject:[APService registrationID] forKey:@"pushId"];
        [dict setObject:@"1" forKey:@"phoneType"];
        [TOHttpHelper postUrl:kTORegist parameters:dict showHUD:YES success:^(NSDictionary *dataDictionary) {
            
            UserInfo *userInfo = [UserInfo sharedInfo];
            [userInfo setInfoDict:[dataDictionary objectForKey:@"info"]];

            [HUDView showHUDWithText:@"注册成功，正在登录"];
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:phoneField.text forKeyedSubscript:@"userPhone"];
            [dict setObject:passwordField.text forKeyedSubscript:@"userPassword"];
            [dict setObject:[APService registrationID] forKey:@"pushId"];
            [dict setObject:@"1" forKeyedSubscript:@"phoneType"];
            
            [TOHttpHelper postUrl:kTOLogin parameters:dict showHUD:YES success:^(NSDictionary *dataDictionary) {
                
                UserInfo *info = [UserInfo sharedInfo];
                [info setInfoDict:[dataDictionary objectForKey:@"info"]];
                
                
                [[NSUserDefaults standardUserDefaults] setObject:phoneField.text forKey:@"toUserName"];
                [[NSUserDefaults standardUserDefaults] setObject:passwordField.text forKey:@"toPassWord"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                
                [[XMPPHelper sharedHelper] setDelegate:self];
                
                [XMPPHelper loginWithJidWithUserName:[info userID] passWord:[info userID]];
                
//                [self.navigationController popViewControllerAnimated:YES];

            } failure:^(NSError *error) {
                
            }];

            
        } failure:^(NSError *error) {
            
        }];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"两次输入的密码不一致" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
}
#pragma mark 登录返回结果
-(void)loginWithResult:(resultFromServer)result
{
    if (result == loginSuccess)
    {
        [ToToolHelper getPrivtePlist];
        
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        
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
