//
//  ProjectInfoController.m
//  TaskOffer
//
//  Created by BourbonZ on 15/3/18.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "ProjectInfoController.h"
#import "PriceView.h"
#import "ProjectTagView.h"
#import "TOHttpHelper.h"
#import "SLConnectionMoreView.h"
#import "ProjectInfo.h"
#import "SingleChatController.h"
#import "UserInfo.h"
#import "SingleCollectionViewCell.h"
#import "ProjectPublishController.h"
#import "ProjectEditInfoController.h"
#import "FriendSelectViewController.h"
#import "SetInfoViewController.h"
#import "ProjectInfoCell.h"
#import "SLTagFrameModel.h"
#import "SLTagView.h"
#import "MJPhotoBrowser.h"
@interface ProjectInfoController ()<UITableViewDataSource,UITableViewDelegate,SLConnectionMoreViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,ProjectPublishControllerDelegate,SetInfoViewControllerDelegate>
{
    NSArray *infoArray;
    NSArray *titleArray;
    SLConnectionMoreView *moreView;
    ProjectInfo *projectInfo;
    UICollectionView *itemCollection;
    NSMutableArray *picArray;

    UILabel *titleLabel;
    UITableView *infoTable;
    PriceView *price;
    
    NSString *_collectID;
    
    UITextView *nameTextView;
}

@end

@implementation ProjectInfoController
@synthesize ifMyProject;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"项目详情";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"更多按钮"] style:(UIBarButtonItemStylePlain) target:self action:@selector(clickMoreButton:)];
    
    nameTextView = [[UITextView alloc] initWithFrame:CGRectZero];
    [nameTextView setTextColor:[UIColor grayColor]];
    nameTextView.font = [UIFont systemFontOfSize:14.0f];
    
    ///设置滚动视图
    infoTable = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
    [infoTable setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-50)];
    if (ifMyProject)
    {
        [infoTable setFrame:self.view.frame];
    }
    
    [infoTable setDelegate:self];
    [infoTable setDataSource:self];
    [infoTable setBackgroundColor:[UIColor colorWithHexString:kDefaultGrayColor]];
    [infoTable setSeparatorStyle:(UITableViewCellSeparatorStyleNone)];
    
    
    ///设置表格的上方头
    UIView *headView = [[UIView alloc] init];
    [headView setBounds:CGRectMake(0, 0, self.view.frame.size.width, 70.0)];
    [headView setBackgroundColor:[UIColor whiteColor]];
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 70.0)];
    [titleLabel setTextAlignment:NSTextAlignmentLeft];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
    titleLabel.numberOfLines = 0;
    [titleLabel setLineBreakMode:(NSLineBreakByWordWrapping)];
    [headView addSubview:titleLabel];
    
    price = [[PriceView alloc] init];
    price.lowPriceLabel.text = @"0W-";
    price.highPriceLabel.text = @"0W";
    [price setCenter:CGPointMake(self.view.frame.size.width-40, 35)];
    [headView addSubview:price];
        
    [infoTable setTableHeaderView:headView];
    [self.view addSubview:infoTable];
    
    ///准备数据
    infoArray = @[@"项目发布人:",@"发布人身份:",@"发布人公司:",@"项目发布日期:",@"截止征集日期:"];
    titleArray = @[@"项目标签",@"基本信息",@"项目信息",@"图片附件"];
    
    ///下方的按钮
    UIButton *acceptButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [acceptButton setTitle:@"接项目" forState:(UIControlStateNormal)];
    [acceptButton setBounds:CGRectMake(0, 0, 300, 35)];
    acceptButton.layer.masksToBounds = NO;
    acceptButton.layer.cornerRadius = 6.0f;
    [acceptButton setCenter:CGPointMake(self.view.frame.size.width/2, 25)];
    [acceptButton addTarget:self action:@selector(clickAcceptProject) forControlEvents:(UIControlEventTouchUpInside)];
    [acceptButton setBackgroundColor:[UIColor colorWithHexString:kDefaultOrgangeColor]];
    
    if (!ifMyProject)
    {
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-50, self.view.frame.size.width, 50)];
        [toolBar addSubview:acceptButton];
        toolBar.tag = 2001;
        [self.view addSubview:toolBar];        
    }

    
//    [self.view setBackgroundColor:[UIColor colorWithHexString:kDefaultGrayColor]];
    
    ///moreview
    if (ifMyProject)
    {
        moreView = [[SLConnectionMoreView alloc] initWithFrame:CGRectMake(0, 64, 0, 0) buttonItemTitles:@[@"推荐项目给好友",@"编辑项目",@"关闭项目"]];
    }
    else
    {
        moreView = [[SLConnectionMoreView alloc] initWithFrame:CGRectMake(0, 64, 0, 0) buttonItemTitles:@[@"推荐项目给好友",@"收藏项目"]];
    }
    [moreView setDelegate:self];
    
    
    ///图片显示界面
    ///项目图片
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    itemCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 5, self.view.frame.size.width, 100) collectionViewLayout:layout];
    [itemCollection registerClass:[SingleCollectionViewCell class] forCellWithReuseIdentifier:@"collection"];
    itemCollection.backgroundColor = [UIColor whiteColor];
    [itemCollection setDataSource:self];
    [itemCollection setDelegate:self];
    picArray = [NSMutableArray array];

    
    projectInfo = [[ProjectInfo alloc] init];
    
    [self getProjectInfo];
}
#pragma mark 获取项目详情
-(void)getProjectInfo
{
    ///获取项目详情
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:self.projectID,@"projectId",[[UserInfo sharedInfo] userID],@"userId", nil];
    
    [TOHttpHelper getUrl:kTOGetProjectInfo parameters:dict showHUD:YES success:^(NSDictionary *dataDictionary) {
        
        [projectInfo setProjectDict:[dataDictionary objectForKey:@"info"]];
        _collectID = [[dataDictionary objectForKey:@"info"] objectForKey:@"collectId"];
        if ([projectInfo.projectLeadId isEqualToString:[[UserInfo sharedInfo] userID]])
        {
            UIToolbar *toolBar = (UIToolbar *)[self.view viewWithTag:2001];
            toolBar.hidden = YES;
        }
        
        if (projectInfo.projectStatus.boolValue)
        {
            [HUDView showHUDWithText:@"项目已经被关闭"];
            [self.navigationController popViewControllerAnimated:YES];
            return ;
        }
        [infoTable reloadData];
        [titleLabel setText:projectInfo.projectName];
        
        CGSize titleSize = [titleLabel sizeThatFits:CGSizeMake(self.view.frame.size.width - 80.0, 70.0)];
        
        [titleLabel setFrame:CGRectMake(10.0, (70.0 - titleSize.height) * 0.5, titleSize.width, titleSize.height)];
        
        BOOL isCollect = [[[dataDictionary objectForKey:@"info"] objectForKey:@"isCollect"] boolValue];
        if (isCollect && !ifMyProject)
        {
            [moreView replaceButtonItemTitle:@"取消收藏" withIndex:1];
        }
        
        NSString *priceString = projectInfo.projectPrice;
        if ([priceString rangeOfString:@"以上"].location != NSNotFound)
        {
            price.lowPriceLabel.text = [priceString substringToIndex:priceString.length-2];
            price.highPriceLabel.text = @"以上";
        }
        else if ([priceString rangeOfString:@"以内"].location != NSNotFound)
        {
            price.lowPriceLabel.text = [priceString substringToIndex:priceString.length-2];
            price.highPriceLabel.text = @"以内";
        }
        else
        {
            NSArray *priceArray = [priceString componentsSeparatedByString:@"~"];
            NSString *low = priceArray.firstObject;
            NSString *high = priceArray.lastObject;
            price.lowPriceLabel.text = [low stringByAppendingString:@"~"];
            price.highPriceLabel.text = [@"~" stringByAppendingString:high];
        }
        
        
        NSString *picString = projectInfo.projectPicture;
        picArray = [[picString componentsSeparatedByString:@","] mutableCopy];
        NSString *str = [picArray lastObject];
        if (str.length == 0)
        {
            [picArray removeLastObject];
        }
        if (picArray.count >= 5 && picArray.count <= 8)
        {
            [itemCollection setFrame:CGRectMake(0, 0, self.view.frame.size.width, 80*2)];
        }
        else if (picArray.count == 9)
        {
            [itemCollection setFrame:CGRectMake(0, 0, self.view.frame.size.width, 80*3)];
        }
        [itemCollection reloadData];
        [infoTable reloadData];
        
    }];

}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [moreView hide];
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
#pragma mark 点击更多按钮
-(void)clickMoreButton:(UIButton *)button
{
    [moreView showInView:self.view];
//    UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(100, 0, 100, 50)];
//    [tmpView setBackgroundColor:[UIColor redColor]];
//    
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
//    animation.toValue = [NSNumber numberWithInt:50];
//    animation.duration = 0.3f;
//    animation.removedOnCompletion = NO;
//    animation.repeatCount = 1;
//    animation.fillMode = kCAFillModeForwards;
//    [tmpView.layer addAnimation:animation forKey:nil];
//    [self.view addSubview:tmpView];
}
#pragma mark 点击接包按钮
-(void)clickAcceptProject
{
    
//    NSMutableDictionary *stateDict = [NSMutableDictionary dictionary];
//    [stateDict setObject:[[UserInfo sharedInfo] userID] forKey:@"srcID"];
//    [stateDict setObject:projectInfo.projectLeadId forKey:@"tarID"];
//    [TOHttpHelper getUrl:kTOgetChatStatus parameters:stateDict showHUD:YES success:^(NSDictionary *dataDictionary) {
    
        
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:projectInfo.projectID forKey:@"projectId"];
        [dict setObject:[NSString stringWithFormat:@"%d",projectInfo.projectConverse+1] forKey:@"projectConverse"];
        [TOHttpHelper postUrl:kTOModifyProject parameters:dict showHUD:YES success:^(NSDictionary *dataDictionary) {
            
            if ([[dataDictionary objectForKey:@"code"] isEqualToString:@"0"])
            {
                SingleChatController *single = [[SingleChatController alloc] init];
                single.currentUserName = projectInfo.projectLeadId;
                single.projectOwner = projectInfo.projectPublish;
                single.projectName = projectInfo.projectName;
                single.projectID = projectInfo.projectID;
                [self.navigationController pushViewController:single animated:YES];
            }
            else
            {
                [HUDView showHUDWithText:[dataDictionary objectForKey:@"info"]];
            }
        } failure:^(NSError *error) {
            
        }];
        
        
//    }];
}
#pragma mark UITableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 || section == 2 || section == 3)
    {
        return 1;
    }
    return 5;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:nil];
        [cell setBackgroundColor:[UIColor whiteColor]];

//        ProjectTagView *tagView = [[ProjectTagView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, 0)];
//        if (projectInfo.projectTags.length > 0)
//        {
        NSArray *array = [NSArray array];
        if ([projectInfo.projectTags rangeOfString:@","].location == NSNotFound)
        {
            array = @[projectInfo.projectTags];
        }
        else
        {
            array = [projectInfo.projectTags componentsSeparatedByString:@","];
        }
//        }
        SLTagView *tagView = [[SLTagView alloc] init];
        tagView.tagFrameModel = [[SLTagFrameModel alloc] initWithTags:array];
//        [tagView setCenter:CGPointMake(self.view.frame.size.width/2, cell.frame.size.height/2-18)];
        [cell.contentView addSubview:tagView];
        [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
        return cell;
    }
    else if (indexPath.section == 1)
    {
        static NSString *cellID = @"cell";
        ProjectInfoCell *cell = (ProjectInfoCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil)
        {
            cell = [[ProjectInfoCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:cellID];
        }
        cell.titleLabel.text = [infoArray objectAtIndex:indexPath.row];
        if (indexPath.row == 0)
        {
            NSString *name = [[projectInfo.projectPublish componentsSeparatedByString:@"   "] firstObject];
            cell.contentLabel.text =name;
        }
        else if (indexPath.row == 1)
        {
            cell.contentLabel.text = projectInfo.projectPublishPosition;
        }
        else if (indexPath.row == 2)
        {
            NSString *name = projectInfo.projectPublish;
            if (name == nil || [name isEqualToString:@""])
            {
                name = [[projectInfo.projectPublish componentsSeparatedByString:@"   "] lastObject];
            }
            
            if (name == nil || [name isEqualToString:@""])
            {
                name = @"用户暂未设置";
            }
            
            if ([name rangeOfString:@"   "].location != NSNotFound)
            {
                NSString *tmp = [[name componentsSeparatedByString:@"   "] lastObject];
                if (tmp != nil && ![tmp isEqualToString:@""] && ![tmp isEqualToString:@"   "])
                {
                    name = tmp;
                }
            }
            
            cell.contentLabel.text = name;
        }
        else if (indexPath.row == 3)
        {
            cell.contentLabel.text = projectInfo.createTime;
        }
        else if (indexPath.row == 4)
        {
            cell.contentLabel.text = projectInfo.projectDeadLine;
        }
        [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
        return cell;
    }
    else if (indexPath.section == 2)
    {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:nil];
        [cell setBackgroundColor:[UIColor whiteColor]];
        nameTextView.text = projectInfo.projectDescibe;
        [nameTextView setEditable:NO];
        [nameTextView setBackgroundColor:[UIColor whiteColor]];
        nameTextView.tag = 3003;
        [cell.contentView addSubview:nameTextView];
        [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
        return cell;
    }
    else
    {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:nil];
        [cell setBackgroundColor:[UIColor whiteColor]];
        [cell addSubview:itemCollection];
        [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2)
    {
        if (projectInfo.projectDescibe.length > 0)
        {
            CGRect rect = [projectInfo.projectDescibe boundingRectWithSize:CGSizeMake(self.view.frame.size.width, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:nil context:nil];
            
            float height = rect.size.height;
            if (height < 60)
            {
                height = 60;
            }
            
            [nameTextView setFrame:CGRectMake(8, 0, self.view.frame.size.width-16, height+30)];
            return nameTextView.frame.size.height;
        }
        return 60;
    }
    else if (indexPath.section == 3)
    {
        if (picArray.count >= 5 && picArray.count <= 8)
        {
            return 80*2;
        }
        else if (picArray.count == 9)
        {
            return 80*3;
        }
        return 80;
    }
    else if (indexPath.section == 0)
    {
        NSArray *array = [NSArray array];
        if ([projectInfo.projectTags rangeOfString:@","].location == NSNotFound)
        {
            array = @[projectInfo.projectTags];
        }
        else
        {
            array = [projectInfo.projectTags componentsSeparatedByString:@","];
        }
        //        }
        SLTagFrameModel *model = [[SLTagFrameModel alloc] initWithTags:array];

        
        return model.tagViewHeight;
    }
    return 30;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 5, self.view.frame.size.width, 35)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, self.view.frame.size.width, 28)];
    [label setText:[NSString stringWithFormat:@"%@",[titleArray objectAtIndex:section]]];
//    [label setTextColor:[UIColor colorWithHexString:kDefaultTextColor]];
    [label setTextColor:[UIColor colorWithRed:43.0 / 255.0 green:82.0 / 255.0 blue:123.0 / 255.0 alpha:1.0]];
    [label setFont:[UIFont systemFontOfSize:16.0f]];
    [view setBackgroundColor:[UIColor whiteColor]];
    [view addSubview:label];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 28+5, self.view.frame.size.width, 0.5)];
    [lineView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.2]];
    [view addSubview:lineView];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 5)];
    [footView setBackgroundColor:[UIColor colorWithHexString:kDefaultGrayColor]];
    [view addSubview:footView];
    return view;
}
#pragma mark SLConnectionMoreView Delegate
-(void)connectionMoreView:(SLConnectionMoreView *)connectionMoreView didClickButtonItemAtIndex:(NSInteger)buttonItemIndex
{
    
    NSString *title = [connectionMoreView buttonItemTitleWithIndex:buttonItemIndex];
    if ([title isEqualToString:@"推荐项目给好友"])
    {
        FriendSelectViewController *selectFriend = [[FriendSelectViewController alloc] init];
        selectFriend.selectType = projectRecommend;
        selectFriend.projectInfo = projectInfo;
        selectFriend.controller = self;
        selectFriend.title = @"发送项目";
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:selectFriend];
        [self presentViewController:navi animated:YES completion:nil];
    }
    else if ([title isEqualToString:@"编辑项目"])
    {
        ProjectEditInfoController *editInfo = [[ProjectEditInfoController alloc] init];
        editInfo.projectInfo = projectInfo;
        editInfo.delegate = self;
        [self.navigationController pushViewController:editInfo animated:YES];
    }
    else if ([title isEqualToString:@"收藏项目"])
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:projectInfo.projectID forKey:@"projectId"];
        UserInfo *user = [UserInfo sharedInfo];
        [dict setObject:user.userID forKey:@"userId"];
        [TOHttpHelper postUrl:kTOProjectCollect parameters:dict showHUD:YES success:^(NSDictionary *dataDictionary) {
            
            if ([[dataDictionary objectForKey:@"message"] isEqualToString:@"success"])
            {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"收藏完毕" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                _collectID = [dataDictionary objectForKey:@"info"] ;
                [moreView replaceButtonItemTitle:@"取消收藏" withIndex:1];
                [moreView hide];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:[dataDictionary objectForKey:@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            
        } failure:^(NSError *error) {
            
        }];
    }
    else if ([title isEqualToString:@"取消收藏"])
    {
        NSString *collect = @"";
        if (_collectID != nil)
        {
            collect = _collectID;
        }
        else if (projectInfo.collectId != nil)
        {
            collect= projectInfo.collectId;
        }
        [TOHttpHelper postUrl:kTOcancelCollect parameters:@{@"collectId":collect} showHUD:YES success:^(NSDictionary *dataDictionary) {
            
            [HUDView showHUDWithText:@"取消收藏成功"];
            [moreView replaceButtonItemTitle:@"收藏项目" withIndex:1];
            
        } failure:^(NSError *error) {
            
        }];
    }
    else if ([title isEqualToString:@"关闭项目"])
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:projectInfo.projectID forKey:@"id"];
        [dict setObject:@"1" forKey:@"projectStatus"];
        [TOHttpHelper postUrl:kTOModifyProject parameters:dict showHUD:YES success:^(NSDictionary *dataDictionary) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"项目关闭成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        } failure:^(NSError *error) {
            
        }];
    }
}
#pragma mark UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return picArray.count;
}
///定义每个cell的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.title isEqualToString:@"项目详情"]) {
        return CGSizeMake(67.5, 67.5);
    }
    return CGSizeMake(67.5, 90);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *collectionCell = @"collection";
    SingleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCell forIndexPath:indexPath];
    cell.tag = indexPath.row;
    
    NSString *path = [picArray objectAtIndex:indexPath.row];
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@",kTOHOSt,kTOProjectPicPath,path];
//    cell.imageView.picUrl = urlString;
//    cell.imageView.picTag = indexPath.row;

//    NSMutableArray *tmpPicArray = [NSMutableArray array];
//    for (NSString *tmp in picArray)
//    {
//        NSString *tmpUrl = [NSString stringWithFormat:@"%@%@/%@",kTOHOSt,kTOProjectPicPath,tmp];
//        [tmpPicArray addObject:tmpUrl];
//    }
//    cell.imageView.picArray = tmpPicArray.copy;
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:kDefaultIcon];
    cell.delButton.hidden = YES;
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *tmpArray = [NSMutableArray array];
    for (int i = 0; i < picArray.count; i++)
    {
        NSString *tmpUrl = [NSString stringWithFormat:@"%@%@/%@",kTOHOSt,kTOProjectPicPath,[picArray objectAtIndex:i]];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:tmpUrl];
        SingleCollectionViewCell *cell = (SingleCollectionViewCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        photo.srcImageView = cell.imageView;
        photo.index = i;
        [tmpArray addObject:photo];
    }
    
    MJPhotoBrowser *photoBrowser = [[MJPhotoBrowser alloc] init];
    photoBrowser.photos = tmpArray;
    photoBrowser.currentPhotoIndex = indexPath.row;
    [photoBrowser show];

}
#pragma mark 编辑项目完成
-(void)projectPublishSuccess
{
    [self getProjectInfo];
}
@end
