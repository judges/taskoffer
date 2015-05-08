//
//  SLFriendCircleTableViewCell.h
//  XMPPIM
//
//  Created by wshaolin on 14/12/19.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SLFriendCircleStatusCommentFrameModel, SLFriendCircleTableViewCell, SLFriendCircleUserModel;

@protocol SLFriendCircleTableViewCellDelegate <NSObject>

@optional
- (void)friendCircleTableViewCell:(SLFriendCircleTableViewCell *)friendCircleTableViewCell didTapfriendCircleCommentUser:(SLFriendCircleUserModel *)friendCircleUserModel;

- (void)friendCircleTableViewCell:(SLFriendCircleTableViewCell *)friendCircleTableViewCell didTapfriendCircleComment:(NSString *)commentId withFriendCircleReplyUser:(SLFriendCircleUserModel *)friendCircleUserModel;

@end

@interface SLFriendCircleTableViewCell : UITableViewCell

@property (nonatomic, strong) SLFriendCircleStatusCommentFrameModel *friendCircleStatusCommentFrameModel;
@property (nonatomic, weak) id<SLFriendCircleTableViewCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
