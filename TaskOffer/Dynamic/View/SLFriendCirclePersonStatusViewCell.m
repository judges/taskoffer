//
//  SLFriendCirclePersonStatusViewCell.m
//  XMPPIM
//
//  Created by wshaolin on 14/12/26.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import "SLFriendCirclePersonStatusViewCell.h"
#import "SLFriendCirclePersonStatusImageView.h"
#import "SLFriendCirclePersonStatusFrameModel.h"
#import "SLFriendCircleFont.h"

@interface SLFriendCirclePersonStatusViewCell()

@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *positionLabel;

@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, strong) SLFriendCirclePersonStatusImageView *statusImageView;
@property (nonatomic, strong) UILabel *imageCountLabel;

@property (nonatomic, strong) UIView *contentLabelBackgroundView;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation SLFriendCirclePersonStatusViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *cellReusableIdentifier = @"SLFriendCirclePersonStatusViewCell";
    SLFriendCirclePersonStatusViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReusableIdentifier];
    if(cell == nil){
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReusableIdentifier];
    }
    return cell;
}

- (UIView *)leftView{
    if(_leftView == nil){
        _leftView = [[UIView alloc] init];
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.textAlignment = NSTextAlignmentLeft;
        _dateLabel.backgroundColor = [UIColor clearColor];
        
        _positionLabel = [[UILabel alloc] init];
        _positionLabel.textAlignment = NSTextAlignmentLeft;
        _positionLabel.backgroundColor = [UIColor clearColor];
        _positionLabel.font = SLFriendCirclePersonStatusPositionFont;
        _positionLabel.textColor = SLFriendCirclePersonStatusPositionColor;
        _positionLabel.numberOfLines = 0;
        
        [_leftView addSubview:_dateLabel];
        [_leftView addSubview:_positionLabel];
    }
    return _leftView;
}

- (UIView *)rightView{
    if(_rightView == nil){
        _rightView = [[UIView alloc] init];
        _statusImageView = [[SLFriendCirclePersonStatusImageView alloc] init];
        _contentLabelBackgroundView = [[UIView alloc] init];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.textColor = SLFriendCirclePersonStatusContentColor;
        _contentLabel.font = SLFriendCirclePersonStatusContentFont;
        _contentLabel.numberOfLines = 0;
        [_contentLabelBackgroundView addSubview:_contentLabel];
        
        _imageCountLabel = [[UILabel alloc] init];
        _imageCountLabel.textAlignment = NSTextAlignmentLeft;
        _imageCountLabel.textColor = SLFriendCirclePersonStatusImageCountColor;
        _imageCountLabel.font = SLFriendCirclePersonStatusImageCountFont;
        
        [_rightView addSubview:_statusImageView];
        [_rightView addSubview:_contentLabelBackgroundView];
        [_rightView addSubview:_imageCountLabel];
        
        [_rightView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rowTap:)]];
    }
    return _rightView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self.contentView addSubview:self.leftView];
        [self.contentView addSubview:self.rightView];
        
        self.backgroundView = nil;
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setFriendCirclePersonStatusFrameModel:(SLFriendCirclePersonStatusFrameModel *)friendCirclePersonStatusFrameModel{
    _friendCirclePersonStatusFrameModel = friendCirclePersonStatusFrameModel;
    self.dateLabel.attributedText = [friendCirclePersonStatusFrameModel.dateAttributedString copy];
    self.dateLabel.frame = friendCirclePersonStatusFrameModel.dateLabelFrame;
    
    self.positionLabel.text = friendCirclePersonStatusFrameModel.friendCircleStatusModel.position;
    self.positionLabel.frame = friendCirclePersonStatusFrameModel.positionLabelFrame;
    
    self.leftView.frame = friendCirclePersonStatusFrameModel.leftViewFrame;
    self.rightView.frame = friendCirclePersonStatusFrameModel.rightViewFrame;
    
    self.statusImageView.frame = friendCirclePersonStatusFrameModel.imageViewFrame;
    self.statusImageView.hidden = friendCirclePersonStatusFrameModel.friendCircleStatusModel.imageUrls.count == 0;
    self.statusImageView.imageUrl = friendCirclePersonStatusFrameModel.friendCircleStatusModel.imageUrls;
    
    self.contentLabel.text = friendCirclePersonStatusFrameModel.friendCircleStatusModel.content;
    self.contentLabel.frame = friendCirclePersonStatusFrameModel.contentLabelFrame;
    self.contentLabelBackgroundView.frame = friendCirclePersonStatusFrameModel.contentViewFrame;
    if(friendCirclePersonStatusFrameModel.friendCircleStatusModel.imageUrls.count == 0){
        self.contentLabelBackgroundView.backgroundColor = [UIColor colorWithHexString:kDefaultGrayColor];
    }else{
        self.contentLabelBackgroundView.backgroundColor = [UIColor clearColor];
    }
    
    self.imageCountLabel.frame = friendCirclePersonStatusFrameModel.imageCountLabelFrame;
    self.imageCountLabel.hidden = friendCirclePersonStatusFrameModel.friendCircleStatusModel.imageUrls.count < 4;
    if(friendCirclePersonStatusFrameModel.friendCircleStatusModel.imageUrls.count >= 4){
        self.imageCountLabel.text = [NSString stringWithFormat:@"共%ld张", (long)friendCirclePersonStatusFrameModel.friendCircleStatusModel.imageUrls.count];
    }
}

- (void)setHideDate:(BOOL)hideDate{
    _hideDate = hideDate;
    self.leftView.hidden = hideDate;
}

- (void)rowTap:(UITapGestureRecognizer *)tapGestureRecognizer{
    if(self.delegate && [self.delegate respondsToSelector:@selector(friendCirclePersonStatusViewCell:didTapAtIndexPath:)]){
        [self.delegate friendCirclePersonStatusViewCell:self didTapAtIndexPath:self.indexPath];
    }
}

@end
