//
//  SLCaseViewController.m
//  TaskOffer
//
//  Created by wshaolin on 15/3/20.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLCaseViewController.h"
#import "SLCaseTableViewCell.h"
#import "SLRootTableView.h"
#import "SLCaseDetailViewController.h"
#import "SLAddCaseViewController.h"
#import "SLEditCaseViewController.h"
#import "SLConnectionHTTPHandler.h"
#import "SLPersonalCaseTableViewCell.h"
#import "SLPersonalCaseFrameModel.h"
#import "MJRefresh.h"

@interface SLCaseViewController ()<UITableViewDataSource, UITableViewDelegate, SLCaseTableViewCellDelegate>

@property (nonatomic, strong) SLRootTableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation SLCaseViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
        self.title = @"案例列表";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
}

- (void)setUserID:(NSString *)userID{
    _userID = userID;
    
    if(_userID == nil){
        _userID = @"";
    }
    
    [self.tableView headerBeginRefreshing];
}

- (void)loadNewCaseData{
    self.currentPage = 1;
    [self loadCaseData];
}

- (void)loadMoreCaseData{
    self.currentPage ++;
    if(self.currentPage < 1){
        self.currentPage = 1;
    }
    [self loadCaseData];
}

- (void)loadCaseData{
    NSDictionary *parameters = @{@"userId" : self.userID,
                                 @"page" : @(self.currentPage),
                                 @"rows" : @(SLConnectionHTTPHandlerRequestPageSize),
                                 @"type" : @"1"};
    __block typeof(self) bself = self;
    [SLConnectionHTTPHandler POSTCaseListWithParameters:parameters showProgressInView:self.view success:^(NSArray *dataArray) {
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
            [bself loadNewCaseData];
        }];
        [_tableView addFooterWithCallback:^{
            [bself loadMoreCaseData];
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
    SLPersonalCaseFrameModel *personalCaseFrameModel = self.dataArray[indexPath.section];
    if(personalCaseFrameModel.caseDetailModel.caseType == SLCaseTypePersonal){
        SLPersonalCaseTableViewCell *cell = [SLPersonalCaseTableViewCell cellWithTableView:tableView];
        cell.personalCaseFrameModel = personalCaseFrameModel;
        cell.indexPath = indexPath;
        return cell;
    }
    
    SLCaseTableViewCell *cell = [SLCaseTableViewCell cellWithTableView:tableView];
    cell.delegate = self;
    cell.caseDetailModel = personalCaseFrameModel.caseDetailModel;
    cell.indexPath = indexPath;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SLPersonalCaseFrameModel *personalCaseFrameModel = self.dataArray[indexPath.section];
    if(personalCaseFrameModel.caseDetailModel.caseType == SLCaseTypePersonal){
        return personalCaseFrameModel.cellRowHeight;
    }
    
    if(personalCaseFrameModel.caseDetailModel.designSchemeUrl.count > 0){
        return 140.0 + ([UIScreen mainScreen].bounds.size.width - 80.0) / 3;
    }
    return 135.0;
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

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    SLPersonalCaseFrameModel *personalCaseFrameModel = self.dataArray[indexPath.section];
    return personalCaseFrameModel.caseDetailModel.caseType != SLCaseTypePersonal;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SLPersonalCaseFrameModel *personalCaseFrameModel = self.dataArray[indexPath.section];
    if(personalCaseFrameModel.caseDetailModel.caseType != SLCaseTypePersonal){
        SLCaseDetailViewController *caseDetailViewController = [[SLCaseDetailViewController alloc] init];
        caseDetailViewController.caseID = personalCaseFrameModel.caseDetailModel.caseID;
        [self.navigationController pushViewController:caseDetailViewController animated:YES];
    }
}

@end
