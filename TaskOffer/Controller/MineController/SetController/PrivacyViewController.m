//
//  PrivacyViewController.m
//  TaskOffer
//
//  Created by BourbonZ on 15/3/16.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "PrivacyViewController.h"
#import "ToToolHelper.h"
#import "SLConnectionDetailTableSectionHeaderView.h"

#define kYES @"1"
#define kNO @"0"
#define kPath [NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),@"private.plist"]
#import "TOHttpHelper.h"
@interface PrivacyViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableDictionary *privacyDit;
    NSMutableDictionary *_tmpPrivatyDict;
}
@end

@implementation PrivacyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"隐私设置";
    
    ///设置表格
    CustomTable *privacyTable = [[CustomTable alloc] initWithFrame:self.view.frame style:(UITableViewStyleGrouped)];
    [privacyTable setDelegate:self];
    [privacyTable setDataSource:self];
    [privacyTable setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:privacyTable];
    
    ///设置数据
    privacyDit = [NSMutableDictionary dictionary];
    [privacyDit setObject:@[@"消息通知",@"消息显示详情"] forKey:@"消息设置"];
    [privacyDit setObject:@[@"通过手机号搜索到我"] forKey:@"搜索设置"];
    [privacyDit setObject:@[@"只看好友动态",@"不允许陌生人发起对话"] forKey:@"好友设置"];
    
    ///隐私设置字典
    _tmpPrivatyDict = [NSMutableDictionary dictionaryWithContentsOfFile:kPath];

    ///完成按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:(UIBarButtonItemStylePlain) target:self action:@selector(clickDoneButton)];
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
#pragma mark 提交设置
-(void)clickDoneButton
{
    [_tmpPrivatyDict setObject:[[UserInfo sharedInfo] userID] forKey:@"userId"];
    [ToToolHelper editPrivatePlistWithDict:_tmpPrivatyDict];

    NSMutableDictionary *infoDict = [NSMutableDictionary dictionary];
    
    [infoDict setObject:[_tmpPrivatyDict objectForKey:@"isReceive"] forKey:@"isReceive"];
    [infoDict setObject:[_tmpPrivatyDict objectForKey:@"isMsgDetail"] forKey:@"isMsgDetail"];
    [infoDict setObject:[_tmpPrivatyDict objectForKey:@"isSearch"] forKey:@"isSearch"];
    [infoDict setObject:[_tmpPrivatyDict objectForKey:@"isAlldynamic"] forKey:@"isAlldynamic"];
    [infoDict setObject:[_tmpPrivatyDict objectForKey:@"isStrangermsg"] forKey:@"isStrangermsg"];
    [infoDict setObject:[_tmpPrivatyDict objectForKey:@"userId"] forKey:@"userId"];

    
    [TOHttpHelper postUrl:kTOsetPrivate parameters:infoDict showHUD:YES success:^(NSDictionary *dataDictionary) {

        [HUDView showHUDWithText:@"更改成功"];
        [_tmpPrivatyDict writeToFile:kPath atomically:YES];
        
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark UITableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 1;
    }
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 36.0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    UILabel *keyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-10, 35)];
//    keyLabel.text = [NSString stringWithFormat:@"  %@", [[privacyDit allKeys] objectAtIndex:section]];
//    [keyLabel setFont:[UIFont systemFontOfSize:13.0f]];
//    [keyLabel setTextAlignment:NSTextAlignmentLeft];
//    [keyLabel setTextColor:[UIColor colorWithHexString:kDefaultTextColor]];
//    [keyLabel setBackgroundColor:[UIColor colorWithHexString:kDefaultBackColor]];
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 35)];
//    [view addSubview:keyLabel];
//    [view setBackgroundColor:[UIColor colorWithHexString:kDefaultBackColor]];
//    return view;
    
    SLConnectionDetailTableSectionHeaderView *view = [SLConnectionDetailTableSectionHeaderView sectionHeaderViewWithTableView:tableView];
    view.title = [[privacyDit allKeys] objectAtIndex:section];
    view.hideBottomLine = YES;
    view.hideMoreButton = YES;
    return view;
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
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellID];
        UISwitch *switchButton = [[UISwitch alloc] init];
        [switchButton setCenter:CGPointMake(self.view.frame.size.width-40, cell.frame.size.height/2)];
        [switchButton setTag:9001];
        [cell.contentView addSubview:switchButton];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, cell.frame.size.height)];
        [titleLabel setTag:9002];
        [titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
        [cell.contentView addSubview:titleLabel];
    }
    UILabel *titelLabel = (UILabel *)[cell.contentView viewWithTag:9002];
    NSString *key = [[privacyDit allKeys] objectAtIndex:indexPath.section];
    titelLabel.text = [[privacyDit objectForKey:key] objectAtIndex:indexPath.row];
    [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    
    UISwitch *switchButton = (UISwitch *)[cell.contentView viewWithTag:9001];
    [switchButton addTarget:self action:@selector(privacySwitchChange:) forControlEvents:(UIControlEventValueChanged)];
    
    
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        NSString *value = [_tmpPrivatyDict objectForKey:@"isReceive"];
        [switchButton setTag:7000];
        [switchButton setOn:[value boolValue] animated:YES];
    }
    else if (indexPath.section == 0 && indexPath.row == 1)
    {
        NSString *value = [_tmpPrivatyDict objectForKey:@"isMsgDetail"];
        [switchButton setTag:7001];
        [switchButton setOn:[value boolValue] animated:YES];
    }
    else if (indexPath.section == 1 && indexPath.row == 0)
    {
        NSString *value = [_tmpPrivatyDict objectForKey:@"isSearch"];
        [switchButton setTag:7002];
        [switchButton setOn:[value boolValue] animated:YES];
    }
    else if (indexPath.section == 1 && indexPath.row == 1)
    {
        NSString *value = [_tmpPrivatyDict objectForKey:@"isSearch"];
        [switchButton setTag:7003];
        [switchButton setOn:[value boolValue] animated:YES];
    }
    else if (indexPath.section == 2 && indexPath.row == 0)
    {
        NSString *value = [_tmpPrivatyDict objectForKey:@"isAlldynamic"];
        [switchButton setTag:7004];
        [switchButton setOn:[value boolValue] animated:YES];
    }
    else if (indexPath.section == 2 && indexPath.row == 1)
    {
        NSString *value = [_tmpPrivatyDict objectForKey:@"isStrangermsg"];
        [switchButton setTag:7005];
        [switchButton setOn:[value boolValue] animated:YES];
    }
    
    return cell;
}
#pragma mark 各种设置按钮
-(void)privacySwitchChange:(UISwitch *)switchButton
{
    NSString *value = @"0";
    if (switchButton.on)
    {
        value = kYES;
    }
    else
    {
        value = kNO;
    }
    
    if (switchButton.tag == 7000)
    {
        [_tmpPrivatyDict removeObjectForKey:@"isReceive"];
        [_tmpPrivatyDict setObject:value forKey:@"isReceive"];
    }
    else if (switchButton.tag == 7001)
    {
        [_tmpPrivatyDict removeObjectForKey:@"isMsgDetail"];

        [_tmpPrivatyDict setObject:value forKey:@"isMsgDetail"];

    }
    else if (switchButton.tag == 7002)
    {
        [_tmpPrivatyDict removeObjectForKey:@"isSearch"];

        [_tmpPrivatyDict setObject:value forKey:@"isSearch"];

    }
    else if (switchButton.tag == 7003)
    {
        [_tmpPrivatyDict removeObjectForKey:@"isSearch"];

        [_tmpPrivatyDict setObject:value forKey:@"isSearch"];

    }
    else if (switchButton.tag == 7004)
    {
        [_tmpPrivatyDict removeObjectForKey:@"isAlldynamic"];

        [_tmpPrivatyDict setObject:value forKey:@"isAlldynamic"];

    }
    else if (switchButton.tag == 7005)
    {
        [_tmpPrivatyDict removeObjectForKey:@"isStrangermsg"];

        [_tmpPrivatyDict setObject:value forKey:@"isStrangermsg"];
    }
    
}
@end
