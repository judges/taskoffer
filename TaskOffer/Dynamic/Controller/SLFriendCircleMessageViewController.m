//
//  SLFriendCircleMessageViewController.m
//  XMPPIM
//
//  Created by wshaolin on 14/12/26.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import "SLFriendCircleMessageViewController.h"
#import "UIBarButtonItem+Image.h"
#import "SLFriendCircleMessageFrameModel.h"
#import "SLFriendCircleMessageViewCell.h"
#import "SLRootTableView.h"
#import "SLFriendCircleStatusDetailViewController.h"
#import "SLFriendCircleSQLiteHandler.h"
#import "SLFriendCircleConstant.h"
#import "MJRefresh.h"
#import "MBProgressHUD+Conveniently.h"

@interface SLFriendCircleMessageViewController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) SLRootTableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation SLFriendCircleMessageViewController

- (SLRootTableView *)tableView{
    if(_tableView == nil){
        _tableView = [[SLRootTableView alloc] initWithDefaultFrameDataSource:self delegate:self];
        __block typeof(self) bself = self;
        [_tableView addFooterWithCallback:^{
            [bself loadMoreData];
        }];
    }
    return _tableView;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
        self.title = @"消息";
        [self.view addSubview:self.tableView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"清空" target:self action:@selector(clearButtonClick)];
}

- (void)setLoadUnreadMessage:(BOOL)loadUnreadMessage{
    _loadUnreadMessage = loadUnreadMessage;
    self.currentPage = 1;
    [self loadData];
}

- (void)loadMoreData{
    self.currentPage ++;
    [self loadData];
}

- (void)loadData{
    NSString *isRead = @"ALL";
    if(self.isLoadUnreadMessage){
        isRead = @"0";
    }
    NSInteger unreadMessageCount = [SLFriendCircleSQLiteHandler allUnreadMessageCount];
    if(unreadMessageCount > 0){
        [[NSNotificationCenter defaultCenter] postNotificationName:kSLFriendCircleReadedMessageNotification object:nil];
    }
    NSDictionary *parameters = @{@"isRead" : isRead,
                                 @"pageNum" : @(self.currentPage),
                                 @"pageSize" : @"20"};
    NSArray *dataArray = [SLFriendCircleSQLiteHandler messageFrameModelWithParameters:parameters];
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.dataArray];
    [tempArray addObjectsFromArray:dataArray];
    self.dataArray = [tempArray copy];
    [self.tableView reloadData];
    
    [self.tableView footerEndRefreshing];
    
    if(self.dataArray.count >= [SLFriendCircleSQLiteHandler allMessageCount]){
        [self.tableView removeFooter];
    }
    
    if(self.dataArray.count == 0){
        [MBProgressHUD showWithError:@"暂无消息"];
    }
    
    if(self.loadUnreadMessage && unreadMessageCount > 0){
        [SLFriendCircleSQLiteHandler updateAllUnreadMessageToRead];
    }
}

- (void)clearButtonClick{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"确定清空所有消息吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SLFriendCircleMessageViewCell *cell = [SLFriendCircleMessageViewCell cellWithTableView:tableView];
    cell.friendCircleMessageFrameModel = self.dataArray[indexPath.row];
    cell.lastRow = indexPath.row == self.dataArray.count - 1;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SLFriendCircleMessageFrameModel *friendCircleMessageFrameModel = self.dataArray[indexPath.row];
    return friendCircleMessageFrameModel.rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SLFriendCircleStatusDetailViewController *friendCircleStatusDetailViewController = [[SLFriendCircleStatusDetailViewController alloc] init];
    SLFriendCircleMessageFrameModel *friendCircleMessageFrameModel = self.dataArray[indexPath.row];
    friendCircleStatusDetailViewController.statusId = friendCircleMessageFrameModel.friendCircleMessageModel.statusId;
    [self.navigationController pushViewController:friendCircleStatusDetailViewController animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        SLFriendCircleMessageFrameModel *friendCircleMessageFrameModel = self.dataArray[indexPath.row];
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.dataArray];
        [SLFriendCircleSQLiteHandler deleteWithMessageModelId:friendCircleMessageFrameModel.friendCircleMessageModel.messageId];
        [tempArray removeObject:friendCircleMessageFrameModel];
        self.dataArray = [tempArray copy];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        self.dataArray = @[];
        [SLFriendCircleSQLiteHandler deleteWithMessageModelId:nil];
        [self.tableView reloadData];
    }
}

@end
