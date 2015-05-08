//
//  CredentialViewController.m
//  TaskOffer
//
//  Created by BourbonZ on 15/3/20.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "CredentialViewController.h"
#import "TOHttpHelper.h"
#import "ZizhiCell.h"
#import "MJRefresh.h"
@interface CredentialViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *credentialArray;
    int pageNum;
}
@end

@implementation CredentialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"资质介绍";
    
    UITableView *table = [[UITableView alloc] initWithFrame:self.view.frame style:(UITableViewStylePlain)];
    table.delegate = self;
    table.dataSource = self;
    table.tableFooterView = [[UIView alloc] init];
    table.backgroundColor = [UIColor colorWithHexString:kDefaultBackColor];
    [table setTag:9001];
    [self.view addSubview:table];
    
    [table addHeaderWithTarget:self action:@selector(headerRereshing)];
    [table addFooterWithTarget:self action:@selector(footerRereshing)];
    
    credentialArray = [NSMutableArray array];
    
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
    [TOHttpHelper postUrl:kTOGetCompanyQualification parameters:companyDict showHUD:YES success:^(NSDictionary *dataDictionary) {
        
        NSArray *array = [[dataDictionary objectForKey:@"info"] objectForKey:@"rows"];
        if (array.count == 0)
        {
            [HUDView showHUDWithText:@"数据加载完毕"];
            return ;
        }
        if (page == 1)
        {
            credentialArray = [array mutableCopy];
        }
        else
        {
            [credentialArray addObjectsFromArray:array];
        }
        UITableView *table = (UITableView *)[self.view viewWithTag:9001];
        [table reloadData];
        
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
    return credentialArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    ZizhiCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[ZizhiCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellID];
    }
    NSDictionary *dict = [credentialArray objectAtIndex:indexPath.row];
    cell.infoDict = dict;
    
    return cell;
}
@end
