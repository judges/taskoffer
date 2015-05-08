//
//  VersionViewController.m
//  TaskOffer
//
//  Created by BourbonZ on 15/3/16.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "VersionViewController.h"
#import "ToHttpHelper.h"
@interface VersionViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSString *versionString;
}
@end

@implementation VersionViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    [dict setObject:@"1" forKey:@"terminalOsType"];
//    [dict setObject:@"0" forKey:@"terminalPort"];
//    
//    [TOHttpHelper postUrl:kTOgetVersionByPortAndType parameters:dict showHUD:YES success:^(NSDictionary *dataDictionary) {
//        
//        
//        UITableView *table = (UITableView *)[self.view viewWithTag:9001];
//        UITableViewCell *cell = [table cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
//        cell.detailTextLabel.text = [[dataDictionary objectForKey:@"info"] objectForKey:@"versionDescribe"];
//        
//    } failure:^(NSError *error) {
//        
//    }];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"版本";
    
    ///二维码
    UIImageView *erCodeView = [[TouchImageView alloc] initWithImage:[UIImage imageNamed:@"默认二维码"]];
    [erCodeView setFrame:CGRectMake((self.view.frame.size.width-160)/2, 100, 160, 160)];
    [self.view addSubview:erCodeView];
    
    ///版本号
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-160)/2, 260, 160, 50)];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    versionLabel.text = [NSString stringWithFormat:@"托付 V%@",version];
    [versionLabel setTextAlignment:NSTextAlignmentCenter];
    [versionLabel setTextColor:[UIColor colorWithHexString:kDefaultTextColor]];
    [self.view addSubview:versionLabel];
    
    
    ///下方检查更新
    UITableView *checkVersion = [[UITableView alloc] initWithFrame:CGRectMake(0, 310, self.view.frame.size.width, 40) style:(UITableViewStylePlain)];
    [checkVersion setDataSource:self];
    [checkVersion setDelegate:self];
    checkVersion.scrollEnabled = NO;
    [checkVersion setTag:9001];
//    [self.view addSubview:checkVersion];
    
    ///设置表格边框
    checkVersion.layer.borderWidth = 0.3f;
    checkVersion.layer.borderColor = [[UIColor grayColor] CGColor];
    

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
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:cellID];
    }
    cell.textLabel.text       = @"检查更新";
    cell.textLabel.font       = [UIFont systemFontOfSize:13.0f];
    cell.detailTextLabel.text = @"已是最新版本";
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13.0f];
    [cell setAccessoryType:(UITableViewCellAccessoryDisclosureIndicator)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"1" forKey:@"terminalOsType"];
    [dict setObject:@"0" forKey:@"terminalPort"];
    
    [TOHttpHelper postUrl:kTOgetVersionByPortAndType parameters:dict showHUD:YES success:^(NSDictionary *dataDictionary) {
        
        
        UITableView *table = (UITableView *)[self.view viewWithTag:9001];
        UITableViewCell *cell = [table cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        cell.detailTextLabel.text = [[dataDictionary objectForKey:@"info"] objectForKey:@"versionDescribe"];
        
    } failure:^(NSError *error) {
        
    }];
}
@end
