//
//  ApplyCompanyController.m
//  TaskOffer
//
//  Created by BourbonZ on 15/4/1.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "ApplyCompanyController.h"
#import "TOHttpHelper.h"
#import "EnterpriseCell.h"
#import "EnterpriseInfo.h"
#import "ApplyInfoCell.h"
#import "ApplyCell.h"
@interface ApplyCompanyController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UITextFieldDelegate>
{
    NSMutableArray *resultArray;
    
    UISearchDisplayController *search;
    
    CustomTable *searchTable;
    
    int page;
}
@end

@implementation ApplyCompanyController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"申请认证";
    
    ///数组
    resultArray = [NSMutableArray array];

    
    ///表格
    searchTable = [[CustomTable alloc] initWithFrame:self.view.frame style:(UITableViewStylePlain)];
    searchTable.delegate = self;
    searchTable.dataSource = self;
    searchTable.tableFooterView = [[UIView alloc] init];
    searchTable.backgroundColor = [UIColor colorWithHexString:kDefaultGrayColor];
    [self.view addSubview:searchTable];
//    ///搜索
//    UISearchBar *bar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
//    bar.delegate = self;
//    searchTable.tableHeaderView = bar;
//    search = [[UISearchDisplayController alloc] initWithSearchBar:bar contentsController:self];
//    [search setSearchResultsDataSource:self];
//    [search setSearchResultsDelegate:self];
    
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    [searchView setBackgroundColor:[UIColor colorWithHexString:@"c8c8c8"]];
    UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width, 40)];
    [searchView addSubview:field];
//    [field setBackgroundColor:[UIColor whiteColor]];
    UIImageView *tmpSearch = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"蓝色搜索"]];
    [tmpSearch setFrame:CGRectMake(0, 0, 30, 30)];
    field.leftView = tmpSearch;
    [field setLeftViewMode:(UITextFieldViewModeAlways)];
    field.returnKeyType = UIReturnKeySearch;
    [field setDelegate:self];
    field.placeholder = @"请输入内容……";
    searchView.layer.borderColor = [[UIColor colorWithHexString:kDefaultGrayColor] CGColor];
    searchView.layer.borderWidth = 1.0f;
    searchTable.tableHeaderView = searchView;
    
    page = 1;
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
#pragma mark UITableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return resultArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    ApplyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[ApplyCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellID];
        
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [button setTag:9008];
        [button addTarget:self action:@selector(clickApplyButton:) forControlEvents:(UIControlEventTouchUpInside)];
        [button setFrame:CGRectMake(self.view.frame.size.width-90,60, 80, 25)];
        [button setTitle:@"申请认证" forState:(UIControlStateNormal)];
        button.titleLabel.textColor = [UIColor whiteColor];
        [button setBackgroundColor:[UIColor colorWithHexString:kDefaultTextColor]];
        [cell.contentView addSubview:button];
    }
    
    UIButton *button = (UIButton *)[cell.contentView viewWithTag:9008];
    button.tag = indexPath.row;
    
    
    NSDictionary *dict = [resultArray objectAtIndex:indexPath.row];
    EnterpriseInfo *info = [[EnterpriseInfo alloc] init];
    [info setEnterpriseDict:dict];
    cell.info = info;
    return cell;
    
}
#pragma mark 点击申请认证
-(void)clickApplyButton:(UIButton *)button
{
    NSDictionary *dict = [resultArray objectAtIndex:button.tag];
    EnterpriseInfo *enterpriseInfo = [[EnterpriseInfo alloc] init];
    enterpriseInfo.enterpriseDict = dict;
    NSMutableDictionary *tmpDict = [NSMutableDictionary dictionary];
    [tmpDict setObject:[[UserInfo sharedInfo] userID] forKey:@"id"];
    [tmpDict setObject:enterpriseInfo.companyId forKey:@"userCompanyId"];
    [tmpDict setObject:enterpriseInfo.enterpriseName forKey:@"userCompanyName"];
    [tmpDict setObject:@"1" forKey:@"userCertificateStatus"];
    
    [TOHttpHelper postUrl:kTOModify parameters:tmpDict showHUD:YES success:^(NSDictionary *dataDictionary) {
        
   
        [HUDView showHUDWithText:@"提交成功，请等待审核"];
        
        [[UserInfo sharedInfo] setUserCertificateStatus:@"1"];
        
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        
    }];
    
    
}
#pragma mark UISearch
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
}
#pragma mark UITextFiled
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{

    NSString *string = textField.text;
    if (string.length == 0)
    {
        [self.view endEditing:YES];
        return YES;
    }
    [self.view endEditing:YES];
    [self getDataFromServer:page withContent:string];

    return YES;
}
#pragma mark 加载数据
-(void)getDataFromServer:(int)pageNum withContent:(NSString *)string
{
    page = page + 1;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:string forKey:@"companyName"];
    [dict setObject:@"10" forKey:@"rows"];
    [dict setObject:[NSString stringWithFormat:@"%d",pageNum] forKey:@"page"];
    [TOHttpHelper getUrl:kTOfindCompanyByName parameters:dict showHUD:YES success:^(NSDictionary *dataDictionary) {
        
        NSArray *array = [[dataDictionary objectForKey:@"info"] objectForKey:@"rows"];
        if (array.count == 0)
        {
            NSString *tmp = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dataDictionary options:(NSJSONWritingPrettyPrinted) error:nil] encoding:NSUTF8StringEncoding];
            
            [HUDView showHUDWithText:@"未查到相关数据"];
            return ;
        }
        
        if (pageNum == 1)
        {
            resultArray = [NSMutableArray arrayWithArray:array];
        }
        else
        {
            [resultArray addObjectsFromArray:array];
        }
        
        [searchTable reloadData];
    }];
}
@end
