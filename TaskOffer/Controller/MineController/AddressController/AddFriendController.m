//
//  AddFriendController.m
//  TaskOffer
//
//  Created by BourbonZ on 15/4/7.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "AddFriendController.h"
#import "SetInfoViewController.h"
#import "TOHttpHelper.h"
#import "HUDView.h"
#import "SLConnectionDetailViewController.h"
#import "MBProgressHUD.h"
#import "RegisterController.h"
@interface AddFriendController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,SetInfoViewControllerDelegate>
{
    NSArray *listArray;
}
@end

@implementation AddFriendController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"添加朋友";
    
    UITableView *listTable = [[UITableView alloc] initWithFrame:self.view.frame];
    listTable.delegate = self;
    listTable.dataSource = self;
    listTable.tableFooterView = [[UIView alloc] init];
    listTable.backgroundColor = [UIColor colorWithHexString:kDefaultBackColor];
//    [self.view addSubview:listTable];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    titleView.backgroundColor = [UIColor colorWithHexString:kDefaultBackColor];
    UIView *tmpSearchView = [[UIView alloc] initWithFrame:CGRectMake(0, 74, self.view.frame.size.width, 40)];
    [tmpSearchView setBackgroundColor:[UIColor whiteColor]];
    UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width, 40)];
    [field setDelegate:self];
    [field setTag:8001];
    [field setReturnKeyType:(UIReturnKeySearch)];
    [field setBackgroundColor:[UIColor whiteColor]];
    [tmpSearchView addSubview:field];
    UIImageView *searchView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"蓝色搜索"]];
    [searchView setFrame:CGRectMake(10, 0, 30, 30)];
    field.leftView = searchView;
    [field setLeftViewMode:(UITextFieldViewModeAlways)];
    field.placeholder = @"搜索添加好友";
//    [titleView addSubview:field];
//    listTable.tableHeaderView = titleView;
    [self.view addSubview:tmpSearchView];
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
#pragma mark UITableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:cellID];
    }
    
    if (indexPath.row == 0)
    {
        cell.textLabel.text = @"扫一扫";
        cell.detailTextLabel.text = @"扫描二维码名片";
    }
    else
    {
        cell.textLabel.text = @"手机联系人";
        cell.detailTextLabel.text = @"添加手机通讯录联系人";
    }
    
    return cell;
}
#pragma mark UITextfield
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField endEditing:YES];
    
    
    if (![[UserInfo sharedInfo] userInfoIntegrity])
    {

        RegisterController *registerController = [[RegisterController alloc] init];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:registerController];
        [self presentViewController:navi animated:YES completion:nil];

    }
    else
    {
        if ([textField.text isEqualToString:[[UserInfo sharedInfo] userPhone]])
        {
            [[HUDView sharedHUDView] showHUDView:@"不能添加自己为好友" withDelayTime:2];
            return YES;
        }
        
        if (textField.text.length > 0)
        {
            
            [TOHttpHelper getUrl:kTOgetUserInfoByPhone parameters:@{@"userPhone":textField.text} showHUD:YES success:^(NSDictionary *dataDictionary) {
                
                id content = [dataDictionary objectForKey:@"info"];
                
                if (dataDictionary == nil)
                {
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
                    hud.mode = MBProgressHUDModeText;
                    hud.labelText = @"该用户不存在";
                    hud.margin = 15.0f;
                    hud.removeFromSuperViewOnHide = YES;
                    [hud hide:YES afterDelay:1];
                    
                    return ;
                    
                }
                
                if ([content isKindOfClass:[NSNull class]])
                {
                    
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
                    hud.mode = MBProgressHUDModeText;
                    hud.labelText = @"该用户不存在";
                    hud.margin = 15.0f;
                    hud.removeFromSuperViewOnHide = YES;
                    [hud hide:YES afterDelay:1];
                    
                    return ;
                }
                
                if ([content isKindOfClass:[NSString class]])
                {
                    [HUDView showHUDWithText:content];
                    return;
                }
                
                else
                {
                    NSDictionary *dict = (NSDictionary *)content;
                    NSString *userID = [dict objectForKey:@"id"];
                    SLConnectionDetailViewController *detail = [[SLConnectionDetailViewController alloc] init];
                    detail.userID = userID;
                    [self.navigationController pushViewController:detail animated:YES];
                }
                
                
            }];
        }
    }
    
    return YES;
}
#pragma mark SetInfoViewController
-(void)setInfoSuccess:(NSString *)value
{
    
}
@end
