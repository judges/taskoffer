//
//  ProjectListTable.m
//  TaskOffer
//
//  Created by BourbonZ on 15/4/13.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "ProjectListTable.h"
#import "ProjectDialogueDataBaseHelper.h"
#import "DialogueCell.h"
#import "HexColor.h"
#import "UIImageView+WebCache.h"
#import "TOHttpHelper.h"
#import "UserInfo.h"
@implementation ProjectListTable
{
    NSMutableArray *itemArray;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style])
    {
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor colorWithHexString:kDefaultGrayColor];
        self.tableFooterView = [[UIView alloc] init];
        itemArray = [NSMutableArray array];
        
        if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
            [self setSeparatorInset:UIEdgeInsetsMake(0,10,0,0)];
        }
        
        if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
            [self setLayoutMargins:UIEdgeInsetsMake(0,10,0,0)];
        }
    }
    return self;
}
-(void)setProjectID:(NSString *)projectID
{
    itemArray = [[ProjectDialogueDataBaseHelper sharedHelper] allDialogueArrayWithProjectID:projectID];
    [self reloadData];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return itemArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 63;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    DialogueCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[DialogueCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellID];
    }
    ProjectDialogue *dialogue = [itemArray objectAtIndex:indexPath.row];
    cell.iconView.image = kDefaultIcon;
    cell.nameLabel.text = dialogue.messageSender;
    cell.contentLabel.text = @"[项目聊天]";
    
    NSString *name = dialogue.messageReceiver;
    if ([name isEqualToString:[[UserInfo sharedInfo] userID]])
    {
        name = dialogue.messageSender;
        [TOHttpHelper getUrl:kTOgetInfo parameters:@{@"id":name,@"type":@"1"} showHUD:NO success:^(NSDictionary *dataDictionary) {
            
            cell.nameLabel.text = [[[dataDictionary objectForKey:@"info"] objectForKey:@"ServerAppUser"] objectForKey:@"userName"];
            
            
            
        }];
    }

    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[dialogue.messageTime doubleValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:ss"];
    
    ProjectDialogueInfo *info = [[ProjectDialogueDataBaseHelper sharedHelper] selectProjectInfo:dialogue.projectID];
    if (info.projectID != nil)
    {
        [cell.iconView sd_setImageWithURL:[NSURL URLWithString:info.projectIconPath] placeholderImage:kDefaultIcon];
        cell.nameLabel.text = info.projectCreater;
        NSString *time = [info.projectTime substringToIndex:(info.projectTime.length-3)];
        cell.timeLabel.text = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time.doubleValue]];
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }

    
    ProjectDialogue *dialogue = [itemArray objectAtIndex:indexPath.row];
    
    ProjectDialogueInfo *projectInfo = [[ProjectDialogueDataBaseHelper sharedHelper] selectProjectInfo:dialogue.projectID];
    if (projectInfo.projectID == nil)
    {
        [TOHttpHelper getUrl:kTOGetProjectInfo parameters:@{@"projectId":dialogue.projectID,@"userId":[[UserInfo sharedInfo] userID]} showHUD:NO success:^(NSDictionary *dataDictionary) {
            
            ProjectDialogueInfo *info = [[ProjectDialogueInfo alloc] init];
            
            [info setProjectID:[[[dataDictionary objectForKey:@"info"] objectForKey:@"serverProject"] objectForKey:@"id"]];
            [info setProjectName:[[[dataDictionary objectForKey:@"info"] objectForKey:@"serverProject"] objectForKey:@"projectName"]];
            
            NSInteger type = [[[[dataDictionary objectForKey:@"info"] objectForKey:@"serverProject"] objectForKey:@"projectType"] integerValue];
            ///0是企业号发布，1是个人发布
            if (type == 0)
            {
                NSString *icon = [NSString stringWithFormat:@"%@%@/%@",kTOHOSt,kTOCompanyPicPath,[[[dataDictionary objectForKey:@"info"] objectForKey:@"serverProject"] objectForKey:@"projectLogo"]];
                [info setProjectIconPath:icon];
            }
            else
            {
                NSString *icon = [NSString stringWithFormat:@"%@%@/%@",kTOHOSt,kTOUploadUserIcon,[[[dataDictionary objectForKey:@"info"] objectForKey:@"serverProject"] objectForKey:@"projectLogo"]];
                [info setProjectIconPath:icon];
            }
            
            [info setProjectTime:[[[[dataDictionary objectForKey:@"info"] objectForKey:@"serverProject"] objectForKey:@"createTime"] stringValue]];
            if ([[[[dataDictionary objectForKey:@"info"] objectForKey:@"serverProject"] objectForKey:@"projectPublishName"] isKindOfClass:[NSNull class]])
            {
                [info setProjectCreater:@""];
            }
            else
            {
                [info setProjectCreater:[[[dataDictionary objectForKey:@"info"] objectForKey:@"serverProject"] objectForKey:@"projectPublishName"]];
            }
            [[ProjectDialogueDataBaseHelper sharedHelper] addProjectInfo:info];
            [tableView reloadData];
        }];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.projectListDelegate clickProjectListTableAtIndex:[itemArray objectAtIndex:indexPath.row]];
}
@end
