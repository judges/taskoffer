//
//  MemberCell.m
//  XMPPIM
//
//  Created by BourbonZ on 15/1/13.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "MemberCell.h"

@implementation MemberCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.nameLabel = [[UILabel alloc] init];
        [self.nameLabel setTextAlignment:NSTextAlignmentCenter];
        [self.nameLabel setTextColor:[UIColor redColor]];
        [self.nameLabel setFont:[UIFont systemFontOfSize:10]];
        [self.contentView addSubview:self.nameLabel];
        
        self.userIcon = [[TouchImageView alloc] init];
        self.userIcon.layer.masksToBounds = NO;
        self.userIcon.layer.cornerRadius = 10.0f;
        [self.contentView addSubview:self.userIcon];
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.userIcon setFrame:CGRectMake(0, 0, 45, 45)];
    [self.nameLabel setFrame:CGRectMake(0, 45, 45, 10)];
}
@end
