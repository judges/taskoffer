//
//  SLFriendCircleSendStatusViewCell.h
//  XMPPIM
//
//  Created by wshaolin on 14/12/25.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import "SLRootTableViewCell.h"

@class SLFriendCircleSendStatusTableViewModel;

@interface SLFriendCircleSendStatusViewCell : SLRootTableViewCell

@property (nonatomic, strong) SLFriendCircleSendStatusTableViewModel *tableViewModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
