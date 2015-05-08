//
//  SLConnectionDetailViewController.m
//  TaskOffer
//
//  Created by wshaolin on 15/3/19.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLConnectionDetailViewController.h"
#import "UIBarButtonItem+Image.h"
#import "SLRootTableView.h"
#import "SLConnectionDetailTableFooterView.h"
#import "SLConnectionDetailTableSectionHeaderView.h"
#import "SLConnectionDetailTableViewTagCell.h"
#import "SLConnectionDetailTableViewLibraryCell.h"
#import "SLConnectionDetailTableViewEIAuthenticatedCell.h"
#import "SLConnectionDetailTableViewEIUnrecognizedCell.h"
#import "SLConnectionDetailTableViewBaseInfoCell.h"
#import "SLConnectionMoreView.h"
#import "SLBiddingProjectViewController.h"
#import "SLCaseViewController.h"
#import "ProjectInfoController.h"
#import "SLCaseDetailViewController.h"
#import "SingleChatController.h"
#import "SLFriendRequestValidateViewController.h"
#import "SLConnectionHTTPHandler.h"
#import "SLConnectionDetailModel.h"
#import "EnterpriseInfoController.h"
#import "SLTaskHandler.h"
#import "FriendSelectViewController.h"
#import "MBProgressHUD+Conveniently.h"
#import "RegisterController.h"

#import "SLFriendCirclePersonStatusViewController.h"
#import "SLFriendCircleStatusDetailViewController.h"
#import "SLFriendCircleUserModel.h"

@interface SLConnectionDetailViewController ()<
            UITableViewDataSource,
            UITableViewDelegate,
            UIAlertViewDelegate,
            SLConnectionDetailTableFooterViewDeledate,
            SLConnectionDetailTableSectionHeaderViewDelegate,
            SLConnectionMoreViewDelegate
            >

@property (nonatomic, strong) SLRootTableView *tableView;
@property (nonatomic, strong) SLConnectionDetailTableFooterView *tableFooterView;
@property (nonatomic, strong) SLConnectionDetailModel *connectionDetailModel;
@property (nonatomic, strong) SLConnectionMoreView *connectionMoreView;

@property (nonatomic, assign, readonly) BOOL isFriend;

@end

@implementation SLConnectionDetailViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
        self.title = @"人脉详情";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.tableFooterView];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"更多按钮" target:self action:@selector(didClickMoreBarButtonItem:)];
}

- (void)setUserID:(NSString *)userID{
    _userID = userID;
    __block typeof(self) bself = self;
    [SLConnectionHTTPHandler POSTConnectionDetailWithUserID:userID success:^(SLConnectionDetailModel *connectionDetailModel) {
        bself.connectionDetailModel = connectionDetailModel;
    } failure:^(NSString *errorMessage) {
        
    }];
}

- (SLRootTableView *)tableView{
    if(_tableView == nil){
        _tableView = [[SLRootTableView alloc] initWithDefaultFrameStyle:UITableViewStyleGrouped dataSource:self delegate:self];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.hidden = YES;
    }
    return _tableView;
}

- (SLConnectionDetailTableFooterView *)tableFooterView{
    if(_tableFooterView == nil){
        _tableFooterView = [[SLConnectionDetailTableFooterView alloc] init];
        _tableFooterView.delegate = self;
        _tableFooterView.hidden = YES;
    }
    return _tableFooterView;
}

- (SLConnectionMoreView *)connectionMoreView{
    if(_connectionMoreView == nil){
        _connectionMoreView = [[SLConnectionMoreView alloc] initWithFrame:CGRectMake(0, 64.0, 0, 0) buttonItemTitles:@[@"发送名片"]];
        _connectionMoreView.delegate = self;
    }
    return _connectionMoreView;
}

- (void)setConnectionDetailModel:(SLConnectionDetailModel *)connectionDetailModel{
    _connectionDetailModel = connectionDetailModel;
    self.tableView.hidden = NO;
    
    _isFriend = [SLTaskHandler validateIsFriendWithUserID:connectionDetailModel.connectionModel.userID];
    
    // 自己
    if([connectionDetailModel.connectionModel.userID isEqualToString:[UserInfo sharedInfo].userID]){
        [self.connectionMoreView removeButtonItemWithIndex:1];
        self.tableFooterView.connectionRelationship = SLConnectionRelationshipSelf;
    }else{
        // 好友
        if(_isFriend){
            self.tableFooterView.connectionRelationship = SLConnectionRelationshipFriend;
        }else{
            self.tableFooterView.connectionRelationship = SLConnectionRelationshipStranger;
        }
        self.tableFooterView.hidden = NO;
    }
    
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.connectionDetailModel.sectionTypes.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SLConnectionDetailSectionType sectionType = [self.connectionDetailModel.sectionTypes[indexPath.section] integerValue];
    switch (sectionType) {
        case SLConnectionDetailSectionTypeBaseInfo:{
            SLConnectionDetailTableViewBaseInfoCell *cell = [SLConnectionDetailTableViewBaseInfoCell cellWithTableView:tableView];
            cell.baseInfoFrameModel = self.connectionDetailModel.connectionDetailBaseInfoFrameModel;
            return cell;
        }
        case SLConnectionDetailSectionTypeTag:{ // 行业标签
            SLConnectionDetailTableViewTagCell *cell = [SLConnectionDetailTableViewTagCell cellWithTableView:tableView];
            cell.tagFrameModel = self.connectionDetailModel.tagFrameModel;
            return cell;
        }
        case SLConnectionDetailSectionTypeEnterpriseInfo:{ // 企业资料
            if(self.connectionDetailModel.connectionModel.isAuthenticated){ // 已认证
                SLConnectionDetailTableViewEIAuthenticatedCell *cell = [SLConnectionDetailTableViewEIAuthenticatedCell cellWithTableView:tableView];
                cell.eiModel = self.connectionDetailModel.eiFrameModel.eiModel;
                return cell;
            }else{ // 未认证
                SLConnectionDetailTableViewEIUnrecognizedCell *cell = [SLConnectionDetailTableViewEIUnrecognizedCell cellWithTableView:tableView];
                cell.frameModel = self.connectionDetailModel.eiFrameModel;
                return cell;
            }
        }
        case SLConnectionDetailSectionTypeCaseLibrary:{ // 案例库
            SLConnectionDetailTableViewLibraryCell *cell = [SLConnectionDetailTableViewLibraryCell cellWithTableView:tableView];
            cell.iconURL = self.connectionDetailModel.caseDetailModel.caseLogo;
            cell.content = self.connectionDetailModel.caseDetailModel.caseName;
            return cell;
        }
        case SLConnectionDetailSectionTypeProjectLibrary:{ // 项目库
            SLConnectionDetailTableViewLibraryCell *cell = [SLConnectionDetailTableViewLibraryCell cellWithTableView:tableView];
            cell.iconURL = self.connectionDetailModel.projectModel.projectLogo;
            cell.content = self.connectionDetailModel.projectModel.projectName;
            return cell;
        }
        case SLConnectionDetailSectionTypeDynamic:{
            SLConnectionDetailTableViewLibraryCell *cell = [SLConnectionDetailTableViewLibraryCell cellWithTableView:tableView];
            cell.iconURL = self.connectionDetailModel.dynamicModel.imageURL;
            cell.content = self.connectionDetailModel.dynamicModel.content;
            return cell;
        }
            break;
        default:
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section != 0){
        SLConnectionDetailTableSectionHeaderView *sectionHeaderView = [SLConnectionDetailTableSectionHeaderView sectionHeaderViewWithTableView:tableView];
        sectionHeaderView.section = section;
        sectionHeaderView.delegate = self;
    
        SLConnectionDetailSectionType sectionType = [self.connectionDetailModel.sectionTypes[section] integerValue];
        sectionHeaderView.title = self.connectionDetailModel.sectionTitles[section];
        sectionHeaderView.hideMoreButton = (sectionType == SLConnectionDetailSectionTypeTag || sectionType == SLConnectionDetailSectionTypeEnterpriseInfo);
    
        return sectionHeaderView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section != 0){
       return self.connectionDetailModel.sectionHeight;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5.0;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    SLConnectionDetailSectionType sectionType = [self.connectionDetailModel.sectionTypes[indexPath.section] integerValue];
    
    return sectionType == SLConnectionDetailSectionTypeCaseLibrary || sectionType == SLConnectionDetailSectionTypeProjectLibrary || (sectionType == SLConnectionDetailSectionTypeEnterpriseInfo && self.connectionDetailModel.connectionModel.isAuthenticated) || sectionType == SLConnectionDetailSectionTypeDynamic;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.connectionDetailModel.sectionCellRowHeight[indexPath.section] floatValue];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SLConnectionDetailSectionType sectionType = [self.connectionDetailModel.sectionTypes[indexPath.section] integerValue];
    switch (sectionType) {
        case SLConnectionDetailSectionTypeCaseLibrary:{
            if(self.connectionDetailModel.caseDetailModel.caseType == SLCaseTypePersonal){
                SLCaseViewController *caseViewController = [[SLCaseViewController alloc] init];
                caseViewController.userID = self.connectionDetailModel.connectionModel.userID;
                [self.navigationController pushViewController:caseViewController animated:YES];
            }else{
                SLCaseDetailViewController *caseDetailViewController = [[SLCaseDetailViewController alloc] init];
                caseDetailViewController.caseID = self.connectionDetailModel.caseDetailModel.caseID;
                [self.navigationController pushViewController:caseDetailViewController animated:YES];
            }
        }
            break;
        case SLConnectionDetailSectionTypeProjectLibrary:{
            ProjectInfoController *projectInfoController = [[ProjectInfoController alloc] init];
            projectInfoController.projectID = self.connectionDetailModel.projectModel.projectID;
            [self.navigationController pushViewController:projectInfoController animated:YES];
        }
            break;
        case SLConnectionDetailSectionTypeEnterpriseInfo:{
            if(self.connectionDetailModel.connectionModel.isAuthenticated){
                EnterpriseInfoController *enterpriseInfoController = [[EnterpriseInfoController alloc] init];
                enterpriseInfoController.companyInfo = self.connectionDetailModel.enterpriseInfo;
                [self.navigationController pushViewController:enterpriseInfoController animated:YES];
            }
        }
            break;
        case SLConnectionDetailSectionTypeDynamic:{
            SLFriendCircleStatusDetailViewController *friendCircleStatusDetailViewController = [[SLFriendCircleStatusDetailViewController alloc] init];
            SLFriendCircleUserModel *friendCircleUserModel = [[SLFriendCircleUserModel alloc] initWithUsername:self.connectionDetailModel.connectionModel.userID displayName:self.connectionDetailModel.connectionModel.displayName iconURL:self.connectionDetailModel.connectionModel.imageURL];
            friendCircleStatusDetailViewController.userModel = friendCircleUserModel;
            friendCircleStatusDetailViewController.statusId = self.connectionDetailModel.dynamicModel.dynamicID;
            [self.navigationController pushViewController:friendCircleStatusDetailViewController animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)didClickMoreBarButtonItem:(UIBarButtonItem *)barButtonItem{
    if(self.connectionDetailModel != nil){
        if([UserInfo sharedInfo].userInfoIntegrity){
            [self.connectionMoreView showInView:self.view];
        }else{
            RegisterController *registerController = [[RegisterController alloc] init];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:registerController];
            [self presentViewController:navigationController animated:YES completion:nil];
        }
    }
}

- (void)connectionMoreView:(SLConnectionMoreView *)connectionMoreView didClickButtonItemAtIndex:(NSInteger)buttonItemIndex{
    if(buttonItemIndex == 0){
        FriendSelectViewController *friendSelectViewController = [[FriendSelectViewController alloc] init];
        friendSelectViewController.selectType = exchangeCards;
        friendSelectViewController.controller = self;
        friendSelectViewController.title = @"发送名片";
        NSDictionary *dictionary = @{@"itemPicPath" : self.connectionDetailModel.connectionModel.imageURL,
                                     @"itemID" : self.connectionDetailModel.connectionModel.userID,
                                     @"itemName" : self.connectionDetailModel.connectionModel.displayName,
                                     @"itemContent" : self.connectionDetailModel.connectionModel.introduction};
        friendSelectViewController.cardDict = [dictionary mutableCopy];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:friendSelectViewController];
        [self presentViewController:navigationController animated:YES completion:nil];
    }else if (buttonItemIndex == 1){
        [self createChat];
    }
}

- (void)connectionDetailTableSectionHeaderView:(SLConnectionDetailTableSectionHeaderView *)tableSectionHeaderView didClickMoreButtonAtSection:(NSInteger)section{
    SLConnectionDetailSectionType sectionType = [self.connectionDetailModel.sectionTypes[section] integerValue];
    switch (sectionType) {
        case SLConnectionDetailSectionTypeProjectLibrary:{
            SLBiddingProjectViewController *biddingProjectViewController = [[SLBiddingProjectViewController alloc] init];
            biddingProjectViewController.userID = self.connectionDetailModel.connectionModel.userID;
            [self.navigationController pushViewController:biddingProjectViewController animated:YES];
        }
            break;
        case SLConnectionDetailSectionTypeCaseLibrary:{
            SLCaseViewController *caseViewController = [[SLCaseViewController alloc] init];
            caseViewController.userID = self.connectionDetailModel.connectionModel.userID;
            [self.navigationController pushViewController:caseViewController animated:YES];
        }
            break;
        case SLConnectionDetailSectionTypeDynamic:{
            SLFriendCircleUserModel *friendCircleUserModel = [[SLFriendCircleUserModel alloc] initWithUsername:self.connectionDetailModel.connectionModel.userID displayName:self.connectionDetailModel.connectionModel.displayName iconURL:self.connectionDetailModel.connectionModel.imageURL];
            SLFriendCirclePersonStatusViewController *friendCirclePersonStatusViewController = [[SLFriendCirclePersonStatusViewController alloc] init];
            friendCirclePersonStatusViewController.friendCircleUserModel = friendCircleUserModel;
            [self.navigationController pushViewController:friendCirclePersonStatusViewController animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)connectionDetailTableFooterView:(SLConnectionDetailTableFooterView *)tableFooterView didChangeFrame:(CGRect)frame{
    CGRect tableViewFrame = self.tableView.frame;
    tableViewFrame.size.height = frame.origin.y;
    self.tableView.frame = tableViewFrame;
}

- (void)connectionDetailTableFooterView:(SLConnectionDetailTableFooterView *)tableFooterView didClickButtonWithType:(SLConnectionDetailTableFooterViewButtonType)buttonType{
    [self.connectionMoreView hide];
    
    switch (buttonType) {
        case SLConnectionDetailTableFooterViewButtonTypeAddFriend:{
            if([UserInfo sharedInfo].userInfoIntegrity){
                SLFriendRequestValidateViewController *friendRequestValidateViewController = [[SLFriendRequestValidateViewController alloc] init];
                friendRequestValidateViewController.userID = self.userID;
                [self.navigationController pushViewController:friendRequestValidateViewController animated:YES];
            }else{
                RegisterController *registerController = [[RegisterController alloc] init];
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:registerController];
                [self presentViewController:navigationController animated:YES completion:nil];
            }
        }
            break;
        case SLConnectionDetailTableFooterViewButtonTypeCreateChat:{
            [self createChat];
        }
            break;
        case SLConnectionDetailTableFooterViewButtonTypeDeleteFriend:{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"确定删除该好友吗？" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消", @"删除", nil];
            [alertView show];
        }
            break;
        default:
            break;
    }
}

- (void)createChat{
    if(![UserInfo sharedInfo].userInfoIntegrity){
        RegisterController *registerController = [[RegisterController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:registerController];
        [self presentViewController:navigationController animated:YES completion:nil];
        return;
    }
    
    if(self.isFriend){
        SingleChatController *singleChatController = [[SingleChatController alloc] init];
        singleChatController.currentUserName = self.connectionDetailModel.connectionModel.userID;
        singleChatController.title = self.connectionDetailModel.connectionModel.displayName;
        [self.navigationController pushViewController:singleChatController animated:YES];
    }else{
        NSDictionary *parameters = @{@"srcID" : [UserInfo sharedInfo].userID,
                                     @"tarID" : self.connectionDetailModel.connectionModel.userID};
        __block typeof(self) bself = self;
        [SLConnectionHTTPHandler POSTAllowChatWithParameters:parameters success:^(BOOL isAllow, NSString *message) {
            if(isAllow){
                SingleChatController *singleChatController = [[SingleChatController alloc] init];
                singleChatController.currentUserName = bself.connectionDetailModel.connectionModel.userID;
                singleChatController.title = bself.connectionDetailModel.connectionModel.displayName;
                [bself.navigationController pushViewController:singleChatController animated:YES];
            }else{
                [MBProgressHUD showWithError:message];
            }
        } failure:^(NSString *errorMessage) {
            
        }];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        [MBProgressHUD showWithText:nil];
        [SLTaskHandler removeFriendWithUserID:self.connectionDetailModel.connectionModel.userID];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hide];
            [MBProgressHUD showWithSuccess:@"删除好友成功！" durationTimeInterval:1.0];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if(self.connectionDetailModel != nil){
        [self.connectionMoreView hide];
    }
}

@end
