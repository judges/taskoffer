//
//  SLFriendCirclePersonStatusViewCell.h
//  XMPPIM
//
//  Created by wshaolin on 14/12/26.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SLFriendCirclePersonStatusViewCell, SLFriendCirclePersonStatusFrameModel;

@protocol SLFriendCirclePersonStatusViewCellDelegate <NSObject>

@optional
- (void)friendCirclePersonStatusViewCell:(SLFriendCirclePersonStatusViewCell *)friendCirclePersonStatusViewCell didTapAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface SLFriendCirclePersonStatusViewCell : UITableViewCell

@property (nonatomic, weak) id<SLFriendCirclePersonStatusViewCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) SLFriendCirclePersonStatusFrameModel *friendCirclePersonStatusFrameModel;
@property (nonatomic, assign) BOOL hideDate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
