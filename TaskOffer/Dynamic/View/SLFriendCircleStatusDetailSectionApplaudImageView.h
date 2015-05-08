//
//  SLFriendCircleStatusDetailSectionApplaudImageView.h
//  XMPPIM
//
//  Created by wshaolin on 14/12/28.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SLFriendCircleStatusDetailSectionApplaudImageView, SLFriendCircleUserModel;

@protocol SLFriendCircleStatusDetailSectionApplaudImageViewDelegate <NSObject>

@optional

- (void)statusDetailSectionApplaudImageView:(SLFriendCircleStatusDetailSectionApplaudImageView *)statusDetailSectionApplaudImageView didTapApplaudUser:(SLFriendCircleUserModel *)friendCircleUserModel;

@end

@interface SLFriendCircleStatusDetailSectionApplaudImageView : UIView

@property (nonatomic, strong, readonly) NSArray *applaudArray;
@property (nonatomic, weak) id<SLFriendCircleStatusDetailSectionApplaudImageViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame applaudArray:(NSArray *)applaudArray;

@end
