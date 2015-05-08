//
//  SLKeyboardEmojiPageView.h
//  XMPPIM
//
//  Created by wshaolin on 15/1/4.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SLKeyboardEmojiPageViewEmojiCount 21 // 20个emoji表情和一个删除按钮（最后一个）

@class SLKeyboardEmojiPageView;

@protocol SLKeyboardEmojiPageViewDelegate <NSObject>

@optional
- (void)keyboardEmojiPageView:(SLKeyboardEmojiPageView *)keyboardEmojiPageView didSelectedEmoji:(NSString *)emojiKey;

- (void)keyboardEmojiPageViewDidClickDeleteButton:(SLKeyboardEmojiPageView *)keyboardEmojiPageView;

@end

@interface SLKeyboardEmojiPageView : UIView

@property (nonatomic, strong, readonly) NSArray *emojiArray;
@property (nonatomic, weak) id<SLKeyboardEmojiPageViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame emojiArray:(NSArray *)emojiArray;

@end
