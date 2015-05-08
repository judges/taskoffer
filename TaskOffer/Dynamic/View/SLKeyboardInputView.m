//
//  SLKeyboardInputView.m
//  XMPPIM
//
//  Created by wshaolin on 14/12/29.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import "SLKeyboardInputView.h"
#import "SLTextView.h"
#import "NSString+Conveniently.h"
#import "SLKeyboardEmojiView.h"
#import "HexColor.h"

@interface SLKeyboardInputView()<UITextViewDelegate, SLKeyboardEmojiViewDelegate>

@property (nonatomic, assign) BOOL isChangedFrame;
@property (nonatomic, strong) UIButton *emojiButton;
@property (nonatomic, assign) BOOL isInitSubviewFrame;
@property (nonatomic, assign) CGFloat currentKeyboardHeight;
@property (nonatomic, assign) CGFloat textViewMinHeight;
@property (nonatomic, assign) CGRect defaultFrame;
@property (nonatomic, assign) CGRect textViewDefaultFrame;
@property (nonatomic, strong) SLKeyboardEmojiView *emojiView;
@property (nonatomic, assign, getter = isEmojiKeyboard) BOOL emojiKeyboard;
@property (nonatomic, assign, getter = isHideWithKeyboardHidden) BOOL hideWithKeyboardHidden;
@property (nonatomic, assign) CGFloat keyboardAnimationDuration;

@property (nonatomic, strong) NSDictionary *emojiDictionary;
@property (nonatomic, strong) NSRegularExpression *emojiRegularExpression;

@end

@implementation SLKeyboardInputView

- (NSDictionary *)emojiDictionary{
    if(_emojiDictionary == nil){
        NSData *emojiData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"facemap.json" ofType:nil]];
        NSDictionary *emojiDictionary = [NSJSONSerialization JSONObjectWithData:emojiData options:(NSJSONReadingMutableLeaves) error:nil];
        if(emojiDictionary != nil){
            _emojiDictionary = emojiDictionary;
        }else{
            _emojiDictionary = [NSDictionary dictionary];
        }
    }
    return _emojiDictionary;
}

- (NSRegularExpression *)emojiRegularExpression{
    if(_emojiRegularExpression == nil){
        _emojiRegularExpression = [[NSRegularExpression alloc] initWithPattern:@"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]" options:NSRegularExpressionCaseInsensitive error:nil];
    }
    return _emojiRegularExpression;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:236.0/ 255.0 green:238.0/ 255.0 blue:241.0/ 255.0 alpha:1.0];
        _isInitSubviewFrame = YES;
        _hideWithKeyboardHidden = YES;
        
        _textView = [[SLTextView alloc] init];
        _textView.delegate = self;
        _textView.layer.masksToBounds = YES;
        _textView.layer.cornerRadius = 4.0;
        _textView.layer.borderWidth = 0.5;
        _textView.showsHorizontalScrollIndicator = NO;
        _textView.showsVerticalScrollIndicator = NO;
        _textView.layer.borderColor = [UIColor colorWithHexString:@"aeb3be"].CGColor;
        _textView.font = [UIFont systemFontOfSize:16.0];
        _textView.returnKeyType = UIReturnKeySend;
        _textView.enablesReturnKeyAutomatically = YES;
        _textView.placeholder = @"评论";
        _textView.textColor = [UIColor blackColor];
        _textView.placeholderPosition = SLTextViewPlaceholderPositionMiddle;
        _textView.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:_textView];
        
        _emojiButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_emojiButton addTarget:self action:@selector(emojiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_emojiButton];
        
        [self setEmojiKeyboard:NO];
        
        // 监听输入框文字的改变
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidChangeNotification:) name:UITextViewTextDidChangeNotification object:_textView];
        
        // 监听键盘frame的变化
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
        
        // 监听键盘的出现
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
        
        // 监听键盘的隐藏
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
        
        // 默认隐藏
        self.hidden = YES;
        
        // 加到window上
        UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
        [window addSubview:self];
    }
    return self;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if([text isEqualToString:@"\n"]){ // 按了发送键
        [self sendText];
        self.textView.text = nil;
        return NO;
    }else if(text.length == 0 && NSEqualRanges(range, NSMakeRange(textView.text.length - 1, 1))){
        // 点击键盘上的删除按钮
        [self deleteText];
        return NO;
    }else if(self.maxEnableCount > 0){
        NSString *string = [textView.text stringByReplacingCharactersInRange:range withString:text];
        if(string.length > self.maxEnableCount){
            [self showAlertView];
            return NO;
        }
    }
    return YES;
}

- (void)showAlertView{
    NSString *message = [NSString stringWithFormat:@"输入的内容太长了，请控制在%lu个字符以内！", (unsigned long)self.maxEnableCount];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"我知道了", nil];
    [alertView show];
}

- (void)textViewTextDidChangeNotification:(NSNotification *)notification{
    CGSize contentSize = self.textView.contentSize;
    CGFloat maxHeight = 80.0;
    if(contentSize.height <= maxHeight || self.textView.frame.size.height <= maxHeight){
        CGRect textViewFrame = self.textView.frame;
        if(contentSize.height < _textViewMinHeight){
            textViewFrame.size.height = _textViewMinHeight;
        }else{
            textViewFrame.size.height = contentSize.height;
            if(textViewFrame.size.height > maxHeight){
                textViewFrame.size.height = maxHeight;
            }
        }
        
        CGRect frame = self.frame;
        frame.size.height = 14.0 + textViewFrame.size.height;
        frame.origin.y = [UIScreen mainScreen].bounds.size.height - (self.currentKeyboardHeight + frame.size.height);
        self.frame = frame;
        self.textView.frame = textViewFrame;
    }
}

- (void)keyboardWillShowNotification:(NSNotification *)notification{
    self.hideWithKeyboardHidden = YES;
    self.emojiKeyboard = NO;
}

- (void)keyboardWillHideNotification:(NSNotification *)notification{
    if(!self.hidden){ // 如果当前输入框都隐藏了，就表明是退出键盘了，不需要再弹出表情键盘了
        self.emojiKeyboard = YES;
    }
}

- (void)keyboardWillChangeFrameNotification:(NSNotification *)notification{
    if(self.hideWithKeyboardHidden){
        CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        self.currentKeyboardHeight = keyboardFrame.size.height;
        self.keyboardAnimationDuration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
        
        CGRect frame = self.frame;
        CGFloat screen_height = [UIScreen mainScreen].bounds.size.height;
        if(keyboardFrame.origin.y == screen_height){
            frame.origin.y += keyboardFrame.size.height;
        }else{
            frame.origin.y = screen_height - keyboardFrame.size.height - frame.size.height;
        }
        
        _isChangedFrame = YES;
        self.frame = frame;
    }
}

- (void)setFrame:(CGRect)frame{
    frame.origin.x = 0;
    frame.size.width = [UIScreen mainScreen].bounds.size.width;
    
    if(!self.isChangedFrame){
        frame.size.height = 50.0;
        frame.origin.y = [UIScreen mainScreen].bounds.size.height - frame.size.height;
        self.defaultFrame = frame;
    }
    [super setFrame:frame];
}

- (void)show{
    if(self.hidden){
        [self.textView becomeFirstResponder]; // 叫出键盘
        self.hidden = NO;
    }
}

- (void)hide{
    self.hidden = YES;
    
    if(self.emojiKeyboard){
        [self emojiKeyboardAppearOrDisappear:NO];
        CGRect frame = self.frame;
        frame.origin.y = [UIScreen mainScreen].bounds.size.height;
        self.frame = frame;
    }else{
        self.hideWithKeyboardHidden = YES;
        [self endEditing:YES];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if(self.isInitSubviewFrame){
        _textViewMinHeight = 36.0;
        CGFloat margin = 10.0;
        CGFloat textView_W = self.bounds.size.width - _textViewMinHeight - margin * 3;
        CGFloat textView_H = _textViewMinHeight;
        CGFloat textView_X = margin;
        CGFloat textView_Y = (self.bounds.size.height - textView_H) * 0.5;
        self.textView.frame = CGRectMake(textView_X, textView_Y, textView_W, textView_H);
        
        CGFloat emojiButton_H = _textViewMinHeight;
        CGFloat emojiButton_W = emojiButton_H;
        CGFloat emojiButton_Y = (self.bounds.size.height - emojiButton_H) * 0.5;
        CGFloat emojiButton_X = self.bounds.size.width - emojiButton_W - margin;
        self.emojiButton.frame = CGRectMake(emojiButton_X, emojiButton_Y, emojiButton_W, emojiButton_H);
        _isInitSubviewFrame = NO;
        
        self.textViewDefaultFrame = self.textView.frame;
    }
}

- (void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    self.textView.placeholder = placeholder;
}

- (void)emojiButtonClick:(UIButton *)button{
    if(self.emojiView == nil){
        self.emojiView = [[SLKeyboardEmojiView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, 0, 0)];
        self.emojiView.delegate = self;
        [self.superview addSubview:self.emojiView];
    }
    
    if(self.emojiKeyboard){
        [self.textView becomeFirstResponder]; // 叫出键盘
    }else{
        [self endEditing:YES]; // 退出键盘
    }
}

- (void)setEmojiKeyboard:(BOOL)emojiKeyboard{
    _emojiKeyboard = emojiKeyboard;
    if(emojiKeyboard){ // 如果当前是表情键盘，当前的键盘高度需要变化
        self.currentKeyboardHeight = self.emojiView.bounds.size.height;
        [self.emojiButton setImage:[UIImage imageNamed:@"friendcircle_keyboard_normal"] forState:UIControlStateNormal];
        [self.emojiButton setImage:[UIImage imageNamed:@"friendcircle_keyboard_highlighted"] forState:UIControlStateHighlighted];
    }else{
        [self.emojiButton setImage:[UIImage imageNamed:@"friendcircle_emotion_normal"] forState:UIControlStateNormal];
        [self.emojiButton setImage:[UIImage imageNamed:@"friendcircle_emotion_highlighted"] forState:UIControlStateHighlighted];
    }
    [self emojiKeyboardAppearOrDisappear:emojiKeyboard];
}

- (void)sendText{
    if(self.textView.text.length > 0){
        if(self.delegate && [self.delegate respondsToSelector:@selector(keyboardInputView:didClickSendButton:)]){
            [self.delegate keyboardInputView:self didClickSendButton:self.textView.text];
        }
        
        if(self.emojiKeyboard){
            [self emojiKeyboardAppearOrDisappear:NO];
        }else{
            self.hideWithKeyboardHidden = YES;
        }
        
        self.hidden = YES; // 先隐藏
        [self endEditing:YES]; // 结束编辑
        self.textView.text = nil; // 清空内容
        
        // 还原默认的frame
        self.frame = self.defaultFrame;
        self.textView.frame = self.textViewDefaultFrame;
    }
}

- (void)deleteText{
    if(self.textView.text.length > 0){
        NSRange range = NSMakeRange(0, self.textView.text.length - 1);
        if([self.textView.text hasSuffix:@"]"]){ // 以"]"结尾，可能为表情
            NSArray *matches = [self.emojiRegularExpression matchesInString:self.textView.text options:0 range:NSMakeRange(0, self.textView.text.length)];
            NSTextCheckingResult *result =  [matches lastObject]; // 匹配到的最后一个表情结果
            if(result != nil){
                // 匹配到的表情标记
                NSString *lastEmojiKey = [self.textView.text substringWithRange:result.range];
                // 确定是一个表情，如果不是以这个标记结尾，则最后一个不是表情
                if([self.textView.text hasSuffix:lastEmojiKey]){
                    range = NSMakeRange(0, self.textView.text.length - result.range.length);
                }
            }
        }
        
        [self setTextViewTextContent:[self.textView.text substringWithRange:range]];
    }
}

- (void)emojiKeyboardAppearOrDisappear:(BOOL)appearOrDisappear{
    CGRect emojiKeyboardFrame = self.emojiView.frame;
    CGRect frame = self.frame;
    if(appearOrDisappear){
        emojiKeyboardFrame.origin.y = [UIScreen mainScreen].bounds.size.height - emojiKeyboardFrame.size.height;
        frame.origin.y = emojiKeyboardFrame.origin.y - frame.size.height;
    }else{
        emojiKeyboardFrame.origin.y = [UIScreen mainScreen].bounds.size.height;
    }
    
    __block typeof(self) bself = self;
    [UIView animateWithDuration:self.keyboardAnimationDuration animations:^{
        bself.emojiView.frame = emojiKeyboardFrame;
        if(appearOrDisappear){
            bself.frame = frame;
        }
    }];
}

#pragma -mark emoji delegater

- (void)keyboardEmojiView:(SLKeyboardEmojiView *)keyboardEmojiView didSelectedEmoji:(NSString *)emojiKey{
    NSString *content = [NSString stringWithFormat:@"%@%@", self.textView.text, emojiKey];
    if(self.maxEnableCount > 0 && content.length > self.maxEnableCount){
        [self showAlertView];
    }else{
        [self setTextViewTextContent:content];
    }
}

- (void)keyboardEmojiViewDidClickDeleteButton:(SLKeyboardEmojiView *)keyboardEmojiView{
    [self deleteText];
}

- (void)setTextViewTextContent:(NSString *)textContent{
    self.textView.text = textContent;
    [self textViewTextDidChangeNotification:nil];
    [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length - 1, 1)];
}

- (void)keyboardEmojiViewDidClickSendButton:(SLKeyboardEmojiView *)keyboardEmojiView{
    if(self.maxEnableCount > 0 && self.textView.text.length > self.maxEnableCount){
        [self showAlertView];
    }else{
        [self sendText];
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
