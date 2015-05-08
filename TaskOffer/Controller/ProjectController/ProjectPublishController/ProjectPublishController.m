//
//  ProjectPublishController.m
//  TaskOffer
//
//  Created by BourbonZ on 15/3/21.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "ProjectPublishController.h"
#import "TOHttpHelper.h"
#import "TagsViewController.h"
#import "ProjectTagView.h"
#import "ZYQAssetPickerController.h"
#import "SingleCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "SetInfoViewController.h"
#import "CreateProjectCell.h"
@interface ProjectPublishController ()<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextViewDelegate,TagsViewControllerDelegate,UIAlertViewDelegate,ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,SingleVieDelegate,SetInfoViewControllerDelegate>

@end

@implementation ProjectPublishController
{
    UILabel *addLabel;
    NSString *tmpName;
    NSString *tmpTime;
    NSString *tmpDesc;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (picItemArray.count !=0)
    {
        if (addLabel != nil)
        {
            addLabel.hidden = YES;
        }
    }
    [publishTable reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"新建项目";
    
    itemArray = [NSArray arrayWithObjects:@"项目名称",@"截止征集日期",@"项目描述",@"项目金额",@"设置项目标签",@"添加图片", nil];
    
    ///设置表格
    publishTable = [[CustomTable alloc] initWithFrame:self.view.frame style:(UITableViewStyleGrouped)];
    [publishTable setDataSource:self];
    [publishTable setDelegate:self];
    publishTable.tag = 9001;
//    [publishTable setSeparatorStyle:(UITableViewCellSeparatorStyleNone)];
    [publishTable setBackgroundColor:[UIColor colorWithHexString:kDefaultGrayColor]];
    [self.view addSubview:publishTable];
    
    ///设置滚动数据视图
    pricePicker = [[UIPickerView alloc] init];
    [pricePicker setDataSource:self];
    [pricePicker setDelegate:self];
    [pricePicker setBackgroundColor:[UIColor colorWithHexString:kDefaultBackColor]];
    [pricePicker setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height+130)];
    priceArray = [NSArray array];
    [self.view addSubview:pricePicker];
    
    ///设置时间
    priceDatePicker = [[UIDatePicker alloc] init];
    [priceDatePicker setDatePickerMode:(UIDatePickerModeDate)];
    [priceDatePicker setBackgroundColor:[UIColor colorWithHexString:kDefaultBackColor]];
    [priceDatePicker setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 216)];
    [priceDatePicker addTarget:self action:@selector(clickDoneOnDatePicker) forControlEvents:(UIControlEventValueChanged)];
    [self.view addSubview:priceDatePicker];
    
    tagView = [[ProjectTagView alloc] initWithFrame:CGRectMake(0, 5, self.view.frame.size.width, 44)];
    [tagView setTag:9001];
    tagView.tagArray = [NSArray array];

    
    placeLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 6, 200, 20)];
    placeLable.enabled = NO;
    placeLable.text = @"请输入项目详情";
    placeLable.font =  [UIFont systemFontOfSize:16];
    placeLable.textColor = [UIColor lightGrayColor];
    
    
    ///获取所有的价格标签
    NSDictionary *dict = [NSDictionary dictionaryWithObject:@"TO_PROJECT_PRICE" forKey:@"parentId"];
    
    [TOHttpHelper postUrl:kTOAllPriceTag parameters:dict showHUD:YES success:^(NSDictionary *dataDictionary) {
        
        priceArray = [dataDictionary objectForKey:@"info"];
        [pricePicker reloadAllComponents];
        
        
    } failure:^(NSError *error) {
        
    }];
    
    ///发布按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:(UIBarButtonItemStylePlain) target:self action:@selector(clickPublishButton)];
    
    ///项目图片
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    itemCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 105) collectionViewLayout:layout];
    [itemCollection registerClass:[SingleCollectionViewCell class] forCellWithReuseIdentifier:@"collection"];
    itemCollection.backgroundColor = [UIColor colorWithHexString:kDefaultBackColor];
    [itemCollection setDataSource:self];
    [itemCollection setDelegate:self];
    picItemArray = [NSMutableArray array];
    
    tmpLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0,100, 40)];
    tmpLabel.text = @"暂未设置标签";
    tmpLabel.font = [UIFont systemFontOfSize:16.0f];
    tmpLabel.textColor = [UIColor lightGrayColor];
    [tagView addSubview:tmpLabel];
//    [tmpLabel setCenter:CGPointMake(tagView.frame.size.width/2, tagView.frame.size.height/2)];
    tmpName = @"";
    tmpTime = @"";
    tmpDesc = @"";
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
#pragma mark 时间选择上的确定按钮
-(void)clickDoneOnDatePicker
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    dateString = [formatter stringFromDate:[priceDatePicker date]];
    NSDateFormatter *dateStringFormatter = [[NSDateFormatter alloc] init];
    [dateStringFormatter setDateFormat:@"yyyy-MM-dd"];
    CreateProjectCell *cell = (CreateProjectCell *)[publishTable cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
    cell.contentLabel.text = [dateStringFormatter stringFromDate:[priceDatePicker date]];
    tmpTime = [dateStringFormatter stringFromDate:[priceDatePicker date]];
}
#pragma mark 点击发布按钮
-(void)clickPublishButton
{
    if (picItemArray.count == 0)
    {
        [self showAlertView:@"请先添加图片"];
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[[UserInfo sharedInfo] userID] forKey:@"projectPublishId"];
    ///项目名称
    CreateProjectCell *nameCell = (CreateProjectCell *)[publishTable cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    NSString *name = [[nameCell contentLabel] text];
    if ([name isEqualToString:@""] || name == nil)
    {
        [self showAlertView:@"项目名称不能为空"];
        return;
    }
    [dict setObject:name forKey:@"projectName"];
    ///截止日期
    if (dateString.length == 0)
    {
        [self showAlertView:@"截止日期不能为空"];
        return;
    }

    NSString *year = [dateString substringToIndex:4];
    if (year.intValue >2099)
    {
        [self showAlertView:@"截止日期过大，请重新选择"];
        return;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:dateString];
    if ([date compare:[NSDate date]] == NSOrderedAscending)
    {
        [self showAlertView:@"截止日期必须大于今天"];
        return;
    }
    
//    [dict setObject:dateString forKey:@"projectEndTime"];
    [dict setObject:dateString forKey:@"endTime"];
    
    ///项目描述
    CreateProjectCell *descCell = (CreateProjectCell *)[publishTable cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]];
//    UITextView *textView = (UITextView *)[descCell viewWithTag:9001];
//    NSString *descString = [textView text];
    NSString *descString = tmpDesc;
    if ([descString isEqualToString:@""] || descString == nil)
    {
        [self showAlertView:@"项目描述不能为空"];
        return;
    }
    else if (descString.length > 200)
    {
        [self showAlertView:@"项目描述不能超过200个字"];
        return;

    }
    [dict setObject:descString forKey:@"projectDescibe"];
    
    ///项目金额
    if (priceTagString.length == 0)
    {
        [self showAlertView:@"请选择项目金额"];
        return;
    }
    [dict setObject:priceTagString forKey:@"projectPrice"];
    
    ///项目标签
    if (tagString.length == 0)
    {
        [self showAlertView:@"请选择标签"];
        return;
    }
    [dict setObject:tagString forKey:@"projectTags"];
    

    ///当前人的头像
    [dict setObject:[[UserInfo sharedInfo] userHeadPicture] forKey:@"projectLogo"];
    
    NSDictionary *picDic = [NSDictionary dictionaryWithObject:@"1" forKey:@"type"];
    
    __block NSMutableString *tmpString = [NSMutableString string];
    NSMutableArray *tmpPicArray = [NSMutableArray array];
    for (id tmp in picItemArray)
    {
        if ([tmp isKindOfClass:[NSString class]])
        {
            tmpString = [[tmpString stringByAppendingFormat:@"%@,",tmp] mutableCopy];
        }
        else
        {
            [tmpPicArray addObject:tmp];
        }
    }

    if (tmpPicArray.count == 0)
    {
        ///项目图片
        tmpString = [tmpString substringToIndex:tmpString.length-1].mutableCopy;
        [dict setObject:tmpString forKey:@"projectPicture"];
        ///项目发布人名称
        [dict setObject:[[UserInfo sharedInfo] userName] forKey:@"projectPublishName"];
        ///项目发布人角色
        [dict setObject:[[UserInfo sharedInfo] userCompanyPosition] forKey:@"projectPublishPosition"];
        ///项目发布人所在城市
        [dict setObject:[[UserInfo sharedInfo] userCity] forKey:@"projectPlace"];
        ///上传信息
        [self publishItem:dict];
        return;
    }
    
    [TOHttpHelper postUrl:kTOPicUpload parameters:picDic showHUD:YES withMedia:tmpPicArray success:^(NSDictionary *dataDictionary) {
        
        
        ///项目图片
        NSString *picPath = [dataDictionary objectForKey:@"info"];
//        if (tmpString.length > 1)
//        {
//            tmpString = [tmpString stringByAppendingString:picPath].mutableCopy;
//        }
        [dict setObject:picPath forKey:@"projectPicture"];
        ///项目发布人名称
        [dict setObject:[[UserInfo sharedInfo] userName] forKey:@"projectPublishName"];
        ///项目发布人角色
        [dict setObject:[[UserInfo sharedInfo] userCompanyPosition] forKey:@"projectPublishPosition"];
        ///项目发布人所在城市
        [dict setObject:[[UserInfo sharedInfo] userCity] forKey:@"projectPlace"];
        ///上传信息
        [self publishItem:dict];
        
        
    } failure:^(NSError *error) {
        
        
    }];
    
    
}
///上传信息
-(void)publishItem:(NSMutableDictionary *)dict;
{
    NSString *string = kTOPublishProject;
    if ([self.title isEqualToString:@"项目编辑"])
    {
        string = kTOModifyProject;
    }
    
    [TOHttpHelper postUrl:string parameters:dict showHUD:YES success:^(NSDictionary *dataDictionary) {
        
        if ([self.title isEqualToString:@"项目编辑"])
        {
            [self showAlertView:@"项目编辑成功"];
        }
        else
        {
            [self showAlertView:@"项目发布成功"];
        }
        
        if ([[dataDictionary objectForKey:@"code"] isEqualToString:@"0"])
        {
            [self.delegate projectPublishSuccess];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        
    } failure:^(NSError *error) {
        
        
        
    }];
    
}
#pragma mark 点击界面其他地方
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UIView *view = [[[touches allObjects] lastObject] view];
    NSString *str = NSStringFromClass([view class]);
    if ([str rangeOfString:@"UIPicker"].location == NSNotFound)
    {
        [self hidePicker:priceDatePicker];
        [self hidePicker:pricePicker];
    }
}

#pragma mark UIPickerViewDelegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return priceArray.count;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSDictionary *dict = [priceArray objectAtIndex:row];
    return dict.allValues.lastObject;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (priceArray.count == 0)
    {
        return;
    }
    NSDictionary *dict = [priceArray objectAtIndex:row];
    priceTagString = [[dict allKeys] lastObject];
    CreateProjectCell *cell = (CreateProjectCell *)[publishTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    cell.contentLabel.text = [[dict allValues] lastObject];
}
#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 3;
    }
    return 1;
}
-(CreateProjectCell *)drawCellWithView:(UITableView *)tableView CellPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    CreateProjectCell *cell = (CreateProjectCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[CreateProjectCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:cellID];
    }
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            cell.titleLabel.text = @"项目名称";
            cell.contentLabel.text = @"请输入项目名称";
            if (tmpName != nil && ![tmpName isEqualToString:@""])
            {
                cell.contentLabel.text = tmpName;
            }
        }
        else if (indexPath.row == 1)
        {
            cell.titleLabel.text = @"截止征集日期";
            cell.contentLabel.text = @"请输入截止日期";
            if (tmpTime != nil && ![tmpTime isEqualToString:@""]) {
                cell.contentLabel.text = tmpTime;
            }
        }
        else if (indexPath.row == 2)
        {
            cell.titleLabel.text = @"项目金额";
        }
        [cell setBackgroundColor:[UIColor whiteColor]];

    }
    else if (indexPath.section == 1)
    {
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(9, 0, cell.frame.size.width, cell.frame.size.height)];
        [textView setDelegate:self];
        [textView setTag:9001];
        [textView setReturnKeyType:(UIReturnKeyDone)];
        [cell.contentView addSubview:textView];
        [cell setBackgroundColor:[UIColor whiteColor]];
        [cell addSubview:placeLable];
        if (tmpDesc != nil && ![tmpDesc isEqualToString:@""])
        {
            [placeLable setHidden:YES];
            textView.text = tmpDesc;
        }
    }
//    else if (indexPath.section == 2)
//    {
//        cell.titleLabel.text = @"项目金额";
//        [cell setBackgroundColor:[UIColor whiteColor]];
//
//        
//    }
    else if (indexPath.section == 2)
    {
        [cell.contentView addSubview:tagView];
        [cell setBackgroundColor:[UIColor colorWithHexString:kDefaultBackColor]];

    }
    else if (indexPath.section == 3)
    {
        [cell.contentView addSubview:itemCollection];
        [cell setBackgroundColor:[UIColor colorWithHexString:kDefaultBackColor]];
    }
    
    [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    return cell;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CreateProjectCell *cell = (CreateProjectCell *)[self drawCellWithView:tableView CellPath:indexPath];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 10;
    }
    return 30;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || indexPath.section == 2)
    {
        return 44;
    }
    else if (indexPath.section == 1)
    {
        return 100;
    }
    else
    {
        int num = 0;
        if (picItemArray.count == 0)
        {
            return 105;
        }
        else if (picItemArray.count <= 4)
        {
            num = 1;
        }
        else if (picItemArray.count > 4 && picItemArray.count <=8)
        {
            num = 2;
        }
        else
        {
            num = 3;
        }
        return 100 * num;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 2 || section == 3)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 15)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, self.view.frame.size.width, 15)];
        if (section == 2)
        {
            [label setText:@"设置项目标签"];
            UIButton *setTagButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
            [setTagButton setFrame:CGRectMake(self.view.frame.size.width-80, 8, 80, 15)];
            [setTagButton setTitle:@"设置标签" forState:(UIControlStateNormal)];
            [setTagButton setTitleColor:[UIColor colorWithRed:43.0 / 255.0 green:82.0 / 255.0 blue:123.0 / 255.0 alpha:1.0] forState:(UIControlStateNormal)];
            setTagButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
            [setTagButton addTarget:self action:@selector(clickSetTagButton) forControlEvents:(UIControlEventTouchUpInside)];
            [view addSubview:setTagButton];
        }
        else
        {
            [label setText:@"添加图片"];
        }
        [label setTextColor:[UIColor colorWithRed:43.0 / 255.0 green:82.0 / 255.0 blue:123.0 / 255.0 alpha:1.0]];
        [label setFont:[UIFont systemFontOfSize:16.0f]];
        [view addSubview:label];
//        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(5, 14, self.view.frame.size.width-10, 1)];
//        [lineView setBackgroundColor:[UIColor colorWithHexString:kDefaultTextColor]];
//        [view addSubview:lineView];
        return view;
    }
    else if (section == 1)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 15)];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, self.view.frame.size.width, 15)];
        [titleLabel setText:@"项目描述"];
        [titleLabel setTextColor:[UIColor colorWithRed:43.0 / 255.0 green:82.0 / 255.0 blue:123.0 / 255.0 alpha:1.0]];
        [titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
        [view addSubview:titleLabel];
        return view;
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            SetInfoViewController *setInfo = [[SetInfoViewController alloc] init];
            setInfo.controllerTitle = [NSString stringWithFormat:@"设置名称"];
            CreateProjectCell *cell = (CreateProjectCell *)[tableView cellForRowAtIndexPath:indexPath];
            setInfo.placeString = cell.contentLabel.text;
            [setInfo setDelegate:self];
            setInfo.title = @"设置名称";
            [self.navigationController pushViewController:setInfo animated:YES];
        }
        else if(indexPath.row == 1)
        {
            [self showPicker:priceDatePicker];
        }
        else if (indexPath.row == 2)
        {
            [self showPicker:pricePicker];
        }
    }
//    else if (indexPath.section == 2)
//    {
//        [self showPicker:pricePicker];
//    }
    else if (indexPath.section == 2)
    {
    }
    else if (indexPath.section == 3)
    {
        ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
        picker.maximumNumberOfSelection = 9;
        picker.assetsFilter = [ALAssetsFilter allPhotos];
        picker.showEmptyGroups = NO;
        picker.delegate = self;
        picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings)
        {
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
}
#pragma mark 图片选择完毕
-(void)assetPickerControllerDidMaximum:(ZYQAssetPickerController *)picker
{
    [HUDView showHUDWithText:@"选择数目已经达到最大"];
}
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    for (int i=0; i<assets.count; i++)
    {
        NSData *data = assets[i];
        NSString *picName = [NSString stringWithFormat:@"%f",[NSDate timeIntervalSinceReferenceDate]];
        
//        NSString *fileName = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@.jpg",picName];
//        if ([data writeToFile:fileName atomically:YES])
//        {
            SLHttpFileData *imageData = [[SLHttpFileData alloc] init];
            [imageData setData:data];
            NSString *name = [NSString stringWithFormat:@"%@.jpg",picName];
            [imageData setParameterName:name];
            [imageData setFileName:name];
            [imageData setMimeType:@"image/jpeg"];
            
            [picItemArray addObject:imageData];
//        }
    }
    int num = 0;
    if (picItemArray.count <= 4)
    {
        num = 1;
    }
    else if (picItemArray.count > 4 && picItemArray.count <=8)
    {
        num = 2;
    }
    else
    {
        num = 3;
    }

    [itemCollection setFrame:CGRectMake(0, 0, self.view.frame.size.width, num * 100)];
    [itemCollection reloadData];
//    CreateProjectCell *cell = (CreateProjectCell *)[publishTable cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:4]];
//    [cell reloadInputViews];
//    [publishTable reloadData];
    [publishTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:3]] withRowAnimation:(UITableViewRowAnimationNone)];
}
-(void)assetPickerControllerDidCancel:(ZYQAssetPickerController *)picker
{
    
}

#pragma mark UITextView Delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
{
    if ([text isEqualToString:@"\n"])
    {
        [textView endEditing:YES];
    }
    
    return YES;
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [self hidePicker:priceDatePicker];
    [self hidePicker:pricePicker];
}
- (void) textViewDidChange:(UITextView *)textView{
    if ([textView.text length] == 0) {
        [placeLable setHidden:NO];
    }else{
        [placeLable setHidden:YES];
        tmpDesc = textView.text;
    }
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
#pragma mark 显示弹窗
-(void)showAlertView:(NSString *)message
{
    [HUDView showHUDWithText:message];
}
#pragma mark 标签选择完毕
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
    if (tagsArray.count != 0)
    {
        [tmpLabel setHidden:YES];
    }
}
#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex ==1)
    {
        NSString *title = [[alertView textFieldAtIndex:0] text];
        
        CreateProjectCell *cell = (CreateProjectCell *)[publishTable cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        cell.contentLabel.text = title;
    }
}
#pragma mark UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (picItemArray.count == 9)
    {
        return 9;
    }
    return picItemArray.count + 1;
}
///定义每个cell的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(67.5, 90);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 5, 10);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *collectionCell = @"collection";
    SingleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCell forIndexPath:indexPath];
    cell.tag = indexPath.row;
    

    if (picItemArray.count > indexPath.row)
    {
        id object = [picItemArray objectAtIndex:indexPath.row];
        if ([object isKindOfClass:[NSString class]])
        {
            NSString *picStr = [NSString stringWithFormat:@"%@%@/%@",kTOHOSt,kTOProjectPicPath,object];
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:picStr] placeholderImage:kDefaultIcon];
            cell.delegate = self;
            cell.delButton.hidden = NO;
        }
        else
        {
            SLHttpFileData *member = object;
            cell.imageView.image = [UIImage imageWithData:member.data];
            cell.delegate = self;
            cell.delButton.hidden = NO;

        }
    }
    else
    {
        cell.imageView.image = [UIImage imageNamed:@"添加照片"];
        cell.delButton.hidden = YES;
    }
    cell.backgroundColor = [UIColor colorWithHexString:kDefaultBackColor];
    
    if (picItemArray.count == 0)
    {
        addLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 75, 67.5, 10)];
        addLabel.text = @"添加图片";
        [addLabel setTextColor:[UIColor darkGrayColor]];
        addLabel.font = [UIFont systemFontOfSize:13.0f];
        [cell.contentView addSubview:addLabel];
    }
    
    return cell;
}
#pragma mark 点击图片下面的删除键
-(void)clickDeleButton:(SingleCollectionViewCell *)sender
{
    [picItemArray removeObjectAtIndex:sender.tag];
    [itemCollection reloadData];
}
-(void)setInfoSuccess:(NSString *)value withTag:(NSInteger)tagTmp
{
    CreateProjectCell *cell = (CreateProjectCell *)[publishTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.contentLabel.text = value;
    tmpName = value;
    [publishTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:(UITableViewRowAnimationNone)];

}
#pragma mark 点击设置标签
-(void)clickSetTagButton
{
    TagsViewController *tagsView = [[TagsViewController alloc] init];
    tagsView.isCompleteInfo = YES;
    [tagsView setDelegate:self];
    [self.navigationController pushViewController:tagsView animated:YES];

}

@end
