//
//  SLFriendCircleTableViewApplaudCell.m
//  XMPPIM
//
//  Created by wshaolin on 15/1/7.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLFriendCircleTableViewApplaudCell.h"
#import "SLFriendCircleFont.h"
#import "NSArray+String.h"
#import "SLFriendCircleUserModel.h"
#import "SLFriendCircleConstant.h"
#import "HexColor.h"
#import "IMAttributedLabel.h"

@interface SLFriendCircleTableViewApplaudCell()

@property (nonatomic, strong) IMAttributedLabel *contentLabel;
@property (nonatomic, strong) UIView *bottomLineView;

@property (nonatomic, strong) UIView *contentBackgroundView;

@end

@implementation SLFriendCircleTableViewApplaudCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *cellReusableIdentifier = @"SLFriendCircleTableViewApplaudCell";
    SLFriendCircleTableViewApplaudCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReusableIdentifier];
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
        [_contentBackgroundView addSubview:self.bottomLineView];
    }
    return _contentBackgroundView;
}

- (IMAttributedLabel *)contentLabel{
    if(_contentLabel == nil){
        _contentLabel = [[IMAttributedLabel alloc] init];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = SLFriendCircleApplaudShowContentFont;
        _contentLabel.textColor = SLFriendCircleApplaudShowContentColor;
    }
    return _contentLabel;
}

- (UIView *)bottomLineView{
    if(_bottomLineView == nil){
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    }
    return _bottomLineView;
}

- (void)setApplaudAttributedString:(NSAttributedString *)applaudAttributedString{
    _applaudAttributedString = applaudAttributedString;
    self.contentLabel.emojiText = [applaudAttributedString string];
}

- (void)setHideButtomLine:(BOOL)hideButtomLine{
    _hideButtomLine = hideButtomLine;
    self.bottomLineView.hidden = hideButtomLine;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat contentBackgroundView_X = 60.0;
    CGFloat contentBackgroundView_Y = 0;
    CGFloat contentBackgroundView_W = self.bounds.size.width - contentBackgroundView_X - 10.0;
    CGFloat contentBackgroundView_H = self.bounds.size.height;
    self.contentBackgroundView.frame = CGRectMake(contentBackgroundView_X, contentBackgroundView_Y, contentBackgroundView_W, contentBackgroundView_H);
    
    CGFloat margin = 5.0;
    CGFloat contentLabel_X = margin;
    CGFloat contentLabel_Y = 0;
    CGFloat contentLabel_H = contentBackgroundView_H - 0.5;
    CGFloat contentLabel_W = contentBackgroundView_W - contentLabel_X - margin;
    self.contentLabel.frame = CGRectMake(contentLabel_X, contentLabel_Y, contentLabel_W, contentLabel_H);
    
    CGFloat bottomLineView_X = contentLabel_X;
    CGFloat bottomLineView_W = contentBackgroundView_W - bottomLineView_X;
    CGFloat bottomLineView_H = 0.5;
    CGFloat bottomLineView_Y = contentBackgroundView_H - bottomLineView_H;
    self.bottomLineView.frame = CGRectMake(bottomLineView_X, bottomLineView_Y, bottomLineView_W, bottomLineView_H);
}

@end
