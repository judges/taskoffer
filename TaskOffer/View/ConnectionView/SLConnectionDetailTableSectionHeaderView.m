//
//  SLConnectionDetailTableSectionHeaderView.m
//  TaskOffer
//
//  Created by wshaolin on 15/3/19.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLConnectionDetailTableSectionHeaderView.h"
#import "HexColor.h"

@interface SLConnectionDetailTableSectionHeaderView()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, strong) UIView *topLineView;

@end

@implementation SLConnectionDetailTableSectionHeaderView

+ (instancetype)sectionHeaderViewWithTableView:(UITableView *)tableView{
    static NSString *reuseIdentifier = @"SLConnectionDetailTableSectionHeaderView";
    SLConnectionDetailTableSectionHeaderView *sectionHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseIdentifier];
    if(sectionHeaderView == nil){
        sectionHeaderView = [[self alloc] initWithReuseIdentifier:reuseIdentifier];
    }
    return sectionHeaderView;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithReuseIdentifier:reuseIdentifier]){
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.moreButton];
        [self.contentView addSubview:self.bottomLineView];
        [self.contentView addSubview:self.topLineView];
        
        self.backgroundView = nil;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.hideMoreButton = YES;
    }
    return self;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
}

- (void)setHideMoreButton:(BOOL)hideMoreButton{
    _hideMoreButton = hideMoreButton;
    self.moreButton.hidden = hideMoreButton;
}

- (void)setHideTopLine:(BOOL)hideTopLine{
    _hideTopLine = hideTopLine;
    self.topLineView.hidden = hideTopLine;
}

- (void)setHideBottomLine:(BOOL)hideBottomLine{
    _hideBottomLine = hideBottomLine;
    self.bottomLineView.hidden = hideBottomLine;
}

- (UILabel *)titleLabel{
    if(_titleLabel == nil){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16.0];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [UIColor colorWithRed:43.0 / 255.0 green:82.0 / 255.0 blue:123.0 / 255.0 alpha:1.0];
    }
    return _titleLabel;
}

- (UIButton *)moreButton{
    if(_moreButton == nil){
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreButton setTitle:@"更多>" forState:UIControlStateNormal];
        [_moreButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_moreButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        _moreButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [_moreButton addTarget:self action:@selector(didClickMoreButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreButton;
}

- (UIView *)bottomLineView{
    if(_bottomLineView == nil){
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    }
    return _bottomLineView;
}

- (UIView *)topLineView{
    if(_topLineView == nil){
        _topLineView = [[UIView alloc] init];
        //_topLineView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        _topLineView.backgroundColor = [UIColor clearColor];
    }
    return _topLineView;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat margin = 10.0;
    
    CGRect topLineViewFrame = self.bounds;
    topLineViewFrame.size.height = 0.5;
    self.topLineView.frame = topLineViewFrame;
    
    CGFloat bottomLineView_X = 0;
    CGFloat bottomLineView_W = self.bounds.size.width - bottomLineView_X;
    CGFloat bottomLineView_H = topLineViewFrame.size.height;
    CGFloat bottomLineView_Y = self.bounds.size.height - bottomLineView_H;
    self.bottomLineView.frame = CGRectMake(bottomLineView_X, bottomLineView_Y, bottomLineView_W, bottomLineView_H);
    
    CGFloat moreButton_W = 60.0;
    CGFloat moreButton_H = 30.0;
    CGFloat moreButton_X = self.bounds.size.width - moreButton_W;
    CGFloat moreButton_Y = (self.bounds.size.height - moreButton_H) * 0.5;
    self.moreButton.frame = CGRectMake(moreButton_X, moreButton_Y, moreButton_W, moreButton_H);
    
    CGFloat titleLabel_X = margin;
    CGFloat titleLabel_H = moreButton_H;
    CGFloat titleLabel_W = moreButton_X - margin - titleLabel_X;
    CGFloat titleLabel_Y = (self.bounds.size.height - titleLabel_H) * 0.5;
    self.titleLabel.frame = CGRectMake(titleLabel_X, titleLabel_Y, titleLabel_W, titleLabel_H);
}

- (void)didClickMoreButton:(UIButton *)button{
    if(self.delegate && [self.delegate respondsToSelector:@selector(connectionDetailTableSectionHeaderView:didClickMoreButtonAtSection:)]){
        [self.delegate connectionDetailTableSectionHeaderView:self didClickMoreButtonAtSection:self.section];
    }
}

@end
