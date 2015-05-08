//
//  SLFriendCircleMessageViewCell.h
//  XMPPIM
//
//  Created by wshaolin on 14/12/27.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SLFriendCircleMessageFrameModel;

@interface SLFriendCircleMessageViewCell : UITableViewCell

@property (nonatomic, strong) SLFriendCircleMessageFrameModel *friendCircleMessageFrameModel;
@property (nonatomic, assign, getter = isLastRow) BOOL lastRow;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
