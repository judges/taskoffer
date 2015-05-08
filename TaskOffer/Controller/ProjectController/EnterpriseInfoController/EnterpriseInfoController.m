//
//  EnterpriseInfoController.m
//  TaskOffer
//
//  Created by BourbonZ on 15/3/20.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "EnterpriseInfoController.h"
#import "ProjectTagView.h"
#import "CredentialViewController.h"
#import "TOHttpHelper.h"
#import "SLConnectionMoreView.h"
#import "UIImageView+WebCache.h"
#import "SLCaseViewController.h"
#import "SLBiddingProjectViewController.h"
#import "SLCaseDetailViewController.h"
#import "ProjectInfoController.h"
#import "SLConnectionDetailViewController.h"
#import "SLAuthenticationViewController.h"
#import "FriendSelectViewController.h"
#import "SLTagView.h"
#import "SLTagFrameModel.h"
#import "MJPhotoBrowser.h"
@interface EnterpriseInfoController ()<UITableViewDataSource,UITableViewDelegate,SLConnectionMoreViewDelegate>
{
    NSArray *enterpriseArray;
    SLConnectionMoreView *moreView;
    
    NSString *_qualificationName;
    NSString *_qualificationPicPath;
    NSString *_qualificationID;
    
    NSString *_caseName;
    NSString *_casePicPath;
    NSString *_caseID;
    
    NSString *_projectName;
    NSString *_projectPicPath;
    NSString *_projectID;
    
    NSString *_userName;
    NSString *_userPicPath;
    NSString *_userDesc;
    NSString *_userID;
    
    EnterpriseInfo *enterpriseInfo;
    NSString *_attentionID;
    int _tmpCompanyType;
}
@end

@implementation EnterpriseInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"企业号详情";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"更多按钮"] style:(UIBarButtonItemStylePlain) target:self action:@selector(clickMoreButton:)];
    
    ///准备数据
    enterpriseArray = [NSArray arrayWithObjects:@"行业标签",@"规模资质",@"案例库",@"项目库",@"认证员工", nil];
    
    ///准备表格
    UITableView *enterpriseTable = [[UITableView alloc] initWithFrame:self.view.frame style:(UITableViewStyleGrouped)];
    [enterpriseTable setDelegate:self];
    [enterpriseTable setDataSource:self];
    [enterpriseTable setBackgroundColor:[UIColor colorWithHexString:kDefaultGrayColor]];
    [enterpriseTable setSeparatorStyle:(UITableViewCellSeparatorStyleNone)];
    [self.view addSubview:enterpriseTable];
    
    ///设置表格上方的头
    UIView *headView = [[UIView alloc] init];
    ///图片
    UIImageView *enterpriseBackImage = [[TouchImageView alloc] init];
    [enterpriseBackImage setImage:[UIImage imageNamed:@"head"]];
    [enterpriseBackImage setFrame:CGRectMake(0, 0, self.view.frame.size.width, 140)];
    [headView addSubview:enterpriseBackImage];
    ///企业号头像
    UIImageView *iconView = [[UIImageView alloc] init];
    [iconView setBounds:CGRectMake(0, 0, 80, 80)];
    [iconView setCenter:CGPointMake(self.view.frame.size.width/2, 70)];
    iconView.layer.masksToBounds = YES;
    iconView.layer.cornerRadius = 40;
    iconView.layer.borderWidth = 2;
    iconView.layer.borderColor = [[UIColor whiteColor] CGColor];
    iconView.backgroundColor = [UIColor whiteColor];
    NSString *tmpIcon = [NSString stringWithFormat:@"%@%@/%@",kTOHOSt,kTOCompanyPicPath,self.companyInfo.enterpriseIcon];
    [iconView sd_setImageWithURL:[NSURL URLWithString:tmpIcon] placeholderImage:[UIImage imageNamed:@"图片不存在160"]];
    [enterpriseBackImage addSubview:iconView];
    ///标题
    UILabel *enterpriseTitleLabel = [[UILabel alloc] init];
    [enterpriseTitleLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
    [enterpriseTitleLabel setNumberOfLines:0];
    [enterpriseTitleLabel setText:self.companyInfo.enterpriseName];
    [enterpriseTitleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    CGSize titleSize = [enterpriseTitleLabel sizeThatFits:CGSizeMake(self.view.frame.size.width-10, 40)];
    [enterpriseTitleLabel setFrame:CGRectMake(10, enterpriseBackImage.frame.size.height+15, titleSize.width, titleSize.height)];
    [headView addSubview:enterpriseTitleLabel];
    ///公司规模
    UILabel *scaleLabel = [[UILabel alloc] init];
    [scaleLabel setTextAlignment:NSTextAlignmentLeft];
    scaleLabel.tag = 1001;
    NSString *string = [NSString stringWithFormat:@"%@%@人",@"公司规模:",self.companyInfo.companySize];
    NSUInteger stringLength = string.length;
    if (stringLength >= 6)
    {
        NSMutableAttributedString *scaleString = [[NSMutableAttributedString alloc] initWithString:string];
        [scaleString addAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor],NSFontAttributeName:[UIFont systemFontOfSize:15.0f]} range:NSMakeRange(0, 5)];
        [scaleString addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:kDefaultOrgangeColor],NSFontAttributeName:[UIFont systemFontOfSize:15.0f]} range:NSMakeRange(5, stringLength-6)];
        [scaleString addAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor],NSFontAttributeName:[UIFont systemFontOfSize:15.0f]} range:NSMakeRange(stringLength-1, 1)];
        scaleLabel.attributedText = scaleString;
    }
    else
    {
        scaleLabel.text = string;
    }
    
    [scaleLabel setFrame:CGRectMake(10, enterpriseTitleLabel.frame.size.height+enterpriseTitleLabel.frame.origin.y+10, self.view.frame.size.width-10, titleSize.height)];
    [headView addSubview:scaleLabel];
    ///公司地址
    UILabel *addressLabel = [[UILabel alloc] init];
    [addressLabel setTextColor:[UIColor grayColor]];
    [addressLabel setText:[@"公司地址:" stringByAppendingString:self.companyInfo.companyAddress]];
    [addressLabel setNumberOfLines:0];
    [addressLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [addressLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    CGSize addressSize = [addressLabel sizeThatFits:CGSizeMake(self.view.frame.size.width, 40)];
    [addressLabel setFrame:CGRectMake(10, scaleLabel.frame.size.height+scaleLabel.frame.origin.y+5, self.view.frame.size.width-20, addressSize.height)];
    [headView addSubview:addressLabel];
    ///公司简介
    UILabel *introLabel = [[UILabel alloc] init];
    [introLabel setTextColor:[UIColor grayColor]];
    [introLabel setNumberOfLines:0];
    [introLabel setText:self.companyInfo.enterpriseContent];
    [introLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [introLabel setFont:[UIFont systemFontOfSize:14.0f]];
    CGSize introSize = [introLabel sizeThatFits:CGSizeMake(self.view.frame.size.width, 100)];
    [introLabel setFrame:CGRectMake(10, addressLabel.frame.size.height + addressLabel.frame.origin.y, self.view.frame.size.width-20, introSize.height + 20)];
    [headView addSubview:introLabel];
    [headView setFrame:CGRectMake(0, 0, self.view.frame.size.width, introLabel.frame.size.height+introLabel.frame.origin.y+5)];
    UIView *tmpFootView = [[UIView alloc] initWithFrame:CGRectMake(0, introLabel.frame.size.height+introLabel.frame.origin.y, self.view.frame.size.width, 5)];
    [tmpFootView setBackgroundColor:[UIColor colorWithHexString:kDefaultGrayColor]];
    [headView addSubview:tmpFootView];
    [headView setBackgroundColor:[UIColor whiteColor]];
    enterpriseTable.tableHeaderView = headView;
    
    
    ///右上角的更多按钮
    ///更多按钮
//    moreView = [[SLConnectionMoreView alloc] initWithFrame:CGRectMake(0, 64, 0, 0) buttonItemTitles:@[@"发送给好友",@"发送给群聊",@"关注"]];
    moreView = [[SLConnectionMoreView alloc] initWithFrame:CGRectMake(0, 64, 0, 0) buttonItemTitles:@[@"发送给好友",@"关注"]];

    [moreView setDelegate:self];

    
    ///准备数据
    _qualificationName = @"";
    _qualificationPicPath = @"";
    _caseName = @"";
    _casePicPath = @"";
    _projectName = @"";
    _projectPicPath = @"";
    _userName = @"";
    _userPicPath = @"";
    
    ///网络请求
    ///获取资质
    NSMutableDictionary *companyDict = [NSMutableDictionary dictionary];
    [companyDict setObject:self.companyInfo.companyId forKey:@"companyId"];
    [companyDict setObject:@"0" forKey:@"page"];
    [companyDict setObject:@"1" forKey:@"rows"];
    [TOHttpHelper postUrl:kTOGetCompanyQualification parameters:companyDict showHUD:YES success:^(NSDictionary *dataDictionary) {
        
        _qualificationName = [[[[dataDictionary objectForKey:@"info"] objectForKey:@"rows"] firstObject] objectForKey:@"qualificationName"];
        _qualificationPicPath = [NSString stringWithFormat:@"%@%@/%@",kTOHOSt,kTOQualificationPicPath,[[[[dataDictionary objectForKey:@"info"] objectForKey:@"rows"] firstObject]objectForKey:@"companyPicture"]];
        _qualificationID = [[[[dataDictionary objectForKey:@"info"] objectForKey:@"rows"] firstObject] objectForKey:@"companyId"];
        
        [enterpriseTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:1]] withRowAnimation:(UITableViewRowAnimationNone)];
        
    } failure:^(NSError *error) {
        
    }];
    
    ///认证用户
    [TOHttpHelper postUrl:kTOGetUsersList parameters:companyDict showHUD:YES success:^(NSDictionary *dataDictionary) {
        
        int total = [[[dataDictionary objectForKey:@"info"] objectForKey:@"total"] intValue];
        if (total == 0)
        {
            return ;
        }
        
        _userName = [[[[dataDictionary objectForKey:@"info"] objectForKey:@"rows"] firstObject] objectForKey:@"userName"];
        _userPicPath = [NSString stringWithFormat:@"%@%@/%@",kTOHOSt,kTOUploadUserIcon,[[[[dataDictionary objectForKey:@"info"] objectForKey:@"rows"] firstObject] objectForKey:@"userHeadPicture"]];
        
        _userDesc = [[[[dataDictionary objectForKey:@"info"] objectForKey:@"rows"] firstObject] objectForKey:@"userCompanyPosition"];
        _userID = [[[[dataDictionary objectForKey:@"info"] objectForKey:@"rows"] firstObject] objectForKey:@"id"];
        [enterpriseTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:enterpriseArray.count - 1]] withRowAnimation:UITableViewRowAnimationNone];
        
    } failure:^(NSError *error) {
        
    }];
    
    ///企业号详情
    enterpriseInfo = [[EnterpriseInfo alloc] init];

    [TOHttpHelper getUrl:kTOGetCompanyInfo parameters:@{@"companyId":self.companyInfo.companyId,@"userId":[[UserInfo sharedInfo] userID]} showHUD:YES success:^(NSDictionary *dataDictionary) {
       
        [enterpriseInfo setEnterpriseDict:[dataDictionary objectForKey:@"info"]];
        
        BOOL isAttention = [[[dataDictionary objectForKey:@"info"] objectForKey:@"isAttention"] boolValue];
        if (isAttention)
        {
            [moreView replaceButtonItemTitle:@"取消关注" withIndex:1];
        }
        
        ///判断企业是甲方还是乙方 企业类别，0：甲方；1：乙方；2：其他；
        _tmpCompanyType = [[[dataDictionary objectForKey:@"companyInfo"] objectForKey:@"companyType"] intValue];
        if (_tmpCompanyType == 0)
        {
            ///甲方
            enterpriseArray = [NSArray arrayWithObjects:@"行业标签",@"规模资质",@"项目库",@"认证员工", nil];
        }
        else if(_tmpCompanyType == 1)
        {
            ///乙方
            enterpriseArray = [NSArray arrayWithObjects:@"行业标签",@"规模资质",@"案例库",@"认证员工", nil];
        }
        [enterpriseTable reloadData];
        
        ///企业规模
        NSString *string = [NSString stringWithFormat:@"%@%@人",@"公司规模:",enterpriseInfo.companySize];
        NSUInteger stringLength = string.length;
        if (stringLength >= 6)
        {
            NSMutableAttributedString *scaleString = [[NSMutableAttributedString alloc] initWithString:string];
            [scaleString addAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor],NSFontAttributeName:[UIFont systemFontOfSize:15.0f]} range:NSMakeRange(0, 5)];
            [scaleString addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:kDefaultOrgangeColor],NSFontAttributeName:[UIFont systemFontOfSize:15.0f]} range:NSMakeRange(5, stringLength-6)];
            [scaleString addAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor],NSFontAttributeName:[UIFont systemFontOfSize:15.0f]} range:NSMakeRange(stringLength-1, 1)];
            scaleLabel.attributedText = scaleString;
        }
        else
        {
            scaleLabel.text = string;
        }
        
        BOOL tmpIsAttention = [[[dataDictionary objectForKey:@"info"] objectForKey:@"isAttention"] boolValue];
        if (tmpIsAttention)
        {
            _attentionID =  [[dataDictionary objectForKey:@"info"] objectForKey:@"attentionId"];
            [moreView replaceButtonItemTitle:@"取消关注" withIndex:1];
        }
        
        if (_tmpCompanyType == 0)
        {
            ///获取项目
            [TOHttpHelper postUrl:kTOGetPrpjectsList parameters:companyDict showHUD:YES success:^(NSDictionary *dataDictionary) {
                
                _projectName = [[[[dataDictionary objectForKey:@"info"] objectForKey:@"rows"] firstObject] objectForKey:@"projectName"];
                _projectPicPath = [NSString stringWithFormat:@"%@%@/%@",kTOHOSt,kTOProjectPicPath,[[[[dataDictionary objectForKey:@"info"] objectForKey:@"rows"] firstObject] objectForKey:@"projectLogo"]];
                _projectID = [[[[dataDictionary objectForKey:@"info"] objectForKey:@"rows"] firstObject] objectForKey:@"id"];
                [enterpriseTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:2]] withRowAnimation:(UITableViewRowAnimationNone)];
                
                
            } failure:^(NSError *error) {
                
            }];
        }
        else if(_tmpCompanyType == 1)
        {
            ///获取案例
            [TOHttpHelper postUrl:kTOGetCasesList parameters:companyDict showHUD:YES success:^(NSDictionary *dataDictionary) {
                
                _caseName = [[[[dataDictionary objectForKey:@"info"] objectForKey:@"rows"] firstObject] objectForKey:@"caseName"];
                _casePicPath = [NSString stringWithFormat:@"%@%@/%@",kTOHOSt,kTOCaseLogoPicPath,[[[[dataDictionary objectForKey:@"info"] objectForKey:@"rows"] firstObject] objectForKey:@"caseLogo"]];
                _caseID = [[[[dataDictionary objectForKey:@"info"] objectForKey:@"rows"] firstObject] objectForKey:@"id"];
                [enterpriseTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:2]] withRowAnimation:(UITableViewRowAnimationNone)];
                
                
            } failure:^(NSError *error) {
                
            }];

        }

        
        if ([[[[dataDictionary objectForKey:@"info"] objectForKey:@"companyInfo"] objectForKey:@"companyStatus"] intValue] == 1)
        {
            float width = self.view.frame.size.width-enterpriseTitleLabel.frame.size.width - enterpriseTitleLabel.frame.origin.x*2;
            UIImageView *iconV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"connection_user_authentication"]];
            [iconV setFrame:CGRectMake(self.view.frame.size.width-width-3, enterpriseTitleLabel.frame.origin.y+4, 12, 12)];
            [headView addSubview:iconV];
            
            if (width-12>14)
            {
                UILabel *company = [[UILabel alloc] init];
                [company setTextColor:[UIColor colorWithHexString:kDefaultOrgangeColor]];
                [company setFont:[UIFont systemFontOfSize:11.0f]];
                [company setText:@"认证企业"];
                CGSize size = [company.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.0]}];
                [company setFrame:CGRectMake(self.view.frame.size.width-width+12, enterpriseTitleLabel.frame.origin.y+5, size.width, 12)];
                [headView addSubview:company];
            }

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
#pragma mark 点击更多
-(void)clickMoreButton:(UIBarButtonItem *)item
{
    [moreView showInView:self.view];
}
#pragma mark UITableView Delegat
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return enterpriseArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if (section == 0)
//    {
//        SLTagFrameModel *model = [[SLTagFrameModel alloc] initWithTags:self.companyInfo.enterpriseTagArray];
//        return model.tagViewHeight-20;
//    }
    return 30;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        UITableViewCell *tagCell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:nil];
        SLTagView *tagView = [[SLTagView alloc] init];
        tagView.tagFrameModel = [[SLTagFrameModel alloc] initWithTags:self.companyInfo.enterpriseTagArray];
        tagView.frame = CGRectMake(0, -tagView.tagFrameModel.tagViewHeight+45, 0, 0);
        [tagCell.contentView addSubview:tagView];
        [tagCell setBackgroundColor:[UIColor whiteColor]];
        tagCell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, tagCell.frame.size.height+6, self.view.frame.size.width, 5)];
        [footView setBackgroundColor:[UIColor colorWithHexString:kDefaultGrayColor]];
        [tagCell addSubview:footView];
        [tagCell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
        return tagCell;
    }
    else if (indexPath.section == 1)
    {
        UITableViewCell *credentialCell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:nil];
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 40, 40)];
        [iconView setTag:4001];
        [credentialCell addSubview:iconView];
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 20, self.view.frame.size.width-100, 15)];
        [credentialCell addSubview:contentLabel];
        [contentLabel setTag:4002];
        contentLabel.adjustsFontSizeToFitWidth = YES;
        contentLabel.font = [UIFont systemFontOfSize:14.0f];
        contentLabel.textColor = [UIColor grayColor];
//        [credentialCell setAccessoryType:(UITableViewCellAccessoryDisclosureIndicator)];
        [credentialCell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
        [credentialCell setBackgroundColor:[UIColor whiteColor]];

        if (_qualificationID == nil)
        {
            contentLabel.text = @"暂未资质";
        }
        else
        {
            UIImageView *iconView = (UIImageView *)[credentialCell viewWithTag:4001];
            [iconView sd_setImageWithURL:[NSURL URLWithString:_qualificationPicPath] placeholderImage:kDefaultIcon];
            contentLabel.text = _qualificationName;
        }
    
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, credentialCell.frame.size.height+6, self.view.frame.size.width, 5)];
        [footView setBackgroundColor:[UIColor colorWithHexString:kDefaultGrayColor]];
        [credentialCell addSubview:footView];
        [credentialCell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
        return credentialCell;
    }
    else if (indexPath.section == 2)
    {
        if (_tmpCompanyType == 1)
        {
            UITableViewCell *caseCell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:nil];
            [caseCell setBackgroundColor:[UIColor whiteColor]];
            UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 40, 40)];
            [caseCell.contentView addSubview:iconView];
            UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 18, self.view.frame.size.width-100, 15)];
            contentLabel.adjustsFontSizeToFitWidth = YES;
            contentLabel.font = [UIFont systemFontOfSize:14.0f];
            contentLabel.textColor = [UIColor grayColor];
            [caseCell.contentView addSubview:contentLabel];
            if (_caseID == nil)
            {
                contentLabel.text = @"暂未案例";
            }
            else
            {
                [iconView sd_setImageWithURL:[NSURL URLWithString:_casePicPath] placeholderImage:kDefaultIcon];
                contentLabel.text = _caseName;
                UIImageView *newImage = [[TouchImageView alloc] initWithImage:[UIImage imageNamed:@"NEW"]];
                [newImage setFrame:CGRectMake(38, 0, 28, 13.5f)];
                //[caseCell.contentView addSubview:newImage];
            }
            
            [caseCell setAccessoryType:(UITableViewCellAccessoryDisclosureIndicator)];
            
            UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, caseCell.frame.size.height+6, self.view.frame.size.width, 5)];
            [footView setBackgroundColor:[UIColor colorWithHexString:kDefaultGrayColor]];
            [caseCell addSubview:footView];

            [caseCell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
            return caseCell;
        }
        else if(_tmpCompanyType == 0)
        {
            UITableViewCell *caseCell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:nil];
            [caseCell setBackgroundColor:[UIColor whiteColor]];
            UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 40, 40)];
            [caseCell.contentView addSubview:iconView];
            UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 18, self.view.frame.size.width-100, 15)];
            contentLabel.adjustsFontSizeToFitWidth = YES;
            contentLabel.font = [UIFont systemFontOfSize:14.0f];
            contentLabel.textColor = [UIColor grayColor];
            [caseCell.contentView addSubview:contentLabel];
            if (_projectID == nil)
            {
                contentLabel.text = @"暂无项目";
            }
            else
            {
                [iconView sd_setImageWithURL:[NSURL URLWithString:_projectPicPath] placeholderImage:kDefaultIcon];
                
                contentLabel.text = _projectName;
                UIImageView *newImage = [[TouchImageView alloc] initWithImage:[UIImage imageNamed:@"NEW"]];
                [newImage setFrame:CGRectMake(38, 0, 28, 13.5f)];
                //[caseCell.contentView addSubview:newImage];
                
            }
            
            [caseCell setAccessoryType:(UITableViewCellAccessoryDisclosureIndicator)];
            
            UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, caseCell.frame.size.height+6, self.view.frame.size.width, 5)];
            [footView setBackgroundColor:[UIColor colorWithHexString:kDefaultGrayColor]];
            [caseCell addSubview:footView];

            [caseCell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
            return caseCell;
        }
        else
        {
            return nil;
        }
    }
    else
    {
        UITableViewCell *userCell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:nil];
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 40, 40)];
        [iconView setTag:3001];
        [userCell.contentView addSubview:iconView];
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, self.view.frame.size.width-60, 20)];
        nameLabel.textColor = [UIColor grayColor];
        [nameLabel setTag:3002];
        [nameLabel setFont:[UIFont systemFontOfSize:15.0f]];
        [userCell.contentView addSubview:nameLabel];
        
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 25, self.view.frame.size.width-60, 20)];
        [contentLabel setTag:3003];
        [contentLabel setTextColor:[UIColor grayColor]];
        [contentLabel setFont:[UIFont systemFontOfSize:13.0f]];
        [userCell.contentView addSubview:contentLabel];
        
//        userCell.detailTextLabel.textColor = [UIColor grayColor];
        [userCell setAccessoryType:(UITableViewCellAccessoryDisclosureIndicator)];
        [userCell setBackgroundColor:[UIColor whiteColor]];
//        userCell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        if (_userID == nil)
        {
            UILabel *name = (UILabel *)[userCell.contentView viewWithTag:3002];
            [name setFrame:CGRectMake(60, 18, self.view.frame.size.width-100, 15)];
            name.text = @"暂无认证员工";
        }
        else
        {
            UIImageView *icon = (UIImageView *)[userCell.contentView viewWithTag:3001];
            [icon sd_setImageWithURL:[NSURL URLWithString:_userPicPath] placeholderImage:kDefaultIcon];
            
            UILabel *name = (UILabel *)[userCell.contentView viewWithTag:3002];
            UILabel *content = (UILabel *)[userCell.contentView viewWithTag:3003];
            name.text = [_userName isKindOfClass:[NSNull class]] == YES ? @"" : _userName;
            content.text = [_userDesc isKindOfClass:[NSNull class]] == YES ? @"" : _userDesc;

        }
        
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, userCell.frame.size.height+6, self.view.frame.size.width, 5)];
        [footView setBackgroundColor:[UIColor colorWithHexString:kDefaultGrayColor]];
        [userCell addSubview:footView];

        [userCell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
        return userCell;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    [view setBackgroundColor:[UIColor whiteColor]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width, 29.5)];
    [label setText:[NSString stringWithFormat:@"%@",[enterpriseArray objectAtIndex:section]]];
    [label setTextColor:[UIColor colorWithHexString:kDefaultBarColor]];
    [label setFont:[UIFont systemFontOfSize:16.0f]];
    [view addSubview:label];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 29.5, self.view.frame.size.width, 0.5)];
    [lineView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.2]];
    [view addSubview:lineView];
    
    if (section != 0)
    {
        UIButton *moreButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [moreButton setBounds:CGRectMake(0, 0, 40, 30)];
        [moreButton setCenter:CGPointMake(self.view.frame.size.width-25, 14.5)];
        [moreButton setTitle:@"更多>" forState:(UIControlStateNormal)];
        moreButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [moreButton setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
        [moreButton addTarget:self action:@selector(clickSectionMoreButton:) forControlEvents:(UIControlEventTouchUpInside)];
        [moreButton setTag:(section + 9000)];
        [moreButton setBackgroundColor:[UIColor whiteColor]];
        [view addSubview:moreButton];
    }
    return view;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2 && _caseID != nil && _tmpCompanyType == 1)
    {
        ///单个案例详情
        SLCaseDetailViewController *detail = [[SLCaseDetailViewController alloc] init];
        detail.caseID = _caseID;
        [self.navigationController pushViewController:detail animated:YES];
    }
    else if (indexPath.section == 2 && _projectID != nil && _tmpCompanyType == 0)
    {
        ProjectInfoController *projectInfo = [[ProjectInfoController alloc] init];
        projectInfo.projectID = _projectID;
        [self.navigationController pushViewController:projectInfo animated:YES];
    }
    else if (indexPath.section == 3 && _userID != nil)
    {
        SLConnectionDetailViewController *detail = [[SLConnectionDetailViewController alloc] init];
        detail.userID = _userID;
        [self.navigationController pushViewController:detail animated:YES];

    }
}
#pragma mark 点击section上的更多按钮
-(void)clickSectionMoreButton:(UIButton *)button
{
    if (button.tag == 9001)
    {
        ///资质
        CredentialViewController *credentia = [[CredentialViewController alloc] init];
        credentia.companyID = self.companyInfo.companyId;
        [self.navigationController pushViewController:credentia animated:YES];
    }
    else if (button.tag == 9002)
    {
        if (_tmpCompanyType == 1)
        {
            ///案例
            SLCaseViewController *caseView = [[SLCaseViewController alloc] init];
            caseView.userID = self.companyInfo.companyId;
            [self.navigationController pushViewController:caseView animated:YES];
        }
        else if(_tmpCompanyType == 0)
        {
            ///项目
            SLBiddingProjectViewController *projectView = [[SLBiddingProjectViewController alloc] init];
            projectView.userID = self.companyInfo.companyId;
            [self.navigationController pushViewController:projectView animated:YES];
        }
    }
    else if (button.tag == 9003)
    {
        SLAuthenticationViewController *authenticationViewController = [[SLAuthenticationViewController alloc] init];
        authenticationViewController.companyID = self.companyInfo.companyId;
        [self.navigationController pushViewController:authenticationViewController animated:YES];
    }
}
#pragma mark 点击右上角的button
-(void)connectionMoreView:(SLConnectionMoreView *)connectionMoreView didClickButtonItemAtIndex:(NSInteger)buttonItemIndex
{
    NSString *title = [connectionMoreView buttonItemTitleWithIndex:buttonItemIndex];
//    @"发送给好友",@"发送给群聊",@"关注"]];

    if ([title isEqualToString:@"发送给好友"])
    {
        ///发送给好友
        FriendSelectViewController *selectFriend = [[FriendSelectViewController alloc] init];
        selectFriend.selectType = enterpriseRecommend;
        selectFriend.enterpriseInfo = self.companyInfo;
        selectFriend.controller = self;
        selectFriend.title = @"推荐企业号";
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:selectFriend];
        [self presentViewController:navi animated:YES completion:nil];

    }
    else if ([title isEqualToString:@"发送给群聊"])
    {
        ///发送给群聊
    }
    else if ([title isEqualToString:@"关注"])
    {
        ///关注
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:[[UserInfo sharedInfo] userID] forKey:@"attentionUserId"];
        [dict setObject:[self.companyInfo companyId] forKey:@"attentionId"];
        [TOHttpHelper postUrl:kTOAttention parameters:dict showHUD:YES success:^(NSDictionary *dataDictionary) {
            
            [HUDView showHUDWithText:@"用户关注成功"];
            [moreView replaceButtonItemTitle:@"取消关注" withIndex:1];
            _attentionID = [dataDictionary objectForKey:@"info"];
            
        } failure:^(NSError *error) {
            
        }];
    }
    else if ([title isEqualToString:@"取消关注"])
    {
        NSString *attention = @"";
        if (_attentionID != nil)
        {
            attention = _attentionID;
        }
        else if (enterpriseInfo.attentionId != nil)
        {
            attention = enterpriseInfo.attentionId;
        }
            
        
        [TOHttpHelper postUrl:kTOcancelAttention parameters:@{@"attentionId":attention} showHUD:YES success:^(NSDictionary *dataDictionary) {
            
            [HUDView showHUDWithText:@"取消关注成功"];
            
            
            [moreView replaceButtonItemTitle:@"关注" withIndex:2];
            
        } failure:^(NSError *error) {
            
        }];
    }
}
@end
