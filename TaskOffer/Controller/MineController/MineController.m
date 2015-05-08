//
//  MineController.m
//  TaskOffer
//
//  Created by BourbonZ on 15/3/12.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "MineController.h"
#import "MineTableViewCell.h"
#import "MyInfoViewController.h"
#import "SetViewController.h"
#import "QRCodeReaderViewController.h"
#import "MyProjectViewController.h"
#import "AddressViewController.h"
#import "MyAttentionCompanyViewContrller.h"
#import "UIImageView+WebCache.h"
#import "TOHttpHelper.h"
#import "NotifyCenterController.h"
#import "SLMyCaseViewController.h"
#import "SLFriendCirclePersonStatusViewController.h"
#import "SLFriendCircleUserModel.h"
#import "SLHTTPServerHandler.h"
#import "SLConnectionDetailViewController.h"
#import "RegisterController.h"
#import "AppDelegate.h"
#import "RedViewHelper.h"
@interface MineController ()<UITableViewDataSource,UITableViewDelegate,QRCodeReaderDelegate,RegisterControllerDelegate>
{
    NSDictionary *titleDict;
    UIButton *setButton;
}
@end

@implementation MineController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];    
    
    
    ///导航栏右侧的设置按钮
    setButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 42, 10, 22, 22)];
    [setButton setImage:[UIImage imageNamed:@"设置"] forState:(UIControlStateNormal)];
    [setButton addTarget:self action:@selector(clickSettingButton) forControlEvents:(UIControlEventTouchUpInside)];
    [self.navigationController.navigationBar addSubview:setButton];
    
    CustomTable *table = (CustomTable *)[self.view viewWithTag:9001];
    [table reloadData];
    
    [TOHttpHelper getUrl:kTOGetMessageFlag parameters:@{@"userId":[[UserInfo sharedInfo] userID]} showHUD:NO success:^(NSDictionary *dataDictionary) {
        
        NSDictionary *info = [dataDictionary objectForKey:@"info"];
        if ([[info objectForKey:@"total"] intValue] > 0)
        {
            CustomTable *table = (CustomTable *)[self.view viewWithTag:9001];
            MineTableViewCell *cell = (MineTableViewCell *)[table cellForRowAtIndexPath:[NSIndexPath indexPathForItem:5 inSection:2]];
            cell.redView.hidden = NO;
        }

    }];
    
    NSString *num = [[RedViewHelper sharedHelper] allRedViewWithType:[NSNumber numberWithInt:2]];
    if (num == 0)
    {
//        self.tabBarItem.badgeValue = nil;
        MineTableViewCell *cell = (MineTableViewCell *)[table cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:2]];
        cell.redView.hidden = YES;
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        UITabBarController *tabbar = [app sharedTabbarController];
        UIViewController *controller = [[tabbar viewControllers] objectAtIndex:3];
        controller.tabBarItem.badgeValue = nil;
    }
    else
    {
//        self.tabBarItem.badgeValue = num;
        MineTableViewCell *cell = (MineTableViewCell *)[table cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:2]];
        cell.redView.hidden = NO;
    }
    
    if ([[UserInfo sharedInfo] userInfoIntegrity] == NO)
    {
        RegisterController *registerView = [[RegisterController alloc] init];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:registerView];
        [self presentViewController:navi animated:YES completion:^{
    
            AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            UITabBarController *tabbarController = [app sharedTabbarController];
            [tabbarController setSelectedIndex:0];

    
        }];
    }

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    ///设置显示的表格
    CustomTable *setTable = [[CustomTable alloc] initWithFrame:self.view.frame style:(UITableViewStyleGrouped)];
    [setTable setDataSource:self];
    [setTable setDelegate:self];
    [setTable setTag:9001];
    [setTable setBackgroundColor:[UIColor colorWithHexString:kDefaultGrayColor]];
    [self.view addSubview:setTable];
    
    ///设置显示的数据
    NSArray *titleArray = [NSArray arrayWithObjects:@"通讯录",@"我的项目",@"我的案例",@"我的关注",@"圈子记录",@"消息中心", nil];
    titleDict = [NSDictionary dictionaryWithObjectsAndKeys:@"扫一扫",@"扫一扫",titleArray,@"更多", nil];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [setButton removeFromSuperview];
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

#pragma mark 点击设置按钮
-(void)clickSettingButton
{
    SetViewController *setView = [[SetViewController alloc] init];
    setView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:setView animated:YES];
}
#pragma mark UITableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else if (section == 1)
    {
        return 1;
    }
    else
    {
        return 6;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 60;
    }
    else
    {
        return 44;
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }

    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIDWithTitle = @"cellIDWithTitle";
    MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIDWithTitle];
    if (cell == nil)
    {
        cell = [[MineTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellIDWithTitle];
        cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    }
    if (indexPath.section == 0)
    {
        cell.titleLabel.text = [[UserInfo sharedInfo] userName];
        NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@",kTOHOSt,kTOUploadUserIcon,[[UserInfo sharedInfo] userHeadPicture]];
        [cell.titleImage sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:kUserDefaultIcon];
    }
    else
    {
        NSString *key = [[titleDict allKeys] objectAtIndex:(indexPath.section-1)];
        if ([key isEqualToString:@"扫一扫"])
        {
            cell.titleLabel.text = [titleDict objectForKey:key];
        }
        else
        {
            NSArray *array = [titleDict objectForKey:key];
            cell.titleLabel.text = [array objectAtIndex:indexPath.row];
        }
        cell.titleImage.image = [UIImage imageNamed:cell.titleLabel.text];
    }

    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        MyInfoViewController *info = [[MyInfoViewController alloc] init];
        info.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:info animated:YES];
    }
    else if (indexPath.section == 1)
    {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted)
        {
            [HUDView showHUDWithText:@"相机打开受限,请检测是否授予权限"];
            return;
        }
        else if (authStatus == AVAuthorizationStatusAuthorized || authStatus == AVAuthorizationStatusNotDetermined)
        {
            static QRCodeReaderViewController *reader = nil;
            static dispatch_once_t onceToken;
            
            dispatch_once(&onceToken, ^{
                reader                        = [QRCodeReaderViewController new];
                reader.modalPresentationStyle = UIModalPresentationFormSheet;
            });
            reader.delegate = self;
            
            [reader setCompletionWithBlock:^(NSString *resultAsString) {
                NSLog(@"Completion with result: %@", resultAsString);
            }];
            
            [self presentViewController:reader animated:YES completion:NULL];
        }
    }
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 0)
        {
            AddressViewController *address = [[AddressViewController alloc] init];
            address.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:address animated:YES];
        }
        else if (indexPath.row == 1)
        {
            MyProjectViewController *myProject = [[MyProjectViewController alloc] init];
            myProject.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:myProject animated:YES];
        }
        else if(indexPath.row == 2){
            SLMyCaseViewController *myCaseViewController = [[SLMyCaseViewController alloc] init];
            myCaseViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:myCaseViewController animated:YES];
        }
        else if (indexPath.row == 3)
        {
            ///我的关注
            MyAttentionCompanyViewContrller *myAttention = [[MyAttentionCompanyViewContrller alloc] init];
            myAttention.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:myAttention animated:YES];
        }else if(indexPath.row == 4){
            SLFriendCirclePersonStatusViewController *friendCirclePersonStatusViewController = [[SLFriendCirclePersonStatusViewController alloc] init];
            friendCirclePersonStatusViewController.hidesBottomBarWhenPushed = YES;
            SLFriendCircleUserModel *friendCircleUserModel = [[SLFriendCircleUserModel alloc] initWithUsername:[UserInfo sharedInfo].userID displayName:[UserInfo sharedInfo].userName iconURL:SLHTTPServerImageURL([UserInfo sharedInfo].userHeadPicture, SLHTTPServerImageKindUserAvatar)];
            friendCirclePersonStatusViewController.friendCircleUserModel = friendCircleUserModel;
            [self.navigationController pushViewController:friendCirclePersonStatusViewController animated:YES];
        }
        else if (indexPath.row == 5)
        {
            NotifyCenterController *notify = [[NotifyCenterController alloc] init];
            notify.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:notify animated:YES];
        }
    }
}
#pragma mark 二维码
- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
    [self dismissViewControllerAnimated:YES completion:^{

        if ([result rangeOfString:kTOUserTag].location != NSNotFound)
        {
            SLConnectionDetailViewController *detail = [[SLConnectionDetailViewController alloc] init];
            detail.userID = [result stringByReplacingOccurrencesOfString:kTOUserTag withString:@""];
            detail.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detail animated:YES];
        }
        else
        {
            [HUDView showHUDWithText:@"无法识别,请检测是否是托付用户"];
        }
        
    }];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark 关闭完善信息界面
-(void)closeRegisterView
{

    [[[[[UIApplication sharedApplication] keyWindow] rootViewController] tabBarController] setSelectedIndex:0];
    
}
@end
