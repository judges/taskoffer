//
//  SLFriendCircleStatusDetailViewCell.m
//  XMPPIM
//
//  Created by wshaolin on 14/12/27.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import "SLFriendCircleStatusDetailViewCell.h"
#import "SLFriendCircleStatusDetailCommentFrameModel.h"
#import "UIImageView+SetImage.h"
#import "SLFriendCircleFont.h"
#import "IMAttributedLabel.h"
#import "SLFriendCircleConstant.h"
#import "HexColor.h"

@interface SLFriendCircleStatusDetailViewCell()

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) IMAttributedLabel *nickNameLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) IMAttributedLabel *contentLabel;

@end

@implementation SLFriendCircleStatusDetailViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *cellReusableIdentifier = @"SLFriendCircleStatusDetailViewCell";
    SLFriendCircleStatusDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReusableIdentifier];
    if(cell == nil){
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReusableIdentifier];
    }
    return cell;
}

- (UIImageView *)iconView{
    if(_iconView == nil){
        _iconView = [[UIImageView alloc] init];
        _iconView.layer.masksToBounds = NO;
        _iconView.userInteractionEnabled = YES;
        [_iconView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconViewTap:)]];
    }
    return _iconView;
}

- (IMAttributedLabel *)nickNameLabel{
    if(_nickNameLabel == nil){
        _nickNameLabel = [[IMAttributedLabel alloc] init];
        _nickNameLabel.backgroundColor = [UIColor clearColor];
        _nickNameLabel.textAlignment = NSTextAlignmentLeft;
        _nickNameLabel.textColor = SLFriendCircleStatusDetailCommentNickNameColor;
        _nickNameLabel.font = SLFriendCircleStatusDetailCommentNickNameFont;
    }
    return _nickNameLabel;
}

- (UILabel *)dateLabel{
    if(_dateLabel == nil){
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.backgroundColor = [UIColor clearColor];
        _dateLabel.textAlignment = NSTextAlignmentRight;
        _dateLabel.textColor = SLFriendCircleStatusDetailCommentDateColor;
        _dateLabel.font = SLFriendCircleStatusDetailCommentDateFont;
    }
    return _dateLabel;
}

- (IMAttributedLabel *)contentLabel{
    if(_contentLabel == nil){
        _contentLabel = [[IMAttributedLabel alloc] init];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.textColor = SLFriendCircleStatusDetailCommentContentColor;
        _contentLabel.font = SLFriendCircleStatusDetailCommentContentFont;
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.backgroundView = nil;
        self.backgroundColor = [UIColor colorWithHexString:kDefaultGrayColor];
        
        [self.contentView addSubview:self.iconView];
        [self.contentView addSubview:self.nickNameLabel];
        [self.contentView addSubview:self.dateLabel];
        [self.contentView addSubview:self.contentLabel];
    }
    return self;
}

- (void)setStatusDetailCommentFrameModel:(SLFriendCircleStatusDetailCommentFrameModel *)statusDetailCommentFrameModel{
    _statusDetailCommentFrameModel = statusDetailCommentFrameModel;
    
    self.iconView.frame = statusDetailCommentFrameModel.iconViewFrame;
    self.iconView.layer.cornerRadius = statusDetailCommentFrameModel.iconViewFrame.size.height * 0.5;
    [self.iconView setImageWithURL:statusDetailCommentFrameModel.friendCircleStatusCommentModel.senderUserModel.iconURL placeholderImage:kUserDefaultIcon];
    
    self.nickNameLabel.frame = statusDetailCommentFrameModel.nickNameFrame;
    NSString *displayName = statusDetailCommentFrameModel.friendCircleStatusCommentModel.senderUserModel.displayName;
    if(displayName != nil && displayName.length > 0){
        SLFriendCircleUserModel *senderUserModel = statusDetailCommentFrameModel.friendCircleStatusCommentModel.senderUserModel;
        NSRange senderRange = NSMakeRange(0, displayName.length);
        NSDictionary *senderComponents = @{kSLFriendCircleAttributedLabelUser : senderUserModel};
        NSTextCheckingResult *senderResult = [NSTextCheckingResult transitInformationCheckingResultWithRange:senderRange components:senderComponents];
        
        self.nickNameLabel.emojiText = displayName;
        
        [self.nickNameLabel addLinkWithTextCheckingResult:senderResult];
        __block typeof(self) bself = self;
        self.nickNameLabel.textSelectedHandler = ^(IMAttributedLabel *attributedLabel, NSTextCheckingResult *result){
            [bself didClickAttributedLabelUser:result];
        };
    }
    
    self.dateLabel.frame = statusDetailCommentFrameModel.dateTimeFrame;
    self.dateLabel.text = statusDetailCommentFrameModel.friendCircleStatusCommentModel.formatDateTime;
    
    self.contentLabel.frame = statusDetailCommentFrameModel.contentFrame;
    
    if(statusDetailCommentFrameModel.friendCircleStatusCommentModel.messageType == SLFriendCircleStatusCommentModelMessageTypeReply){
        SLFriendCircleUserModel *recipientUserModel = statusDetailCommentFrameModel.friendCircleStatusCommentModel.recipientUserModel;
        NSRange recipientRange = NSMakeRange(2, recipientUserModel.displayName.length);
        NSDictionary *recipientComponents = @{kSLFriendCircleAttributedLabelUser : recipientUserModel};
        NSTextCheckingResult *recipientResult = [NSTextCheckingResult transitInformationCheckingResultWithRange:recipientRange components:recipientComponents];
        
        self.contentLabel.emojiText = [NSString stringWithFormat:@"回复%@：%@", recipientUserModel.displayName, statusDetailCommentFrameModel.friendCircleStatusCommentModel.commentContent];
        
        [self.contentLabel addLinkWithTextCheckingResult:recipientResult];
        __block typeof(self) bself = self;
        self.contentLabel.textSelectedHandler = ^(IMAttributedLabel *attributedLabel, NSTextCheckingResult *result){
            [bself didClickAttributedLabelUser:result];
        };
    }else{
        self.contentLabel.emojiText = statusDetailCommentFrameModel.friendCircleStatusCommentModel.commentContent;
        self.contentLabel.textSelectedHandler = nil;
    }
}

- (void)iconViewTap:(UITapGestureRecognizer *)tapGestureRecognizer{
    [self didTapFriendCircleUser:self.statusDetailCommentFrameModel.friendCircleStatusCommentModel.senderUserModel];
}

- (void)didClickAttributedLabelUser:(NSTextCheckingResult *)result{
    SLFriendCircleUserModel *friendCircleUserModel = result.components[kSLFriendCircleAttributedLabelUser];
    
    [self didTapFriendCircleUser:friendCircleUserModel];
}

- (void)didTapFriendCircleUser:(SLFriendCircleUserModel *)friendCircleUserModel{
    if(self.delegate && [self.delegate respondsToSelector:@selector(friendCircleStatusDetailViewCell:didTapFriendCircleUser:)]){
        [self.delegate friendCircleStatusDetailViewCell:self didTapFriendCircleUser:friendCircleUserModel];
    }
}

@end
