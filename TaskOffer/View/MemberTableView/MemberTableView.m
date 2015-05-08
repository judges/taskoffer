//
//  MemberTableView.m
//  TaskOffer
//
//  Created by BourbonZ on 15/4/8.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "MemberTableView.h"
#import "MemberTableViewCell.h"
#import "HexColor.h"
@implementation MemberTableView
@synthesize memberArray = _memberArray;
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
        self.tableFooterView = [[UIView alloc] init];
        self.scrollEnabled = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectTagCellWith:) name:@"selectCell" object:nil];
        
        if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
            [self setSeparatorInset:UIEdgeInsetsMake(0,10,0,0)];
        }
        
        if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
            [self setLayoutMargins:UIEdgeInsetsMake(0,10,0,0)];
        }

    }
    return self;
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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _memberArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    MemberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[MemberTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellID];
    }
    cell.friendInfo = [_memberArray objectAtIndex:indexPath.row];
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 28)];
    if (_memberArray.count == 0)
    {
        label.text = @"  根据项目标签，未能有好友拥有与之匹配的标签";
    }
    else
    {
        label.text = @"  根据项目标签,您的如下好友与之匹配";
    }
    [label setTextColor:[UIColor colorWithHexString:kDefaultTextColor]];
    [label setFont:[UIFont systemFontOfSize:13.0f]];
    [view addSubview:label];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 28, self.frame.size.width, 0.25)];
    [lineView setBackgroundColor:[UIColor colorWithHexString:kDefaultTextColor]];
    [view addSubview:lineView];
    return view;

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MemberTableViewCell *cell = (MemberTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.isSelected == YES)
    {
        [cell setIsSelected:NO];
    }
    else
    {
        [cell setIsSelected:YES];
    }
    
    if (self.memberDelegate != nil && [self.memberDelegate respondsToSelector:@selector(clickMemberOnIndex:withProjectInfo:)])
    {
        [self.memberDelegate clickMemberOnIndex:indexPath withProjectInfo:[_memberArray objectAtIndex:indexPath.row]];
    }
}
-(void)setMemberArray:(NSArray *)memberArray
{
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0 ; i < memberArray.count; i ++)
    {
        UserInfo *info = [[UserInfo alloc] init];
        [info setInfoDict:[memberArray objectAtIndex:i]];
        [array addObject:info];
    }
    _memberArray = [array copy];
}
#pragma mark 接受消息通知
-(void)selectTagCellWith:(NSNotification *)notify
{
    XMPPFriendInfo *info = [notify object];
    for (int i = 0 ; i < _memberArray.count; i++)
    {
        UserInfo *user = [_memberArray objectAtIndex:i];
        if ([user.userID isEqualToString:info.jid.user])
        {
            MemberTableViewCell *cell = (MemberTableViewCell *)[self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            cell.isSelected = !cell.isSelected;
            break;
        }
    }
}
@end
