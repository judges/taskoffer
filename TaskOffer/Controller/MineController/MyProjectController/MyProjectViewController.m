//
//  MyProjectViewController.m
//  TaskOffer
//
//  Created by BourbonZ on 15/3/16.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "MyProjectViewController.h"
#import "ProjectViewCell.h"
#import "UserInfo.h"
#import "TOHttpHelper.h"
#import "ProjectInfoController.h"
#import "MJRefresh.h"
@interface MyProjectViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *projectArray;
    BOOL projectControl;    ///控制切换界面
    UITableView *projectTable;
    int _tmpNum;
}
@end

@implementation MyProjectViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self reloadDataTableWithStart:1 page:10];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的项目";
    
    ///上方的segment
    UISegmentedControl *segmentButton = [[UISegmentedControl alloc] initWithItems:@[@"发布的项目",@"收藏的项目"]];
    [segmentButton setCenter:CGPointMake(self.view.frame.size.width/2, self.navigationController.navigationBar.frame.size.height/2)];
    [segmentButton setSelectedSegmentIndex:0];
    [segmentButton setTintColor:[UIColor whiteColor]];
    [segmentButton addTarget:self action:@selector(clickChangeSegment:) forControlEvents:(UIControlEventValueChanged)];
    self.navigationItem.titleView = segmentButton;
    
    
    ///下方表格
    projectTable = [[UITableView alloc] initWithFrame:self.view.frame style:(UITableViewStylePlain)];
    [projectTable setDataSource:self];
    [projectTable setDelegate:self];
    projectTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    projectTable.backgroundColor = [UIColor colorWithHexString:kDefaultGrayColor];
    projectTable.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:projectTable];
    
    [projectTable addHeaderWithTarget:self action:@selector(headRefresh)];
    [projectTable addFooterWithTarget:self action:@selector(footRefresh)];
    
    projectControl = YES;
    
    _tmpNum = 1;
}

#pragma mark 上提加载
-(void)footRefresh
{
    [projectTable footerEndRefreshing];
    _tmpNum = _tmpNum + 1;
    [self reloadDataTableWithStart:_tmpNum page:10];

}
#pragma mark 下拉刷新
-(void)headRefresh
{
    [projectTable headerEndRefreshing];
    [self reloadDataTableWithStart:1 page:10];

}
#pragma mark 上方的收藏
-(void)clickChangeSegment:(UISegmentedControl *)segment
{
    projectControl = !projectControl;
    
    [self reloadDataTableWithStart:1 page:10];
}
#pragma mark UITableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return projectArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (projectControl)
    {
        ///发布的项目
        static NSString *cellID = @"cell1";
        ProjectViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil)
        {
            cell = [[ProjectViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellID];
        }
        ProjectInfo *info = [[ProjectInfo alloc] init];
        NSDictionary *dict = [projectArray objectAtIndex:indexPath.row];
        if (dict != nil)
        {
            [info setProjectDict:dict];
            cell.info = info;
        }
        
        UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 135, self.view.frame.size.width, 5)];
        [tmpView setBackgroundColor:[UIColor colorWithHexString:kDefaultGrayColor]];
        [cell addSubview:tmpView];
        
        return cell;
    }
    else
    {
        ///收藏的项目
        static NSString *cellID = @"cell1";
        ProjectViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil)
        {
            cell = [[ProjectViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellID];
        }
        ProjectInfo *info = [[ProjectInfo alloc] init];
        NSDictionary *dict = [projectArray objectAtIndex:indexPath.row];
        if (dict != nil)
        {
            [info setProjectDict:dict];
            cell.info = info;
        }
        
        UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 135, self.view.frame.size.width, 5)];
        [tmpView setBackgroundColor:[UIColor colorWithHexString:kDefaultGrayColor]];
        [cell addSubview:tmpView];

        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (projectControl)
    {
        ///发布的项目
        ProjectInfoController *infoController = [[ProjectInfoController alloc] init];
        ProjectInfo *info = [[ProjectInfo alloc] init];
        NSDictionary *dict = [projectArray objectAtIndex:indexPath.row];
        [info setProjectDict:dict];

        infoController.projectID = info.projectID;
        infoController.ifMyProject = YES;
        [self.navigationController pushViewController:infoController animated:YES];
    }
    else
    {
        ///收藏的项目
        ProjectInfoController *infoController = [[ProjectInfoController alloc] init];
        ProjectInfo *info = [[ProjectInfo alloc] init];
        NSDictionary *dict = [projectArray objectAtIndex:indexPath.row];
        [info setProjectDict:dict];
        
        infoController.projectID = info.projectID;
        [self.navigationController pushViewController:infoController animated:YES];
    }
}
#pragma mark 刷新界面
-(void)reloadDataTableWithStart:(NSInteger)start page:(NSInteger)page
{
    if (projectControl)
    {
        ///发布的项目
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:[[UserInfo sharedInfo] userID] forKey:@"userId"];
        [dict setObject:[NSString stringWithFormat:@"%ld",(long)start] forKey:@"page"];
        [dict setObject:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"rows"];
        [dict setObject:@"1" forKey:@"type"];
        [TOHttpHelper postUrl:kTOAllProject parameters:dict showHUD:YES success:^(NSDictionary *dataDictionary) {
            
            NSArray *aray = [[dataDictionary objectForKey:@"info"] objectForKey:@"rows"];
            
            if (aray.count == 0)
            {
                if (start == 1)
                {
                    projectArray = aray;
                    [projectTable reloadData];
                }
                
                [HUDView showHUDWithText:@"数据加载完毕"];
                return ;
            }
            
            if (start == 1)
            {
                projectArray = [NSArray arrayWithArray:aray];
            }
            else
            {
                NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:projectArray];
                [tmpArray addObjectsFromArray:aray];
                projectArray = tmpArray;
            }
            
            [projectTable reloadData];
        } failure:^(NSError *error) {
            
        }];
    }
    else
    {
        ///收藏的项目
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:[[UserInfo sharedInfo] userID] forKey:@"userId"];
        [dict setObject:[NSString stringWithFormat:@"%ld",(long)start] forKey:@"page"];
        [dict setObject:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"rows"];
        [TOHttpHelper postUrl:kTOAllProjectCollect parameters:dict showHUD:YES success:^(NSDictionary *dataDictionary) {
            
            NSArray *aray = [[dataDictionary objectForKey:@"info"] objectForKey:@"rows"];
            
            if (aray.count == 0)
            {
                if (start == 1)
                {
                    projectArray = aray;
                    [projectTable reloadData];
                }

                [HUDView showHUDWithText:@"数据加载完毕"];
                return ;
            }
            
            if (start == 1)
            {
                projectArray = [NSArray arrayWithArray:aray];
            }
            else
            {
                NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:projectArray];
                [tmpArray addObjectsFromArray:aray];
                projectArray = tmpArray;
            }
            
            [projectTable reloadData];
        } failure:^(NSError *error) {
            
        }];
    }

}
@end
