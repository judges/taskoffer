//
//  MyinfoTableViewCell.m
//  TaskOffer
//
//  Created by BourbonZ on 15/3/16.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "MyinfoTableViewCell.h"

@implementation MyinfoTableViewCell
@synthesize logoView;
@synthesize contentLabel;
@synthesize titleLabel;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        titleLabel = [[UILabel alloc] init];
        [titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
        [titleLabel setTextAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:titleLabel];
        
        logoView = [[TouchImageView alloc] init];
        logoView.hidden = YES;
        [self.contentView addSubview:logoView];
        
        contentLabel = [[UILabel alloc] init];
        [contentLabel setFont:[UIFont systemFontOfSize:16.0f]];
        [contentLabel setTextAlignment:NSTextAlignmentRight];
        [contentLabel setTextColor:[UIColor grayColor]];
        [self.contentView addSubview:contentLabel];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [titleLabel setFrame:CGRectMake(10, 10, 80, self.frame.size.height-20)];
    [contentLabel setFrame:CGRectMake(90, 10, self.frame.size.width - 100, self.frame.size.height-20)];
    [logoView setFrame:CGRectMake(self.frame.size.width-10-(self.frame.size.height-22), 10, self.frame.size.height-22, self.frame.size.height-22)];
    
}
@end
