//
//  DialogueCell.m
//  XMPPIM
//
//  Created by BourbonZ on 14/12/25.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import "DialogueCell.h"

@implementation DialogueCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.iconView setFrame:CGRectMake(10, 10, 45, 45)];
    [self.nameLabel setFrame:CGRectMake(65, 10, self.frame.size.width-135, 25)];
    [self.contentLabel setFrame:CGRectMake(65, 32, self.frame.size.width-142, 25)];
    [self.redView setFrame:CGRectMake(48, 5, 10, 10)];
    [self.timeLabel setFrame:CGRectMake(self.frame.size.width-69, 6, 63, 25)];
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.iconView = [[UIImageView alloc] init];
        self.iconView.layer.cornerRadius = 10.0f;
        self.iconView.layer.masksToBounds = NO;
        [self.contentView addSubview:self.iconView];
        
        self.nameLabel = [[UILabel alloc] init];
        [self.nameLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
        [self.nameLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        [self.contentView addSubview:self.nameLabel];
        
        self.contentLabel = [[UILabel alloc] init];
        [self.contentLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [self.contentLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        [self.contentLabel setTextColor:[UIColor grayColor]];
        [self.contentView addSubview:self.contentLabel];
        
        self.timeLabel = [[UILabel alloc] init];
        [self.timeLabel setFont:[UIFont systemFontOfSize:12.0f]];
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        [self.timeLabel setTextColor:[UIColor lightGrayColor]];
        [self.contentView addSubview:self.timeLabel];
        
        self.redView = [[UIView alloc] init];
        [self.redView setBackgroundColor:[UIColor redColor]];
        [self.redView.layer setCornerRadius:5];
        [self.contentView addSubview:self.redView];
        
        [self setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    }
    return self;
}
@end
