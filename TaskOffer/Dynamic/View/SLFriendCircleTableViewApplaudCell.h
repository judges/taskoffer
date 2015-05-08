//
//  SLFriendCircleTableViewApplaudCell.h
//  XMPPIM
//
//  Created by wshaolin on 15/1/7.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLFriendCircleTableViewApplaudCell : UITableViewCell

@property (nonatomic, strong) NSAttributedString *applaudAttributedString;
@property (nonatomic, assign) BOOL hideButtomLine;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
