//
//  FriendSelectViewController.m
//  TaskOffer
//
//  Created by BourbonZ on 15/3/31.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "FriendSelectViewController.h"
#import "XMPPHelper.h"
#import "ChartCellFrame.h"
#import "ContactCell.h"
#import "SingleChatController.h"
#import "TOHttpHelper.h"
#import "ProjectTagView.h"
#import "MemberTableView.h"
#import "MBProgressHUD.h"
#import "TOHttpHelper.h"
@interface FriendSelectViewController ()<UITableViewDataSource,UITableViewDelegate,MemberTableViewDelegate>
{
    NSArray *addressArray;
    NSDictionary *valueDict;
    NSMutableArray *selectArray;
}
@end

@implementation FriendSelectViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.title = @"选择好友";
    
    ///所有好友
    addressArray = [XMPPHelper allMyFriendsWithState:kAllFriend];
    //    [addressArray addObjectsFromArray:[XMPPHelper allMyFriendsWithState:kAllFriend]];
    valueDict = [ToolHelper arrayToDictionary:addressArray];
    ///显示列表
    CustomTable *friendTable = [[CustomTable alloc] initWithFrame:self.view.frame style:(UITableViewStyleGrouped)];
    friendTable.dataSource = self;
    friendTable.delegate = self;
    [friendTable setSectionIndexBackgroundColor:[UIColor clearColor]];
    [friendTable setTag:9001];
    friendTable.backgroundColor = [UIColor colorWithHexString:kDefaultBackColor];
    [self.view addSubview:friendTable];
    
    selectArray = [NSMutableArray array];
    
    ///取消按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:(UIBarButtonItemStylePlain) target:self action:@selector(clickCancelButton)];
    ///发送按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:(UIBarButtonItemStylePlain) target:self action:@selector(clickSendButton)];
    
    NSString *itemID = @"";
    if (self.selectType == projectRecommend)
    {
        itemID = self.projectInfo.projectID;
    }
    else if (self.selectType == enterpriseRecommend)
    {
        itemID = self.enterpriseInfo.companyId;
    }
    
    if (itemID.length == 0)
    {
        return;
    }

    [TOHttpHelper getUrl:kTOgetUsersByProjectIdAndUserId parameters:@{@"userId":[[UserInfo sharedInfo] userID],@"projectId":itemID} showHUD:YES success:^(NSDictionary *dataDictionary) {

       
        
            NSArray *array = [dataDictionary objectForKey:@"info"];
            NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:addressArray];
            for (int i = 0; i < array.count; i++)
            {
                NSDictionary *dict = [array objectAtIndex:i];
                for (int j = 0; j< addressArray.count; j++)
                {
                    FriendUserInfo *info = [addressArray objectAtIndex:j];
                    if ([[dict objectForKey:@"id"] isEqualToString:info.userID])
                    {
                        [tmpArray removeObject:info];
                    }
                }
            }
        
            valueDict = [ToolHelper arrayToDictionary:tmpArray];
            [friendTable reloadData];
        
        ///标签列表
        if (self.selectType == projectRecommend)
        {
            UIView *titleView = [[UIView alloc] init];
            ProjectTagView *tagView = [[ProjectTagView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
            tagView.tagArray = [self.projectInfo.projectTags componentsSeparatedByString:@","];
            tagView.backgroundColor = [UIColor colorWithHexString:@"c8c8c8"];
            [titleView addSubview:tagView];
            
            MemberTableView *memberView = [[MemberTableView alloc] initWithFrame:CGRectMake(0, 35, self.view.frame.size.width, array.count * 100+20) style:(UITableViewStylePlain)];
            memberView.tag = 7002;
            memberView.memberArray = array;
            [memberView setMemberDelegate:self];
            [titleView addSubview:memberView];
            
            [titleView setFrame:CGRectMake(0, 0, self.view.frame.size.width, memberView.frame.size.height + memberView.frame.origin.y)];
            
            
            friendTable.tableHeaderView = titleView;
        }

    }];
    
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
#pragma mark 发送按钮
-(void)clickSendButton
{
    NSString *type = @"";
    NSString *text = @"";
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    if (self.selectType == projectRecommend)
    {
        ///0是企业号发布，1是个人发布
        NSString *icon = @"";
        if (self.projectInfo.projectType.intValue == 0)
        {
            icon = [NSString stringWithFormat:@"%@%@/%@",kTOHOSt,kTOCompanyPicPath,self.projectInfo.projectIcon];
        }
        else
        {
            icon = [NSString stringWithFormat:@"%@%@/%@",kTOHOSt,kTOUploadUserIcon,self.projectInfo.projectIcon];
        }
        ///头像地址
        [dict setObject:icon forKey:@"itemPicPath"];
        ///项目ID
        [dict setObject:self.projectInfo.projectID forKey:@"itemID"];
        [dict setObject:self.projectInfo.projectName forKey:@"itemName"];
        [dict setObject:self.projectInfo.projectContent forKey:@"itemContent"];
        NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:(NSJSONWritingPrettyPrinted) error:nil];
        text = [[NSString alloc] initWithData:data encoding:(NSUTF8StringEncoding)];

        type = kProject;


    }
    else if (self.selectType == enterpriseRecommend)
    {

        [dict setObject:[NSString stringWithFormat:@"%@%@/%@",kTOHOSt,kTOCompanyPicPath,self.enterpriseInfo.enterpriseIcon] forKey:@"itemPicPath"];
        [dict setObject:self.enterpriseInfo.companyId forKey:@"itemID"];
        [dict setObject:self.enterpriseInfo.enterpriseName forKey:@"itemName"];
        [dict setObject:self.enterpriseInfo.enterpriseContent forKey:@"itemContent"];
        NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
        text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        type = kCompany;

    }
    else if (self.selectType == caseRecommend)
    {
        [dict setObject:self.caseInfo.caseID forKeyedSubscript:@"itemID"];
        [dict setObject:self.caseInfo.caseName forKeyedSubscript:@"itemName"];
        [dict setObject:self.caseInfo.caseLogo forKeyedSubscript:@"itemPicPath"];
        [dict setObject:self.caseInfo.projectDesc forKeyedSubscript:@"itemContent"];
        NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
        text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        type = kCase;

    }
    else if (self.selectType == exchangeCards)
    {
        NSData *data = [NSJSONSerialization dataWithJSONObject:self.cardDict options:NSJSONWritingPrettyPrinted error:nil];
        text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        type = kCard;
    }

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (int i = 0; i < selectArray.count; i++)
    {
        NSString *tmpUser = [NSString stringWithFormat:@"%@@%@",[selectArray objectAtIndex:i],kDOMAIN];
        dispatch_async(queue, ^{
            [XMPPHelper sendMessage:tmpUser type:@"chat" message:text messageType:type duration:0];
        });
    }
    
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"发送成功";
        hud.margin = 15.0f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1];
        
    }];

}
#pragma mark 点击取消
-(void)clickCancelButton
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark UITableView 
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [valueDict allKeys].count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = [[[valueDict allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }] objectAtIndex:(section)];
    NSArray *array = [valueDict objectForKey:key];
    return array.count;
}
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSArray *array = [[valueDict allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
    return array;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *key = [[[valueDict allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }]objectAtIndex:(section)];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 25)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 25)];
    view.backgroundColor = [UIColor colorWithHexString:kDefaultGrayColor];
    [label setBackgroundColor:[UIColor colorWithHexString:kDefaultGrayColor]];
    key = [key uppercaseString];
    [label setText:key];
    [view addSubview:label];
    return view;
    
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }

    
    NSString *key = [[[valueDict allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }] objectAtIndex:(indexPath.section)];
    NSArray *array = [valueDict objectForKey:key];
    FriendUserInfo *object = [array objectAtIndex:indexPath.row];

    NSString *name = [[XMPPRosterHelper sharedHelper] remarkNameOrNickNameForFriend:object.userID];
    if ([object.userID isEqualToString:name])
    {
        [TOHttpHelper getUrl:kTOgetInfo parameters:@{@"id":object.userID,@"type":@"1"} showHUD:NO success:^(NSDictionary *dataDictionary) {
            
            NSString *name = [[[dataDictionary objectForKey:@"info"] objectForKey:@"ServerAppUser"] objectForKey:@"userName"];
            [[XMPPRosterHelper sharedHelper] changeNickForDatabase:name useID:object.userID];
            //好友信息
            addressArray = [[XMPPHelper allMyFriendsWithState:kAllFriend] mutableCopy];
            valueDict = [ToolHelper arrayToDictionary:addressArray];
            [tableView reloadData];
        }];
    }

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    ContactCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[ContactCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellID];
    }
    
    cell.redView.hidden = YES;
    NSString *key = [[[valueDict allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }] objectAtIndex:(indexPath.section)];
    NSArray *array = [valueDict objectForKey:key];
    FriendUserInfo *object = [array objectAtIndex:indexPath.row];
    cell.nameLabel.text = [[XMPPRosterHelper sharedHelper] remarkNameOrNickNameForFriend:object.userID];
    [TOHttpHelper getUrl:kTOgetInfo parameters:@{@"id":object.userID,@"type":@"1"} showHUD:NO success:^(NSDictionary *dataDictionary) {
        
        NSString *headPath = [NSString stringWithFormat:@"%@%@/%@",kTOHOSt,kTOUploadUserIcon,[[[dataDictionary objectForKey:@"info"] objectForKey:@"ServerAppUser"] objectForKey:@"userHeadPicture"]];
        
        [cell.iconView sd_setImageWithURL:[NSURL URLWithString:headPath] placeholderImage:kDefaultIcon];
    }];

    if ([selectArray containsObject:object])
    {
        cell.isSelected = YES;
    }
    else
    {
        cell.isSelected = NO;
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [[[valueDict allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }] objectAtIndex:(indexPath.section)];
    NSArray *array = [valueDict objectForKey:key];
    FriendUserInfo *object = [array objectAtIndex:indexPath.row];
    
    ContactCell *cell = (ContactCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.isSelected = !cell.isSelected;
    
    if ([selectArray containsObject:object.userID])
    {
        [selectArray removeObject:object.userID];
    }
    else
    {
        [selectArray addObject:object.userID];
    }
}
#pragma mark MemberTableViewDelegate
-(void)clickMemberOnIndex:(NSIndexPath *)index withProjectInfo:(UserInfo *)projectInfo
{
    if ([selectArray containsObject:projectInfo.userID])
    {
        [selectArray removeObject:projectInfo.userID];
    }
    else
    {
        [selectArray addObject:projectInfo.userID];
    }
}
@end
