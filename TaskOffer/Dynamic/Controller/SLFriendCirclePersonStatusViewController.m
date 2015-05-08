//
//  SLFriendCirclePersonStatusViewController.m
//  XMPPIM
//
//  Created by wshaolin on 14/12/26.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import "SLFriendCirclePersonStatusViewController.h"
#import "SLFriendCircleStatusDetailViewController.h"
#import "SLFriendCircleTableHeaderView.h"
#import "UIBarButtonItem+Image.h"
#import "SLFriendCirclePersonStatusViewCell.h"
#import "SLFriendCirclePersonStatusFrameModel.h"
#import "MJRefresh.h"
#import "SLFriendCircleTableHeaderView.h"
#import "SLDynamicHTTPHandler.h"
#import "SLFriendCircleSQLiteHandler.h"
#import "SLFriendCircleUserModel.h"
#import "SLRootTableView.h"
#import "UIImageView+SetImage.h"
#import "SLConnectionDetailViewController.h"

@interface SLFriendCirclePersonStatusViewController ()<
        UITableViewDataSource,
        UITableViewDelegate,
        UIActionSheetDelegate,
        SLFriendCirclePersonStatusViewCellDelegate,
        SLFriendCircleStatusDetailViewControllerDelegate,
        SLFriendCircleTableHeaderViewDelegate
        >

@property (nonatomic, strong) SLRootTableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) SLFriendCircleTableHeaderView *tableHeaderView;
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, assign, getter = isNeedLoadData) BOOL needLoadData;

@end

@implementation SLFriendCirclePersonStatusViewController

- (SLRootTableView *)tableView{
    if(_tableView == nil){
        _tableView = [[SLRootTableView alloc] initWithDefaultFrameDataSource:self delegate:self];
        _tableHeaderView = [[SLFriendCircleTableHeaderView alloc] initWithFrame:CGRectZero isNeedMessageButton:NO];
        _tableHeaderView.delegate = self;
        _tableHeaderView.hideNickName = YES;
        _tableView.tableHeaderView = _tableHeaderView;
        
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

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
        self.title = @"圈子";
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
    self.needLoadData = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if(self.isNeedLoadData && self.friendCircleUserModel != nil){
        self.needLoadData = NO;
        if(self.friendCircleUserModel.username != nil && self.friendCircleUserModel.username.length > 0){
            if(self.friendCircleUserModel.displayName.length){
                self.tableHeaderView.hideNickName = NO;
                self.tableHeaderView.nickName = self.friendCircleUserModel.displayName;
            }
            
            [self.tableHeaderView.iconView setImageWithURL:self.friendCircleUserModel.iconURL placeholderImage:kUserDefaultIcon];
            
            [self.tableView headerBeginRefreshing];
        }else{
            self.tableHeaderView.iconView.image = kDefaultIcon;
        }
    }
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
    if(self.friendCircleUserModel.username != nil && self.friendCircleUserModel.username.length > 0){
        NSDictionary *parameters = @{@"username" : self.friendCircleUserModel.username,
                                     @"pageSize" : @(SLDynamicHTTPHandlerRequestPageSize),
                                     @"pageNum" : @(self.currentPage)};
        __block typeof(self) bself = self;
        [SLDynamicHTTPHandler POSTFriendCirclePersonMessageListWithParameters:parameters showProgressInView:nil success:^(NSArray *dataArray) {
            if(bself.currentPage == 1){
                // 新请求回来的数据
                NSMutableArray *tempArray = [NSMutableArray arrayWithArray:dataArray];
                // 当前页面显示的数据
                NSMutableArray *oldTempArray = [NSMutableArray arrayWithArray:bself.dataArray];
                for (SLFriendCirclePersonStatusFrameModel *personStatusFrameModel in tempArray) {
                    // 如果新的数据的id在老的数据中存在，则删除老的数据，保留新的数据
                    // 这样做的目的是尽量避免数据的最新性和正确性
                    for(SLFriendCirclePersonStatusFrameModel *oldPersonStatusFrameModel in oldTempArray){
                        if([personStatusFrameModel.friendCircleStatusModel.statusId isEqualToString:oldPersonStatusFrameModel.friendCircleStatusModel.statusId]){
                            // 移除老的数据
                            [oldTempArray removeObject:oldPersonStatusFrameModel];
                            break;
                        }
                    }
                }
                
                if(oldTempArray.count > 0){
                    [tempArray addObjectsFromArray:[oldTempArray copy]];
                }
                bself.dataArray = [tempArray copy];
            }else{
                NSMutableArray *tempArray = [NSMutableArray arrayWithArray:bself.dataArray];
                [tempArray addObjectsFromArray:dataArray];
                bself.dataArray = [tempArray copy];
            }
            
            if(dataArray.count == 0){
                bself.currentPage --;
            }
            [bself.tableView reloadData];
            [bself.tableView headerEndRefreshing];
            [bself.tableView footerEndRefreshing];
        } failure:^(NSString *errorMessage) {
            bself.currentPage --;
            [bself.tableView headerEndRefreshing];
            [bself.tableView footerEndRefreshing];
        }];
    }else{
        self.currentPage --;
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SLFriendCirclePersonStatusViewCell *cell = [SLFriendCirclePersonStatusViewCell cellWithTableView:tableView];
    SLFriendCirclePersonStatusFrameModel *currentPersonStatusFrameModel = self.dataArray[indexPath.row];
    cell.friendCirclePersonStatusFrameModel = currentPersonStatusFrameModel;
    cell.indexPath = indexPath;
    cell.delegate = self;
    BOOL hideDate = NO;
    if(indexPath.row > 0){
        SLFriendCirclePersonStatusFrameModel *previousPersonStatusFrameModel = self.dataArray[indexPath.row - 1];
        hideDate = [previousPersonStatusFrameModel.friendCircleStatusModel.dayLinkMonth isEqualToString:currentPersonStatusFrameModel.friendCircleStatusModel.dayLinkMonth];
    }
    cell.hideDate = hideDate;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SLFriendCirclePersonStatusFrameModel *friendCirclePersonStatusFrameModel = self.dataArray[indexPath.row];
    CGFloat rowHeight = friendCirclePersonStatusFrameModel.rowHeight;
    if(indexPath.row == self.dataArray.count - 1){
        rowHeight += 10.0;
    }
    return rowHeight;
}

- (void)friendCirclePersonStatusViewCell:(SLFriendCirclePersonStatusViewCell *)friendCirclePersonStatusViewCell didTapAtIndexPath:(NSIndexPath *)indexPath{
    SLFriendCircleStatusDetailViewController *friendCircleStatusDetailViewController = [[SLFriendCircleStatusDetailViewController alloc] init];
    SLFriendCirclePersonStatusFrameModel *friendCirclePersonStatusFrameModel = self.dataArray[indexPath.row];
    friendCircleStatusDetailViewController.friendCircleStatusModel = friendCirclePersonStatusFrameModel.friendCircleStatusModel;
    friendCircleStatusDetailViewController.delegate = self;
    friendCircleStatusDetailViewController.indexPath = indexPath;
    friendCircleStatusDetailViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:friendCircleStatusDetailViewController animated:YES];
}

- (void)friendCircleStatusDetailViewController:(SLFriendCircleStatusDetailViewController *)friendCircleStatusDetailViewController didCompletedDeleteStatus:(NSString *)statusId atIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.dataArray];
    [tempArray removeObjectAtIndex:indexPath.row];
    self.dataArray = [tempArray copy];
    [self.tableView reloadData];
}

- (void)friendCircleStatusDetailViewController:(SLFriendCircleStatusDetailViewController *)friendCircleStatusDetailViewController didCompletedComment:(SLFriendCircleStatusCommentModel *)statusCommentModel atIndexPath:(NSIndexPath *)indexPath{
    SLFriendCirclePersonStatusFrameModel *friendCirclePersonStatusFrameModel = self.dataArray[indexPath.row];
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:friendCirclePersonStatusFrameModel.friendCircleStatusModel.commentArray];
    SLFriendCircleStatusCommentFrameModel *friendCircleStatusCommentFrameModel = [[SLFriendCircleStatusCommentFrameModel alloc] initWithFriendCircleStatusCommentModel:statusCommentModel];
    [tempArray addObject:friendCircleStatusCommentFrameModel];
    
    friendCirclePersonStatusFrameModel.friendCircleStatusModel.commentArray = [tempArray copy];
}

- (void)friendCircleTableHeaderViewIconTap:(SLFriendCircleTableHeaderView *)friendCircleTableHeaderView{
    SLConnectionDetailViewController *connectionDetailViewController = [[SLConnectionDetailViewController alloc] init];
    connectionDetailViewController.userID = self.friendCircleUserModel.username;
    [self.navigationController pushViewController:connectionDetailViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

@end
