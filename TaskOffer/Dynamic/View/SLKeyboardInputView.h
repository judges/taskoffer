//
//  SLKeyboardInputView.h
//  XMPPIM
//
//  Created by wshaolin on 14/12/29.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SLTextView, SLKeyboardInputView;

@protocol SLKeyboardInputViewDelegate <NSObject>

@optional
- (void)keyboardInputView:(SLKeyboardInputView *)keyboardInputView didClickSendButton:(NSString *)snedText;

@end

@interface SLKeyboardInputView : UIView

@property (nonatomic, strong, readonly) SLTextView *textView;
@property (nonatomic, copy) NSString *placeholder;

@property (nonatomic, assign) NSUInteger maxEnableCount; // 允许输入的最大字符数，0 为不限制，默认

@property (nonatomic, weak) id<SLKeyboardInputViewDelegate> delegate;

- (void)show;

- (void)hide;

@end
