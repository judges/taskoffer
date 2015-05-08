//
//  SLMyCaseViewController.m
//  TaskOffer
//
//  Created by wshaolin on 15/4/1.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLMyCaseViewController.h"
#import "SLRootTableView.h"
#import "SLCaseTableViewCell.h"
#import "SLPersonalCaseFrameModel.h"
#import "SLCaseDetailViewController.h"
#import "SLAddCaseViewController.h"
#import "SLConnectionHTTPHandler.h"
#import "SLEditCaseViewController.h"
#import "MJRefresh.h"
#import "SLPersonalCaseTableViewCell.h"
#import "RegisterController.h"

@interface SLMyCaseViewController ()<
            UITableViewDataSource,
            UITableViewDelegate,
            SLCaseTableViewCellDelegate,
            SLAddCaseViewControllerDelegate,
            SLEditCaseViewControllerDelegate,
            SLPersonalCaseTableViewCellDelegate
            >

@property (nonatomic, strong) SLRootTableView *tableView;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) NSArray *myCaseArray;
@property (nonatomic, strong) NSArray *myCollectionCaseArray;
@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, assign, getter = isAutoLoadMyCaseData) BOOL autoLoadMyCaseData;
@property (nonatomic, assign, getter = isAutoLoadMyCollectionCaseData) BOOL autoLoadMyCollectionCaseData;

@property (nonatomic, assign) NSInteger currentMyCasePage;
@property (nonatomic, assign) NSInteger currentMyCollectionCasePage;

@end

@implementation SLMyCaseViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
        self.title = @"我的案例";
        self.autoLoadMyCaseData = YES;
        self.autoLoadMyCollectionCaseData = YES;
    }
    return self;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex{
    _selectedIndex = selectedIndex;
    if(selectedIndex == 1){
        if(self.isAutoLoadMyCollectionCaseData){
            [self.tableView headerBeginRefreshing];
        }
    }else{
        if(self.isAutoLoadMyCaseData){
            [self.tableView headerBeginRefreshing];
        }
    }
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(didClickAddBarButtonItem:)];
    self.navigationItem.titleView = self.segmentedControl;
    
    [self.view addSubview:self.tableView];
    
    self.selectedIndex = self.segmentedControl.selectedSegmentIndex;
}

- (UISegmentedControl *)segmentedControl{
    if(_segmentedControl == nil){
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"我的案例", @"收藏的案例"]];
        _segmentedControl.frame = CGRectMake(0, 0, 180.0, 30.0);
        _segmentedControl.selectedSegmentIndex = 0;
        [_segmentedControl addTarget:self action:@selector(didChangeSelectedIndexWithSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}

- (SLRootTableView *)tableView{
    if(_tableView == nil){
        _tableView = [[SLRootTableView alloc] initWithDefaultFrameDataSource:self delegate:self];
        
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(self.selectedIndex == 1){
        return self.myCollectionCaseArray.count;
    }
    return self.myCaseArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SLPersonalCaseFrameModel *personalCaseFrameModel = [self personalCaseFrameModelWithIndexPath:indexPath];
    if(personalCaseFrameModel.caseDetailModel.caseType == SLCaseTypePersonal){
        SLPersonalCaseTableViewCell *cell = [SLPersonalCaseTableViewCell cellWithTableView:tableView];
        cell.personalCaseFrameModel = personalCaseFrameModel;
        cell.indexPath = indexPath;
        cell.delegate = self;
        cell.enableEditor = YES;
        return cell;
    }
    
    SLCaseTableViewCell *cell = [SLCaseTableViewCell cellWithTableView:tableView];
    cell.delegate = self;
    cell.caseDetailModel = personalCaseFrameModel.caseDetailModel;
    cell.indexPath = indexPath;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SLPersonalCaseFrameModel *personalCaseFrameModel = [self personalCaseFrameModelWithIndexPath:indexPath];
    if(personalCaseFrameModel.caseDetailModel.caseType == SLCaseTypePersonal){
        return personalCaseFrameModel.cellRowHeight;
    }
    
    if(personalCaseFrameModel.caseDetailModel.designSchemeUrl.count > 0){
        return 140.0 + ([UIScreen mainScreen].bounds.size.width - 80.0) / 3;
    }
    return 135.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(self.selectedIndex == 1){
        if(section == self.myCollectionCaseArray.count - 1){
            return 0.01;
        }
    }else{
        if(section == self.myCaseArray.count - 1){
            return 0.01;
        }
    }
    return 5.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SLPersonalCaseFrameModel *personalCaseFrameModel = [self personalCaseFrameModelWithIndexPath:indexPath];
    if(personalCaseFrameModel.caseDetailModel.caseType != SLCaseTypePersonal){
        SLCaseDetailViewController *caseDetailViewController = [[SLCaseDetailViewController alloc] init];
        caseDetailViewController.caseID = personalCaseFrameModel.caseDetailModel.caseID;
        [self.navigationController pushViewController:caseDetailViewController animated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    SLPersonalCaseFrameModel *personalCaseFrameModel = [self personalCaseFrameModelWithIndexPath:indexPath];
    return personalCaseFrameModel.caseDetailModel.caseType != SLCaseTypePersonal;
}

- (void)personalCaseTableViewCell:(SLPersonalCaseTableViewCell *)personalCaseTableViewCell didClickEditButtonAtIndexPath:(NSIndexPath *)indexPath{
    SLEditCaseViewController *editCaseViewController = [[SLEditCaseViewController alloc] init];
    editCaseViewController.delegate = self;
    editCaseViewController.indexPath = indexPath;
    SLPersonalCaseFrameModel *personalCaseFrameModel = [self personalCaseFrameModelWithIndexPath:indexPath];
    editCaseViewController.caseDetailModel = personalCaseFrameModel.caseDetailModel;
    [self.navigationController pushViewController:editCaseViewController animated:YES];
}

- (void)didChangeSelectedIndexWithSegmentedControl:(UISegmentedControl *)segmentedControl{
    self.selectedIndex = segmentedControl.selectedSegmentIndex;
}

- (void)loadNewData{
    if(self.selectedIndex == 1){
        self.currentMyCollectionCasePage = 1;
        [self loadMyCollectionCaseData];
    }else{
        self.currentMyCasePage = 1;
        [self loadMyCaseData];
    }
}

- (void)loadMoreData{
    if(self.selectedIndex == 1){
        self.currentMyCollectionCasePage ++;
        if(self.currentMyCollectionCasePage < 1){
            self.currentMyCollectionCasePage = 1;
        }
        [self loadMyCollectionCaseData];
    }else{
        self.currentMyCasePage ++;
        if(self.currentMyCasePage < 1){
            self.currentMyCasePage = 1;
        }
        [self loadMyCaseData];
    }
}

- (void)loadMyCaseData{
    self.autoLoadMyCaseData = NO;
    NSDictionary *parameters = @{@"userId" : [UserInfo sharedInfo].userID,
                                 @"page" : @(self.currentMyCasePage),
                                 @"rows" : @(SLConnectionHTTPHandlerRequestPageSize),
                                 @"type" : @(0)};
    __block typeof(self) bself = self;
    [SLConnectionHTTPHandler POSTCaseListWithParameters:parameters showProgressInView:self.view success:^(NSArray *dataArray) {
        if(bself.currentMyCasePage == 1){
            bself.myCaseArray = dataArray;
        }else{
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:bself.myCaseArray];
            [tempArray addObjectsFromArray:dataArray];
            bself.myCaseArray = [tempArray copy];
        }
        [bself.tableView reloadData];
        [bself.tableView headerEndRefreshing];
        [bself.tableView footerEndRefreshing];
    } failure:^(NSString *errorMessage) {
        bself.currentMyCasePage --;
        [bself.tableView headerEndRefreshing];
        [bself.tableView footerEndRefreshing];
    }];
}

- (void)loadMyCollectionCaseData{
    self.autoLoadMyCollectionCaseData = NO;
    NSDictionary *parameters = @{@"userId" : [UserInfo sharedInfo].userID,
                                 @"page" : @(self.currentMyCollectionCasePage),
                                 @"rows" : @(SLConnectionHTTPHandlerRequestPageSize)};
    __block typeof(self) bself = self;
    [SLConnectionHTTPHandler POSTCollectionCaseListWithParameters:parameters showProgressInView:self.view success:^(NSArray *dataArray) {
        if(bself.currentMyCollectionCasePage == 1){
            bself.myCollectionCaseArray = dataArray;
        }else{
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:bself.myCollectionCaseArray];
            [tempArray addObjectsFromArray:dataArray];
            bself.myCollectionCaseArray = [tempArray copy];
        }
        [bself.tableView reloadData];
        [bself.tableView headerEndRefreshing];
        [bself.tableView footerEndRefreshing];
    } failure:^(NSString *errorMessage) {
        bself.currentMyCollectionCasePage --;
        [bself.tableView headerEndRefreshing];
        [bself.tableView footerEndRefreshing];
    }];
}

- (SLPersonalCaseFrameModel *)personalCaseFrameModelWithIndexPath:(NSIndexPath *)indexPath{
    if(self.selectedIndex == 1){
        return self.myCollectionCaseArray[indexPath.section];
    }
    return self.myCaseArray[indexPath.section];
}

- (void)didClickAddBarButtonItem:(UIBarButtonItem *)barButtonItem{
    if([UserInfo sharedInfo].userInfoIntegrity){
        SLAddCaseViewController *addCaseViewController = [[SLAddCaseViewController alloc] init];
        addCaseViewController.delegate = self;
        [self.navigationController pushViewController:addCaseViewController animated:YES];
    }else{
        RegisterController *registerController = [[RegisterController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:registerController];
        [self presentViewController:navigationController animated:YES completion:nil];
    }
}

- (void)addCaseViewController:(SLAddCaseViewController *)addCaseViewController didPublishCaseSuccess:(SLCaseDetailModel *)caseDetailModel{
    self.autoLoadMyCaseData = YES;
    self.segmentedControl.selectedSegmentIndex = 0;
    self.selectedIndex = self.segmentedControl.selectedSegmentIndex;
}

- (void)editCaseViewController:(SLEditCaseViewController *)editCaseViewController didEditCaseSuccess:(SLCaseDetailModel *)caseDetailModel forIndexPath:(NSIndexPath *)indexPath{
    [self.tableView headerBeginRefreshing];
}

- (void)editCaseViewController:(SLEditCaseViewController *)editCaseViewController didRemoveCaseSuccessForIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *tempArray = nil;
    if(self.selectedIndex == 1){
        tempArray = [self.myCollectionCaseArray mutableCopy];
        [tempArray removeObjectAtIndex:indexPath.row];
        self.myCollectionCaseArray = [tempArray copy];
    }else{
        tempArray = [self.myCaseArray mutableCopy];
        [tempArray removeObjectAtIndex:indexPath.row];
        self.myCaseArray = [tempArray copy];
    }
    [self.tableView reloadData];
}

@end
