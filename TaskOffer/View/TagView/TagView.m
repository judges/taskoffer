//
//  TagView.m
//  TaskOffer
//
//  Created by BourbonZ on 15/3/16.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "TagView.h"
#import "HexColor.h"
@implementation TagView
@synthesize tagArray;
@synthesize titleLabel = _titleLabel;
@synthesize tmpView = _tmpView;
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setTextAlignment:NSTextAlignmentLeft];
        [_titleLabel setText:@"行业标签"];
        [_titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [_titleLabel setTextColor:[UIColor blueColor]];
        [self addSubview:_titleLabel];
        
        for (int i = 0; i < 4; i ++)
        {
            
        }
        
        _tmpView = [[UIView alloc] init];
        [_tmpView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:_tmpView];
        
        [self setBackgroundColor:[UIColor colorWithHexString:kDefaultBarColor]];
        
//        [titleLabel setFrame:CGRectMake(10, 20, self.frame.size.width, 30)];
//        [tmpView setFrame:CGRectMake(0, titleLabel.frame.size.height + titleLabel.frame.origin.y, self.frame.size.width, 40)];
        [self setFrame:CGRectMake(0, 0, self.frame.size.width, _titleLabel.frame.origin.y + _titleLabel.frame.size.height + _tmpView.frame.size.height)];

    }
    return self;
}
-(void)setTitleLabel:(UILabel *)titleLabel
{
    [_titleLabel setFrame:CGRectMake(10, 20, self.frame.size.width, 30)];
}
-(void)setTmpView:(UIView *)tmpView
{
    [_tmpView setFrame:CGRectMake(0, _titleLabel.frame.size.height + _titleLabel.frame.origin.y, self.frame.size.width, 40)];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
//    [titleLabel setFrame:CGRectMake(10, 20, self.frame.size.width, 30)];
//    [tmpView setFrame:CGRectMake(0, titleLabel.frame.size.height + titleLabel.frame.origin.y, self.frame.size.width, 40)];
}
@end
