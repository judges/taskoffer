//
//  ItemView.m
//  TaskOffer
//
//  Created by BourbonZ on 15/4/1.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "ItemView.h"
#import "HexColor.h"
@implementation ItemView
{
    UIView *lineView;
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
        self.backgroundColor = [UIColor whiteColor];
        
        self.itemTypeLabel = [[UILabel alloc] init];
        self.itemTypeLabel.textColor = [UIColor grayColor];
        self.itemTypeLabel.font = [UIFont systemFontOfSize:13.0f];
        [self addSubview:self.itemTypeLabel];
        
        lineView = [[UIView alloc] init];
        [lineView setBackgroundColor:[UIColor lightGrayColor]];
        [self addSubview:lineView];
        
        self.itemPicView = [[UIImageView alloc] init];
        [self addSubview:self.itemPicView];
        
        self.itemNameLabel = [[UILabel alloc] init];
        self.itemNameLabel.textColor = [UIColor blackColor];
        self.itemNameLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        [self addSubview:self.itemNameLabel];
        
        self.itemContentLabel = [[UILabel alloc] init];
        self.itemContentLabel.textColor = [UIColor grayColor];
        self.itemContentLabel.font = [UIFont systemFontOfSize:13.0f];
        [self addSubview:self.itemContentLabel];
        
//        self.itemSubjectLabel = [[UILabel alloc] init];
//        self.itemSubjectLabel.textColor = [UIColor colorWithHexString:kDefaultOrgangeColor];
//        self.itemSubjectLabel.font = [UIFont systemFontOfSize:<#(CGFloat)#>];
        
        frame = CGRectMake(frame.origin.x, frame.origin.y, 200, 100);
        
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.itemTypeLabel setFrame:CGRectMake(10, 1, self.frame.size.width-20, 20)];
    [lineView setFrame:CGRectMake(5, 20, self.frame.size.width-10, 0.5f)];
    [self.itemPicView setFrame:CGRectMake(10, 23, 40, 40)];
    [self.itemNameLabel setFrame:CGRectMake(60, 20, self.frame.size.width-60, 20)];
    [self.itemContentLabel setFrame:CGRectMake(60, 40, self.frame.size.width-60, 20)];
}
@end
