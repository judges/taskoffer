//
//  SLFriendCircleTableHeaderView.h
//  XMPPIM
//
//  Created by wshaolin on 14/12/17.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SLFriendCircleTableHeaderView;

@protocol SLFriendCircleTableHeaderViewDelegate <NSObject>

@optional
- (void)friendCircleTableHeaderViewIconTap:(SLFriendCircleTableHeaderView *)friendCircleTableHeaderView;

- (void)friendCircleTableHeaderViewMessageButtonTap:(SLFriendCircleTableHeaderView *)friendCircleTableHeaderView;

@end

@interface SLFriendCircleTableHeaderView : UIView

- (instancetype)initWithFrame:(CGRect)frame isNeedMessageButton:(BOOL)isNeed;

@property (nonatomic, weak) id<SLFriendCircleTableHeaderViewDelegate> delegate;

@property (nonatomic, assign) BOOL hideNickName;

@property (nonatomic, copy) NSString *nickName;

@property (nonatomic, assign, readonly) BOOL isNeedMessageButton;

@property (nonatomic, strong, readonly) UIImageView *iconView;

@end
