//
//  SLFriendCircleStatusDetailTableFooterView.m
//  TaskOffer
//
//  Created by wshaolin on 15/4/9.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLFriendCircleStatusDetailTableFooterView.h"

@interface SLFriendCircleStatusDetailTableFooterView()

@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation SLFriendCircleStatusDetailTableFooterView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self addSubview:self.contentLabel];
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    frame = [UIScreen mainScreen].bounds;
    frame.size.height = 200.0;
    [super setFrame:frame];
}

- (UILabel *)contentLabel{
    if(_contentLabel == nil){
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.textColor = [UIColor colorWithWhite:0 alpha:0.25];
        _contentLabel.font = [UIFont systemFontOfSize:16.0];
        _contentLabel.text = @"这个家伙很懒，什么都没有";
    }
    return _contentLabel;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.contentLabel.frame = self.bounds;
}

@end
