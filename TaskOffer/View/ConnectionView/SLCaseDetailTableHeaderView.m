//
//  SLCaseDetailTableHeaderView.m
//  TaskOffer
//
//  Created by wshaolin on 15/3/21.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLCaseDetailTableHeaderView.h"

@interface SLCaseDetailTableHeaderView()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *topLineView;

@end

@implementation SLCaseDetailTableHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self addSubview:self.titleLabel];
        [self addSubview:self.topLineView];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setHeaderTitle:(NSString *)headerTitle{
    _headerTitle = headerTitle;
    self.titleLabel.text = headerTitle;
}

- (void)setFrame:(CGRect)frame{
    frame = [UIScreen mainScreen].bounds;
    frame.size.height = 50.0;
    [super setFrame:frame];
}

- (UILabel *)titleLabel{
    if(_titleLabel == nil){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _titleLabel;
}

- (UIView *)topLineView{
    if(_topLineView == nil){
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    }
    return _topLineView;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGRect topLineViewFrame = self.bounds;
    topLineViewFrame.size.height = 0.5;
    self.topLineView.frame = topLineViewFrame;
    
    self.titleLabel.frame = self.bounds;
}

@end
