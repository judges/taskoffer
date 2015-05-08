//
//  CompanyUserListViewController.m
//  TaskOffer
//
//  Created by BourbonZ on 15/3/25.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "CompanyUserListViewController.h"
#import "TOHttpHelper.h"
#import "CompanyUserCell.h"
#import "SLConnectionDetailViewController.h"
#import "MJRefresh.h"
@interface CompanyUserListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *userListArray;
    int pageNum;
}
@end

@implementation CompanyUserListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"认证员工";
    
    ///请求网络

    
    ///准备表格
    UITableView *userListTable = [[UITableView alloc] initWithFrame:self.view.frame style:(UITableViewStylePlain)];
    userListTable.delegate = self;
    userListTable.dataSource = self;
    userListTable.backgroundColor = [UIColor colorWithHexString:kDefaultBackColor];
    [userListTable setTag:9001];
    userListTable.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:userListTable];
    ///设置下拉刷新，上拉加载
    [userListTable addHeaderWithTarget:self action:@selector(headerRereshing)];
    [userListTable addFooterWithTarget:self action:@selector(footerRereshing)];
    pageNum = 1;
    userListArray = [NSMutableArray array];
    [self getDataFromServerPage:1 rows:10];

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
#pragma mark 下拉刷新
-(void)headerRereshing
{
    [self getDataFromServerPage:1 rows:10];
    UITableView *table = (UITableView *)[self.view viewWithTag:9001];
    [table headerEndRefreshing];
}
#pragma mark 上提加载更多
-(void)footerRereshing
{
    pageNum = pageNum + 1;
    [self getDataFromServerPage:pageNum rows:10];
    UITableView *table = (UITableView *)[self.view viewWithTag:9001];
    [table footerEndRefreshing];
}
#pragma mark 获取数据
-(void)getDataFromServerPage:(int)page rows:(int)rows
{
    ///获取资质
    NSMutableDictionary *companyDict = [NSMutableDictionary dictionary];
    [companyDict setObject:self.companyID forKey:@"companyId"];
    [companyDict setObject:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    [companyDict setObject:[NSString stringWithFormat:@"%d",rows] forKey:@"rows"];
    [TOHttpHelper postUrl:kTOGetUsersList parameters:companyDict showHUD:YES success:^(NSDictionary *dataDictionary) {
        
        NSArray *array = [[dataDictionary objectForKey:@"info"] objectForKey:@"rows"];
        if (array.count == 0)
        {
            if (page == 1)
            {
                userListArray = [NSMutableArray arrayWithArray:array];
                UITableView *userListTable = (UITableView *)[self.view viewWithTag:9001];
                [userListTable reloadData];
            }

            [HUDView showHUDWithText:@"数据加载完毕"];
            return ;
        }
        
        if (page == 1)
        {
            userListArray = [array mutableCopy];
        }
        else
        {
            [userListArray  addObjectsFromArray:array];
        }
        
        UITableView *userListTable = (UITableView *)[self.view viewWithTag:9001];
        [userListTable reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return userListArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    CompanyUserCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[CompanyUserCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellID];
    }
    NSDictionary *dict = [userListArray objectAtIndex:indexPath.row];
    cell.userDict = dict;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [userListArray objectAtIndex:indexPath.row];
    
    SLConnectionDetailViewController *detail = [[SLConnectionDetailViewController alloc] init];
    detail.userID = [dict objectForKey:@"id"];
    [self.navigationController pushViewController:detail animated:YES];
}
@end
