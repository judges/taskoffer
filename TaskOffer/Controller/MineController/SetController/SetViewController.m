//
//  SetViewController.m
//  TaskOffer
//
//  Created by BourbonZ on 15/3/16.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SetViewController.h"
#import "HexColor.h"
#import "FeedBackViewController.h"
#import "VersionViewController.h"
#import "NationalViewController.h"
#import "PrivacyViewController.h"
#import "TOHttpHelper.h"
#import "LoginViewController.h"
#import "ToToolHelper.h"
#import "SLConnectionButton.h"
#import "SLAboutViewController.h"
#import "AppDelegate.h"
#import "ViewController.h"
@interface SetViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    NSArray *setArray;
}
@end

@implementation SetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置";
    
    ///数据
    setArray = [NSArray arrayWithObjects:@"意见反馈",@"关于我们",@"通用功能",@"隐私设置", nil];
   
    ///表格
    UITableView *setTable = [[UITableView alloc] initWithFrame:self.view.frame style:(UITableViewStyleGrouped)];
    [setTable setDataSource:self];
    [setTable setDelegate:self];
    [setTable setBackgroundColor:[UIColor colorWithHexString:kDefaultGrayColor]];
    setTable.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:setTable];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    SLConnectionButton *logoutButton = [SLConnectionButton buttonWithType:(UIButtonTypeCustom)];
    logoutButton.title = @"退出登录";
    [logoutButton setFrame:CGRectMake(10.0 , 22.0, self.view.frame.size.width - 20.0, 36.0)];
    [logoutButton addTarget:self action:@selector(clickLogOut)];
    [bottomView addSubview:logoutButton];
    
    setTable.tableFooterView = bottomView;
    
    self.view.backgroundColor = [UIColor colorWithHexString:kDefaultGrayColor];
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
#pragma mark 点击退出登录
-(void)clickLogOut
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要退出登录吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alert show];
}
#pragma mark 确认退出登录
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [TOHttpHelper postUrl:kTOLogout parameters:@{@"id":[[UserInfo sharedInfo] userID]} showHUD:YES success:^(NSDictionary *dataDictionary) {
            

            [ToToolHelper changeLoginState];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"toPassWord"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            ViewController *login = [[ViewController alloc] init];
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:login];
            [self presentViewController:navi animated:YES completion:^{
                [self removeFromParentViewController];
                
                AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                UITabBarController *tabbar = [app sharedTabbarController];
                [tabbar setSelectedIndex:0];
                
                [XMPPHelper logOut];
            }];
            
        } failure:^(NSError *error) {
            
        }];
    }
}
#pragma mark UITableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return setArray.count;
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
        UILabel *titleLabel = [[UILabel alloc] init];
        [titleLabel setFrame:CGRectMake(10, 0, 200, cell.frame.size.height)];
        [titleLabel setTag:9001];
        [titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
        [cell.contentView addSubview:titleLabel];
    }

    UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:9001];
    [titleLabel setText:[setArray objectAtIndex:indexPath.section]];
    [cell setAccessoryType:(UITableViewCellAccessoryDisclosureIndicator)];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0)
    {
        FeedBackViewController *feedBack = [[FeedBackViewController alloc] init];
        feedBack.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:feedBack animated:YES];
    }
    else if (indexPath.section == 1)
    {
        SLAboutViewController *aboutViewController = [[SLAboutViewController alloc] init];
    [self.navigationController pushViewController:aboutViewController animated:YES];
    }
    else if (indexPath.section == 2)
    {
        NationalViewController *national = [[NationalViewController alloc] init];
        national.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:national animated:YES];
    }
    else if (indexPath.section == 3)
    {
        PrivacyViewController *privacy = [[PrivacyViewController alloc] init];
        privacy.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:privacy animated:YES];
    }
}
@end
