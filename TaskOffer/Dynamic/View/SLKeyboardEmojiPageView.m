//
//  SLKeyboardEmojiPageView.m
//  XMPPIM
//
//  Created by wshaolin on 15/1/4.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLKeyboardEmojiPageView.h"
#import "SLEmojiModel.h"

@interface SLKeyboardEmojiPageView()

@property (nonatomic, strong) NSArray *buttonArray;

@end

@implementation SLKeyboardEmojiPageView

- (instancetype)initWithFrame:(CGRect)frame emojiArray:(NSArray *)emojiArray{
    if(self = [super initWithFrame:frame]){
        [self createEmojiButton];
        
        [self setEmojiArray:emojiArray];
    }
    return self;
}

- (void)setEmojiArray:(NSArray *)emojiArray{
    _emojiArray = emojiArray;
    
    for(NSInteger index = 0; index < self.buttonArray.count; index ++){
        UIButton *button = self.buttonArray[index];
        button.hidden = (index >= emojiArray.count && index < self.buttonArray.count - 1);
        if(index < emojiArray.count){
            SLEmojiModel *emojiModel = emojiArray[index];
            [button setImage:[UIImage imageNamed:emojiModel.emojiImageName] forState:UIControlStateNormal];
        }
        
        if(index == self.buttonArray.count - 1){
            [button setImage:[UIImage imageNamed:@"faceDelete"] forState:UIControlStateNormal];
        }
    }
}

- (void)createEmojiButton{
    NSMutableArray *tempArray = [NSMutableArray array];
    for(NSInteger index = 0; index < SLKeyboardEmojiPageViewEmojiCount; index ++){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor clearColor];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = index;
        [self addSubview:button];
        [tempArray addObject:button];
    }
    self.buttonArray = [tempArray copy];
}

- (void)buttonClick:(UIButton *)button{
    if(button.tag < _emojiArray.count){
        SLEmojiModel *emojiModel = _emojiArray[button.tag];
        if(self.delegate && [self.delegate respondsToSelector:@selector(keyboardEmojiPageView:didSelectedEmoji:)]){
            [self.delegate keyboardEmojiPageView:self didSelectedEmoji:emojiModel.emojiKey];
        }
    }
    
    if(button.tag == SLKeyboardEmojiPageViewEmojiCount - 1){
        if(self.delegate && [self.delegate respondsToSelector:@selector(keyboardEmojiPageViewDidClickDeleteButton:)]){
            [self.delegate keyboardEmojiPageViewDidClickDeleteButton:self];
        }
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    NSInteger column = 7;
    NSInteger row = 3;
    CGFloat button_W = 28.0;
    CGFloat button_H = button_W;
    CGFloat margin_H = (self.bounds.size.width - column * button_W) / (column + 1);
    CGFloat margin_W = (self.bounds.size.height - row * button_H) / (row + 1);
    
    for(NSInteger index = 0; index < self.buttonArray.count; index ++){
        UIButton *button = self.buttonArray[index];
        CGFloat button_X = (index % column) * (button_W + margin_H) + margin_H;
        CGFloat button_Y = (index / column) * (button_H + margin_W) + margin_W;
        button.frame = CGRectMake(button_X, button_Y, button_W, button_H);
    }
}

@end
