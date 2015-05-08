//
//  MyAttentionCompanyViewContrller.m
//  TaskOffer
//
//  Created by BourbonZ on 15/3/25.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "MyAttentionCompanyViewContrller.h"
#import "TOHttpHelper.h"
#import "EnterpriseCell.h"
#import "MJRefresh.h"
#import "EnterpriseInfoController.h"
@interface MyAttentionCompanyViewContrller ()<UITableViewDataSource,UITableViewDelegate>
{
    int pageNum;
    NSMutableArray *listArray;
}
@end

@implementation MyAttentionCompanyViewContrller
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    ///请求网络
    [self getDataFromServerPage:1 rows:10];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的关注";
    
    CustomTable *table = [[CustomTable alloc] initWithFrame:self.view.frame style:(UITableViewStylePlain)];
    table.delegate = self;
    table.dataSource = self;
    table.backgroundColor = [UIColor colorWithHexString:kDefaultGrayColor];
    table.tableFooterView = [[UIView alloc] init];
    [table setTag:9001];
    [self.view addSubview:table];
    
    ///设置下拉刷新，上拉加载
    [table addHeaderWithTarget:self action:@selector(headerRereshing)];
    [table addFooterWithTarget:self action:@selector(footerRereshing)];

    
    listArray = [NSMutableArray array];
    
    
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

#pragma mark 网络请求
-(void)getDataFromServerPage:(int)page rows:(int)rows
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[[UserInfo sharedInfo] userID] forKey:@"userId"];
    [dict setObject:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    [dict setObject:[NSString stringWithFormat:@"%d",rows] forKey:@"rows"];
    
    [TOHttpHelper postUrl:kTOGetMyAttentionCompanyList parameters:dict showHUD:YES success:^(NSDictionary *dataDictionary) {
        
        NSArray *array = [[dataDictionary objectForKey:@"info"] objectForKey:@"rows"];
        if (array.count == 0)
        {
            [HUDView showHUDWithText:@"数据加载完毕"];
            return ;
        }
        
        if (page == 1)
        {
            listArray = [array mutableCopy];
        }
        else
        {
            [listArray addObjectsFromArray:array];
        }
        
        UITableView *table = (UITableView *)[self.view viewWithTag:9001];
        [table reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark UITableView
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    EnterpriseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[EnterpriseCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellID];
    }
    
    EnterpriseInfo *info = [[EnterpriseInfo alloc] init];
    NSDictionary *dict = [listArray objectAtIndex:indexPath.row];
    if (dict != nil)
    {
        [info setEnterpriseDict:dict];
        cell.info = info;
    }

    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EnterpriseInfoController *info = [[EnterpriseInfoController alloc] init];
    NSDictionary *dict = [listArray objectAtIndex:indexPath.row];
    EnterpriseInfo *companyInfo = [[EnterpriseInfo alloc] init];
    [companyInfo setEnterpriseDict:dict];
    info.companyInfo = companyInfo;
    [self.navigationController pushViewController:info animated:YES];
}
@end
