//
//  SLFriendCircleStatusDetailViewCell.h
//  XMPPIM
//
//  Created by wshaolin on 14/12/27.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SLFriendCircleStatusDetailCommentFrameModel, SLFriendCircleStatusDetailViewCell, SLFriendCircleUserModel;

@protocol SLFriendCircleStatusDetailViewCellDelegate <NSObject>

@optional
- (void)friendCircleStatusDetailViewCell:(SLFriendCircleStatusDetailViewCell *)friendCircleStatusDetailViewCell didTapFriendCircleUser:(SLFriendCircleUserModel *)friendCircleUserModel;

@end

@interface SLFriendCircleStatusDetailViewCell : UITableViewCell

@property (nonatomic, strong) SLFriendCircleStatusDetailCommentFrameModel *statusDetailCommentFrameModel;
@property (nonatomic, weak) id<SLFriendCircleStatusDetailViewCellDelegate> delegate;
@property (nonatomic, assign, getter = isLastRow) BOOL lastRow;
@property (nonatomic, assign, getter = isFirstRow) BOOL firstRow;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
