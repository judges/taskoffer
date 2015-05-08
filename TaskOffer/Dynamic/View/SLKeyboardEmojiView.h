//
//  SLKeyboardEmojiView.h
//  XMPPIM
//
//  Created by wshaolin on 15/1/3.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SLKeyboardEmojiView;

@protocol SLKeyboardEmojiViewDelegate <NSObject>

@optional
- (void)keyboardEmojiView:(SLKeyboardEmojiView *)keyboardEmojiView didSelectedEmoji:(NSString *)emojiKey;

- (void)keyboardEmojiViewDidClickDeleteButton:(SLKeyboardEmojiView *)keyboardEmojiView;

- (void)keyboardEmojiViewDidClickSendButton:(SLKeyboardEmojiView *)keyboardEmojiView;

@end

@interface SLKeyboardEmojiView : UIView

@property (nonatomic, weak) id<SLKeyboardEmojiViewDelegate> delegate;

@end
