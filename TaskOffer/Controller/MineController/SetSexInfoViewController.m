//
//  SetSexInfoViewController.m
//  TaskOffer
//
//  Created by BourbonZ on 15/4/22.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SetSexInfoViewController.h"

@interface SetSexInfoViewController ()
@end

@implementation SetSexInfoViewController
{
    NSString *_tmpUserSex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:(UIBarButtonItemStylePlain) target:self action:@selector(clickDoneButton)];
    self.title = @"设置性别";
    self.tableView.tableFooterView = [[UIView alloc] init];
    _tmpUserSex = [[UserInfo sharedInfo] userSex];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 点击完成按钮
-(void)clickDoneButton
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(setUserSexSuccess:)] && _tmpUserSex.length > 0)
    {
        [self.delegate setUserSexSuccess:_tmpUserSex];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellID];
    }
    
    // Configure the cell...
    
    if (indexPath.row == 0)
    {
        cell.textLabel.text = @"男";
        if ([[[UserInfo sharedInfo] userSex] isEqualToString:@"男"])
        {
            [cell setAccessoryType:(UITableViewCellAccessoryCheckmark)];
        }
    }
    else
    {
        cell.textLabel.text = @"女";
        if ([[[UserInfo sharedInfo] userSex] isEqualToString:@"女"])
        {
            [cell setAccessoryType:(UITableViewCellAccessoryCheckmark)];
        }

    }
    
    [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell setAccessoryType:(UITableViewCellAccessoryNone)];
    
    UITableViewCell *cell1 = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    [cell1 setAccessoryType:(UITableViewCellAccessoryNone)];

    
    UITableViewCell *cell3 = [tableView cellForRowAtIndexPath:indexPath];
    [cell3 setAccessoryType:(UITableViewCellAccessoryCheckmark)];
    
    if (indexPath.row == 0)
    {
        _tmpUserSex = @"男";
    }
    else
    {
        _tmpUserSex = @"女";
    }
    
}


@end
