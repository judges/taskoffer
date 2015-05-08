//
//  ProjectDialogueView.m
//  TaskOffer
//
//  Created by BourbonZ on 15/4/10.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "ProjectDialogueView.h"
#import "HexColor.h"
@implementation ProjectDialogueView
{
    UIImageView *iconView;
    UILabel *nameLabel;
    UILabel *contentLabel;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        iconView = [[UIImageView alloc] init];
        iconView.image = [UIImage imageNamed:@"tmpIcon"];
        iconView.layer.masksToBounds = NO;
        iconView.layer.cornerRadius = 10.0f;
        [self addSubview:iconView];
        
        nameLabel = [[UILabel alloc] init];
        nameLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        nameLabel.text = @"项目聊天";
        [self addSubview:nameLabel];
        
        contentLabel = [[UILabel alloc] init];
        contentLabel.text = @"项目聊天";
        [contentLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [contentLabel setTextColor:[UIColor grayColor]];
        [self addSubview:contentLabel];
        
        self.layer.borderColor = [[UIColor colorWithHexString:kDefaultGrayColor] CGColor];
        self.layer.borderWidth = 1.0f;
        
        self.backgroundColor = [UIColor colorWithHexString:kDefaultBackColor];
        self.userInteractionEnabled = YES;
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [iconView setFrame:CGRectMake(10, 10, 45, 45)];
    [nameLabel setFrame:CGRectMake(65, 14, self.frame.size.width-80, 20)];
    [contentLabel setFrame:CGRectMake(65, 35, self.frame.size.width-80, 20)];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.delegate clickProjectDialogueView];
}
@end
