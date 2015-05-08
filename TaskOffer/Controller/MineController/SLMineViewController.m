//
//  SLMineViewController.m
//  TaskOffer
//
//  Created by wshaolin on 15/4/28.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLMineViewController.h"
#import "SLRootTableView.h"
#import "SLMineTableViewCell.h"
#import "SLSettingModel.h"

@interface SLMineViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) SLRootTableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation SLMineViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
        self.title = @"个人中心";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
}

- (void)loadData{
    SLSettingModel *settingModel0 = [[SLSettingModel alloc] initWithIcon:kUserDefaultIcon title:@""];
    SLSettingModel *settingModel1 = [[SLSettingModel alloc] initWithIcon:kUserDefaultIcon title:@"扫一扫"];
    SLSettingModel *settingModel2 = [[SLSettingModel alloc] initWithIcon:kUserDefaultIcon title:@"通讯录"];
    SLSettingModel *settingModel3 = [[SLSettingModel alloc] initWithIcon:kUserDefaultIcon title:@"我的项目"];
    SLSettingModel *settingModel4 = [[SLSettingModel alloc] initWithIcon:kUserDefaultIcon title:@"我的案例"];
    SLSettingModel *settingModel5 = [[SLSettingModel alloc] initWithIcon:kUserDefaultIcon title:@"我的关注"];
    SLSettingModel *settingModel6 = [[SLSettingModel alloc] initWithIcon:kUserDefaultIcon title:@"圈子记录"];
    SLSettingModel *settingModel7 = [[SLSettingModel alloc] initWithIcon:kUserDefaultIcon title:@"消息中心"];
    
    self.dataArray = @[@[settingModel0], @[settingModel1], @[settingModel2, settingModel3, settingModel4, settingModel5, settingModel6, settingModel7]];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = self.dataArray[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SLMineTableViewCell *cell = [SLMineTableViewCell cellWithTableView:tableView];
    NSArray *array = self.dataArray[indexPath.section];
    cell.settingModel = array[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return 70.0;
    }
    return 44.0;
}

@end
