//
//  SLAddCaseDeleteView.m
//  TaskOffer
//
//  Created by wshaolin on 15/3/23.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLAddCaseDeleteView.h"
#import "HexColor.h"
#import "SLConnectionButton.h"

@interface SLAddCaseDeleteView()

@property (nonatomic, strong) SLConnectionButton *button;
@property (nonatomic, strong) UIView *topLineView;

@end

@implementation SLAddCaseDeleteView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self addSubview:self.topLineView];
        [self addSubview:self.button];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (SLConnectionButton *)button{
    if(_button == nil){
        _button = [SLConnectionButton buttonWithType:UIButtonTypeCustom];
        _button.title = @"删除";
        [_button addTarget:self action:@selector(didClickButton:)];
    }
    return _button;
}

- (UIView *)topLineView{
    if(_topLineView == nil){
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _topLineView;
}

- (void)setFrame:(CGRect)frame{
    frame.origin.x = 0;
    frame.size.width = [UIScreen mainScreen].bounds.size.width;
    frame.size.height = 56.0;
    frame.origin.y = [UIScreen mainScreen].bounds.size.height - frame.size.height;
    [super setFrame:frame];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGRect topLineViewFrame = self.bounds;
    topLineViewFrame.size.height = 0.25;
    self.topLineView.frame = topLineViewFrame;
    
    CGFloat topAndBottonMargin = 8.0;
    CGFloat button_H = self.bounds.size.height - topAndBottonMargin * 2;
    CGFloat button_Y = topAndBottonMargin;
    CGFloat button_X = 10.0;
    CGFloat button_W = self.bounds.size.width - button_X * 2;
    self.button.frame = CGRectMake(button_X, button_Y, button_W, button_H);
}

- (void)didClickButton:(UIButton *)button{
    if(self.delegate && [self.delegate respondsToSelector:@selector(addCaseDeleteViewDidClickDeleteButton:)]){
        [self.delegate addCaseDeleteViewDidClickDeleteButton:self];
    }
}

@end
