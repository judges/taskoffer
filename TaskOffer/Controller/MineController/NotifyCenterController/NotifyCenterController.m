//
//  NotifyCenterController.m
//  TaskOffer
//
//  Created by BourbonZ on 15/3/26.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "NotifyCenterController.h"
#import "TOHttpHelper.h"
#define kTOSyetemMessage @"1"
#define kTOUserMessage @"0"
#import "UserMessageCell.h"
#import "SystemMessageCell.h"
#import "MJRefresh.h"
@interface NotifyCenterController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *userMessageArray;
    NSMutableArray *systemMessageArray;
    BOOL isUserMessageView;
    int pageNum;
}
@end

@implementation NotifyCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"消息中心";
    
    userMessageArray = [NSMutableArray array];
    systemMessageArray = [NSMutableArray array];
    
    pageNum = 1;
    [self createTitleBackView];
    
    [self createTable];
    isUserMessageView = YES;
    [self getDateFromServerPage:1 rows:10 type:isUserMessageView];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 创建上方背景view
-(void)createTitleBackView
{
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"关注",@"系统"]];
    segment.tintColor = [UIColor whiteColor];
    [segment setSelectedSegmentIndex:0];
    [segment addTarget:self action:@selector(segmentValueChange:) forControlEvents:(UIControlEventValueChanged)];
    [segment setBounds:CGRectMake(0, 0, 120, 30)];
    [segment setCenter:CGPointMake(self.view.frame.size.width/2, self.navigationController.navigationBar.frame.size.height/2)];
    self.navigationItem.titleView = segment;
}
#pragma mark 网络请求
-(void)getDateFromServerPage:(int)page rows:(int)rows type:(BOOL)type
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[[UserInfo sharedInfo] userID] forKey:@"userId"];
    [dict setObject:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    [dict setObject:[NSString stringWithFormat:@"%d",rows] forKey:@"rows"];
    if (!type)
    {
        [dict setObject:kTOSyetemMessage forKey:@"messageType"];
    }
    else
    {
        [dict setObject:kTOUserMessage forKey:@"messageType"];
    }
    [TOHttpHelper getUrl:kTOGetMessageList parameters:dict showHUD:YES success:^(NSDictionary *dataDictionary) {
        
        NSArray *array = [[dataDictionary objectForKey:@"info"] objectForKey:@"rows"];
        if (array.count == 0)
        {
            [HUDView showHUDWithText:@"数据加载完毕"];
            return ;
        }
        
        if (isUserMessageView)
        {
            page == 0 ? userMessageArray = [array mutableCopy] : [userMessageArray addObjectsFromArray:array];
        }
        else
        {
            page == 0 ? systemMessageArray = [array mutableCopy] : [systemMessageArray addObjectsFromArray:array];
        }
        
        UITableView *table = (UITableView *)[self.view viewWithTag:9001];
        [table reloadData];
        
        
    }];
    
}
#pragma mark 创建表格
-(void)createTable
{
    UITableView *table = [[UITableView alloc] initWithFrame:self.view.frame style:(UITableViewStylePlain)];
    [table setDelegate:self];
    [table setDataSource:self];
    table.backgroundColor = [UIColor colorWithHexString:kDefaultBackColor];
    table.tableFooterView = [[UIView alloc] init];
    [table setTag:9001];
    [self.view addSubview:table];
    
    [table addHeaderWithTarget:self action:@selector(headerRereshing)];
    [table addFooterWithTarget:self action:@selector(footerRereshing)];
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
    [self getDateFromServerPage:1 rows:10 type:isUserMessageView];
    UITableView *table = (UITableView *)[self.view viewWithTag:9001];
    [table headerEndRefreshing];
}
#pragma mark 上提加载更多
-(void)footerRereshing
{
    pageNum = pageNum + 1;
    [self getDateFromServerPage:pageNum rows:10 type:isUserMessageView];
    UITableView *table = (UITableView *)[self.view viewWithTag:9001];
    [table footerEndRefreshing];
}

#pragma mark 上方按钮切换
-(void)segmentValueChange:(UISegmentedControl *)control
{
    if (control.selectedSegmentIndex == 0)
    {
        isUserMessageView = YES;
        
        if (userMessageArray.count == 0)
        {
            [self getDateFromServerPage:1 rows:10 type:YES];
        }
    }
    else
    {
        isUserMessageView = NO;
        if (systemMessageArray.count == 0)
        {
            [self getDateFromServerPage:1 rows:10 type:NO];
        }
    }
    UITableView *table = (UITableView *)[self.view viewWithTag:9001];
    [table reloadData];
}
#pragma mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isUserMessageView)
    {
        return userMessageArray.count;
    }
    return systemMessageArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isUserMessageView)
    {
        static NSString *cellID = @"usercell";
        UserMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil)
        {
            cell = [[UserMessageCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellID];
        }
        cell.dict = [userMessageArray objectAtIndex:indexPath.row];
        return cell;
    }
    else
    {
        static NSString *cellID = @"systemCell";
        SystemMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil)
        {
            cell = [[SystemMessageCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellID];
        }
        cell.dict = [systemMessageArray objectAtIndex:indexPath.row];
        return cell;
    }
}
@end
