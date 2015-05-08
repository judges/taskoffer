//
//  SLConnectionDetailTableFooterView.m
//  TaskOffer
//
//  Created by wshaolin on 15/3/19.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLConnectionDetailTableFooterView.h"
#import "HexColor.h"
#import "SLConnectionButton.h"

@interface SLConnectionDetailTableFooterView()

@property (nonatomic, strong) SLConnectionButton *addFriendButton;
@property (nonatomic, strong) SLConnectionButton *deleteFriendButton;
@property (nonatomic, strong) SLConnectionButton *createChatButton;

@property (nonatomic, strong) UIView *topLineView;

@end;

@implementation SLConnectionDetailTableFooterView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self addSubview:self.topLineView];
        [self addSubview:self.addFriendButton];
        [self addSubview:self.deleteFriendButton];
        [self addSubview:self.createChatButton];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (SLConnectionButton *)addFriendButton{
    if(_addFriendButton == nil){
        _addFriendButton = [SLConnectionButton buttonWithType:UIButtonTypeCustom];
        _addFriendButton.title = @"添加好友";
        _addFriendButton.tag = SLConnectionDetailTableFooterViewButtonTypeAddFriend;
        [_addFriendButton addTarget:self action:@selector(didClickButton:)];
    }
    return _addFriendButton;
}

- (SLConnectionButton *)deleteFriendButton{
    if(_deleteFriendButton == nil){
        _deleteFriendButton = [SLConnectionButton buttonWithType:UIButtonTypeCustom];
        _deleteFriendButton.title = @"删除好友";
        _deleteFriendButton.tag = SLConnectionDetailTableFooterViewButtonTypeDeleteFriend;
        [_deleteFriendButton addTarget:self action:@selector(didClickButton:)];
    }
    return _deleteFriendButton;
}

- (SLConnectionButton *)createChatButton{
    if(_createChatButton == nil){
        _createChatButton = [SLConnectionButton buttonWithType:UIButtonTypeCustom];
        _createChatButton.title = @"发起聊天";
        _createChatButton.backgroundColor = [UIColor colorWithHexString:kDefaultTextColor];
        _createChatButton.tag = SLConnectionDetailTableFooterViewButtonTypeCreateChat;
        [_createChatButton addTarget:self action:@selector(didClickButton:)];
    }
    return _createChatButton;
}

- (UIView *)topLineView{
    if(_topLineView == nil){
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    }
    return _topLineView;
}

- (void)setFrame:(CGRect)frame{
    
}

- (void)setConnectionRelationship:(SLConnectionRelationship)connectionRelationship{
    _connectionRelationship = connectionRelationship;
    
    CGFloat x = 0;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = 0;
    switch (_connectionRelationship) {
        case SLConnectionRelationshipFriend:
            height = 96.0;
            break;
        case SLConnectionRelationshipSelf:
            break;
        case SLConnectionRelationshipStranger:
            height = 96.0;
            break;
        default:
            break;
    }
    CGFloat y = [UIScreen mainScreen].bounds.size.height - height;
    
    CGRect frame = CGRectMake(x, y, width, height);
    [super setFrame:frame];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(connectionDetailTableFooterView:didChangeFrame:)]){
        [self.delegate connectionDetailTableFooterView:self didChangeFrame:frame];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGRect topLineViewFrame = self.bounds;
    topLineViewFrame.size.height = 0.5;
    self.topLineView.frame = topLineViewFrame;
    
    CGFloat topAndBottonMargin = 8.0;
    CGFloat button_H = 36.0;
    CGFloat button_X = 10.0;
    CGFloat button_W = self.bounds.size.width - button_X * 2;
    
    switch (self.connectionRelationship) {
        case SLConnectionRelationshipSelf:{
            self.addFriendButton.frame = CGRectZero;
            self.deleteFriendButton.frame = CGRectZero;
            self.createChatButton.frame = CGRectZero;
        }
            break;
        case SLConnectionRelationshipStranger:{
            self.deleteFriendButton.frame = CGRectZero;
            self.addFriendButton.frame = CGRectZero;
            CGFloat createChatButton_Y = topAndBottonMargin;
            CGFloat addFriendButton_Y = self.bounds.size.height - button_H - topAndBottonMargin;
            self.createChatButton.frame = CGRectMake(button_X, createChatButton_Y, button_W, button_H);
            self.addFriendButton.frame = CGRectMake(button_X, addFriendButton_Y, button_W, button_H);
        }
            break;
        case SLConnectionRelationshipFriend:{
            self.addFriendButton.frame = CGRectZero;
            CGFloat createChatButton_Y = topAndBottonMargin;
            CGFloat deleteFriendButton_Y = self.bounds.size.height - button_H - topAndBottonMargin;
            self.createChatButton.frame = CGRectMake(button_X, createChatButton_Y, button_W, button_H);
            self.deleteFriendButton.frame = CGRectMake(button_X, deleteFriendButton_Y, button_W, button_H);
        }
            break;
        default:
            break;
    }
}

- (void)didClickButton:(UIButton *)button{
    if(self.delegate && [self.delegate respondsToSelector:@selector(connectionDetailTableFooterView:didClickButtonWithType:)]){
        [self.delegate connectionDetailTableFooterView:self didClickButtonWithType:button.tag];
    }
}

@end
