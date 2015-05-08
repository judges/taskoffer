//
//  SLBiddingProjectViewController.m
//  TaskOffer
//
//  Created by wshaolin on 15/3/20.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLBiddingProjectViewController.h"
#import "SLBiddingProjectTableViewCell.h"
#import "SLRootTableView.h"
#import "ProjectInfoController.h"
#import "SLConnectionHTTPHandler.h"
#import "UserInfo.h"
#import "SLProjectModel.h"
#import "MJRefresh.h"

@interface SLBiddingProjectViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) SLRootTableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation SLBiddingProjectViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
        self.title = @"项目列表";
        [self.view addSubview:self.tableView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setUserID:(NSString *)userID{
    _userID = userID;
    if(_userID == nil){
        _userID = @"";
    }
    
    [self.tableView headerBeginRefreshing];
}

- (void)loadNewProjectData{
    self.currentPage = 1;
    [self loadProjectData];
}

- (void)loadMoreProjectData{
    self.currentPage ++;
    if(self.currentPage < 1){
        self.currentPage = 1;
    }
    [self loadProjectData];
}

- (void)loadProjectData{
    NSDictionary *parameters = @{@"userId" : self.userID,
                                 @"page" : @(self.currentPage),
                                 @"rows" : @(SLConnectionHTTPHandlerRequestPageSize),
                                 @"type" : @"1"};
    __block typeof(self) bself = self;
    [SLConnectionHTTPHandler POSTProjectListWithParameters:parameters showProgressInView:self.view success:^(NSArray *dataArray) {
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
    }];
}

- (SLRootTableView *)tableView{
    if(_tableView == nil){
        _tableView = [[SLRootTableView alloc] initWithDefaultFrameDataSource:self delegate:self];
        
        __block typeof(self) bself = self;
        [_tableView addHeaderWithCallback:^{
            [bself loadNewProjectData];
        }];
        [_tableView addFooterWithCallback:^{
            [bself loadMoreProjectData];
        }];
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SLBiddingProjectTableViewCell *cell = [SLBiddingProjectTableViewCell cellWithTableView:tableView];
    cell.projectModel = self.dataArray[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == self.dataArray.count - 1){
        return 0.01;
    }
    return 5.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ProjectInfoController *projectInfoController = [[ProjectInfoController alloc] init];
    SLProjectModel *projectModel = self.dataArray[indexPath.section];
    projectInfoController.projectID = projectModel.projectID;
    [self.navigationController pushViewController:projectInfoController animated:YES];
}

@end
