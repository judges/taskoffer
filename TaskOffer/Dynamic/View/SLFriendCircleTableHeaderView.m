//
//  SLFriendCircleTableHeaderView.m
//  XMPPIM
//
//  Created by wshaolin on 14/12/17.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import "SLFriendCircleTableHeaderView.h"
#import "UIImageView+SetImage.h"
#import "SLFriendCircleConstant.h"
#import "SLFriendCircleSQLiteHandler.h"
#import "SLFriendCircleMessageButton.h"
#import "HexColor.h"

@interface SLFriendCircleTableHeaderView()

@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) UILabel *nickNameLabel;
@property (nonatomic, strong) SLFriendCircleMessageButton *messageButton;
@property (nonatomic, strong) UIView *bottomView;

@end

@implementation SLFriendCircleTableHeaderView

- (UIImageView *)backgroundView{
    if(_backgroundView == nil){
        _backgroundView = [[UIImageView alloc] init];
        _backgroundView.backgroundColor = [UIColor colorWithHexString:kDefaultGrayColor];
        _backgroundView.userInteractionEnabled = YES;
        _backgroundView.image = [UIImage imageNamed:@"friendcircle_all_table_head_background"];
    }
    return _backgroundView;
}

- (UILabel *)nickNameLabel{
    if(_nickNameLabel == nil){
        _nickNameLabel = [[UILabel alloc] init];
        _nickNameLabel.backgroundColor = [UIColor clearColor];
        _nickNameLabel.textAlignment = NSTextAlignmentCenter;
        _nickNameLabel.textColor = [UIColor whiteColor];
        _nickNameLabel.font = [UIFont boldSystemFontOfSize:16.0];
    }
    return _nickNameLabel;
}

- (UIView *)bottomView{
    if(_bottomView == nil){
        _bottomView = [[UIView alloc] init];
        
        _messageButton = [SLFriendCircleMessageButton buttonWithType:UIButtonTypeCustom];
        _messageButton.hidden = YES;
        [_messageButton addTarget:self action:@selector(messageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_bottomView addSubview:_messageButton];
    }
    return _bottomView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    return [self initWithFrame:frame isNeedMessageButton:NO];
}

- (instancetype)initWithFrame:(CGRect)frame isNeedMessageButton:(BOOL)isNeed{
    _isNeedMessageButton = isNeed;
    if(self = [super initWithFrame:frame]){
        [self addSubview:self.backgroundView];
        
        _iconView = [[UIImageView alloc] init];
        _iconView.backgroundColor = [UIColor clearColor];
        _iconView.userInteractionEnabled = YES;
        _iconView.layer.masksToBounds = YES;
        _iconView.layer.borderWidth = 2.0;
        _iconView.layer.borderColor = [UIColor whiteColor].CGColor;
        [_iconView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconViewTap:)]];
        
        [self addSubview:_iconView];
        [self addSubview:self.nickNameLabel];
        if(_isNeedMessageButton){
            [self addSubview:self.bottomView];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNewMessageNotification:) name:kSLFriendCircleHasNewMessageNotification object:nil];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(readedMessageNotification:) name:kSLFriendCircleReadedMessageNotification object:nil];
        }
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    frame.size.height = 175.0;
    if(self.isNeedMessageButton){
        frame.size.height += 50.0;
    }
    [super setFrame:frame];
}

- (void)setHideNickName:(BOOL)hideNickName{
    _hideNickName = hideNickName;
    self.nickNameLabel.hidden = hideNickName;
}

- (void)setNickName:(NSString *)nickName{
    _nickName = nickName;
    self.nickNameLabel.text = nickName;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat bottomView_H = 50.0;
    if(self.isNeedMessageButton){
        CGFloat bottomView_W = self.bounds.size.width;
        CGFloat bottomView_X = 0;
        CGFloat bottomView_Y = self.bounds.size.height - bottomView_H;
        self.bottomView.frame = CGRectMake(bottomView_X, bottomView_Y, bottomView_W, bottomView_H);
        
        CGFloat messageButton_H = 40.0;
        CGFloat messageButton_W = 180.0;
        CGFloat messageButton_X = (bottomView_W - messageButton_W) * 0.5;
        CGFloat messageButton_Y = bottomView_H - messageButton_H;
        self.messageButton.frame = CGRectMake(messageButton_X, messageButton_Y, messageButton_W, messageButton_H);
        
        self.messageButton.imageView.frame = CGRectMake(0, 0, messageButton_H, messageButton_H);
    }else{
        bottomView_H = 0;
    }
    
    CGRect backgroundViewFrame = self.bounds;
    backgroundViewFrame.size.height -= bottomView_H;
    self.backgroundView.frame = backgroundViewFrame;
    
    CGFloat iconView_H = 80.0;
    CGFloat iconView_W = iconView_H;
    CGFloat iconView_X = (self.bounds.size.width - iconView_W) * 0.5;
    CGFloat iconView_Y = (self.bounds.size.height - iconView_H - bottomView_H) * 0.5;
    self.iconView.frame = CGRectMake(iconView_X, iconView_Y, iconView_W, iconView_H);
    self.iconView.layer.cornerRadius = iconView_H * 0.5;

    CGFloat nickNameLabel_W = 200.0;
    CGFloat nickNameLabel_H = 30.0;
    
    CGFloat nickNameLabel_X = (self.bounds.size.width - nickNameLabel_W) * 0.5;
    CGFloat nickNameLabel_Y = CGRectGetMaxY(self.iconView.frame);
    self.nickNameLabel.frame = CGRectMake(nickNameLabel_X, nickNameLabel_Y, nickNameLabel_W, nickNameLabel_H);
}

- (void)iconViewTap:(UITapGestureRecognizer *)tapGestureRecognizer{
    if(tapGestureRecognizer.view == self.iconView){
        if(self.delegate && [self.delegate respondsToSelector:@selector(friendCircleTableHeaderViewIconTap:)]){
            [self.delegate friendCircleTableHeaderViewIconTap:self];
        }
    }
}

- (void)receiveNewMessageNotification:(NSNotification *)notification{
    //NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //NSString *username = [userDefaults stringForKey:kSLFriendCircleNewestMessageUsername];
    //[self.messageButton setImage:[[SLFriendCircleUserHandler sharedHandler] friendCircleUserModelWithUsername:username].icon forState:UIControlStateNormal];
    NSInteger unreadMessageCount = [SLFriendCircleSQLiteHandler allUnreadMessageCount];
    self.messageButton.hidden = unreadMessageCount == 0;
    NSString *title = [NSString stringWithFormat:@"%ld条新消息", (long)unreadMessageCount];
    [self.messageButton setTitle:title forState:UIControlStateNormal];
}

- (void)readedMessageNotification:(NSNotification *)notification{
    self.messageButton.hidden = YES;
}

- (void)messageButtonClick:(UIButton *)button{
    if(self.delegate && [self.delegate respondsToSelector:@selector(friendCircleTableHeaderViewMessageButtonTap:)]){
        [self.delegate friendCircleTableHeaderViewMessageButtonTap:self];
    }
}

- (void)dealloc{
    
    if(self.isNeedMessageButton){
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

@end
