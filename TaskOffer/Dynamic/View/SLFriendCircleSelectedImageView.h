//
//  SLFriendCircleSelectedImageView.h
//  XMPPIM
//
//  Created by wshaolin on 14/12/19.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SLFriendCircleSelectedImageView;

@protocol SLFriendCircleSelectedImageViewDelegate <NSObject>

@optional
- (void)friendCircleSelectedImageViewDidClickAddButton:(SLFriendCircleSelectedImageView *)friendCircleSelectedImageView;

- (void)friendCircleSelectedImageView:(SLFriendCircleSelectedImageView *)friendCircleSelectedImageView didCancelImageAtIndex:(NSInteger)index;

- (void)friendCircleSelectedImageView:(SLFriendCircleSelectedImageView *)friendCircleSelectedImageView didChangeHeight:(CGFloat)height;

@end

@interface SLFriendCircleSelectedImageView : UIView

@property (nonatomic, strong) NSArray *selectedImages;

@property (nonatomic, weak) id<SLFriendCircleSelectedImageViewDelegate> delegate;

@end
