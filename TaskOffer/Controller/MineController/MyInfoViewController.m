//
//  MyInfoViewController.m
//  TaskOffer
//
//  Created by BourbonZ on 15/3/16.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "MyInfoViewController.h"
#import "MyinfoTableViewCell.h"
#import "TagView.h"
#import "UIImageView+WebCache.h"
#import "ZYQAssetPickerController.h"
#import "TOHttpHelper.h"
#import "ToToolHelper.h"
#import "ProjectTagView.h"
#import "TagsViewController.h"
#import "QRCodeViewController.h"
#import "ApplyCompanyController.h"
#import "ToToolHelper.h"
#import "XMPPVCardHelper.h"
#import "SetInfoViewController.h"
#import "SetSexInfoViewController.h"
#import "SLConnectionDetailTableSectionHeaderView.h"
#import "SLSelectTagsViewController.h"
#import "SLTagModel.h"
#import "SLConnectionDetailTableViewTagCell.h"
#import "SLTagFrameModel.h"
#import "SLConnectionHTTPHandler.h"
#import "SLOptionPickerView.h"
#import "SLOptionModel.h"
#import "EnterpriseInfoController.h"
#import "EnterpriseInfo.h"
#import "UIImage+GWebP.h"
#import "CustomTable.h"
#import "MJPhotoBrowser.h"
@interface MyInfoViewController ()<UITableViewDataSource,UITableViewDelegate,ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,TagsViewControllerDelegate,SetInfoViewControllerDelegate,xmppVcardHelperDelegate,SetSexInfoViewControllerDelegate, SLSelectTagsViewControllerDelegate, SLOptionPickerViewDelegate>
{
    NSArray *infoArray;
    BOOL editUserInfo;
    NSMutableDictionary *editInfoDict;
    SLHttpFileData *imageData;
    UITableView *infoTable;
    
    ///临时值
    NSString *_userName;
    NSString *_userMail;
    NSString *_userPhone;
    NSString *_userCompanyDefinedName;
    NSString *_companySize;
    NSString *_tmpCompanySize;
    NSString *_userCompanyPosition;
    NSString *_userTags;
    NSString *_tmpCompanyAddress;
    NSString *_tmpUserSex;
    NSString *_tmpDesc;
    
    NSArray *tagArray;
    UIPickerView *tagPicker;
    UIImage *_iconImage;
    
    ProjectTagView *tagView;

    UIButton *applyButton;
    NSData *tmpData;
    
    NSArray *_selectedTagModels;
    SLTagFrameModel *_tagFrameModel;
    
    SLOptionPickerView *_optionPickerView;
    NSArray *_optionArray;
}

@end

@implementation MyInfoViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [infoTable reloadData];
}
//-(void)viewDidLayoutSubviews
//{
//    if ([infoTable respondsToSelector:@selector(setSeparatorInset:)]) {
//        [infoTable setSeparatorInset:UIEdgeInsetsMake(0,10,0,0)];
//    }
//    
//    if ([infoTable respondsToSelector:@selector(setLayoutMargins:)]) {
//        [infoTable setLayoutMargins:UIEdgeInsetsMake(0,10,0,0)];
//    }
//}

//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//    
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//}
-(void)clickIcon
{
    MJPhoto *photo = [[MJPhoto alloc] init];
    NSString *icon = [NSString stringWithFormat:@"%@%@/%@",kTOHOSt,kTOUploadUserIcon,[[UserInfo sharedInfo] userHeadPicture]];
    photo.url = [NSURL URLWithString:icon];
    
    MyinfoTableViewCell *cell = (MyinfoTableViewCell *)[infoTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    photo.srcImageView = cell.logoView;
    photo.index = 0;
    
    MJPhotoBrowser *photoBrowser = [[MJPhotoBrowser alloc] init];
    photoBrowser.photos = @[photo];
    photoBrowser.currentPhotoIndex = 0;
    [photoBrowser show];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    
    ///右侧的编辑按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:(UIBarButtonItemStylePlain) target:self action:@selector(clickEditButton:)];
    
    ///显示的表格
    infoTable = [[CustomTable alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:(UITableViewStyleGrouped)];
    [infoTable setDelegate:self];
    [infoTable setDataSource:self];
    infoTable.backgroundView = nil;
    [infoTable setBackgroundColor:[UIColor clearColor]];
    infoTable.contentInset = UIEdgeInsetsMake(0, 0, 50.0, 0);
    ///下方的标签
//    TagView *tagView = [[TagView alloc] init];
//    [infoTable setTableFooterView:tagView];
    
    [self.view addSubview:infoTable];
    
    ///数据
    infoArray = @[@"头像",@"姓名",@"性别",@"二维码",@"邮箱",@"手机号码",@"公司名称",@"企业号",@"公司地址",@"公司规模",@"职位/级别",@"个人描述"];
    
    ///下方的行业标签
    
    editUserInfo = NO;
    
    ///上传时发送的dict
    editInfoDict = [[NSMutableDictionary alloc] init];
    
    ///赋值
    _userName = [[UserInfo sharedInfo] userName];
    _userMail = [[UserInfo sharedInfo] userMail];
    _userPhone = [[UserInfo sharedInfo] userPhone];
    _userCompanyDefinedName = [[UserInfo sharedInfo] userCompanyDefinedName];
    _userCompanyPosition = [[UserInfo sharedInfo] userCompanyPosition];
    _userTags = [[UserInfo sharedInfo] userTags];
    _tmpCompanyAddress = [[UserInfo sharedInfo] userCity];
    _tmpUserSex = [[UserInfo sharedInfo] userSex];
    _tmpDesc = [[UserInfo sharedInfo] userDescibe];
    tagArray = [NSArray array];
    
    ///准备picker
    ///设置滚动数据视图
    tagPicker = [[UIPickerView alloc] init];
    [tagPicker setDataSource:self];
    [tagPicker setDelegate:self];
    [tagPicker setBackgroundColor:[UIColor colorWithHexString:kDefaultBackColor]];
    [tagPicker setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height+130)];
    [self.view addSubview:tagPicker];

    
    ///申请按钮
    applyButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [applyButton setTitle:@"申请认证" forState:(UIControlStateNormal)];
    [applyButton setBackgroundColor:[UIColor colorWithHexString:kDefaultTextColor]];
    [applyButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [applyButton.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [applyButton addTarget:self action:@selector(clickApplyButton) forControlEvents:(UIControlEventTouchUpInside)];
    [applyButton setFrame:CGRectMake(self.view.frame.size.width-90, 5, 80, 30)];
    
    ///获取数据
//    NSDictionary *tmpDict = [NSDictionary dictionaryWithObject:@"TO_USER_COMPANY_SIZE" forKey:@"parentId"];
//    [TOHttpHelper postUrl:kTOAllPriceTag parameters:tmpDict showHUD:YES success:^(NSDictionary *dataDictionary) {
//    
//        tagArray = [dataDictionary objectForKey:@"info"];
//        
//        for (int i = 0; i < tagArray.count; i++)
//        {
//            NSDictionary *dict = [tagArray objectAtIndex:i];
//            if ([[[dict allKeys] lastObject] isEqualToString:[[UserInfo sharedInfo] userCompanySize]])
//            {
//                _companySize = [[dict allKeys] lastObject];
//                _tmpCompanySize = [[dict allValues] lastObject];
//                break;
//            }
//        }
//        [infoTable reloadData];
//        [tagPicker reloadAllComponents];
//        
//    } failure:^(NSError *error) {
//        
//    }];
    
//    _tmpCompanySize = [UserInfo sharedInfo].userCompanySize;
//    if(_tmpCompanySize == nil){
//        _tmpCompanySize = @"";
//    }
    
    __block typeof(self) bself = self;
        [SLConnectionHTTPHandler POSTSystemDictionaryOptionWithOptionType:kSLSystemDictionaryOptionTypeCompanySize showProgressInView:self.view success:^(NSArray *dataArray) {
            _optionArray = dataArray;
            SLOptionModel *selectedOptionModel = nil;
            for(SLOptionModel *optionModel in dataArray){
                if([optionModel.optionKey isEqualToString:[UserInfo sharedInfo].userCompanySize]){
                    _companySize = optionModel.optionKey;
                    _tmpCompanySize = optionModel.optionValue;
                    selectedOptionModel = optionModel;
                    break;
                }
            }
            _optionPickerView = [[SLOptionPickerView alloc] initWithOptionArray:dataArray];
            _optionPickerView.delegate = bself;
            _optionPickerView.selectedOptionModel = selectedOptionModel;
            [infoTable reloadData];
        } failure:^(NSString *errorMessage) {
            
        }];
    
    
    ///获取标签
    [TOHttpHelper postUrl:kTOALLAvailAble parameters:nil showHUD:YES success:^(NSDictionary *dataDictionary) {
        
        tagView = [[ProjectTagView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        NSString *tagString = [[UserInfo sharedInfo] userTags];
        if (tagString.length > 0)
        {
            NSArray *allTagArray = [dataDictionary objectForKey:@"info"];
            NSMutableArray *tmpArray = [NSMutableArray array];
            NSArray *array = [tagString componentsSeparatedByString:@","];
            NSMutableArray *selectedModels = [NSMutableArray array];
            for (NSString *tmpTag in array)
            {
                for (NSDictionary *info in allTagArray)
                {
                    if ([tmpTag isEqualToString:[info objectForKey:@"labelCode"]])
                    {
                        SLTagModel *tagModel = [[SLTagModel alloc] initWithDictionary:info];
                        [selectedModels addObject:tagModel];
                        [tmpArray addObject:[info objectForKey:@"labelName"]];
                        break;
                    }
                }
            }
            _selectedTagModels = [selectedModels copy];
            tagView.tagArray = tmpArray;
            _tagFrameModel = [[SLTagFrameModel alloc] initWithTags:[tmpArray copy]];
            [infoTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:1]] withRowAnimation:(UITableViewRowAnimationNone)];
        }
        else
        {
            tagView.tagArray = [NSArray array];
        }

        
    } failure:^(NSError *error) {
        
        
        
    }];

    
}


#pragma mark 显示pickerView
-(void)showPicker:(id)picker
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.6];
    [picker setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-108)];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationFinished)];
    [UIView commitAnimations];
}
-(void)hidePicker:(id)picker
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.6];
    [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    [picker setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height+108)];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationFinished)];
    [UIView commitAnimations];
}
-(void)animationFinished
{
    //    NSLog(@"动画结束");
}


#pragma mark 点击界面其他地方
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UIView *view = [[[touches allObjects] lastObject] view];
    NSString *str = NSStringFromClass([view class]);
    if ([str rangeOfString:@"UIPicker"].location == NSNotFound)
    {
        [self hidePicker:tagPicker];
        [self hidePicker:tagPicker];
    }
}

#pragma mark UIPickerViewDelegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return tagArray.count;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSDictionary *dict = [tagArray objectAtIndex:row];
    return dict.allValues.lastObject;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (tagArray.count == 0)
    {
        return;
    }
    NSDictionary *dict = [tagArray objectAtIndex:row];
    _companySize = [[dict allKeys] lastObject];
    _tmpCompanySize = [[dict allValues] lastObject];
    [infoTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:8 inSection:0]] withRowAnimation:(UITableViewRowAnimationNone)];
}

#pragma mark UITableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1)
    {
        return 1;
    }
    return infoArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        static NSString *cellID = @"cellID";
//        MyinfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//        
//        if (cell == nil)
//        {
//            cell = [[MyinfoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellID];
//        }
        MyinfoTableViewCell *cell = [[MyinfoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:nil];
        
        if (indexPath.row == 0)
        {
            if (_iconImage)
            {
                cell.logoView.image = _iconImage;
            }
            else
            {
                NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@",kTOHOSt,kTOUploadUserIcon,[[UserInfo sharedInfo] userHeadPicture]];
                [cell.logoView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:kUserDefaultIcon];
            }
            cell.logoView.userInteractionEnabled = YES;
            [cell.logoView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickIcon)]];
        }
        else if (indexPath.row == 1)
        {
            ///姓名
            cell.contentLabel.text = _userName;
        }
        else if (indexPath.row == 2)
        {
            //性别
            if ([_tmpUserSex isEqualToString:@""] || _tmpUserSex == nil)
            {
                cell.contentLabel.text = @"未设置性别";
            }
            else
            {
                cell.contentLabel.text = _tmpUserSex;
            }
        }
        else if (indexPath.row ==3)
        {
            cell.logoView.image = [UIImage imageNamed:@"默认二维码"];
            cell.contentLabel.text = nil;
        }
        else if (indexPath.row == 4)
        {
            ///邮箱
            cell.contentLabel.text = _userMail;
        }
        else if (indexPath.row == 5)
        {
            ///手机号
            cell.contentLabel.text = _userPhone;
        }
        else if (indexPath.row == 6)
        {
            ///公司名称
            cell.contentLabel.text = _userCompanyDefinedName;
        }
        else if (indexPath.row == 7)
        {
            ///企业号
            ///认证状态，0：未认证；1：认证中；2：伪认证；3：已认证；
            if ([[UserInfo sharedInfo] userCertificateStatus].integerValue == 3)
            {
//                cell.contentLabel.text = [[UserInfo sharedInfo] userCompanyName];
                [applyButton setTitle:@"已认证" forState:(UIControlStateNormal)];
                [cell.contentView addSubview:applyButton];
            }
            else
            {
                if ([[UserInfo sharedInfo] userCertificateStatus].integerValue == 2)
                {
                    [applyButton setTitle:@"认证通过" forState:(UIControlStateNormal)];
                    [cell.contentView addSubview:applyButton];
                }
                else if ([[UserInfo sharedInfo] userCertificateStatus].integerValue == 1)
                {
                    [applyButton setTitle:@"认证中" forState:(UIControlStateNormal)];
                    applyButton.userInteractionEnabled = NO;
                    [cell.contentView addSubview:applyButton];
                }
                else if ([[UserInfo sharedInfo] userCertificateStatus].integerValue == 0)
                {
                    [applyButton setTitle:@"未认证" forState:(UIControlStateNormal)];
                    [cell.contentView addSubview:applyButton];
                }
            }

        }
        else if (indexPath.row == 8)
        {
            ///公司地址
            cell.contentLabel.text = _tmpCompanyAddress;
            
        }
        else if (indexPath.row == 9)
        {
            ///公司规模
            cell.contentLabel.text = _tmpCompanySize;
        }
        else if (indexPath.row == 10)
        {
            ///职位/级别
            cell.contentLabel.text = _userCompanyPosition;
        }
        else if (indexPath.row == 11)
        {
            ///个人描述
            cell.contentLabel.text = _tmpDesc;
        }
        
        cell.tag = 9000 + indexPath.row;
        cell.titleLabel.text = [infoArray objectAtIndex:indexPath.row];
        
        if (indexPath.row == 0 || indexPath.row == 3)
        {
            cell.logoView.hidden = NO;
        }
        else
        {
            cell.logoView.hidden = YES;
        }
        
        return cell;
    }
    else
    {
        SLConnectionDetailTableViewTagCell *cell = [SLConnectionDetailTableViewTagCell cellWithTableView:tableView];
        cell.tagFrameModel = _tagFrameModel;
        return cell;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        return 0.1f;
    }
    return 35.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0){
        return 62.0;
    }else if(indexPath.section == 1 && indexPath.row == 0){
        if(_tagFrameModel == nil || _tagFrameModel.tagViewHeight < 44.0){
            return 44.0;
        }
        return _tagFrameModel.tagViewHeight;
    }else{
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
    
        SLConnectionDetailTableSectionHeaderView *view = [SLConnectionDetailTableSectionHeaderView sectionHeaderViewWithTableView:tableView];
        view.title = @"行业标签";
        view.hideMoreButton = YES;
        view.hideBottomLine = YES;
        return view;
    }
    
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 3)
    {
        return YES;
    }
    return editUserInfo;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 3)
    {
        QRCodeViewController *qrCode = [[QRCodeViewController alloc] init];
        qrCode.qrString = [kTOUserTag stringByAppendingString:[[UserInfo sharedInfo] userID]];
        [self.navigationController pushViewController:qrCode animated:YES];
    }

    if (editUserInfo)
    {
        if (indexPath.section == 0)
        {
            if (indexPath.row == 0)
            {
                ///点击之后进入照相
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
            else if (indexPath.row == 9)
            {
            [_optionPickerView showOptionPicker];
                //[self showPicker:tagPicker];
            }
            else if (indexPath.row == 2)
            {
                SetSexInfoViewController *userSex = [[SetSexInfoViewController alloc] init];
                userSex.title = @"选择性别";
                [userSex setDelegate:self];
                [self.navigationController pushViewController:userSex animated:YES];
            }
            else if (indexPath.row != 0 && indexPath.row != 2 && indexPath.row != 3 && indexPath.row != 5 && indexPath.row != 7)
            {
                MyinfoTableViewCell *cell = (MyinfoTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
                NSString *string = [NSString stringWithFormat:@"设置%@",cell.titleLabel.text];
                SetInfoViewController *setInfo = [[SetInfoViewController alloc] init];
                [setInfo setDelegate:self];
                setInfo.title = string;
                MyinfoTableViewCell *tmpCell = (MyinfoTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
                setInfo.placeString = tmpCell.contentLabel.text;
                setInfo.controllerTitle = string;
                [setInfo setTagTmp:(indexPath.row + 9000)];
                [self.navigationController pushViewController:setInfo animated:YES];
            }

        }
        else
        {
//            TagsViewController *tagViewController = [[TagsViewController alloc] init];
//            [tagViewController setDelegate:self];
//            tagViewController.isCompleteInfo = YES;
            SLSelectTagsViewController *selectTagsViewController = [[SLSelectTagsViewController alloc] init];
            selectTagsViewController.delegate = self;
            selectTagsViewController.selectedTags = _selectedTagModels;
            [self.navigationController pushViewController:selectTagsViewController animated:YES];

        }
    }
    
}
#pragma mark ZYQAssetPickerController Delegate
-(void)assetPickerControllerDidMaximum:(ZYQAssetPickerController *)picker
{
    [HUDView showHUDWithText:@"选择数目已经达到最大"];
}
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    NSData *data = assets[0];
    NSString *picName = [NSString stringWithFormat:@"%f",[NSDate timeIntervalSinceReferenceDate]];

    UIImage *image = [ToToolHelper imageByScalingAndCroppingForSize:CGSizeMake(150, 150) withSourchImage:[UIImage imageWithData:data]];
    
    tmpData = [ToToolHelper imageBySize:0.5 andImage:image];
    
    imageData = [[SLHttpFileData alloc] init];
    [imageData setData:[UIImage imageToWebP:[UIImage imageWithData:data] quality:1]];
    NSString *name = [NSString stringWithFormat:@"%@.webp",picName];
    [imageData setParameterName:name];
    [imageData setFileName:name];
    [imageData setMimeType:@"image/webp"];
    
    _iconImage = [UIImage imageWithData:data];
    [infoTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]] withRowAnimation:(UITableViewRowAnimationNone)];
}
-(void)assetPickerControllerDidCancel:(ZYQAssetPickerController *)picker
{
    
}
#pragma mark 点击编辑按钮
-(void)clickEditButton:(UIBarButtonItem *)sender
{
    if ([sender.title isEqualToString:@"编辑"])
    {
        [sender setTitle:@"保存"];
        editUserInfo = YES;
        MyinfoTableViewCell *cell = (MyinfoTableViewCell *)[infoTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        cell.logoView.userInteractionEnabled = NO;
    }
    else
    {
        MyinfoTableViewCell *cell = (MyinfoTableViewCell *)[infoTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        cell.logoView.userInteractionEnabled = YES;

        [editInfoDict setObject:[[UserInfo sharedInfo] userID] forKey:@"id"];
        ///上传信息
        if ([_userName isEqualToString:@""] || _userName == nil)
        {
            [self showAlertWithMessage:@"姓名不能为空"];
            return;
        }
        [editInfoDict setObject:_userName forKey:@"userName"];
        
        if ([_userMail isEqualToString:@""] || _userMail == nil || ![ToToolHelper isValidateEmail:_userMail])
        {
            [self showAlertWithMessage:@"输入邮箱格式不正确"];
            return;
        }
        [editInfoDict setObject:_userMail forKey:@"userMail"];
        
        if ([_userPhone isEqualToString:@""] || _userPhone == nil || ![ToToolHelper isMobileNumber:_userPhone])
        {
            [self showAlertWithMessage:@"手机号输入不正确"];
            return;
        }
        [editInfoDict setObject:_userPhone forKey:@"userPhone"];
        
        if ([_userCompanyDefinedName isEqualToString:@""] || _userCompanyDefinedName == nil)
        {
            [self showAlertWithMessage:@"公司名称输入不正确"];
            return;
        }
        [editInfoDict setObject:_userCompanyDefinedName forKey:@"userCompanyDefinedName"];
        
        if ([_companySize isEqualToString:@""] || _companySize == nil)
        {
            [self showAlertWithMessage:@"请选择公司规模"];
            return;
        }
        [editInfoDict setObject:_companySize forKey:@"userCompanySize"];
        
        if ([_userCompanyPosition isEqualToString:@""] || _userCompanyPosition == nil)
        {
            [self showAlertWithMessage:@"公司地址输入不正确"];
            return;
        }
        [editInfoDict setObject:_userCompanyPosition forKey:@"userCompanyPosition"];
        
        if ([_userTags isEqualToString:@""] || _userTags == nil)
        {
            [self showAlertWithMessage:@"请选择标签"];
            return;
        }
        [editInfoDict setObject:_userTags forKey:@"userTags"];

        if ([_tmpCompanyAddress isEqualToString:@""] || _tmpCompanyAddress == nil)
        {
            [self showAlertWithMessage:@"公司地址不能为空"];
            return;
        }
        [editInfoDict setObject:_tmpCompanyAddress forKey:@"userCity"];
        
        if ([_tmpUserSex isEqualToString:@""] || _tmpUserSex == nil)
        {
            [self showAlertWithMessage:@"性别不能为空"];
            return;
        }
        [editInfoDict setObject:_tmpUserSex forKey:@"userSex"];
        
        
        if ([_tmpDesc isEqualToString:@""] || _tmpDesc == nil)
        {
            [self showAlertWithMessage:@"个人描述"];
            return;
        }
        [editInfoDict setObject:_tmpDesc forKey:@"userDescibe"];
        
        if (imageData == nil)
        {
            [editInfoDict setObject:[[UserInfo sharedInfo] userHeadPicture] forKey:@"userHeadPicture"];
            
            [TOHttpHelper postUrl:kTOModify parameters:editInfoDict showHUD:YES success:^(NSDictionary *dataDictionary) {
                
                [self showAlertWithMessage:@"信息更改完成"];
                
                [self changeUserSuccess:nil];
                
                [sender setTitle:@"编辑"];
                editUserInfo = NO;
                
            } failure:^(NSError *error) {
                
            }];
        }
        else
        {
            NSDictionary *dict = [NSDictionary dictionaryWithObject:@"0" forKey:@"type"];
            
            [TOHttpHelper postUrl:kTOPicUpload parameters:dict showHUD:YES withMedia:@[imageData] success:^(NSDictionary *dataDictionary) {
                
                NSString *headPic = [dataDictionary objectForKey:@"info"];
                [editInfoDict setObject:headPic forKey:@"userHeadPicture"];
                
                [TOHttpHelper postUrl:kTOModify parameters:editInfoDict showHUD:YES success:^(NSDictionary *dataDictionary) {
                    
                    [self showAlertWithMessage:@"信息更改完成"];
                    
                    [self changeUserSuccess:headPic];
                    
                    [sender setTitle:@"编辑"];
                    editUserInfo = NO;
                    
                } failure:^(NSError *error) {
                    
                }];
                
                
            } failure:^(NSError *error) {
                
            }];
        }
    }
}
-(void)changeUserSuccess:(NSString *)headpic
{
    ///同时设置昵称
    XMPPVCardHelper *vCardHelper = [XMPPVCardHelper sharedHelper];
    [vCardHelper setDelegate:self];
    [vCardHelper changeMyVcard:_userName byType:kNickName];
    
    [[UserInfo sharedInfo] setUserName:_userName];
    [[UserInfo sharedInfo] setUserMail:_userMail];
    [[UserInfo sharedInfo] setUserPhone:_userPhone];
    [[UserInfo sharedInfo] setUserCompanyDefinedName:_userCompanyDefinedName];
    [[UserInfo sharedInfo] setUserCompanySize:_companySize];
    [[UserInfo sharedInfo] setUserCompanyPosition:_userCompanyPosition];
    [[UserInfo sharedInfo] setUserTags:_userTags];
    [[UserInfo sharedInfo] setUserCity:_tmpCompanyAddress];
    [[UserInfo sharedInfo] setUserSex:_tmpUserSex];
    [[UserInfo sharedInfo] setUserDescibe:_tmpDesc];
    if (headpic)
    {
        ///同时设置头像
        [vCardHelper changeMyIcon:[UIImage imageWithData:tmpData]];
        [[UserInfo sharedInfo] setUserHeadPicture:headpic];
        
    }
}
#pragma mark vcardHelper
-(void)myInfoChangeSuccess:(XMPPUserInfo *)temp
{
    
}
#pragma mark ShowALert
-(void)showAlertWithMessage:(NSString *)message
{
    [HUDView showHUDWithText:message];
}
#pragma mark TagsViewController
-(void)selectTagsSuccess:(NSMutableArray *)tagsArray
{
    NSMutableString *tagString = [NSMutableString string];
    NSMutableArray *titleArray = [NSMutableArray array];
    for (NSDictionary *dict in tagsArray)
    {
        [titleArray addObject:[dict objectForKey:@"labelName"]];
        [tagString appendFormat:@"%@,",[dict objectForKey:@"labelCode"]];
    }
    _userTags = [[tagString substringToIndex:tagString.length-1] mutableCopy];
    tagView.tagArray = titleArray;
}

- (void)selectTagsViewController:(SLSelectTagsViewController *)selectTagsViewController didSelectedTags:(NSArray *)selectedTags{
    NSMutableString *tagString = [NSMutableString string];
    NSMutableArray *titleArray = [NSMutableArray array];
    _selectedTagModels = selectedTags;
    
    for (SLTagModel *tagModel in selectedTags){
        [titleArray addObject:tagModel.tagName];
        [tagString appendFormat:@"%@,",tagModel.tagCode];
    }
    
    if(tagString.length > 0){
        _userTags = [[tagString substringToIndex:tagString.length-1] copy];
    }else{
        _userTags = @"";
    }
    _tagFrameModel = [[SLTagFrameModel alloc] initWithTags:[titleArray copy]];
    
    [infoTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:1]] withRowAnimation:(UITableViewRowAnimationNone)];
}

#pragma mark 点击申请认证
-(void)clickApplyButton
{
    if ([[UserInfo sharedInfo] userCertificateStatus].integerValue == 3 ||
        [[UserInfo sharedInfo] userCertificateStatus].integerValue == 2)
    {
        [TOHttpHelper getUrl:kTOGetCompanyInfo parameters:@{@"companyId":[[UserInfo sharedInfo] userCompanyId],@"userId":[[UserInfo sharedInfo] userID]} showHUD:YES success:^(NSDictionary *dataDictionary) {
            
            EnterpriseInfoController *info = [[EnterpriseInfoController alloc] init];
            
            EnterpriseInfo *companyInfo = [[EnterpriseInfo alloc] init];
            [companyInfo setEnterpriseDict:dataDictionary];
            info.companyInfo = companyInfo;
            info.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:info animated:YES];
            
            
        }];

    }
    else
    {
        ApplyCompanyController *apply = [[ApplyCompanyController alloc] init];
        [self.navigationController pushViewController:apply animated:YES];
    }
}

#pragma mark SetInfoDelegate
-(void)setInfoSuccess:(NSString *)value withTag:(NSInteger)tagTmp
{
    NSInteger num = tagTmp - 9000;
    
    MyinfoTableViewCell *cell = (MyinfoTableViewCell *)[infoTable cellForRowAtIndexPath:[NSIndexPath indexPathForItem:num inSection:0]];
    cell.contentLabel.text = value;
    
    if (num == 1)
    {
        ///姓名
        _userName = value;
    }
    else if (num == 4)
    {
        ///邮箱
        _userMail = value;
    }
    else if (num == 5)
    {
        ///手机号码
        _userPhone = value;
    }
    else if (num == 6)
    {
        ///公司名称
        _userCompanyDefinedName = value;
    }
    else if (num == 8)
    {
        ///公司地址
        _tmpCompanyAddress = value;
    }
    else if (num == 9)
    {
        ///公司规模
        _companySize = value;
    }
    else if (num == 10)
    {
        ///职位/级别
        _userCompanyPosition = value;
    }
    else if (num == 11)
    {
        //个人描述
        _tmpDesc = value;
    }
}

#pragma mark 设置性别
-(void)setUserSexSuccess:(NSString *)sex
{
    MyinfoTableViewCell *cell = (MyinfoTableViewCell *)[infoTable cellForRowAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0]];
    cell.contentLabel.text = sex;
    _tmpUserSex = sex;
}

- (void)optionPickerView:(SLOptionPickerView *)optionPickerView didSelectOptionComplete:(SLOptionModel *)optionModel{
    _companySize = optionModel.optionKey;
    _tmpCompanySize = optionModel.optionValue;
    
    [infoTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:9 inSection:0]] withRowAnimation:(UITableViewRowAnimationNone)];
}

@end
