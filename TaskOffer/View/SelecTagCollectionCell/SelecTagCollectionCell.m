//
//  SelecTagCollectionCell.m
//  TaskOffer
//
//  Created by BourbonZ on 15/3/18.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SelecTagCollectionCell.h"
#import "HexColor.h"
@implementation SelecTagCollectionCell
@synthesize tagButton;
@synthesize tagString;
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        tagButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [tagButton setFrame:frame];
        [tagButton setTitle:tagString forState:(UIControlStateNormal)];
        [tagButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateSelected)];
        [tagButton setTitleColor:[UIColor colorWithHexString:kDefaultTextColor] forState:(UIControlStateNormal)];
        [tagButton setBackgroundImage:[UIImage imageNamed:@"标签背景"] forState:(UIControlStateSelected)];
        [tagButton setBackgroundImage:nil forState:(UIControlStateNormal)];
        tagButton.layer.borderColor = [[UIColor colorWithHexString:kDefaultTextColor] CGColor];
        tagButton.layer.borderWidth = 1.0f;
        [tagButton addTarget:self action:@selector(tagButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.contentView addSubview:tagButton];
    }
    return self;
}
-(void)tagButtonClick:(UIButton *)button
{
    button.selected = button.selected == YES ? NO : YES;
}
@end
