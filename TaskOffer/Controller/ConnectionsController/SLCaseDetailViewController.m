//
//  SLCaseDetailViewController.m
//  TaskOffer
//
//  Created by wshaolin on 15/3/20.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLCaseDetailViewController.h"
#import "SLRootTableView.h"
#import "SLConnectionMoreView.h"
#import "UIBarButtonItem+Image.h"
#import "SLConnectionDetailTableSectionHeaderView.h"
#import "SLTagView.h"
#import "SLConnectionDetailTableViewTagCell.h"
#import "SLCaseDetailTableViewBasicInfoCell.h"
#import "SLCaseDetailTableViewTechnicalInfoCell.h"
#import "SLCaseDetailTableViewDownloadInfoCell.h"
#import "SLCaseDetailTableViewDesignSchemeCell.h"
#import "SLCaseDetailTableHeaderView.h"
#import "SLCaseDetailFrameModel.h"
#import "SLWebViewController.h"
#import "SLConnectionHTTPHandler.h"
#import "FriendSelectViewController.h"
#import "MBProgressHUD+Conveniently.h"
#import "RegisterController.h"

@interface SLCaseDetailViewController ()<UITableViewDataSource, UITableViewDelegate, SLConnectionMoreViewDelegate, SLCaseDetailTableViewDownloadInfoCellDelegate>

@property (nonatomic, strong) SLRootTableView *tableView;
@property (nonatomic, strong) SLConnectionMoreView *connectionMoreView;
@property (nonatomic, strong) SLCaseDetailTableHeaderView *tableHeaderView;
@property (nonatomic, strong) SLCaseDetailFrameModel *caseDetailFrameModel;

@end

@implementation SLCaseDetailViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
        self.title = @"案例详情";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"更多按钮" target:self action:@selector(didClickMoreBarButtonItem:)];
}

- (void)setCaseID:(NSString *)caseID{
    _caseID = caseID;
    
    __block typeof(self) bself = self;
    [SLConnectionHTTPHandler POSTCaseDetailWithCaseID:caseID showProgressInView:self.view success:^(SLCaseDetailFrameModel *caseDetailFrameModel) {
        bself.caseDetailFrameModel = caseDetailFrameModel;
    } failure:^(NSString *errorMessage) {
        
    }];
}

- (void)setCaseDetailFrameModel:(SLCaseDetailFrameModel *)caseDetailFrameModel{
    _caseDetailFrameModel = caseDetailFrameModel;
    if(caseDetailFrameModel.caseDetailModel.isCollected){
        [self.connectionMoreView replaceButtonItemTitle:@"取消收藏" withIndex:2];
    }
    
    if([caseDetailFrameModel.caseDetailModel.createUser isEqualToString:[UserInfo sharedInfo].userID]){
        [self.connectionMoreView removeButtonItemWithIndex:2];
    }
    
    self.tableHeaderView.hidden = NO;
    self.tableView.hidden = NO;
    self.tableHeaderView.headerTitle = caseDetailFrameModel.caseDetailModel.caseName;
    [self.tableView reloadData];
}

- (SLRootTableView *)tableView{
    if(_tableView == nil){
        _tableView = [[SLRootTableView alloc] initWithDefaultFrameStyle:UITableViewStyleGrouped dataSource:self delegate:self];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableHeaderView = self.tableHeaderView;
        _tableView.allowsSelection = NO;
        _tableView.hidden = YES;
    }
    return _tableView;
}

- (SLCaseDetailTableHeaderView *)tableHeaderView{
    if(_tableHeaderView == nil){
        _tableHeaderView = [[SLCaseDetailTableHeaderView alloc] init];
        _tableHeaderView.hidden = YES;
        _tableHeaderView.headerTitle = self.caseDetailFrameModel.caseDetailModel.caseName;
    }
    return _tableHeaderView;
}

- (SLConnectionMoreView *)connectionMoreView{
    if(_connectionMoreView == nil){
        _connectionMoreView = [[SLConnectionMoreView alloc] initWithFrame:CGRectMake(0, 64.0, 0, 0) buttonItemTitles:@[@"发送案例给好友", @"收藏案例"]];
        _connectionMoreView.delegate = self;
    }
    return _connectionMoreView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        SLConnectionDetailTableViewTagCell *cell = [SLConnectionDetailTableViewTagCell cellWithTableView:tableView];
        cell.tagFrameModel = self.caseDetailFrameModel.tagFrameModel;
        return cell;
    }else if(indexPath.section == 1){
        SLCaseDetailTableViewBasicInfoCell *cell = [SLCaseDetailTableViewBasicInfoCell cellWithTableView:tableView];
        cell.caseDetailFrameModel = self.caseDetailFrameModel;
        return cell;
    }else if(indexPath.section == 2){
        SLCaseDetailTableViewTechnicalInfoCell *cell = [SLCaseDetailTableViewTechnicalInfoCell cellWithTableView:tableView];
        cell.caseDetailFrameModel = self.caseDetailFrameModel;
        return cell;
    }else if(indexPath.section == 3){
        SLCaseDetailTableViewDownloadInfoCell *cell = [SLCaseDetailTableViewDownloadInfoCell cellWithTableView:tableView];
        cell.delegate = self;
        cell.caseDetailModel = self.caseDetailFrameModel.caseDetailModel;
        return cell;
    }else{
        SLCaseDetailTableViewDesignSchemeCell *cell = [SLCaseDetailTableViewDesignSchemeCell cellWithTableView:tableView];
        cell.caseDetailFrameModel = self.caseDetailFrameModel;
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return self.caseDetailFrameModel.tagsCellRowHeight;
    }else if(indexPath.section == 1){
        return self.caseDetailFrameModel.basicInfoCellRowHeight;
    }else if(indexPath.section == 2){
        return self.caseDetailFrameModel.technicalInfoCellRowHeight;
    }else if(indexPath.section == 3){
        return self.caseDetailFrameModel.downloadInfoCellRowHeight;
    }else{
        return self.caseDetailFrameModel.designSchemeCellRowHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 4){
        return 0.01;
    }
    return 5.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    SLConnectionDetailTableSectionHeaderView *sectionHeaderView = [SLConnectionDetailTableSectionHeaderView sectionHeaderViewWithTableView:tableView];
    sectionHeaderView.title = @[@"案例标签", @"基本信息", @"技术信息", @"下载信息", @"设计方案"][section];
    sectionHeaderView.hideTopLine = section == 0;
    return sectionHeaderView;
}

- (void)caseDetailTableViewDownloadInfoCell:(SLCaseDetailTableViewDownloadInfoCell *)downloadInfoCell didClickDownloadURL:(NSURL *)url{
    SLWebViewController *webViewController = [[SLWebViewController alloc] init];
    webViewController.webURL = url;
    [self.navigationController pushViewController:webViewController animated:YES];
}

- (void)didClickMoreBarButtonItem:(UIBarButtonItem *)barButtonItem{
    if(self.caseDetailFrameModel != nil){
        if([UserInfo sharedInfo].userInfoIntegrity){
            [self.connectionMoreView showInView:self.view];
        }else{
            RegisterController *registerController = [[RegisterController alloc] init];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:registerController];
            [self presentViewController:navigationController animated:YES completion:nil];
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if(self.caseDetailFrameModel != nil){
        [self.connectionMoreView hide];
    }
}

- (void)connectionMoreView:(SLConnectionMoreView *)connectionMoreView didClickButtonItemAtIndex:(NSInteger)buttonItemIndex{
    switch (buttonItemIndex) {
        case 0:{
            FriendSelectViewController *friendSelectViewController = [[FriendSelectViewController alloc] init];
            friendSelectViewController.selectType = caseRecommend;
            friendSelectViewController.caseInfo = self.caseDetailFrameModel.caseDetailModel;
            friendSelectViewController.controller = self;
            friendSelectViewController.title = @"发送案例";
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:friendSelectViewController];
            [self presentViewController:navigationController animated:YES completion:nil];
        }
            break;
        case 1:{
            if(self.caseDetailFrameModel.caseDetailModel.isCollected){
                [self cancelCollectCase];
            }else{
                [self collectCase];
            }
        }
            break;
        default:
            break;
    }
}

- (void)collectCase{
    __block typeof(self) bself = self;
    NSDictionary *parameters = @{@"caseId" : self.caseID, @"userId" : [UserInfo sharedInfo].userID};
    [SLConnectionHTTPHandler POSTCollectCaseWithParameters:parameters showProgressInView:self.view success:^(NSString *collectionID){
        [MBProgressHUD showWithSuccess:@"收藏成功."];
        [bself.caseDetailFrameModel.caseDetailModel setCollectId:collectionID];
        [bself.caseDetailFrameModel.caseDetailModel setCollected:YES];
        [bself.connectionMoreView replaceButtonItemTitle:@"取消收藏" withIndex:2];
    } failure:^(NSString *errorMessage) {
        [MBProgressHUD showWithError:[NSString stringWithFormat:@"收藏失败，失败原因：%@", errorMessage]];
    }];
}

- (void)cancelCollectCase{
    __block typeof(self) bself = self;
    [SLConnectionHTTPHandler POSTCancelCollectionWithCollectID:self.caseDetailFrameModel.caseDetailModel.collectId showProgressInView:self.view success:^{
        [MBProgressHUD showWithSuccess:@"取消收藏成功."];
        [bself.caseDetailFrameModel.caseDetailModel setCollected:NO];
        [bself.connectionMoreView replaceButtonItemTitle:@"收藏案例" withIndex:2];
    } failure:^(NSString *errorMessage) {
        [MBProgressHUD showWithError:[NSString stringWithFormat:@"取消收藏失败，失败原因：%@", errorMessage]];
    }];
}

@end
