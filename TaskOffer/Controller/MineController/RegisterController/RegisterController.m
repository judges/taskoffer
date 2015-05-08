//
//  RegisterController.m
//  TaskOffer
//
//  Created by BourbonZ on 15/3/18.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "RegisterController.h"
#import "TagsViewController.h"
#import "TOHttpHelper.h"
#import "ToToolHelper.h"
#import "ZYQAssetPickerController.h"
#import "ProjectTagView.h"
#import "UserInfo.h"
#import "UIBarButtonItem+Image.h"
#import "SetInfoViewController.h"
#import "SetSexInfoViewController.h"
#import "SLTagFrameModel.h"
#import "SLConnectionDetailTableViewTagCell.h"
#import "SLTagModel.h"
#import "SLSelectTagsViewController.h"

@interface RegisterController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate,TagsViewControllerDelegate,SetInfoViewControllerDelegate,SetSexInfoViewControllerDelegate, SLSelectTagsViewControllerDelegate>
{
    NSMutableDictionary *infoDict;
    CustomTable *infoTable;
    SLHttpFileData *imageData;
    ProjectTagView *tagView;
    NSMutableString *tagString;
    
    NSArray *_selectedTags;
    SLTagFrameModel *_tagFrameModel;
}

@end

@implementation RegisterController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"完善注册信息";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"保存" target:self action:@selector(clickSaveButton)];
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTitle:@"<返回" target:self action:@selector(clickBackButton)];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:(UIBarButtonItemStylePlain) target:self action:@selector(clickBackButton)];
    self.navigationItem.leftBarButtonItem = item;
    ///表格
    infoTable = [[CustomTable alloc] initWithFrame:self.view.frame style:(UITableViewStyleGrouped)];
    [infoTable setDelegate:self];
    [infoTable setDataSource:self];
    [infoTable setBackgroundColor:[UIColor colorWithHexString:kDefaultGrayColor]];
    [self.view addSubview:infoTable];
    
    ///数据
//    infoDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"请填写您的真实姓名",@"姓名",@"请填写您的所在地",@"所在地",@"请填写您的联系邮箱",@"邮箱",@"请填写完整公司名称",@"公司名称",@"请注明您的职位信息",@"职位/级别", nil];
    infoDict = [NSMutableDictionary dictionary];
    [infoDict setObject:@"请填写您的真实姓名" forKey:@"姓名"];
    [infoDict setObject:@"请填写您的所在地" forKey:@"所在地"];
    [infoDict setObject:@"请选择您的性别" forKey:@"性别"];
    [infoDict setObject:@"请填写完整公司名称" forKey:@"公司名称"];
    [infoDict setObject:@"请注明您的职位信息" forKey:@"职位/级别"];
    
    tagView = [[ProjectTagView alloc] initWithFrame:CGRectMake(0, 5, self.view.frame.size.width, 44)];
    tagView.tagArray = [NSArray array];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark 点击保存按钮
-(void)clickSaveButton
{

    for (NSString *tmp in infoDict.allValues)
    {
        if ([tmp isEqualToString:@"请填写您的真实姓名"] ||
            [tmp isEqualToString:@"请填写您的所在地"] ||
            [tmp isEqualToString:@"请填写您的性别"] ||
            [tmp isEqualToString:@"请填写完整公司名称"] ||
            [tmp isEqualToString:@"请注明您的职位信息"])
        {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"请完善相关信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
            [HUDView showHUDWithText:@"请完善相关信息"];
            return;
        }
        
        if ([tmp isEqualToString:@""] || tmp == nil)
        {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"所填写内容不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
            [HUDView showHUDWithText:@"所填写内容不能为空"];
            return;
        }
    }
    
//    if (![ToToolHelper isValidateEmail:[infoDict objectForKey:@"邮箱"]])
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"邮箱设置不正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//        
//        return;
//    }
    
    
    if (imageData.data.length == 0)
    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"请先设置头像" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
        [HUDView showHUDWithText:@"请先设置头像"];
        return;
    }
    
    if ([tagString isEqualToString:@""] || tagString == nil)
    {
        [HUDView showHUDWithText:@"请选择标签"];
        return;
    }
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:@"0" forKey:@"type"];
    [TOHttpHelper postUrl:kTOPicUpload parameters:dict showHUD:YES withMedia:@[imageData] success:^(NSDictionary *dataDictionary) {
        
        
        NSMutableDictionary *pushDict = [NSMutableDictionary dictionary];
        [pushDict setObject:[[UserInfo sharedInfo] userID] forKey:@"id"];
        [pushDict setObject:[dataDictionary objectForKey:@"info"] forKey:@"userHeadPicture"];
        [pushDict setObject:[infoDict objectForKey:@"姓名"] forKey:@"userName"];
        [pushDict setObject:[infoDict objectForKey:@"性别"] forKey:@"userSex"];
        [pushDict setObject:[infoDict objectForKey:@"公司名称"] forKey:@"userCompanyDefinedName"];
        [pushDict setObject:[infoDict objectForKey:@"职位/级别"] forKey:@"userCompanyPosition"];
        [pushDict setObject:[infoDict objectForKey:@"所在地"] forKey:@"userCity"];
        [pushDict setObject:tagString forKey:@"userTags"];
        [pushDict setObject:@"1" forKey:@"userInfoIntegrity"];
        [TOHttpHelper postUrl:kTOModify parameters:pushDict showHUD:YES success:^(NSDictionary *dataDictionary) {
            
            
            [[UserInfo sharedInfo] setInfoDict:pushDict];
            [[UserInfo sharedInfo] setUserInfoIntegrity:YES];
            
            [HUDView showHUDWithText:@"个人信息补充完毕"];
            
            
            XMPPVCardHelper *vCardHelper = [XMPPVCardHelper sharedHelper];
//            [vCardHelper setDelegate:self];
            [vCardHelper changeMyVcard:[infoDict objectForKey:@"姓名"] byType:kNickName];
            
//            [[UserInfo sharedInfo] setUserName:[infoDict objectForKey:@"姓名"]];
////            [[UserInfo sharedInfo] setUserPhone:];
//            [[UserInfo sharedInfo] setUserCompanyDefinedName:[infoDict objectForKey:@"公司名称"]];
////            [[UserInfo sharedInfo] setUserCompanySize:_companySize];
////            [[UserInfo sharedInfo] setUserCompanyPosition:_userCompanyPosition];
//            [[UserInfo sharedInfo] setUserTags:tagString];
////            [[UserInfo sharedInfo] setUserCity:_tmpCompanyAddress];
//            [[UserInfo sharedInfo] setUserSex:[infoDict objectForKey:@"性别"]];
////            [[UserInfo sharedInfo] setUserDescibe:_tmpDesc];
            if (imageData)
            {
                ///同时设置头像
                [vCardHelper changeMyIcon:[UIImage imageWithData:imageData.data]];
//                [[UserInfo sharedInfo] setUserHeadPicture:[pushDict objectForKey:@"userHeadPicture"]];
                
            }

            
            
            
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        } failure:^(NSError *error) {
            
        }];
        
        
    } failure:^(NSError *error) {
        
        
        
    }];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark 点击返回按钮
-(void)clickBackButton
{
    [self dismissViewControllerAnimated:YES completion:^{
       
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(closeRegisterView)])
        {
            [self.delegate closeRegisterView];
        }
        
    }];
}
#pragma mark UITableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else if (section == 1)
    {
        return 5;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0){
        return 60;
    }else if(indexPath.section == 2 && indexPath.row == 0 && _tagFrameModel != nil){
        return _tagFrameModel.tagViewHeight;
    }
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 35;
    }
    else if (section == 1)
    {
        return 10;
    }
    return 29;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"CELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:cellID];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, cell.frame.size.height)];
        [titleLabel setTag:9001];
        [titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
        [cell.contentView addSubview:titleLabel];
        
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-160, 0, 150, 44)];
        [contentLabel setTag:9002];
        [contentLabel setFont:[UIFont systemFontOfSize:16]];
        [cell.contentView addSubview:contentLabel];
    }
    if (indexPath.section == 0)
    {
        UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:9001];
        titleLabel.text = @"添加头像";
        [titleLabel setFrame:CGRectMake(10, 0, 100, 60)];
        UIImageView *iconView = [[TouchImageView alloc] init];
        iconView.image = kUserDefaultIcon;
        if (imageData.data.length > 0)
        {
            [iconView setImage:[UIImage imageWithData:imageData.data]];
        }
        [iconView setTag:9001];
        [iconView setFrame:CGRectMake(self.view.frame.size.width-50, 10, 40, 40)];
        [cell.contentView addSubview:iconView];
    }
    else if (indexPath.section == 1)
    {
        UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:9001];
        UILabel *contentLabel = (UILabel *)[cell.contentView viewWithTag:9002];
        if (indexPath.row == 0)
        {
            titleLabel.text = @"姓名";
        }
        else if (indexPath.row == 1)
        {
            titleLabel.text = @"所在地";
        }
        else if (indexPath.row == 2)
        {
            titleLabel.text = @"性别";
        }
        else if (indexPath.row == 3)
        {
            titleLabel.text = @"公司名称";
        }
        else if (indexPath.row == 4)
        {
            titleLabel.text = @"职位/级别";
        }
        cell.detailTextLabel.text = [infoDict objectForKey:titleLabel.text];
//        contentLabel.text = [infoDict objectForKey:titleLabel.text];
        contentLabel.textColor = [UIColor grayColor];
//        cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
//        cell.detailTextLabel.font = [UIFont systemFontOfSize:16.0f];

    }
    else
    {
    SLConnectionDetailTableViewTagCell *connectionDetailTableViewTagCell = [SLConnectionDetailTableViewTagCell cellWithTableView:tableView];
    connectionDetailTableViewTagCell.tagFrameModel = _tagFrameModel;
    return connectionDetailTableViewTagCell;

    }
//    [cell.textLabel setFont:[UIFont systemFontOfSize:13.0f]];
    [cell.detailTextLabel setFont:[UIFont systemFontOfSize:16.0f]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        UILabel *titleLabel = [[UILabel alloc] init];
        [titleLabel setFrame:CGRectMake(0, 0, self.view.frame.size.width, 35)];
        [titleLabel setText:@"您需要完成以下内容后方可进行相关操作"];
        [titleLabel setTextColor:[UIColor grayColor]];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
        return titleLabel;
    }
    else if (section == 2)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 29)];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-10, 29)];
        [titleLabel setTextAlignment:NSTextAlignmentLeft];
        [titleLabel setTextColor:[UIColor colorWithRed:43.0 / 255.0 green:82.0 / 255.0 blue:123.0 / 255.0 alpha:1.0]];
        [titleLabel setText:@"行业标签"];
        [titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
        [view addSubview:titleLabel];
        return view;
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }

    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0)
    {
        ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
        picker.maximumNumberOfSelection = 1;
        picker.assetsFilter = [ALAssetsFilter allPhotos];
        picker.showEmptyGroups = NO;
        picker.delegate = self;
        picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            if ([[(ALAsset *)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo])
            {
                NSTimeInterval duration = [[(ALAsset *)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
                return duration >= 5;
            } else {
                return YES;
            }
        }];
        [self presentViewController:picker animated:YES completion:^{
            
        }];
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 2)
        {
            SetSexInfoViewController *userSex = [[SetSexInfoViewController alloc] init];
            [userSex setDelegate:self];
            [self.navigationController pushViewController:userSex animated:YES];
        }
        else
        {
            SetInfoViewController *setInfo = [[SetInfoViewController alloc] init];
            [setInfo setDelegate:self];
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            setInfo.controllerTitle = [NSString stringWithFormat:@"请输入%@",cell.textLabel.text];
            //        setInfo.tagTmp = indexPath.row + 9000;
            UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:9001];
            setInfo.tmpKey = titleLabel.text;
            setInfo.title = [NSString stringWithFormat:@"设置%@",titleLabel.text];
            [self.navigationController pushViewController:setInfo animated:YES];
        }

    }
    else if (indexPath.section == 2)
    {
//        TagsViewController *tagViewController = [[TagsViewController alloc] init];
//        [tagViewController setDelegate:self];
//        tagViewController.isCompleteInfo = YES;
    
    SLSelectTagsViewController *selectTagsViewController = [[SLSelectTagsViewController alloc] init];
    selectTagsViewController.selectedTags = _selectedTags;
    selectTagsViewController.delegate = self;
        [self.navigationController pushViewController:selectTagsViewController animated:YES];
    }
}
#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        NSString *content = [[alertView textFieldAtIndex:0] text];
        
        NSString *key = [[infoDict allKeys] objectAtIndex:(alertView.tag - 9000)];
        [infoDict setObject:content forKey:key];
        
        [infoTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:(alertView.tag - 9000) inSection:1]] withRowAnimation:(UITableViewRowAnimationNone)];
    }
}
#pragma mark ZYQAssetPickerController Delegate
-(void)assetPickerControllerDidMaximum:(ZYQAssetPickerController *)picker
{
    [HUDView showHUDWithText:@"选择数目已经达到最大"];
}
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    NSMutableArray *tmpArray = [NSMutableArray array];
    NSData *data = assets[0];
    NSString *picName = [NSString stringWithFormat:@"%f",[NSDate timeIntervalSinceReferenceDate]];

    imageData = [[SLHttpFileData alloc] init];
    [imageData setData:data];
    NSString *name = [NSString stringWithFormat:@"%@.jpg",picName];
    [imageData setParameterName:name];
    [imageData setFileName:name];
    [imageData setMimeType:@"image/jpeg"];
    
    [tmpArray addObject:imageData];
    
//    UITableViewCell *cell = [infoTable cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
//    UIImageView *view = (UIImageView *)[cell.contentView viewWithTag:9001];
//    view.image = [UIImage imageWithData:data];
    [infoTable reloadData];
}
-(void)assetPickerControllerDidCancel:(ZYQAssetPickerController *)picker
{
    
}
#pragma mark TagsView
-(void)selectTagsSuccess:(NSMutableArray *)tagsArray
{
    tagString = [NSMutableString string];
    NSMutableArray *titleArray = [NSMutableArray array];
    for (NSDictionary *dict in tagsArray)
    {
        [titleArray addObject:[dict objectForKey:@"labelName"]];
        [tagString appendFormat:@"%@,",[dict objectForKey:@"labelCode"]];
    }
    tagString = [[tagString substringToIndex:tagString.length-1] mutableCopy];
    tagView.tagArray = titleArray;

}

- (void)selectTagsViewController:(SLSelectTagsViewController *)selectTagsViewController didSelectedTags:(NSArray *)selectedTags{
    tagString = [NSMutableString string];
    NSMutableArray *titleArray = [NSMutableArray array];
    _selectedTags = selectedTags;
    
    for (SLTagModel *tagModel in selectedTags){
        [titleArray addObject:tagModel.tagName];
        [tagString appendFormat:@"%@,",tagModel.tagCode];
    }
    
    if(tagString.length > 0){
        tagString = [[tagString substringToIndex:tagString.length-1] copy];
    }
    
    if(titleArray != nil && titleArray.count > 0){
        _tagFrameModel = [[SLTagFrameModel alloc] initWithTags:[titleArray copy]];
    }else{
        _tagFrameModel = nil;
    }
    
    [infoTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:2]] withRowAnimation:(UITableViewRowAnimationNone)];
}


#pragma mark 设置性别成功
-(void)setUserSexSuccess:(NSString *)sex
{
    [infoDict setObject:sex forKey:@"性别"];
    [infoTable reloadData];
}
#pragma mark SetInfoDelegate
-(void)setInfoSuccess:(NSString *)value withKey:(NSString *)key
{

    [infoDict setObject:value forKey:key];

    [infoTable reloadData];
}
@end
