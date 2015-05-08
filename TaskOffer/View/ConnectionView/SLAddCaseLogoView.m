//
//  SLAddCaseLogoView.m
//  TaskOffer
//
//  Created by wshaolin on 15/3/21.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLAddCaseLogoView.h"
#import "SLSelectImageButton.h"
#import "HexColor.h"

@interface SLAddCaseLogoView()<SLSelectImageButtonDelegate>

@property (nonatomic, strong) UIView *logoTitleView;
@property (nonatomic, strong) UILabel *logoTitleLabel;
@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) UIView *middleLineView;
@property (nonatomic, strong) UIView *bottomLineView;

@property (nonatomic, strong) UIView *logoContentView;
@property (nonatomic, strong) SLSelectImageButton *selectImageButton;
@property (nonatomic, strong) UILabel *descLabel;

@end

@implementation SLAddCaseLogoView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self addSubview:self.topLineView];
        [self addSubview:self.logoTitleView];
        [self addSubview:self.middleLineView];
        [self addSubview:self.logoContentView];
        [self addSubview:self.bottomLineView];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (UIView *)logoTitleView{
    if(_logoTitleView == nil){
        _logoTitleView = [[UIView alloc] init];
        _logoTitleView.backgroundColor = [UIColor clearColor];
        [_logoTitleView addSubview:self.logoTitleLabel];
    }
    return _logoTitleView;
}

- (UILabel *)logoTitleLabel{
    if(_logoTitleLabel == nil){
        _logoTitleLabel = [[UILabel alloc] init];
        _logoTitleLabel.textAlignment = NSTextAlignmentLeft;
        _logoTitleLabel.textColor = [UIColor colorWithRed:43.0 / 255.0 green:82.0 / 255.0 blue:123.0 / 255.0 alpha:1.0];
        _logoTitleLabel.font = [UIFont systemFontOfSize:16.0];
        _logoTitleLabel.text = @"上传LOGO";
    }
    return _logoTitleLabel;
}

- (UIView *)topLineView{
    if(_topLineView == nil){
        _topLineView = [[UIView alloc] init];
        //_topLineView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        _topLineView.backgroundColor = [UIColor clearColor];
    }
    return _topLineView;
}

- (UIView *)middleLineView{
    if(_middleLineView == nil){
        _middleLineView = [[UIView alloc] init];
        _middleLineView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    }
    return _middleLineView;
}

- (UIView *)bottomLineView{
    if(_bottomLineView == nil){
        _bottomLineView = [[UIView alloc] init];
        //_bottomLineView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        _bottomLineView.backgroundColor = [UIColor clearColor];
    }
    return _bottomLineView;
}

- (UIView *)logoContentView{
    if(_logoContentView == nil){
        _logoContentView = [[UIView alloc] init];
        _logoContentView.backgroundColor = [UIColor whiteColor];
        [_logoContentView addSubview:self.selectImageButton];
        [_logoContentView addSubview:self.descLabel];
    }
    return _logoContentView;
}

- (SLSelectImageButton *)selectImageButton{
    if(_selectImageButton == nil){
        _selectImageButton = [[SLSelectImageButton alloc] init];
        _selectImageButton.delegate = self;
        [_selectImageButton setButtonNormalImage:@"add_image_normal" highlightedImage:@"add_image_highlighted"];
    }
    return _selectImageButton;
}

- (UILabel *)descLabel{
    if(_descLabel == nil){
        _descLabel = [[UILabel alloc] init];
        _descLabel.textAlignment = NSTextAlignmentLeft;
        _descLabel.textColor = [UIColor lightGrayColor];
        _descLabel.font = [UIFont systemFontOfSize:14.0];
        _descLabel.numberOfLines = 0;
        _descLabel.text = @"请上传尺寸大于60x60的LOGO，支持jpg、png、gif等常用图片格式。";
    }
    return _descLabel;
}

- (void)setFrame:(CGRect)frame{
    frame.origin.x = 0;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    frame.size = CGSizeMake(width, (width - 10.0 * 5) / 4 + 75.0);
    [super setFrame:frame];
}

- (void)setCaseLogoOrURL:(id)caseLogoOrURL{
    self.selectImageButton.imageOrURL = caseLogoOrURL;
}

- (id)caseLogoOrURL{
    return self.selectImageButton.imageOrURL;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat logoTitleView_W = self.bounds.size.width;
    CGFloat logoTitleView_X = 0;
    CGFloat logoTitleView_H = 35.0;
    CGFloat logoTitleView_Y = 0;
    self.logoTitleView.frame = CGRectMake(logoTitleView_X, logoTitleView_Y, logoTitleView_W, logoTitleView_H);
    
    CGFloat logoTitleLabel_X = 10.0;
    CGFloat logoTitleLabel_H = 20.0;
    CGFloat logoTitleLabel_Y = (logoTitleView_H - logoTitleLabel_H) * 0.5;
    CGFloat logoTitleLabel_W = logoTitleView_W - logoTitleLabel_X * 2;
    self.logoTitleLabel.frame = CGRectMake(logoTitleLabel_X, logoTitleLabel_Y, logoTitleLabel_W, logoTitleLabel_H);
    
    CGFloat middleLineView_X = 0;
    CGFloat middleLineView_H = 0.5;
    CGFloat middleLineView_W = self.bounds.size.width;
    CGFloat middleLineView_Y = CGRectGetMaxY(self.logoTitleView.frame);
    self.middleLineView.frame = CGRectMake(middleLineView_X, middleLineView_Y, middleLineView_W, middleLineView_H);
    
    CGFloat logoContentView_H = 100.0;
    CGFloat logoContentView_X = 0;
    CGFloat logoContentView_W = self.bounds.size.width;
    CGFloat logoContentView_Y = CGRectGetMaxY(self.middleLineView.frame);
    self.logoContentView.frame = CGRectMake(logoContentView_X, logoContentView_Y, logoContentView_W, logoContentView_H);
    
    CGFloat selectImageButton_X = logoTitleLabel_X;
    CGFloat selectImageButton_Y = 10.0;
    self.selectImageButton.frame = CGRectMake(selectImageButton_X, selectImageButton_Y, 0, 0);
    
    CGFloat descLabel_X = CGRectGetMaxX(self.selectImageButton.frame) + logoTitleLabel_X;
    CGFloat descLabel_Y = 0;
    CGFloat descLabel_H = self.selectImageButton.frame.size.height;
    CGFloat descLabel_W = self.bounds.size.width - descLabel_X - logoTitleLabel_X;
    self.descLabel.frame = CGRectMake(descLabel_X, descLabel_Y, descLabel_W, descLabel_H);
    
    CGRect topLineViewFrame = self.bounds;
    topLineViewFrame.size.height = 0.5;
    self.topLineView.frame = topLineViewFrame;
    
    CGRect bottomLineViewFrame = topLineViewFrame;
    bottomLineViewFrame.origin.y = self.bounds.size.height - bottomLineViewFrame.size.height;
    self.bottomLineView.frame = bottomLineViewFrame;
}

- (void)selectImageButtonDidClickAddImageButton:(SLSelectImageButton *)selectImageButton{
    if(self.delegate && [self.delegate respondsToSelector:@selector(addCaseLogoViewDidClickAddButton:)]){
        [self.delegate addCaseLogoViewDidClickAddButton:self];
    }
}

- (void)selectImageButtonDidClickCancelImageButton:(SLSelectImageButton *)selectImageButton{
    [self.selectImageButton setButtonNormalImage:@"add_image_normal" highlightedImage:@"add_image_highlighted"];
    if(self.delegate && [self.delegate respondsToSelector:@selector(addCaseLogoViewDidClickCancelButton:)]){
        [self.delegate addCaseLogoViewDidClickCancelButton:self];
    }
}

@end
