//
//  SLCaseCellToolView.m
//  TaskOffer
//
//  Created by wshaolin on 15/3/20.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLCaseCellToolView.h"
#import "HexColor.h"

@interface SLCaseCellToolView()

@property (nonatomic, strong) NSMutableArray *buttons;

@end;

@implementation SLCaseCellToolView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self setupSubViews];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews{
    self.backgroundColor = [UIColor clearColor];
    
    self.buttons = [NSMutableArray array];
    NSArray *titles = @[@"下载连接", @"合同附件", @"安装包"];
    for(NSInteger index = 0; index < titles.count; index ++){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont systemFontOfSize:12.0];
        button.backgroundColor = [UIColor colorWithHexString:kDefaultTextColor];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [button setTitle:titles[index] forState:UIControlStateNormal];
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        button.tag = index;
        [button addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
        button.userInteractionEnabled = NO;
        [self addSubview:button];
        [self.buttons addObject:button];
    }
}

- (void)setFrame:(CGRect)frame{
    frame.size.width = [UIScreen mainScreen].bounds.size.width;
    frame.origin.x = 0;
    [super setFrame:frame];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    NSInteger buttonCount = self.buttons.count;
    CGFloat margin = 10.0;
    CGFloat button_H = 20.0;
    CGFloat button_W = (self.bounds.size.width - margin * 6) / 5;
    CGFloat button_Y = (self.bounds.size.height - button_H) * 0.5;
    
    for(NSInteger index = 0; index < buttonCount; index ++){
        CGFloat button_X = margin + (button_W + margin) * index;
        UIButton *button = self.buttons[index];
        button.frame = CGRectMake(button_X, button_Y, button_W, button_H);
    }
}

- (void)didClickButton:(UIButton *)button{
    if(self.delegate && [self.delegate respondsToSelector:@selector(caseCellToolView:didClickButtonWithType:)]){
        [self.delegate caseCellToolView:self didClickButtonWithType:button.tag];
    }
}

@end
