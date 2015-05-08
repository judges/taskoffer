//
//  ApplyInfoCell.m
//  TaskOffer
//
//  Created by BourbonZ on 15/4/29.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "ApplyInfoCell.h"

@implementation ApplyInfoCell

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
        self.iconView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.iconView];
        
        self.nameLabel = [[UILabel alloc] init];
        [self.nameLabel setTextColor:[UIColor blackColor]];
        [self.nameLabel setFont:[UIFont systemFontOfSize:15.0f]];
        [self.contentView addSubview:self.nameLabel];
        
        self.contentLabel = [[UILabel alloc] init];
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.textColor = [UIColor grayColor];
        self.contentLabel.font = [UIFont systemFontOfSize:13.0f];
        [self.contentView addSubview:self.contentLabel];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.iconView setFrame:CGRectMake(10, 10, 40, 40)];
    [self.nameLabel setFrame:CGRectMake(60, 10, self.frame.size.width-60, 20)];

    CGSize size = [self.contentLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]}];
    [self.contentLabel setFrame:CGRectMake(10, 35, self.frame.size.width-60, size.height)];
    
}
@end
