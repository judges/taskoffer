//
//  SLFriendCircleStatusDetailViewController.m
//  XMPPIM
//
//  Created by wshaolin on 14/12/26.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import "SLFriendCircleStatusDetailViewController.h"
#import "SLFriendCircleTableSectionHeaderView.h"
#import "SLFriendCircleTableHeaderView.h"
#import "SLRootTableView.h"
#import "SLFriendCircleStatusFrameModel.h"
#import "SLFriendCircleStatusDetailCommentFrameModel.h"
#import "SLFriendCircleStatusDetailViewCell.h"
#import "SLFriendCircleStatusDetailSectionView.h"
#import "SLDynamicHTTPHandler.h"
#import "SLKeyboardInputView.h"
#import "SLAlertView.h"
#import "SLFriendCircleConstant.h"
#import "NSDate+Conveniently.h"
#import "SLFriendCircleSQLiteHandler.h"
#import "SLFriendCirclePersonStatusViewController.h"
#import "MBProgressHUD+Conveniently.h"
#import "NSString+Conveniently.h"
#import "NSDictionary+NullFilter.h"
#import "RegisterController.h"

@interface SLFriendCircleStatusDetailViewController ()<
            UITableViewDataSource,
            UITableViewDelegate,
            UIAlertViewDelegate,
            SLFriendCircleTableSectionHeaderViewDelegate,
            SLKeyboardInputViewDelegate,
            SLFriendCircleStatusDetailViewCellDelegate
            >

@property (nonatomic, strong) SLRootTableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) SLKeyboardInputView *keyboardInputView;
@property (nonatomic, strong) SLFriendCircleTableSectionHeaderView *tableHeaderView;
@property (nonatomic, strong) SLFriendCircleStatusFrameModel *friendCircleStatusFrameModel;
@property (nonatomic, strong) NSDictionary *replyInfo;

@end

@implementation SLFriendCircleStatusDetailViewController

- (SLRootTableView *)tableView{
    if(_tableView == nil){
        _tableView = [[SLRootTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (SLKeyboardInputView *)keyboardInputView{
    if(_keyboardInputView == nil){
        _keyboardInputView = [[SLKeyboardInputView alloc] init];
        _keyboardInputView.delegate = self;
        _keyboardInputView.maxEnableCount = 250.0;
    }
    return _keyboardInputView;
}

- (void)setFriendCircleStatusModel:(SLFriendCircleStatusModel *)friendCircleStatusModel{
    if(friendCircleStatusModel != nil){
        _statusId = friendCircleStatusModel.statusId;
        
        if(self.userModel != nil){
            [friendCircleStatusModel setFriendCircleUserModel:self.userModel];
        }
        
        self.friendCircleStatusFrameModel = [[SLFriendCircleStatusFrameModel alloc] initWithFriendCircleStatusModel:friendCircleStatusModel];
        
        // 计算frame
        CGRect tableHeaderBottomViewFrame = self.view.bounds;
        tableHeaderBottomViewFrame.origin.y = 0;
        tableHeaderBottomViewFrame.size.height = self.friendCircleStatusFrameModel.statusSectionHeight + 5.0;
        
        // 创建tableHeaderBottomView
        SLFriendCircleTableSectionHeaderView *tableHeaderView = [SLFriendCircleTableSectionHeaderView sectionHeaderViewWithTableView:nil];
        tableHeaderView.frame = tableHeaderBottomViewFrame;
        
        tableHeaderView.delegate = self;
        // 显示删除按钮
        tableHeaderView.showDeleteButton = friendCircleStatusModel.userModel.isCurrentUser;
        
        // 隐藏顶部的线
        tableHeaderView.showTopLine = NO;
        
        // 设置数据
        tableHeaderView.friendCircleStatusFrameModel = self.friendCircleStatusFrameModel;
        self.tableHeaderView = tableHeaderView;
        
        // 设置TableView的tableHeaderView
        self.tableView.tableHeaderView = tableHeaderView;
        
        // 设置评论数据
        NSMutableArray *tempArray = [NSMutableArray array];
        for(SLFriendCircleStatusCommentFrameModel *commentFrameModel in friendCircleStatusModel.commentArray){
            // 模型转换
            SLFriendCircleStatusDetailCommentFrameModel *statusDetailCommentFrameModel = [[SLFriendCircleStatusDetailCommentFrameModel alloc] initWithFriendCircleStatusCommentModel:commentFrameModel.friendCircleStatusCommentModel];
            [tempArray addObject:statusDetailCommentFrameModel];
        }
        
        // 设置数据源
        self.dataArray = [tempArray copy];
        // 刷新显示数据
        [self.tableView reloadData];
    }
}

- (void)setStatusId:(NSString *)statusId{
    _statusId = statusId;
    NSDictionary *parameters = @{@"infoId" : statusId,
                                 @"username" : [UserInfo sharedInfo].userID};
    __block typeof(self) bself = self;
    [SLDynamicHTTPHandler POSTFriendCircleStatusDetailWithParameters:parameters showProgressInView:self.view success:^(SLFriendCircleStatusModel *friendCircleStatusModel) {
        [bself setFriendCircleStatusModel: friendCircleStatusModel];
    } failure:^(NSString *errorMessage) {
        
    }];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
        self.title = @"动态详情";
        [self.view addSubview:self.tableView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusImageDidClickNotification:) name:kSLFriendCircleStatusImageDidClickNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.keyboardInputView hide];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SLFriendCircleStatusDetailViewCell *cell = [SLFriendCircleStatusDetailViewCell cellWithTableView:tableView];
    cell.firstRow = indexPath.row == 0;
    cell.lastRow = indexPath.row == self.dataArray.count - 1;
    cell.statusDetailCommentFrameModel = self.dataArray[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SLFriendCircleStatusDetailCommentFrameModel *statusDetailCommentFrameModel = self.dataArray[indexPath.row];
    return statusDetailCommentFrameModel.rowHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(self.friendCircleStatusFrameModel.friendCircleStatusModel.applaudCount > 0){
        SLFriendCircleStatusDetailSectionView *view = [SLFriendCircleStatusDetailSectionView statusDetailSectionViewWithTableView:tableView];
        view.applaudNicknameString = self.friendCircleStatusFrameModel.friendCircleStatusModel.allApplaudNicknameString;
        view.hideLine = self.dataArray.count == 0;
        return view;
    }
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(self.friendCircleStatusFrameModel.friendCircleStatusModel.applaudCount > 0){
        return [self.friendCircleStatusFrameModel.friendCircleStatusModel.allApplaudNicknameString sizeWithFont:[UIFont systemFontOfSize:15.0] limitSize:CGSizeMake(tableView.bounds.size.width - 20.0, MAXFLOAT)].height + 10.0;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01; // 不显示FooterView
}

#pragma mark - 回复别人的信息（消息发送人不是自己，如果发送人是自己，则啥也不做）

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(![UserInfo sharedInfo].userInfoIntegrity){
        RegisterController *registerController = [[RegisterController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:registerController];
        [self presentViewController:navigationController animated:YES completion:nil];
        return;
    }
    
    SLFriendCircleStatusDetailCommentFrameModel *statusDetailCommentFrameModel = self.dataArray[indexPath.row];
    SLFriendCircleUserModel *userModel = statusDetailCommentFrameModel.friendCircleStatusCommentModel.senderUserModel;
    
    // 自己不能回复自己
    if(![userModel.username isEqualToString:[UserInfo sharedInfo].userID]){
        self.keyboardInputView.placeholder = [NSString stringWithFormat:@"回复%@：", userModel.displayName];
        self.replyInfo = @{@"commentid" : statusDetailCommentFrameModel.friendCircleStatusCommentModel.commentId,
                       @"username" : userModel.username,
                       @"displayname" : userModel.displayName};
        [self.keyboardInputView show];
    }
}

- (void)friendCircleTableSectionHeaderView:(SLFriendCircleTableSectionHeaderView *)friendCircleTableSectionHeaderView didTapApplaudForSection:(NSInteger)section isCancel:(BOOL)cancel{
    [self.keyboardInputView hide];
    
    if(![UserInfo sharedInfo].userInfoIntegrity){
        RegisterController *registerController = [[RegisterController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:registerController];
        [self presentViewController:navigationController animated:YES completion:nil];
        return;
    }
    
    NSString *currentUsername = [UserInfo sharedInfo].userID;
    NSString *currentDisplayName = [UserInfo sharedInfo].userName;
    NSDictionary *parameters = @{@"username" : currentUsername,
                                 @"infoId" : self.statusId};
    
    NSMutableArray *tempNicknameArray = [NSMutableArray arrayWithArray:self.friendCircleStatusFrameModel.friendCircleStatusModel.applaudNicknameArray];
    NSMutableArray *tempUsernameArray = [NSMutableArray arrayWithArray:self.friendCircleStatusFrameModel.friendCircleStatusModel.applaudUsernameArray];
    // 取消点赞
    if(cancel){
        // 移除点赞人的昵称
        for(NSString *nickname in tempNicknameArray){
            if([nickname isEqualToString:currentDisplayName]){
                [tempNicknameArray removeObject:nickname];
                break;
            }
        }
        // 移除点赞人的ID
        for(NSString *username in tempUsernameArray){
            if([username isEqualToString:currentUsername]){
                [tempUsernameArray removeObject:username];
                break;
            }
        }
    }else{
        [tempNicknameArray addObject:currentDisplayName];
        [tempUsernameArray addObject:currentUsername];
    }
    
    // 重新赋值
    self.friendCircleStatusFrameModel.friendCircleStatusModel.applaudNicknameArray = [tempNicknameArray copy];
    self.friendCircleStatusFrameModel.friendCircleStatusModel.applaudUsernameArray = [tempUsernameArray copy];
    
    [self.tableView reloadData];
    
    __block typeof(self) bself = self;
    [SLDynamicHTTPHandler POSTFriendCircleApplaudWithParameters:parameters isCancel:cancel showProgressInView:nil success:^{
        // 如果成功了，则需要更新缓存数据
        // [SLFriendCircleSQLiteHandler updateWithStatusModel:statusFrameModel.friendCircleStatusModel];
    } failure:^(NSString *errorMessage) {
        if(cancel){
            [MBProgressHUD showWithError:@"取消赞失败"];
            [tempNicknameArray removeObject:currentDisplayName];
            [tempUsernameArray removeObject:currentUsername];
        }else{
            [MBProgressHUD showWithError:@"点赞失败"];
            
            for(NSString *nickname in tempNicknameArray){
                if([nickname isEqualToString:currentDisplayName]){
                    [tempNicknameArray removeObject:nickname];
                    break;
                }
            }
            
            for(NSString *username in tempUsernameArray){
                if([username isEqualToString:currentUsername]){
                    [tempUsernameArray removeObject:username];
                    break;
                }
            }
        }
        
        bself.friendCircleStatusFrameModel.friendCircleStatusModel.applaudNicknameArray = [tempNicknameArray copy];
        bself.friendCircleStatusFrameModel.friendCircleStatusModel.applaudUsernameArray = [tempUsernameArray copy];
        
        [bself.tableView reloadData];
    }];
}

- (void)friendCircleTableSectionHeaderView:(SLFriendCircleTableSectionHeaderView *)friendCircleTableSectionHeaderView didTapCommentForSection:(NSInteger)section{
    if(![UserInfo sharedInfo].userInfoIntegrity){
        RegisterController *registerController = [[RegisterController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:registerController];
        [self presentViewController:navigationController animated:YES completion:nil];
        return;
    }
    
    self.replyInfo = nil;
    self.keyboardInputView.placeholder = @"评论";
    
    [self.keyboardInputView show];
}


#pragma mark - 删除

- (void)friendCircleTableSectionHeaderView:(SLFriendCircleTableSectionHeaderView *)friendCircleTableSectionHeaderView didTapDeleteForSection:(NSInteger)section{
    NSDictionary *parameters = @{@"infoId" : self.statusId,
                                 @"username" : [UserInfo sharedInfo].userID};
    __block typeof(self) bself = self;
    [SLDynamicHTTPHandler POSTFriendCircleDeleteStatusWithParameters:parameters showProgressInView:self.view success:^{
        if(bself.delegate && [bself.delegate respondsToSelector:@selector(friendCircleStatusDetailViewController:didCompletedDeleteStatus:atIndexPath:)]){
            [bself.delegate friendCircleStatusDetailViewController:bself didCompletedDeleteStatus:self.statusId atIndexPath:bself.indexPath];
        }
        
        // 发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kSLFriendCircleStatusDeleteCompletedNotification object:self.statusId];
        [SLAlertView showWithMessage:@"删除成功！" delegate:bself cancelButtonTitle:@"确定" otherButtonTitle:nil];
        
        // 删除缓存
        // [SLFriendCircleSQLiteHandler deleteWithStatusModelId:statusId];
    } failure:^(NSString *errorMessage) {
        [MBProgressHUD showWithError:@"删除失败"];
    }];
}

#pragma mark - 评论

- (void)keyboardInputView:(SLKeyboardInputView *)keyboardInputView didClickSendButton:(NSString *)snedText{
    NSString *parentId = @"";
    NSString *replyTo = @"";
    NSString *replyToRemark = @"";
    __block NSString *failureMessage = @"评论失败";
    if(self.replyInfo != nil && self.replyInfo.count > 0){
        parentId = [self.replyInfo stringForKey:@"commentid"];
        replyTo = [self.replyInfo stringForKey:@"username"];
        replyToRemark = [self.replyInfo stringForKey:@"displayname"];
        failureMessage = @"回复失败";
    }
    
    NSDictionary *parameters = @{@"username" : [UserInfo sharedInfo].userID,
                                 @"infoId" : self.statusId,
                                 @"comment" : snedText,
                                 @"parentId" : parentId}; // 评论时parentId的值为空
    NSDictionary *commentDictionary = @{@"type" : @(0),
                                        @"username" : [UserInfo sharedInfo].userID,
                                        @"remarkname" : [UserInfo sharedInfo].userName,
                                        @"nickname" : [UserInfo sharedInfo].userName,
                                        @"comment" : snedText,
                                        @"parentId" : parentId,
                                        @"replyTo" : replyTo,
                                        @"replyToNick" : replyToRemark,
                                        @"replyToRemark" : replyToRemark,
                                        @"infoId" : self.statusId,
                                        @"createTime" : [[NSDate date] defaultFormat]};
    // 构造一条评论
    SLFriendCircleStatusCommentModel *statusCommentModel = [[SLFriendCircleStatusCommentModel alloc] initWithDictionary:commentDictionary];
    SLFriendCircleStatusDetailCommentFrameModel *statusDetailCommentFrameModel = [[SLFriendCircleStatusDetailCommentFrameModel alloc] initWithFriendCircleStatusCommentModel:statusCommentModel];
    NSMutableArray *tempCommentArray = [self.dataArray mutableCopy];
    [tempCommentArray addObject:statusDetailCommentFrameModel];
    self.dataArray  = [tempCommentArray copy];
    [self.tableView reloadData];
    
    __block typeof(self) bself = self;
    [SLDynamicHTTPHandler POSTFriendCircleCommentWithParameters:parameters showProgressInView:nil success:^(SLFriendCircleStatusCommentModel *statusCommentModel) {
        
        SLFriendCircleStatusCommentFrameModel *statusCommentFrameModel = [bself.dataArray lastObject];
        [statusCommentFrameModel.friendCircleStatusCommentModel setCommentId:statusCommentModel.commentId];
        
        if(bself.delegate && [bself.delegate respondsToSelector:@selector(friendCircleStatusDetailViewController:didCompletedComment:atIndexPath:)]){
            [bself.delegate friendCircleStatusDetailViewController:bself didCompletedComment:statusCommentFrameModel.friendCircleStatusCommentModel atIndexPath:bself.indexPath];
        }
        
        // 如果成功了，则需要更新缓存数据
        // [SLFriendCircleSQLiteHandler insertWithStatusCommentModel:statusCommentModel];
    } failure:^(NSString *errorMessage) {
        if(errorMessage != nil && errorMessage.length > 0){
            failureMessage = errorMessage;
        }
        [MBProgressHUD showWithError:failureMessage];
    }];
    
    self.replyInfo = nil;
}

- (void)friendCircleStatusDetailViewCell:(SLFriendCircleStatusDetailViewCell *)friendCircleStatusDetailViewCell didTapFriendCircleUser:(SLFriendCircleUserModel *)friendCircleUserModel{
    [self didTapFriendCircleUser:friendCircleUserModel];
}

- (void)statusDetailSectionView:(SLFriendCircleStatusDetailSectionView *)statusDetailSectionView didTapApplaudUser:(SLFriendCircleUserModel *)friendCircleUserModel{
    [self didTapFriendCircleUser:friendCircleUserModel];
}

- (void)didTapFriendCircleUser:(SLFriendCircleUserModel *)friendCircleUserModel{
    [self.keyboardInputView hide];
    SLFriendCirclePersonStatusViewController *friendCirclePersonStatusViewController = [[SLFriendCirclePersonStatusViewController alloc] init];
    friendCirclePersonStatusViewController.hidesBottomBarWhenPushed = YES;
    friendCirclePersonStatusViewController.friendCircleUserModel= friendCircleUserModel;
    friendCirclePersonStatusViewController.title = friendCircleUserModel.displayName;
    [self.navigationController pushViewController:friendCirclePersonStatusViewController animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)statusImageDidClickNotification:(NSNotification *)notification{
    [self.keyboardInputView hide];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.keyboardInputView hide];
}

@end
