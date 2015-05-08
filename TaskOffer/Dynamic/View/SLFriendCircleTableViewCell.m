//
//  SLFriendCircleTableViewCell.m
//  XMPPIM
//
//  Created by wshaolin on 14/12/19.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import "SLFriendCircleTableViewCell.h"
#import "SLFriendCircleStatusCommentFrameModel.h"
#import "SLFriendCircleFont.h"
#import "IMAttributedLabel.h"
#import "SLFriendCircleConstant.h"

@interface SLFriendCircleTableViewCell()<UIActionSheetDelegate>

@property (nonatomic, strong) IMAttributedLabel *contentLabel;
@property (nonatomic, strong) UIView *contentBackgroundView;

@end

@implementation SLFriendCircleTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *cellReusableIdentifier = @"SLFriendCircleTableViewCell";
    SLFriendCircleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReusableIdentifier];
    if(cell == nil){
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReusableIdentifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self.contentView addSubview:self.contentBackgroundView];
        self.backgroundView = nil;
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (UIView *)contentBackgroundView{
    if(_contentBackgroundView == nil){
        _contentBackgroundView = [[UIView alloc] init];
        _contentBackgroundView.backgroundColor = [UIColor colorWithHexString:kDefaultGrayColor];
        [_contentBackgroundView addSubview:self.contentLabel];
    }
    return _contentBackgroundView;
}

- (IMAttributedLabel *)contentLabel{
    if(_contentLabel == nil){
        _contentLabel = [[IMAttributedLabel alloc] init];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = SLFriendCircleCommentContentFont;
        _contentLabel.textColor = SLFriendCircleCommentContentColor;
        _contentLabel.enableTapAttributedText = YES;
    }
    return _contentLabel;
}

- (void)setFriendCircleStatusCommentFrameModel:(SLFriendCircleStatusCommentFrameModel *)friendCircleStatusCommentFrameModel{
    _friendCircleStatusCommentFrameModel = friendCircleStatusCommentFrameModel;
    self.contentLabel.frame = friendCircleStatusCommentFrameModel.statusCommentFrame;
    
    // 发送人相关
    SLFriendCircleUserModel *senderUserModel = friendCircleStatusCommentFrameModel.friendCircleStatusCommentModel.senderUserModel;
    NSInteger senderLength = senderUserModel.displayName.length;
    NSRange senderRange = NSMakeRange(0, senderLength);
    NSDictionary *senderComponents = @{kSLFriendCircleAttributedLabelUser : senderUserModel};
    NSTextCheckingResult *senderResult = [NSTextCheckingResult transitInformationCheckingResultWithRange:senderRange components:senderComponents];
    
    // 接收人相关
    SLFriendCircleUserModel *recipientUserModel = friendCircleStatusCommentFrameModel.friendCircleStatusCommentModel.recipientUserModel;
    NSInteger recipientLength = recipientUserModel.displayName.length;
    NSRange recipientRange = NSMakeRange(senderRange.location + senderRange.length + 2, recipientLength);
    NSDictionary *recipientComponents = @{kSLFriendCircleAttributedLabelUser : recipientUserModel};
    NSTextCheckingResult *recipientResult = [NSTextCheckingResult transitInformationCheckingResultWithRange:recipientRange components:recipientComponents];
    
    __block typeof(self) bself = self;
    if(friendCircleStatusCommentFrameModel.friendCircleStatusCommentModel.messageType == SLFriendCircleStatusCommentModelMessageTypeComment){
        self.contentLabel.emojiText = [NSString stringWithFormat:@"%@：%@", senderUserModel.displayName, friendCircleStatusCommentFrameModel.friendCircleStatusCommentModel.commentContent];
        // 下面的代码必须放在设置emojiText之后
        [self.contentLabel addLinkWithTextCheckingResult:senderResult];
    }else{
        self.contentLabel.emojiText = [NSString stringWithFormat:@"%@回复%@：%@", senderUserModel.displayName, recipientUserModel.displayName, friendCircleStatusCommentFrameModel.friendCircleStatusCommentModel.commentContent];
        // 下面的代码必须放在设置emojiText之后
        [self.contentLabel addLinkWithTextCheckingResult:senderResult];
        [self.contentLabel addLinkWithTextCheckingResult:recipientResult];
    }
    
    self.contentLabel.textSelectedHandler = ^(IMAttributedLabel *attributedLabel, NSTextCheckingResult *result){
        [bself didClickAttributedLabelUser:result];
    };
    
    self.contentLabel.textTapHandler = ^(IMAttributedLabel *attributedLabel, NSString *text){
        // 如果是自己的，则弹出删除选择项
        if(senderUserModel.isCurrentUser){
//            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:bself cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil, nil];
//            [actionSheet showInView:bself];
        }else{
            if(bself.delegate && [bself.delegate respondsToSelector:@selector(friendCircleTableViewCell:didTapfriendCircleComment:withFriendCircleReplyUser:)]){
                NSString *commentId = bself.friendCircleStatusCommentFrameModel.friendCircleStatusCommentModel.commentId;
                [bself.delegate friendCircleTableViewCell:bself didTapfriendCircleComment:commentId withFriendCircleReplyUser:senderUserModel];
            }
        }
    };
}

- (void)didClickAttributedLabelUser:(NSTextCheckingResult *)result{
    SLFriendCircleUserModel *userModel = result.components[kSLFriendCircleAttributedLabelUser];
    if(self.delegate && [self.delegate respondsToSelector:@selector(friendCircleTableViewCell:didTapfriendCircleCommentUser:)]){
        [self.delegate friendCircleTableViewCell:self didTapfriendCircleCommentUser:userModel];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){ // 删除评论
        
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat contentBackgroundView_X = 60.0;
    CGFloat contentBackgroundView_Y = 0;
    CGFloat contentBackgroundView_W = self.bounds.size.width - contentBackgroundView_X - 10.0;
    CGFloat contentBackgroundView_H = self.bounds.size.height;
    self.contentBackgroundView.frame = CGRectMake(contentBackgroundView_X, contentBackgroundView_Y, contentBackgroundView_W, contentBackgroundView_H);
}

@end
