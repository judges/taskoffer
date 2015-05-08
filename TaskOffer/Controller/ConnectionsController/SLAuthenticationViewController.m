//
//  SLAuthenticationViewController.m
//  TaskOffer
//
//  Created by wshaolin on 15/4/27.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLAuthenticationViewController.h"
#import "SLConnectionFrameModel.h"
#import "SLConnectionTableViewCell.h"
#import "SLRootTableView.h"
#import "MJRefresh.h"
#import "SLConnectionDetailViewController.h"
#import "SLConnectionHTTPHandler.h"
#import "MBProgressHUD+Conveniently.h"

@interface SLAuthenticationViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) SLRootTableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation SLAuthenticationViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
        self.title = @"认证员工";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
}

- (void)setCompanyID:(NSString *)companyID{
    _companyID = companyID;
    if(_companyID != nil && _companyID.length > 0){
        [self.tableView headerBeginRefreshing];
    }
}

- (SLRootTableView *)tableView{
    if(_tableView == nil){
        _tableView = [[SLRootTableView alloc] initWithDefaultFrameStyle:UITableViewStyleGrouped dataSource:self delegate:self];
        
        __block typeof(self) bself = self;
        [_tableView addHeaderWithCallback:^{
            [bself loadNewData];
        }];
        [_tableView addFooterWithCallback:^{
            [bself loadMoreData];
        }];
    }
    return _tableView;
}

- (void)loadNewData{
    self.currentPage = 1;
    
    [self loadData];
}

- (void)loadMoreData{
    self.currentPage ++;
    if(self.currentPage < 1){
        self.currentPage = 1;
    }
    
    [self loadData];
}

- (void)loadData{
    NSDictionary *parameters = @{@"companyId" : self.companyID,
                                 @"page" : @(self.currentPage),
                                 @"rows" : @(SLConnectionHTTPHandlerRequestPageSize)};
    __block typeof(self) bself = self;
    [SLConnectionHTTPHandler POSTCompanyAuthenticationEmployeeWithParameters:parameters success:^(NSArray *dataArray) {
        if(bself.currentPage == 1){
            bself.dataArray = dataArray;
        }else{
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:bself.dataArray];
            [tempArray addObjectsFromArray:dataArray];
            bself.dataArray = [tempArray copy];
        }
        [bself.tableView reloadData];
        [bself.tableView headerEndRefreshing];
        [bself.tableView footerEndRefreshing];
    } failure:^(NSString *errorMessage) {
        bself.currentPage --;
        [bself.tableView headerEndRefreshing];
        [bself.tableView footerEndRefreshing];
        [MBProgressHUD showWithError:@"数据加载失败！"];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SLConnectionTableViewCell *cell = [SLConnectionTableViewCell cellWithTableView:tableView];
    cell.connectionFrameModel = self.dataArray[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SLConnectionFrameModel *connectionFrameModel = self.dataArray[indexPath.section];
    return connectionFrameModel.cellRowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 0.01;
    }
    return 5.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SLConnectionFrameModel *connectionFrameModel = self.dataArray[indexPath.section];
    SLConnectionDetailViewController *connectionDetailViewController = [[SLConnectionDetailViewController alloc] init];
    connectionDetailViewController.userID = connectionFrameModel.connectionModel.userID;
    [self.navigationController pushViewController:connectionDetailViewController animated:YES];
}

@end
