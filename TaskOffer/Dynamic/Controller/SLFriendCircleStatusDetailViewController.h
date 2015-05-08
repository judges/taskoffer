//
//  SLFriendCircleStatusDetailViewController.h
//  XMPPIM
//
//  Created by wshaolin on 14/12/26.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import "SLRootViewController.h"

@class SLFriendCircleStatusDetailViewController, SLFriendCircleStatusModel, SLFriendCircleStatusCommentModel, SLFriendCircleUserModel;

@protocol SLFriendCircleStatusDetailViewControllerDelegate <NSObject>

@optional

- (void)friendCircleStatusDetailViewController:(SLFriendCircleStatusDetailViewController *)friendCircleStatusDetailViewController didCompletedDeleteStatus:(NSString *)statusId atIndexPath:(NSIndexPath *)indexPath;

- (void)friendCircleStatusDetailViewController:(SLFriendCircleStatusDetailViewController *)friendCircleStatusDetailViewController didCompletedComment:(SLFriendCircleStatusCommentModel *)statusCommentModel atIndexPath:(NSIndexPath *)indexPath;

@end

@interface SLFriendCircleStatusDetailViewController : SLRootViewController

// 从非个人列表过来需要传递的参数
@property (nonatomic, copy) NSString *statusId;
@property (nonatomic, strong) SLFriendCircleUserModel *userModel;

// 从个人列表过来需要传递的参数，不能传statusId
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id<SLFriendCircleStatusDetailViewControllerDelegate> delegate;

- (void)setFriendCircleStatusModel:(SLFriendCircleStatusModel *)friendCircleStatusModel;

@end
