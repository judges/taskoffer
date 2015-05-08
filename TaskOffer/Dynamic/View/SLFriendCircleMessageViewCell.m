//
//  SLFriendCircleMessageViewCell.m
//  XMPPIM
//
//  Created by wshaolin on 14/12/27.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import "SLFriendCircleMessageViewCell.h"
#import "SLFriendCircleFont.h"
#import "SLFriendCircleMessageFrameModel.h"
#import "UIImageView+SetImage.h"
#import "IMAttributedLabel.h"

@interface SLFriendCircleMessageViewCell()

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *nickNameLabel;
@property (nonatomic, strong) IMAttributedLabel *messageLabel;
@property (nonatomic, strong) UILabel *dateTimeLabel;
@property (nonatomic, strong) UIImageView *contentImageView;
@property (nonatomic, strong) UILabel *contentTextLabel;
@property (nonatomic, strong) UIView *bottomLineView;

@end

@implementation SLFriendCircleMessageViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *cellReusableIdentifier = @"SLFriendCircleMessageViewCell";
    SLFriendCircleMessageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReusableIdentifier];
    if(cell == nil){
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReusableIdentifier];
    }
    return cell;
}

- (UIImageView *)iconView{
    if(_iconView == nil){
        _iconView = [[UIImageView alloc] init];
        _iconView.backgroundColor = [UIColor colorWithHexString:kDefaultGrayColor];
    }
    return _iconView;
}

- (UIImageView *)contentImageView{
    if(_contentImageView == nil){
        _contentImageView = [[UIImageView alloc] init];
        _contentImageView.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
    }
    return _contentImageView;
}

- (UILabel *)nickNameLabel{
    if(_nickNameLabel == nil){
        _nickNameLabel = [[UILabel alloc] init];
        _nickNameLabel.backgroundColor = [UIColor clearColor];
        _nickNameLabel.textAlignment = NSTextAlignmentLeft;
        _nickNameLabel.textColor = SLFriendCircleMessageNickNameColor;
        _nickNameLabel.font = SLFriendCircleMessageNickNameFont;
    }
    return _nickNameLabel;
}

- (IMAttributedLabel *)messageLabel{
    if(_messageLabel == nil){
        _messageLabel = [[IMAttributedLabel alloc] init];
        _messageLabel.backgroundColor = [UIColor clearColor];
        _messageLabel.textAlignment = NSTextAlignmentLeft;
        _messageLabel.textColor = SLFriendCircleMessageContentColor;
        _messageLabel.font = SLFriendCircleMessageContentFont;
        _messageLabel.numberOfLines = 0;
    }
    return _messageLabel;
}

- (UILabel *)dateTimeLabel{
    if(_dateTimeLabel == nil){
        _dateTimeLabel = [[UILabel alloc] init];
        _dateTimeLabel.backgroundColor = [UIColor clearColor];
        _dateTimeLabel.textAlignment = NSTextAlignmentLeft;
        _dateTimeLabel.textColor = SLFriendCircleMessageDateColor;
        _dateTimeLabel.font = SLFriendCircleMessageDateFont;
    }
    return _dateTimeLabel;
}

- (UILabel *)contentTextLabel{
    if(_contentTextLabel == nil){
        _contentTextLabel = [[UILabel alloc] init];
        _contentTextLabel.backgroundColor = [UIColor clearColor];
        _contentTextLabel.textAlignment = NSTextAlignmentLeft;
        _contentTextLabel.textColor = SLFriendCircleMessageStatusContentColor;
        _contentTextLabel.font = SLFriendCircleMessageStatusContentFont;
        _contentTextLabel.numberOfLines = 0;
        _contentTextLabel.backgroundColor = [UIColor colorWithHexString:@"dcdcdc"];
    }
    return _contentTextLabel;
}

- (UIView *)bottomLineView{
    if(_bottomLineView == nil){
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = SLGrayColor;
    }
    return _bottomLineView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.backgroundView = nil;
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.iconView];
        [self.contentView addSubview:self.nickNameLabel];
        [self.contentView addSubview:self.messageLabel];
        [self.contentView addSubview:self.dateTimeLabel];
        [self.contentView addSubview:self.contentImageView];
        [self.contentView addSubview:self.contentTextLabel];
        [self.contentView addSubview:self.bottomLineView];
    }
    return self;
}

- (void)setFriendCircleMessageFrameModel:(SLFriendCircleMessageFrameModel *)friendCircleMessageFrameModel{
    _friendCircleMessageFrameModel = friendCircleMessageFrameModel;
    //self.iconView.image = friendCircleMessageFrameModel.friendCircleMessageModel.userModel.icon;
    self.iconView.frame = friendCircleMessageFrameModel.iconFrame;
    
    self.nickNameLabel.text = friendCircleMessageFrameModel.friendCircleMessageModel.userModel.displayName;
    self.nickNameLabel.frame = friendCircleMessageFrameModel.nicknameFrame;
    
    if(friendCircleMessageFrameModel.friendCircleMessageModel.messageType == SLFriendCircleMessageTypeApplaud){
        self.messageLabel.emojiText = @"❤️";
    }else{
        self.messageLabel.emojiText = friendCircleMessageFrameModel.friendCircleMessageModel.messageContent;
    }
    self.messageLabel.frame = friendCircleMessageFrameModel.messageFrame;
    
    self.dateTimeLabel.text = friendCircleMessageFrameModel.friendCircleMessageModel.formatDate;
    self.dateTimeLabel.frame = friendCircleMessageFrameModel.dateFrame;
    
    self.contentTextLabel.text = friendCircleMessageFrameModel.friendCircleMessageModel.statusContent;
    self.contentTextLabel.frame = friendCircleMessageFrameModel.statusContentFrame;
    
    self.contentImageView.frame = friendCircleMessageFrameModel.statusContentFrame;
    
    if(friendCircleMessageFrameModel.friendCircleMessageModel.firstImageUrl != nil && friendCircleMessageFrameModel.friendCircleMessageModel.firstImageUrl.length > 0){
        self.contentTextLabel.hidden = YES;
        [self.contentImageView setImageWithURL:friendCircleMessageFrameModel.friendCircleMessageModel.firstImageUrl];
        self.contentImageView.hidden = NO;
    }else{
        self.contentTextLabel.hidden = NO;
        self.contentImageView.image = nil;
        self.contentImageView.hidden = YES;
    }
}

- (void)setLastRow:(BOOL)lastRow{
    _lastRow = lastRow;
    self.bottomLineView.hidden = lastRow;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat bottomLineView_W = self.bounds.size.width;
    CGFloat bottomLineView_H = 0.6;
    CGFloat bottomLineView_X = 0;
    CGFloat bottomLineView_Y = self.bounds.size.height - bottomLineView_H;
    self.bottomLineView.frame = CGRectMake(bottomLineView_X, bottomLineView_Y, bottomLineView_W, bottomLineView_H);
}

@end
