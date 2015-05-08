//
//  NationalViewController.m
//  TaskOffer
//
//  Created by BourbonZ on 15/3/16.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "NationalViewController.h"
#import "SDImageCache.h"
@interface NationalViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation NationalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"通用功能";
    
    ///表格
    UITableView *nationalTable = [[UITableView alloc] initWithFrame:self.view.frame style:(UITableViewStyleGrouped)];
    nationalTable.delegate = self;
    nationalTable.dataSource = self;
    nationalTable.backgroundColor = [UIColor colorWithHexString:kDefaultGrayColor];
    [self.view addSubview:nationalTable];
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
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 0)
//    {
//        UITableViewCell *modelCell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:nil];
//        [modelCell.textLabel setText:@"语音听筒模式"];
//        [modelCell.textLabel setFont:[UIFont systemFontOfSize:15.0f]];
//        [modelCell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
//
//        ///听筒模式
//        UISwitch *switchButton = [[UISwitch alloc] init];
//        [switchButton addTarget:self action:@selector(changeToTelephoneReceiverModelButtonClick:) forControlEvents:(UIControlEventValueChanged)];
//        [switchButton setCenter:CGPointMake(self.view.frame.size.width-40, modelCell.frame.size.height/2)];
//        [modelCell addSubview:switchButton];
//        return modelCell;
//    }
//    else
//    {
        UITableViewCell *cokieCell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:nil];
        [cokieCell setAccessoryType:(UITableViewCellAccessoryDisclosureIndicator)];
        [cokieCell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, cokieCell.frame.size.height)];
    label.font = [UIFont systemFontOfSize:16.0f];
    label.text = @"清理缓存";
    [cokieCell.contentView addSubview:label];
        NSInteger cache = [[SDImageCache sharedImageCache] getSize];
        float total = cache / 1024.0 / 1024.0;
        cokieCell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fM",total];
        [cokieCell.detailTextLabel setFont:[UIFont systemFontOfSize:15.0f]];
        return cokieCell;
//    }
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            NSInteger cache = [[SDImageCache sharedImageCache] getSize];
            float total = cache / 1024.0 / 1024.0;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fM",total];
            [HUDView showHUDWithText:@"清理完毕"];
        }];
    }
}
#pragma mark 听筒模式
-(void)changeToTelephoneReceiverModelButtonClick:(UISwitch *)switchButton
{

}
@end
