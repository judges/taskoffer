//
//  SLFriendCirclePostionViewController.h
//  XMPPIM
//
//  Created by wshaolin on 14/12/26.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import "SLRootViewController.h"

@class SLFriendCirclePostionViewController, SLPostionModel;

@protocol SLFriendCirclePostionViewControllerDelegate <NSObject>

@optional
- (void)friendCirclePostionViewController:(SLFriendCirclePostionViewController *)friendCirclePostionViewController didSelectedPostion:(SLPostionModel *)postion;

@end

@interface SLFriendCirclePostionViewController : SLRootViewController

@property (nonatomic, weak) id<SLFriendCirclePostionViewControllerDelegate> delegate;
@property (nonatomic, strong) SLPostionModel *selectedPostion;

@end
