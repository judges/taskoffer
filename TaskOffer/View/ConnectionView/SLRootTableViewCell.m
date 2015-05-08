//
//  SLRootTableViewCell.m
//  TaskOffer
//
//  Created by wshaolin on 15/3/19.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLRootTableViewCell.h"

@interface SLRootTableViewCell()

@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, strong) UIView *topLineView;

@end

@implementation SLRootTableViewCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    return [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self _init];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        [self _init];
    }
    return self;
}

- (void)_init{
    [self.contentView addSubview:self.topLineView];
    [self.contentView addSubview:self.bottomLineView];
    
    self.backgroundView = nil;
    self.backgroundColor = [UIColor whiteColor];
    
    //self.topLineColor = [UIColor colorWithWhite:0 alpha:0.2];
    self.topLineColor = [UIColor clearColor];
    self.bottomLineColor = self.topLineColor;
}

- (UIView *)bottomLineView{
    if(_bottomLineView == nil){
        _bottomLineView = [[UIView alloc] init];
    }
    return _bottomLineView;
}

- (UIView *)topLineView{
    if(_topLineView == nil){
        _topLineView = [[UIView alloc] init];
    }
    return _topLineView;
}

- (void)setHideBottomLine:(BOOL)hideBottomLine{
    _hideBottomLine = hideBottomLine;
    self.bottomLineView.hidden = hideBottomLine;
}

- (void)setBottomLineColor:(UIColor *)bottomLineColor{
    _bottomLineColor = bottomLineColor;
    self.bottomLineView.backgroundColor = bottomLineColor;
}

- (void)setHideTopLine:(BOOL)hideTopLine{
    _hideTopLine = hideTopLine;
    self.topLineView.hidden = hideTopLine;
}

- (void)setTopLineColor:(UIColor *)topLineColor{
    _topLineColor = topLineColor;
    self.topLineView.backgroundColor = topLineColor;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGRect topLineViewFrame = self.bounds;
    topLineViewFrame.size.height = 0.5;
    self.topLineView.frame = topLineViewFrame;
    
    CGRect bottomLineViewFrame = topLineViewFrame;
    bottomLineViewFrame.origin.y = self.bounds.size.height - bottomLineViewFrame.size.height;
    self.bottomLineView.frame = bottomLineViewFrame;
}

@end
