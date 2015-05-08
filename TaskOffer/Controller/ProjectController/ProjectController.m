//
//  ProjectController.m
//  TaskOffer
//
//  Created by BourbonZ on 15/3/12.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "ProjectController.h"
#import "HexColor.h"
#import "ProjectViewCell.h"
#import "EnterpriseCell.h"
#import "RegisterController.h"
#import "ProjectInfoController.h"
#import "EnterpriseInfoController.h"
#import "TOHttpHelper.h"
#import "SLConnectionMoreView.h"
#import "ProjectPublishController.h"
#import "MJRefresh.h"
#import "RegisterController.h"
#import "UIImageView+WebCache.h"
#import "SLFriendCircleSendStatusViewController.h"
#import "ZYQAssetPickerController.h"
#import "SLActionSheet.h"

@interface ProjectController ()<
            UITableViewDataSource,
            UITableViewDelegate,
            SLConnectionMoreViewDelegate,
            UIAlertViewDelegate,
            ProjectPublishControllerDelegate,
            SLActionSheetDelegate,
            UIImagePickerControllerDelegate,
            UINavigationControllerDelegate,
            ZYQAssetPickerControllerDelegate
            >{
    UISegmentedControl *categorySegment;
    NSMutableArray *projectArray;
    NSMutableArray *enterpriseArray;
    NSMutableArray *totalArray;
    ///控制上方按钮的切换
    BOOL tableControl;
    NSInteger pageNum;
    
    SLConnectionMoreView *moreView;
}

@property (nonatomic, strong) UIImagePickerController *imagePickerController;

@end

@implementation ProjectController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.navigationController.navigationBar addSubview:categorySegment];
    
//    BOOL rity = [[UserInfo sharedInfo] userInfoIntegrity];
//    NSString *userID = [[UserInfo sharedInfo] userID];
//    if (!rity && userID.length > 0)
//    {
//        RegisterController *registerController = [[RegisterController alloc] init];
//        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:registerController];
//        [self presentViewController:navi animated:YES completion:nil];
//    }

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    ///上方的分割按钮
    categorySegment = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"项目",@"企业号", nil]];
    [categorySegment setBounds:CGRectMake(0, 0, 180, 30)];
    [categorySegment setCenter:CGPointMake(self.view.frame.size.width/2, self.navigationController.navigationBar.frame.size.height/2)];
    [categorySegment setTintColor:[UIColor whiteColor]];
    [categorySegment addTarget:self action:@selector(clickUISegmentButton:) forControlEvents:(UIControlEventValueChanged)];
    [categorySegment setSelectedSegmentIndex:0];

    ///设置导航栏上方的按钮
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemSearch) target:self action:@selector(clickSearchButton)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemAdd) target:self action:@selector(clickAddButton)];
    
    ///设置表格
    UITableView *table = [[UITableView alloc] initWithFrame:self.view.frame style:(UITableViewStylePlain)];
    [table setDataSource:self];
    [table setDelegate:self];
//    [table setBackgroundColor:[UIColor colorWithHexString:kDefaultBackColor]];
    [table setBackgroundColor:[UIColor colorWithHexString:@"efefef"]];
    table.tableFooterView = [[UIView alloc] init];
    table.tag = 9001;
    [self.view addSubview:table];
    
    ///设置下拉刷新，上拉加载
    [table addHeaderWithTarget:self action:@selector(headerRereshing)];
    [table addFooterWithTarget:self action:@selector(footerRereshing)];
    
    ///数据
    projectArray    = [NSMutableArray array];
    enterpriseArray = [NSMutableArray array];
    ///控制显示的界面
    tableControl = YES;

    ///更多按钮
    moreView = [[SLConnectionMoreView alloc] initWithFrame:CGRectMake(0, 64, 0, 0) buttonItemTitles:@[@"发动态",@"发项目"]];
    [moreView setDelegate:self];
    
    ///刷新数据
    pageNum = 1;
    [self reloadDataTableWithStart:pageNum page:10];
    
    ///版本检查
//    [self checkVersion];

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [categorySegment removeFromSuperview];
    [moreView hide];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)checkVersion
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"1" forKey:@"terminalOsType"];
    [dict setObject:@"0" forKey:@"terminalPort"];
    
    [TOHttpHelper postUrl:kTOgetVersionByPortAndType parameters:dict showHUD:YES success:^(NSDictionary *dataDictionary) {
        
        NSString *version = [[[dataDictionary objectForKey:@"info"] objectForKey:@"version"] substringFromIndex:1];
        
        NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
        NSString *nowVersion = [infoDict objectForKey:@"CFBundleVersion"];
        if (version.floatValue != nowVersion.floatValue)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请更新至最新版" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alert.tag = 8000;
            [alert show];
   
        }
        
    } failure:^(NSError *error) {
        
    }];

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark 下拉刷新
-(void)headerRereshing
{
    [self reloadDataTableWithStart:1 page:10];
    UITableView *table = (UITableView *)[self.view viewWithTag:9001];
    [table headerEndRefreshing];
}
#pragma mark 上提加载更多
-(void)footerRereshing
{
    pageNum = pageNum + 1;
    [self reloadDataTableWithStart:pageNum page:10];
    UITableView *table = (UITableView *)[self.view viewWithTag:9001];
    [table footerEndRefreshing];
}
#pragma mark UISegmentButton
-(void)clickUISegmentButton:(UISegmentedControl *)button
{
    tableControl = tableControl == YES ? NO : YES;
    [moreView hide];
    if (button.selectedSegmentIndex == 0)
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemAdd) target:self action:@selector(clickAddButton)];
    }
    else
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
    ///刷新数据
    [self reloadDataTableWithStart:1 page:10];
}
#pragma mark 搜索按钮
-(void)clickSearchButton
{

}
#pragma mark 添加按钮
-(void)clickAddButton
{
    if ([[UserInfo sharedInfo] userInfoIntegrity])
    {
//        [moreView showInView:self.view];
        ProjectPublishController *publish = [[ProjectPublishController alloc] init];
        [publish setDelegate:self];
        publish.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:publish animated:YES];

    }
    else
    {
        RegisterController *registerController = [[RegisterController alloc] init];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:registerController];
        [self presentViewController:navi animated:YES completion:nil];
    }
}
#pragma mark UITableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableControl)
    {
        return projectArray.count;
    }
    return totalArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 135;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        return 0.01;
    }
    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableControl)
    {
        static NSString *cellID = @"cell1";
        ProjectViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil)
        {
            cell = [[ProjectViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellID];
        }
        ProjectInfo *info = [[ProjectInfo alloc] init];
        if (projectArray.count == 0)
        {
            return cell;
        }
        NSDictionary *dict = [projectArray objectAtIndex:indexPath.section];
        if (dict != nil)
        {
            [info setProjectDict:dict];
            cell.info = info;
        }
        
        ///0是企业号发布，1是个人发布
        if (info.projectType.intValue == 0)
        {
            NSString *icon = [NSString stringWithFormat:@"%@%@/%@",kTOHOSt,kTOCompanyPicPath,info.projectIcon];
            [cell.projectIconView sd_setImageWithURL:[NSURL URLWithString:icon] placeholderImage:kDefaultIcon];
        }
        else
        {
            NSString *icon = [NSString stringWithFormat:@"%@%@/%@",kTOHOSt,kTOUploadUserIcon,info.projectIcon];
            [cell.projectIconView sd_setImageWithURL:[NSURL URLWithString:icon] placeholderImage:kDefaultIcon];
        }

        return cell;
    }
    else
    {
        static NSString *cellID = @"cell2";
        EnterpriseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil)
        {
            cell = [[EnterpriseCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellID];
        }
        EnterpriseInfo *info = [[EnterpriseInfo alloc] init];
        if (totalArray.count == 0)
        {
            return cell;
        }
        NSDictionary *dict = [totalArray objectAtIndex:indexPath.section];
        if (dict != nil)
        {
            [info setEnterpriseDict:dict];
            cell.info = info;
        }
        
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableControl)
    {
        ProjectInfoController *info = [[ProjectInfoController alloc] init];
        NSDictionary *dict = [projectArray objectAtIndex:indexPath.section];
        info.projectID = [dict objectForKey:@"id"];
        NSString *name = [dict objectForKey:@"projectPublishId"];
        if ([name isEqualToString:[[UserInfo sharedInfo] userID]])
        {
            info.ifMyProject = YES;
        }
        [info setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:info animated:YES];
    }
    else
    {
        EnterpriseInfoController *info = [[EnterpriseInfoController alloc] init];
        NSDictionary *dict = [totalArray objectAtIndex:indexPath.section];
        EnterpriseInfo *companyInfo = [[EnterpriseInfo alloc] init];
        [companyInfo setEnterpriseDict:dict];
        info.companyInfo = companyInfo;
        info.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:info animated:YES];
    }
}
#pragma mark SLConnectionMoreView Delegate
-(void)connectionMoreView:(SLConnectionMoreView *)connectionMoreView didClickButtonItemAtIndex:(NSInteger)buttonItemIndex
{
        
    if (buttonItemIndex == 0)
    {
        SLFriendCircleSendStatusViewController *friendCircleSendStatusViewController = [[SLFriendCircleSendStatusViewController alloc] init];
        friendCircleSendStatusViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:friendCircleSendStatusViewController animated:YES];
    
        // SLActionSheet *actionSheet = [[SLActionSheet alloc] initWithOtherButtonTitles:@"从手机相册选择", @"拍照", nil];
        // actionSheet.delegate = self;
        // [actionSheet show];
    }
    else
    {
        ProjectPublishController *publish = [[ProjectPublishController alloc] init];
        [publish setDelegate:self];
        publish.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:publish animated:YES];
    }
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
    [self.navigationController pushViewController:friendCircleSendStatusViewController animated:YES];
}

#pragma mark 刷新显示的界面
-(void)reloadDataTableWithStart:(NSInteger)start page:(NSInteger)page
{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)start] forKeyedSubscript:@"page"];
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)page] forKeyedSubscript:@"rows"];
    
    if (tableControl)
    {
        ///默认请求所有项目列表

        
        [TOHttpHelper postUrl:kTOAllProject parameters:dict showHUD:YES success:^(NSDictionary *dataDictionary) {
            
            NSArray *array = [[dataDictionary objectForKey:@"info"] objectForKey:@"rows"];
            if (array.count == 0)
            {
                if (start == 1)
                {
                    projectArray = [NSMutableArray array];
                    UITableView *tableView = (UITableView *)[self.view viewWithTag:9001];
                    [tableView reloadData];
                }
                [HUDView showHUDWithText:@"数据加载完毕"];
            }
            if (start == 1)
            {
                [projectArray removeAllObjects];
                projectArray = [array mutableCopy];
            }
            else
            {
                [projectArray addObjectsFromArray:array];
            }
            
            UITableView *tableView = (UITableView *)[self.view viewWithTag:9001];
            [tableView reloadData];
            
        } failure:^(NSError *error) {
            
            
            
        }];
    }
    else
    {
        ///企业号
  
        [TOHttpHelper postUrl:kTOAllCompanyList parameters:dict showHUD:YES success:^(NSDictionary *dataDictionary) {
            
            NSArray *array = [dataDictionary objectForKey:@"info"];
            if (array.count == 0)
            {
                if (start == 1)
                {
                    projectArray = [NSMutableArray array];
                    UITableView *tableView = (UITableView *)[self.view viewWithTag:9001];
                    [tableView reloadData];
                }

                [HUDView showHUDWithText:@"数据加载完毕"];

            }
            
            if (start == 1)
            {
                [totalArray removeAllObjects];
                totalArray = [array mutableCopy];
            }
            else
            {
                [totalArray addObjectsFromArray:array];
            }

            
            
            UITableView *tableView = (UITableView *)[self.view viewWithTag:9001];
            [tableView reloadData];
            
        } failure:^(NSError *error) {
            
        }];
    }
 
}
#pragma mark UIAlertView
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 8000)
    {
        NSString *appleID = @"414478124";
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8) {
            NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",appleID];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        } else {
            NSString *str = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", appleID];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }  

    }
}
#pragma mark 项目发布完成后刷新界面
-(void)projectPublishSuccess
{
    [self reloadDataTableWithStart:1 page:10];
}
@end
