//
//  SLFriendCircleTableSectionHeaderView.m
//  XMPPIM
//
//  Created by wshaolin on 14/12/19.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import "SLFriendCircleTableSectionHeaderView.h"
#import "SLFriendCircleImageCollectionView.h"
#import "UIImageView+SetImage.h"
#import "SLFriendCircleStatusFrameModel.h"
#import "SLFriendCircleFont.h"
#import "UIView+Conveniently.h"
#import "SLAlertView.h"
#import "IMAttributedLabel.h"
#import "SLFriendCircleConstant.h"
#import "HexColor.h"

#define CommentViewAnimateDuration 0.25

@interface SLFriendCircleTableSectionHeaderView()<UIAlertViewDelegate>

@property (nonatomic, strong) UIImageView *iconView; // icon
@property (nonatomic, strong) IMAttributedLabel *nickNameLabel; // 昵称
@property (nonatomic, strong) UILabel *companyAndJobLabel; // 公司职位
@property (nonatomic, strong) UILabel *dateTimeLabel; // 日期
@property (nonatomic, strong) UILabel *contentLabel; // 内容
@property (nonatomic, strong) UIView *topLine; // 底部的线
@property (nonatomic, strong) SLFriendCircleImageCollectionView *imageCollectionView; // 显示图片的view
@property (nonatomic, strong) UIButton *applaudButton; // 赞按钮
@property (nonatomic, strong) UIButton *commentButton; // 评论按钮
@property (nonatomic, strong) UIButton *deleteButton; // 删除按钮

@end

@implementation SLFriendCircleTableSectionHeaderView

+ (instancetype)sectionHeaderViewWithTableView:(UITableView *)tableView{
    static NSString *headerFooterViewReuseIdentifier = @"SLFriendCircleTableSectionHeaderView";
    SLFriendCircleTableSectionHeaderView *sectionHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerFooterViewReuseIdentifier];
    if(sectionHeaderView == nil){
        sectionHeaderView = [[self alloc] initWithReuseIdentifier:headerFooterViewReuseIdentifier];
    }
    return sectionHeaderView;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithReuseIdentifier:reuseIdentifier]){
        [self.contentView addSubview:self.topLine];
        [self.contentView addSubview:self.iconView];
        [self.contentView addSubview:self.nickNameLabel];
        [self.contentView addSubview:self.dateTimeLabel];
        [self.contentView addSubview:self.companyAndJobLabel];
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.imageCollectionView];
        [self.contentView addSubview:self.applaudButton];
        [self.contentView addSubview:self.commentButton];
        [self.contentView addSubview:self.deleteButton];
        
        self.backgroundView = nil;
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (UIImageView *)iconView{
    if(_iconView == nil){
        _iconView = [[UIImageView alloc] init];
        _iconView.backgroundColor = [UIColor colorWithHexString:kDefaultGrayColor];
        _iconView.userInteractionEnabled = YES;
        [_iconView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconHandlerTap:)]];
    }
    return _iconView;
}

- (IMAttributedLabel *)nickNameLabel{
    if(_nickNameLabel == nil){
        _nickNameLabel = [[IMAttributedLabel alloc] init];
        _nickNameLabel.font = SLFriendCircleNickNameFont;
        _nickNameLabel.textColor = SLFriendCircleNickNameColor;
        _nickNameLabel.backgroundColor = [UIColor clearColor];
    }
    return _nickNameLabel;
}

- (UILabel *)dateTimeLabel{
    if(_dateTimeLabel == nil){
        _dateTimeLabel = [[UILabel alloc] init];
        _dateTimeLabel.font = SLFriendCircleDateTimeFont;
        _dateTimeLabel.textColor = SLFriendCircleDateTimeColor;
        _dateTimeLabel.backgroundColor = [UIColor clearColor];
        _dateTimeLabel.textAlignment = NSTextAlignmentRight;
        _dateTimeLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _dateTimeLabel;
}

- (UILabel *)companyAndJobLabel{
    if(_companyAndJobLabel == nil){
        _companyAndJobLabel = [[UILabel alloc] init];
        _companyAndJobLabel.font = SLFriendCircleCompanyAndJobFont;
        _companyAndJobLabel.textColor = SLFriendCircleCompanyAndJobColor;
        _companyAndJobLabel.backgroundColor = [UIColor clearColor];
        _companyAndJobLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _companyAndJobLabel;
}

- (UILabel *)contentLabel{
    if(_contentLabel == nil){
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = SLFriendCircleContentFont;
        _contentLabel.textColor = SLFriendCircleContentColor;
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (UIView *)topLine{
    if(_topLine == nil){
        _topLine = [[UIView alloc] init];
        _topLine.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    }
    return _topLine;
}

- (UIButton *)applaudButton{
    if(_applaudButton == nil){
        _applaudButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_applaudButton setImage:[UIImage imageNamed:@"点赞"] forState:UIControlStateNormal];
        [_applaudButton setImage:[UIImage imageNamed:@"已点赞"] forState:UIControlStateSelected];
        [_applaudButton addTarget:self action:@selector(applaudButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _applaudButton;
}

- (UIButton *)commentButton{
    if(_commentButton == nil){
        _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commentButton setImage:[UIImage imageNamed:@"评论"] forState:UIControlStateNormal];
        [_commentButton addTarget:self action:@selector(commentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentButton;
}

- (UIButton *)deleteButton{
    if(_deleteButton == nil){
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setImage:[UIImage imageNamed:@"动态删除"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _deleteButton.hidden = YES;
    }
    return _deleteButton;
}

- (SLFriendCircleImageCollectionView *)imageCollectionView{
    if(_imageCollectionView == nil){
        _imageCollectionView = [[SLFriendCircleImageCollectionView alloc] init];
    }
    return _imageCollectionView;
}

- (void)setFriendCircleStatusFrameModel:(SLFriendCircleStatusFrameModel *)friendCircleStatusFrameModel{
    _friendCircleStatusFrameModel = friendCircleStatusFrameModel;
    SLFriendCircleUserModel *userModel = friendCircleStatusFrameModel.friendCircleStatusModel.userModel;
    [self.iconView setImageWithURL:userModel.iconURL placeholderImage:kUserDefaultIcon];
    
    self.iconView.frame = friendCircleStatusFrameModel.iconFrame;
    
    self.nickNameLabel.emojiText = friendCircleStatusFrameModel.friendCircleStatusModel.userModel.displayName;
    
    NSDictionary *components = @{kSLFriendCircleAttributedLabelUser : userModel};
    NSTextCheckingResult *textCheckingResult = [NSTextCheckingResult transitInformationCheckingResultWithRange:NSMakeRange(0, userModel.displayName.length) components:components];
    
    [self.nickNameLabel addLinkWithTextCheckingResult:textCheckingResult];
    
    __block typeof(self) bself = self;
    self.nickNameLabel.textSelectedHandler = ^(IMAttributedLabel *attributedLabel, NSTextCheckingResult *result){
        if(bself.delegate && [bself.delegate respondsToSelector:@selector(friendCircleTableSectionHeaderView:didTapDisplayNameForSection:)]){
            [bself.delegate friendCircleTableSectionHeaderView:bself didTapDisplayNameForSection:bself.section];
        }
    };
    self.nickNameLabel.frame = friendCircleStatusFrameModel.nickNameFrame;
    
    self.dateTimeLabel.text = friendCircleStatusFrameModel.friendCircleStatusModel.formatDateTime;
    self.dateTimeLabel.frame = friendCircleStatusFrameModel.dataTimeFrame;
    
    self.companyAndJobLabel.frame = friendCircleStatusFrameModel.companyAndJobFrame;
    self.companyAndJobLabel.text = friendCircleStatusFrameModel.friendCircleStatusModel.companyAndJob;
    
    self.contentLabel.text = friendCircleStatusFrameModel.friendCircleStatusModel.content;
    self.contentLabel.frame = friendCircleStatusFrameModel.contentFrame;
    
    self.imageCollectionView.imgaeUrls = friendCircleStatusFrameModel.friendCircleStatusModel.imageUrls;
    self.imageCollectionView.frame = friendCircleStatusFrameModel.imageCollectionFrame;
    self.applaudButton.frame = friendCircleStatusFrameModel.applaudButtonFrame;
    self.applaudButton.selected = friendCircleStatusFrameModel.friendCircleStatusModel.applauded;
    self.commentButton.frame = friendCircleStatusFrameModel.commentButtonFrame;
    self.deleteButton.frame = friendCircleStatusFrameModel.deleteButtonFrame;
}

- (void)setShowTopLine:(BOOL)showTopLine{
    _showTopLine = showTopLine;
    self.topLine.hidden = !showTopLine;
}

- (void)setShowDeleteButton:(BOOL)showDeleteButton{
    _showDeleteButton = showDeleteButton;
    self.deleteButton.hidden = !showDeleteButton;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat topLine_X = 0;
    CGFloat topLine_W = self.bounds.size.width;
    CGFloat topLine_H = 0.5;
    CGFloat topLine_Y = 0;
    self.topLine.frame = CGRectMake(topLine_X, topLine_Y, topLine_W, topLine_H);
}

#pragma -mark 调代理

- (void)applaudButtonClick:(UIButton *)button{
    button.selected = !button.selected;
    if(self.delegate && [self.delegate respondsToSelector:@selector(friendCircleTableSectionHeaderView:didTapApplaudForSection:isCancel:)]){
        [self.delegate friendCircleTableSectionHeaderView:self didTapApplaudForSection:self.section isCancel:self.friendCircleStatusFrameModel.friendCircleStatusModel.applauded];
    }
}

- (void)commentButtonClick:(UIButton *)button{
    if(self.delegate && [self.delegate respondsToSelector:@selector(friendCircleTableSectionHeaderView:didTapCommentForSection:)]){
        [self.delegate friendCircleTableSectionHeaderView:self didTapCommentForSection:self.section];
    }
}

- (void)deleteButtonClick:(UIButton *)button{
    [SLAlertView showWithMessage:@"确定删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitle:@"确定"];
}

- (void)iconHandlerTap:(UITapGestureRecognizer *)tapGestureRecognizer{
    if(self.delegate && [self.delegate respondsToSelector:@selector(friendCircleTableSectionHeaderView:didTapIconForSection:)]){
        [self.delegate friendCircleTableSectionHeaderView:self didTapIconForSection:self.section];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        if(self.delegate && [self.delegate respondsToSelector:@selector(friendCircleTableSectionHeaderView:didTapDeleteForSection:)]){
            [self.delegate friendCircleTableSectionHeaderView:self didTapDeleteForSection:self.section];
        }
    }
}

@end
