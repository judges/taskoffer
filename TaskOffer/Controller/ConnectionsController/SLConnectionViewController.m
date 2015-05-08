//
//  SLConnectionViewController.m
//  TaskOffer
//
//  Created by wshaolin on 15/3/19.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

// 人脉
#import "SLConnectionViewController.h"
#import "SLRootTableView.h"
#import "SLConnectionFrameModel.h"
#import "SLConnectionTableViewCell.h"
#import "SLConnectionDetailViewController.h"
#import "SLConnectionMoreView.h"
#import "ProjectPublishController.h"
#import "SLConnectionHTTPHandler.h"
#import "MJRefresh.h"

// 动态
#import "SLFriendCircleTableHeaderView.h"
#import "UIBarButtonItem+Image.h"
#import "SLFriendCircleStatusFrameModel.h"
#import "SLFriendCircleStatusCommentFrameModel.h"
#import "SLFriendCircleTableSectionHeaderView.h"
#import "SLFriendCircleTableSectionFooterView.h"
#import "SLFriendCircleTableViewCell.h"
#import "UIScrollView+TouchEvent.h"
#import "ZYQAssetPickerController.h"
#import "SLFriendCircleSendStatusViewController.h"
#import "SLFriendCirclePersonStatusViewController.h"
#import "SLKeyboardInputView.h"
#import "NSDate+Conveniently.h"
#import "SLFriendCircleConstant.h"
#import "SLDynamicHTTPHandler.h"
#import "SLFriendCircleTableViewApplaudCell.h"
#import "NSArray+String.h"
#import "NSString+Conveniently.h"
#import "SLFriendCircleFont.h"
#import "SLFriendCircleMessageModel.h"
#import "NSDictionary+NullFilter.h"
#import "SLFriendCircleMessageViewController.h"
#import "MBProgressHUD+Conveniently.h"

#import "SLHTTPServerHandler.h"
#import "UIImageView+SetImage.h"
#import "SLActionSheet.h"
#import "RegisterController.h"

@interface SLConnectionViewController ()<
            UITableViewDataSource,
            UITableViewDelegate,
            UIImagePickerControllerDelegate,
            UINavigationControllerDelegate,
            SLConnectionMoreViewDelegate,
            SLFriendCircleTableHeaderViewDelegate,
            SLFriendCircleTableSectionHeaderViewDelegate,
            ZYQAssetPickerControllerDelegate,
            SLFriendCircleSendStatusViewControllerDelegate,
            SLFriendCircleTableViewCellDelegate,
            SLKeyboardInputViewDelegate,
            SLActionSheetDelegate
>

@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) SLRootTableView *connectionTableView;
@property (nonatomic, strong) SLRootTableView *dynamicTableView;

@property (nonatomic, strong) NSMutableArray *connectionArray;
@property (nonatomic, strong) NSMutableArray *dynamicArray;
@property (nonatomic, strong) SLConnectionMoreView *connectionMoreView;
@property (nonatomic, assign) NSInteger currentConnectionPage;
@property (nonatomic, assign) NSInteger currentDynamicPage;
@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) SLKeyboardInputView *keyboardInputView;
@property (nonatomic, assign) NSInteger currentClickCommentSection;
@property (nonatomic, assign, getter = isNeedRefreshData) BOOL needRefreshData;
@property (nonatomic, strong) NSDictionary *replyInfo;
@property (nonatomic, strong) SLFriendCircleTableHeaderView *tableHeaderView;

@property (nonatomic, assign, getter = isChangeDynamicPrivacy) BOOL changeDynamicPrivacy;

@end

@implementation SLConnectionViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tableHeaderView.nickName = [UserInfo sharedInfo].userName;
    NSString *iconURL = SLHTTPServerImageURL([UserInfo sharedInfo].userHeadPicture, SLHTTPServerImageKindUserAvatar);
    [self.tableHeaderView.iconView setImageWithURL:iconURL placeholderImage:kUserDefaultIcon];
    
    if(self.isChangeDynamicPrivacy && self.selectedIndex == 1){
        [self.dynamicTableView headerBeginRefreshing];
        self.changeDynamicPrivacy = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.keyboardInputView hide];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(didClickAddBarButtonItem:)];
    // self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(didClickSearchBarButtonItem:)];
    self.navigationItem.titleView = self.segmentedControl;
    
    [self.view addSubview:self.connectionTableView];
    [self.view addSubview:self.dynamicTableView];
    
    self.selectedIndex = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveFriendCircleStatusImageDidClickNotification:) name:kSLFriendCircleStatusImageDidClickNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveFriendCircleStatusDeleteCompletedNotification:) name:kSLFriendCircleStatusDeleteCompletedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceivePrivacyDynamicChangeNotification:) name:kSLPrivacyDynamicChangeNotification object:nil];
}

#pragma mark - 初始化子控件

- (SLKeyboardInputView *)keyboardInputView{
    if(_keyboardInputView == nil){
        _keyboardInputView = [[SLKeyboardInputView alloc] init];
        _keyboardInputView.delegate = self;
        _keyboardInputView.maxEnableCount = 250.0;
    }
    return _keyboardInputView;
}

- (SLFriendCircleTableHeaderView *)tableHeaderView{
    if(_tableHeaderView == nil){
        _tableHeaderView = [[SLFriendCircleTableHeaderView alloc] initWithFrame:self.view.bounds isNeedMessageButton:NO];
        _tableHeaderView.delegate = self;
    }
    return _tableHeaderView;
}

- (UISegmentedControl *)segmentedControl{
    if(_segmentedControl == nil){
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"人脉", @"动态"]];
        _segmentedControl.frame = CGRectMake(0, 0, 180.0, 30.0);
        _segmentedControl.selectedSegmentIndex = 0;
        [_segmentedControl addTarget:self action:@selector(didChangedSelectedIndexWithSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}

- (SLRootTableView *)connectionTableView{
    if(_connectionTableView == nil){
        _connectionTableView = [[SLRootTableView alloc] initWithDefaultFrameDataSource:self delegate:self];
        
        __block typeof(self) bself = self;
        [_connectionTableView addHeaderWithCallback:^{
            [bself loadNewConnectionData];
        }];
        
        [_connectionTableView addFooterWithCallback:^{
            [bself loadMoreConnectionData];
        }];
    }
    return _connectionTableView;
}

- (SLRootTableView *)dynamicTableView{
    if(_dynamicTableView == nil){
        _dynamicTableView = [[SLRootTableView alloc] initWithDefaultFrameStyle:UITableViewStyleGrouped dataSource:self delegate:self];
        //_dynamicTableView.tableHeaderView = self.tableHeaderView;
        _dynamicTableView.contentInset = UIEdgeInsetsMake(64.0, 0.0, 49.0, 0);
        
        __block typeof(self) bself = self;
        [_dynamicTableView addHeaderWithCallback:^{
            [bself loadNewDynamicData];
        }];
        
        [_dynamicTableView addFooterWithCallback:^{
            [bself loadMoreDynamicData];
        }];
    }
    return _dynamicTableView;
}

- (SLConnectionMoreView *)connectionMoreView{
    if(_connectionMoreView == nil){
        _connectionMoreView = [[SLConnectionMoreView alloc] initWithFrame:CGRectMake(0, 64.0, 0, 0) buttonItemTitles:@[@"发动态", @"发项目"]];
        _connectionMoreView.delegate = self;
    }
    return _connectionMoreView;
}

- (NSMutableArray *)connectionArray{
    if(_connectionArray == nil){
        _connectionArray = [NSMutableArray array];
    }
    return _connectionArray;
}

- (NSMutableArray *)dynamicArray{
    if(_dynamicArray == nil){
        _dynamicArray = [NSMutableArray array];
    }
    return _dynamicArray;
}

#pragma mark - selectedIndex

- (void)setSelectedIndex:(NSInteger)selectedIndex{
    _selectedIndex = selectedIndex;
    
    self.dynamicTableView.hidden = selectedIndex != 1;
    self.connectionTableView.hidden = selectedIndex == 1;
    
    if(selectedIndex == 1 && (self.dynamicArray.count == 0 || self.isChangeDynamicPrivacy)){
        [self.dynamicTableView headerBeginRefreshing];
        self.changeDynamicPrivacy = NO;
    }else if(selectedIndex != 1 && self.connectionArray.count == 0){
        [self.connectionTableView headerBeginRefreshing];
    }
    
    if(selectedIndex == 0){
        self.navigationItem.rightBarButtonItem = nil;
    }else{
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"connection_send_dynamic" target:self action:@selector(didClickAddBarButtonItem:)];
    }
}

#pragma mark - 加载数据

- (void)loadNewConnectionData{
    self.currentConnectionPage = 1;
    [self loadConnectionData];
}

- (void)loadMoreConnectionData{
    self.currentConnectionPage ++;
    if(self.currentConnectionPage < 1){
        self.currentConnectionPage = 1;
    }
    [self loadConnectionData];
}

- (void)loadNewDynamicData{
    self.currentDynamicPage = 1;
    [self loadDynamicData];
}

- (void)loadMoreDynamicData{
    self.currentDynamicPage ++;
    if(self.currentDynamicPage < 1){
        self.currentDynamicPage = 1;
    }
    [self loadDynamicData];
}

- (void)loadConnectionData{
    __block typeof(self) bself = self;
    [SLConnectionHTTPHandler POSTConnectionListWithParameters:@{@"page" : @(self.currentConnectionPage), @"rows" : @(SLConnectionHTTPHandlerRequestPageSize)} success:^(NSArray *dataArray) {
        if(bself.currentConnectionPage == 1){
            [bself.connectionArray removeAllObjects];
        }
        [bself.connectionArray addObjectsFromArray:dataArray];
        [bself.connectionTableView reloadData];
        
        [bself.connectionTableView headerEndRefreshing];
        [bself.connectionTableView footerEndRefreshing];
    } failure:^(NSString *errorMessage) {
        bself.currentConnectionPage --;
        [bself.connectionTableView headerEndRefreshing];
        [bself.connectionTableView footerEndRefreshing];
    }];
}

- (void)loadDynamicData{
    __block typeof(self) bself = self;
    
    NSString *privacyFilePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:(@"private.plist")];
    NSDictionary *privacyDictionary = [NSDictionary dictionaryWithContentsOfFile:privacyFilePath];
    NSDictionary *parameters = @{@"username" : [UserInfo sharedInfo].userID,
                                 @"type" : @(![privacyDictionary boolForKey:@"isAlldynamic"]),
                                 @"pageSize" : @(SLDynamicHTTPHandlerRequestPageSize),
                                 @"pageNum" : @(self.currentDynamicPage)};
    
    [SLDynamicHTTPHandler POSTFriendCircleAllMessageListWithParameters:parameters showProgressInView:self.view success:^(NSArray *dataArray) {
        if(bself.currentDynamicPage == 1){
            [bself.dynamicArray removeAllObjects];
        }
        [bself.dynamicArray addObjectsFromArray:dataArray];
        [bself.dynamicTableView reloadData];
        [bself.dynamicTableView headerEndRefreshing];
        [bself.dynamicTableView footerEndRefreshing];
    } failure:^(NSString *errorMessage) {
        bself.currentDynamicPage --;
        [bself.dynamicTableView headerEndRefreshing];
        [bself.dynamicTableView footerEndRefreshing];
    }];
}

#pragma mark - tableView的数据源

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(tableView == self.dynamicTableView){
        return self.dynamicArray.count;
    }
    return self.connectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == self.dynamicTableView){
        SLFriendCircleStatusFrameModel *friendCircleStatusFrameModel = self.dynamicArray[section];
        NSInteger rows = friendCircleStatusFrameModel.friendCircleStatusModel.commentArray.count;
        if(friendCircleStatusFrameModel.friendCircleStatusModel.applaudCount > 0){
            rows ++;
        }
        return rows;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.dynamicTableView){
        SLFriendCircleStatusFrameModel *friendCircleStatusFrameModel = self.dynamicArray[indexPath.section];
        NSInteger indexRow = indexPath.row;
        // 如果有赞，则第一个cell显示点赞的人
        if(friendCircleStatusFrameModel.friendCircleStatusModel.applaudCount > 0 && indexRow == 0){
            SLFriendCircleTableViewApplaudCell *cell = [SLFriendCircleTableViewApplaudCell cellWithTableView:tableView];
            cell.applaudAttributedString = friendCircleStatusFrameModel.friendCircleStatusModel.applaudNicknameString;
            // 如果没有评论，则隐藏点赞与评论直接的分割线
            cell.hideButtomLine = friendCircleStatusFrameModel.friendCircleStatusModel.commtentCount == 0;
            return cell;
        }
        
        // 之后的cell显示评论和回复内容
        SLFriendCircleTableViewCell *cell = [SLFriendCircleTableViewCell cellWithTableView:tableView];
        cell.indexPath = indexPath;
        if(friendCircleStatusFrameModel.friendCircleStatusModel.applaudCount > 0){
            // 如果有赞，indexRow --，保证从0开始
            indexRow --;
        }
        
        cell.friendCircleStatusCommentFrameModel = friendCircleStatusFrameModel.friendCircleStatusModel.commentArray[indexRow];
        cell.delegate = self;
        return cell;
    }
    
    SLConnectionTableViewCell *cell = [SLConnectionTableViewCell cellWithTableView:tableView];
    cell.connectionFrameModel = self.connectionArray[indexPath.section];
    return cell;
}

#pragma mark - tableView的代理

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(tableView == self.dynamicTableView){
        SLFriendCircleTableSectionHeaderView *sectionHeaderView = [SLFriendCircleTableSectionHeaderView sectionHeaderViewWithTableView:tableView];
        sectionHeaderView.delegate = self;
        sectionHeaderView.showTopLine = section > 0;
        sectionHeaderView.section = section;
        SLFriendCircleStatusFrameModel *friendCircleStatusFrameModel = self.dynamicArray[section];
        sectionHeaderView.friendCircleStatusFrameModel = friendCircleStatusFrameModel;
        return sectionHeaderView;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(tableView == self.dynamicTableView){
        return [SLFriendCircleTableSectionFooterView sectionFoooterViewWithTableView:tableView];
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(tableView == self.dynamicTableView){
        SLFriendCircleStatusFrameModel *friendCircleStatusFrameModel = self.dynamicArray[section];
        return friendCircleStatusFrameModel.statusSectionHeight;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.dynamicTableView){
        SLFriendCircleStatusFrameModel *friendCircleStatusFrameModel = self.dynamicArray[indexPath.section];
        NSInteger indexRow = indexPath.row;
        BOOL hasApplaud = friendCircleStatusFrameModel.friendCircleStatusModel.applaudCount > 0;
        if(hasApplaud && indexRow == 0){
            // 计算点赞人字符串所占的高度，末尾加10用于分割文字的上下间距
            CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width - 80.0;
            return [friendCircleStatusFrameModel.friendCircleStatusModel.applaudNicknameString.string emojiSizDefaultLineSpacingeWithFont:SLFriendCircleApplaudShowContentFont maximumWidth:maxWidth].height + 10.0;
        }
        
        if(hasApplaud > 0){
            indexRow --;
        }
        
        SLFriendCircleStatusCommentFrameModel *friendCircleStatusCommentFrameModel = friendCircleStatusFrameModel.friendCircleStatusModel.commentArray[indexRow];
        CGFloat height = friendCircleStatusCommentFrameModel.statusCommentCellHeight;
        if(hasApplaud && indexRow == friendCircleStatusFrameModel.friendCircleStatusModel.commtentCount - 1){
            height += 5.0;
        }
        return height;
    }
    
    SLConnectionFrameModel *connectionFrameModel = self.connectionArray[indexPath.section];
    return connectionFrameModel.cellRowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(tableView == self.dynamicTableView){
        SLFriendCircleStatusFrameModel *friendCircleStatusFrameModel = self.dynamicArray[section];
        // 如果有赞或者评论，Footer高度为10.0，用于分割两条两天动态
        if(friendCircleStatusFrameModel.friendCircleStatusModel.applaudCount > 0 || friendCircleStatusFrameModel.friendCircleStatusModel.commtentCount > 0){
            return 10.0;
        }
        // 如果有赞或者评论，Footer高度为5.0，因为section的高度多了5.0，加起来刚好是10.0
        return 5.0;
    }
    
    if(section == self.connectionArray.count - 1){
        return 0.01;
    }
    return 5.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 人脉允许点击，动态不允许点击
    if(tableView == self.connectionTableView){
        SLConnectionFrameModel *connectionFrameModel = self.connectionArray[indexPath.section];
        SLConnectionDetailViewController *connectionDetailViewController = [[SLConnectionDetailViewController alloc] init];
        connectionDetailViewController.userID = connectionFrameModel.connectionModel.userID;
        connectionDetailViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:connectionDetailViewController animated:YES];
    }
}

- (void)didClickAddBarButtonItem:(UIBarButtonItem *)barButtonItem{
    [self.keyboardInputView hide];
    if([UserInfo sharedInfo].userInfoIntegrity){
        SLFriendCircleSendStatusViewController *friendCircleSendStatusViewController = [[SLFriendCircleSendStatusViewController alloc] init];
        friendCircleSendStatusViewController.delegate = self;
        friendCircleSendStatusViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:friendCircleSendStatusViewController animated:YES];
    }else{
        RegisterController *registerController = [[RegisterController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:registerController];
        [self presentViewController:navigationController animated:YES completion:nil];
    }
}

- (void)didClickSearchBarButtonItem:(UIBarButtonItem *)barButtonItem{
    [self.connectionMoreView hide];
    [self.keyboardInputView hide];
}

- (void)didChangedSelectedIndexWithSegmentedControl:(UISegmentedControl *)segmentedControl{
    [self.connectionMoreView hide];
    [self.keyboardInputView hide];
    self.selectedIndex = segmentedControl.selectedSegmentIndex;
}

- (void)connectionMoreView:(SLConnectionMoreView *)connectionMoreView didClickButtonItemAtIndex:(NSInteger)buttonItemIndex{
    if(buttonItemIndex == 1){
        ProjectPublishController *projectPublishController = [[ProjectPublishController alloc] init];
        projectPublishController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:projectPublishController animated:YES];
    }else{
        SLFriendCircleSendStatusViewController *friendCircleSendStatusViewController = [[SLFriendCircleSendStatusViewController alloc] init];
        friendCircleSendStatusViewController.delegate = self;
        friendCircleSendStatusViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:friendCircleSendStatusViewController animated:YES];
        
        // SLActionSheet *actionSheet = [[SLActionSheet alloc] initWithOtherButtonTitles:@"从手机相册选择", @"拍照", nil];
        // actionSheet.delegate = self;
        // [actionSheet show];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.connectionMoreView hide];
    [self.keyboardInputView hide];
}

- (void)actionSheet:(SLActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{ // 从手机相册选择
            [self openPhotoAlbum];
            break;
        }
        case 1:{ // 拍照
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                [self imagePickerControllerWithSourceType:UIImagePickerControllerSourceTypeCamera];
            }
            break;
        }
        default:
            break;
    }
}

- (void)imagePickerControllerWithSourceType:(UIImagePickerControllerSourceType)sourceType{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.editing = YES;
    imagePickerController.allowsEditing = YES;
    imagePickerController.delegate = self;
    imagePickerController.sourceType = sourceType;
    self.imagePickerController = imagePickerController;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)dictionary{
    UIImage *image = dictionary[UIImagePickerControllerEditedImage];
    // 保持图片到相册
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    ZYQAssetPickerController *assetPickerController = [[ZYQAssetPickerController alloc] init];
    assetPickerController.maximumNumberOfSelection = SLFriendCircleSendStatusWithImageCount - 1;
    assetPickerController.assetsFilter = [ALAssetsFilter allPhotos];
    assetPickerController.showEmptyGroups = NO;
    
    SLFriendCircleSendStatusViewController *friendCircleSendStatusViewController = [[SLFriendCircleSendStatusViewController alloc] init];
    friendCircleSendStatusViewController.delegate = self;
    friendCircleSendStatusViewController.takeImages = @[image];
    friendCircleSendStatusViewController.assetPickerController = assetPickerController;
    friendCircleSendStatusViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:friendCircleSendStatusViewController animated:YES];
}

- (void)openPhotoAlbum{
    ZYQAssetPickerController *assetPickerController = [[ZYQAssetPickerController alloc] init];
    assetPickerController.maximumNumberOfSelection = SLFriendCircleSendStatusWithImageCount;
    assetPickerController.assetsFilter = [ALAssetsFilter allPhotos];
    assetPickerController.showEmptyGroups = NO;
    assetPickerController.delegate = self;
    [self presentViewController:assetPickerController animated:YES completion:nil];
}

- (void)assetPickerControllerDidMaximum:(ZYQAssetPickerController *)assetPickerController{
    UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"您最多只能选择%ld张照片", (long)assetPickerController.maximumNumberOfSelection] delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)assetPickerController:(ZYQAssetPickerController *)assetPickerController didFinishPickingAssets:(NSArray *)assets{
    SLFriendCircleSendStatusViewController *friendCircleSendStatusViewController = [[SLFriendCircleSendStatusViewController alloc] init];
    friendCircleSendStatusViewController.assets = assets;
    friendCircleSendStatusViewController.assetPickerController = assetPickerController;
    friendCircleSendStatusViewController.hidesBottomBarWhenPushed = YES;
    friendCircleSendStatusViewController.delegate = self;
    [self.navigationController pushViewController:friendCircleSendStatusViewController animated:YES];
}

- (void)friendCircleTableSectionHeaderView:(SLFriendCircleTableSectionHeaderView *)friendCircleTableSectionHeaderView didTapIconForSection:(NSInteger)section{
    SLFriendCircleStatusFrameModel *friendCircleStatusFrameModel = self.dynamicArray[section];
    [self openPersonStatusViewController:friendCircleStatusFrameModel.friendCircleStatusModel.userModel];
}

- (void)friendCircleTableSectionHeaderView:(SLFriendCircleTableSectionHeaderView *)friendCircleTableSectionHeaderView didTapDisplayNameForSection:(NSInteger)section{
    SLFriendCircleStatusFrameModel *friendCircleStatusFrameModel = self.dynamicArray[section];
    [self openPersonStatusViewController:friendCircleStatusFrameModel.friendCircleStatusModel.userModel];
}

#pragma mark - 点赞或者取消赞

- (void)friendCircleTableSectionHeaderView:(SLFriendCircleTableSectionHeaderView *)friendCircleTableSectionHeaderView didTapApplaudForSection:(NSInteger)section isCancel:(BOOL)cancel{
    [self.keyboardInputView hide];
    if(![UserInfo sharedInfo].userInfoIntegrity){
        RegisterController *registerController = [[RegisterController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:registerController];
        [self presentViewController:navigationController animated:YES completion:nil];
        return;
    }
    
    __block SLFriendCircleStatusFrameModel *statusFrameModel = self.dynamicArray[section];
    NSString *currentUsername = [UserInfo sharedInfo].userID;
    NSString *currentDisplayName = [UserInfo sharedInfo].userName;
    
    if(currentUsername == nil || currentDisplayName == nil){
        return;
    }
    
    NSDictionary *parameters = @{@"username" : currentUsername,
                                 @"infoId" : statusFrameModel.friendCircleStatusModel.statusId};
    
    NSMutableArray *tempNicknameArray = [NSMutableArray arrayWithArray:statusFrameModel.friendCircleStatusModel.applaudNicknameArray];
    NSMutableArray *tempUsernameArray = [NSMutableArray arrayWithArray:statusFrameModel.friendCircleStatusModel.applaudUsernameArray];
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
    statusFrameModel.friendCircleStatusModel.applaudNicknameArray = [tempNicknameArray copy];
    statusFrameModel.friendCircleStatusModel.applaudUsernameArray = [tempUsernameArray copy];
    
    // 重新计算frame
    [statusFrameModel recalculateFrame];
    
    // 刷新一个section
    [self.dynamicTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
    
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
        statusFrameModel.friendCircleStatusModel.applaudNicknameArray = [tempNicknameArray copy];
        statusFrameModel.friendCircleStatusModel.applaudUsernameArray = [tempUsernameArray copy];
        
        [statusFrameModel recalculateFrame];
        
        [bself.dynamicTableView reloadSections:[[NSIndexSet alloc] initWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
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
    self.currentClickCommentSection = section;
    
    [self.keyboardInputView show];
}

#pragma mark - 点击用户的头像

- (void)friendCircleTableHeaderViewIconTap:(SLFriendCircleTableHeaderView *)friendCircleTableHeaderView{
    NSString *iconURL = SLHTTPServerImageURL([UserInfo sharedInfo].userHeadPicture, SLHTTPServerImageKindUserAvatar);
    SLFriendCircleUserModel *userModel = [[SLFriendCircleUserModel alloc] initWithUsername:[UserInfo sharedInfo].userID displayName:[UserInfo sharedInfo].userName iconURL:iconURL];
    [self openPersonStatusViewController:userModel];
}

- (void)friendCircleTableHeaderViewMessageButtonTap:(SLFriendCircleTableHeaderView *)friendCircleTableHeaderView{
    [self.keyboardInputView hide];
    self.tabBarItem.badgeValue = nil;
    SLFriendCircleMessageViewController *friendCircleMessageViewController = [[SLFriendCircleMessageViewController alloc] init];
    friendCircleMessageViewController.hidesBottomBarWhenPushed = YES;
    friendCircleMessageViewController.loadUnreadMessage = YES;
    [self.navigationController pushViewController:friendCircleMessageViewController animated:YES];
}

- (void)friendCircleTableViewCell:(SLFriendCircleTableViewCell *)friendCircleTableViewCell didTapfriendCircleCommentUser:(SLFriendCircleUserModel *)friendCircleUserModel{
    [self openPersonStatusViewController:friendCircleUserModel];
}

#pragma -mark 评论和回复（点击）

- (void)friendCircleTableViewCell:(SLFriendCircleTableViewCell *)friendCircleTableViewCell didTapfriendCircleComment:(NSString *)commentId withFriendCircleReplyUser:(SLFriendCircleUserModel *)friendCircleUserModel{
    if(![UserInfo sharedInfo].userInfoIntegrity){
        RegisterController *registerController = [[RegisterController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:registerController];
        [self presentViewController:navigationController animated:YES completion:nil];
        return;
    }
    
    self.currentClickCommentSection = friendCircleTableViewCell.indexPath.section;
    self.keyboardInputView.placeholder = [NSString stringWithFormat:@"回复%@：", friendCircleUserModel.displayName];
    self.replyInfo = @{@"commentid" : commentId,
                       @"username" : friendCircleUserModel.username,
                       @"displayname" : friendCircleUserModel.displayName};
    [self.keyboardInputView show];
}

- (void)openPersonStatusViewController:(SLFriendCircleUserModel *)friendCircleUserModel{
    [self.keyboardInputView hide];
    SLFriendCirclePersonStatusViewController *friendCirclePersonStatusViewController = [[SLFriendCirclePersonStatusViewController alloc] init];
    friendCirclePersonStatusViewController.hidesBottomBarWhenPushed = YES;
    friendCirclePersonStatusViewController.friendCircleUserModel = friendCircleUserModel;
    [self.navigationController pushViewController:friendCirclePersonStatusViewController animated:YES];
}

#pragma -mark 发布动态成功的回调

- (void)friendCircleSendStatusViewControllerSendMessageCompleted:(SLFriendCircleSendStatusViewController *)friendCircleSendStatusViewController{
    self.segmentedControl.selectedSegmentIndex = 1;
    self.selectedIndex = self.segmentedControl.selectedSegmentIndex;
    [self.dynamicTableView headerBeginRefreshing];
}

#pragma -mark 评论和回复（调接口）

- (void)keyboardInputView:(SLKeyboardInputView *)keyboardInputView didClickSendButton:(NSString *)snedText{
    __block SLFriendCircleStatusFrameModel *statusFrameModel = self.dynamicArray[self.currentClickCommentSection];
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
                                 @"infoId" : statusFrameModel.friendCircleStatusModel.statusId,
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
                                        @"infoId" : statusFrameModel.friendCircleStatusModel.statusId,
                                        @"createTime" : [[NSDate date] defaultFormat]};
    // 构造一条评论
    SLFriendCircleStatusCommentModel *statusCommentModel = [[SLFriendCircleStatusCommentModel alloc] initWithDictionary:commentDictionary];
    SLFriendCircleStatusCommentFrameModel *statusCommentFrameModel = [[SLFriendCircleStatusCommentFrameModel alloc] initWithFriendCircleStatusCommentModel:statusCommentModel];
    NSMutableArray *tempCommentArray = [NSMutableArray arrayWithArray:statusFrameModel.friendCircleStatusModel.commentArray];
    [tempCommentArray addObject:statusCommentFrameModel];
    statusFrameModel.friendCircleStatusModel.commentArray = [tempCommentArray copy];
    
    // 重新计算子控件的大小
    [statusFrameModel recalculateFrame];
    
    [self.dynamicTableView reloadSections:[NSIndexSet indexSetWithIndex:self.currentClickCommentSection] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    __block typeof(self) bself = self;
    [SLDynamicHTTPHandler POSTFriendCircleCommentWithParameters:parameters showProgressInView:nil success:^(SLFriendCircleStatusCommentModel *statusCommentModel) {
        
        SLFriendCircleStatusCommentFrameModel *statusCommentFrameModel = [statusFrameModel.friendCircleStatusModel.commentArray lastObject];
        [statusCommentFrameModel.friendCircleStatusCommentModel setCommentId:statusCommentModel.commentId];
        [bself.dynamicTableView reloadSections:[NSIndexSet indexSetWithIndex:bself.currentClickCommentSection] withRowAnimation:UITableViewRowAnimationAutomatic];
        
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

- (void)didReceiveFriendCircleStatusImageDidClickNotification:(NSNotification *)notification{
    [self.keyboardInputView hide];
}

- (void)didReceiveFriendCircleStatusDeleteCompletedNotification:(NSNotification *)notification{
    NSString *statusID = (NSString *)notification.object;
    if(statusID != nil && statusID.length > 0){
        for(SLFriendCircleStatusFrameModel *friendCircleStatusFrameModel in self.dynamicArray){
            if([friendCircleStatusFrameModel.friendCircleStatusModel.statusId isEqualToString:statusID]){
                [self.dynamicArray removeObject:friendCircleStatusFrameModel];
                break;
            }
        }
        
        if(self.selectedIndex == 1){
            [self.dynamicTableView reloadData];
        }
    }
}

- (void)didReceivePrivacyDynamicChangeNotification:(NSNotification *)notification{
    self.changeDynamicPrivacy = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.keyboardInputView hide];
}

@end
