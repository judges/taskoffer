//
//  ForgetPasswordViewController.m
//  TaskOffer
//
//  Created by BourbonZ on 15/3/19.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "LBorderHelper.h"
#import "ToToolHelper.h"
#import "TOHttpHelper.h"
@interface ForgetPasswordViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    NSArray *setArray;
    NSArray *placeArray;
    UIButton *getVerifyButton;
    UITableView *setTable;
    NSString *verifyCode;

    int numTime;
}
@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"忘记密码";
    
    ///设置表格
    setTable = [[UITableView alloc] initWithFrame:self.view.frame style:(UITableViewStyleGrouped)];
    [setTable setDelegate:self];
    [setTable setDataSource:self];
    [setTable setBackgroundColor:[UIColor colorWithHexString:kDefaultBackColor]];
    
    ///下方的完成按钮
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    [bottomView setBackgroundColor:[UIColor colorWithHexString:kDefaultBackColor]];
    UIButton *doneButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [doneButton setTitle:@"完    成" forState:(UIControlStateNormal)];
    [doneButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [doneButton setBackgroundColor:[UIColor colorWithHexString:kDefaultTextColor]];
    [doneButton.layer setMasksToBounds:YES];
    [doneButton.layer setCornerRadius:5.0f];
    [doneButton addTarget:self action:@selector(clickDoneButton) forControlEvents:(UIControlEventTouchUpInside)];
    [doneButton setFrame:CGRectMake((self.view.frame.size.width-200)/2, 30, 200, 40)];
    [bottomView addSubview:doneButton];
    setTable.tableFooterView = bottomView;
    [self.view addSubview:setTable];

    
    ///设置数据
    setArray = [NSArray arrayWithObjects:@"手机号",@"验证码",@"重设密码",@"确认密码", nil];
    placeArray = [NSArray arrayWithObjects:@"请输入绑定的手机号",@"请输入验证码",@"请输入新密码",@"请再次输入新密码", nil];
    
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
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark 点击完成按钮
-(void)clickDoneButton
{
    UITableViewCell *phoneCell = [setTable cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    UITextField *phoneField = (UITextField *)[phoneCell viewWithTag:9002];

    UITableViewCell *vercodeCell = [setTable cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]];
    UITextField *vercodeField = (UITextField *)[vercodeCell viewWithTag:9002];

    UITableViewCell *passwordCell = [setTable cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:2]];
    UITextField *passwordField = (UITextField *)[passwordCell viewWithTag:9002];

    UITableViewCell *confirmCell = [setTable cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:3]];
    UITextField *confimField = (UITextField *)[confirmCell viewWithTag:9002];

    if (![vercodeField.text isEqualToString:verifyCode])
    {
        [HUDView showHUDWithText:@"输入的验证码不正确"];
        return;
    }
    
    if (![passwordField.text isEqualToString:confimField.text])
    {
        [HUDView showHUDWithText:@"两次输入的密码不相同"];
        return;
    }
    
    if (![ToToolHelper isMobileNumber:phoneField.text])
    {
        [HUDView showHUDWithText:@"手机号输入不正确"];
        return;
    }

    if (passwordField.text.length < 6 || passwordField.text.length > 20 )
    {
        [HUDView showHUDWithText:@"密码长度必须在6到20位之间"];
        return;
    }
    
    if (passwordField.text == nil || [passwordField.text isEqualToString:@""] ||
        confimField.text == nil || [confimField.text isEqualToString:@""])
    {
        [HUDView showHUDWithText:@"密码不能为空"];
        return;

    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:phoneField.text forKeyedSubscript:@"userPhone"];
    [dict setObject:passwordField.text forKeyedSubscript:@"userPassword"];
    [dict setObject:@"0" forKey:@"isModifyPassWord"];
    [TOHttpHelper postUrl:kTOModify parameters:dict showHUD:YES success:^(NSDictionary *dataDictionary) {
        verifyCode = @"";
        [HUDView showHUDWithText:@"更改成功,请重新登录"];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        
        
        
    }];
}
#pragma mark UITableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return setArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
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
    [titleLabel setText:[setArray objectAtIndex:indexPath.section]];
    
    UITextField *field = (UITextField *)[cell.contentView viewWithTag:9002];
    [field setPlaceholder:[placeArray objectAtIndex:indexPath.section]];
    
    if (indexPath.section == 1)
    {
        [getVerifyButton setCenter:CGPointMake(self.view.frame.size.width-40, 22)];
        [cell.contentView addSubview:getVerifyButton];
        [field setKeyboardType:(UIKeyboardTypeNumberPad)];
    }
    else if (indexPath.section == 0)
    {
        [field setKeyboardType:(UIKeyboardTypePhonePad)];
    }
    else if (indexPath.section == 3 || indexPath.section == 2)
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
    UITableViewCell *phoneCell = [setTable cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    UITextField *phoneField = (UITextField *)[phoneCell viewWithTag:9002];
    if (![ToToolHelper isMobileNumber:phoneField.text])
    {
        [HUDView showHUDWithText:@"请输入正确的手机号"];
        return;
    }

    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:phoneField.text forKey:@"userPhone"];
    [dict setObject:@"1" forKey:@"type"];
    
    [TOHttpHelper postUrl:kTOGetVerifyCode parameters:dict showHUD:YES success:^(NSDictionary *dataDictionary) {

        [HUDView showHUDWithText:@"获取验证码成功，请注意查收"];

        verifyCode = [dataDictionary objectForKey:@"info"];
        
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeButtonTitle) userInfo:nil repeats:YES];
        
    } failure:^(NSError *error) {
        
        [getVerifyButton setTitle:@"获取验证码" forState:(UIControlStateNormal)];
        getVerifyButton.userInteractionEnabled = YES;

        
    }];
}
#pragma mark 更改按钮文字
#pragma mark 更改获取验证码按钮上的文字
-(void)changeButtonTitle
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

@end
