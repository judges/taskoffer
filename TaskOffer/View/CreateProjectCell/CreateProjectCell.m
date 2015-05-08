//
//  CreateProjectCell.m
//  TaskOffer
//
//  Created by BourbonZ on 15/4/24.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "CreateProjectCell.h"
#import "HexColor.h"
@implementation CreateProjectCell

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
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [self.contentView addSubview:self.titleLabel];
        
        self.contentLabel = [[UILabel alloc] init];
        self.contentLabel.font = [UIFont systemFontOfSize:16.0f];
        self.contentLabel.textColor = [UIColor lightGrayColor];
        self.contentLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.contentLabel];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.titleLabel setFrame:CGRectMake(10, 0, 100, self.frame.size.height)];
    [self.contentLabel setFrame:CGRectMake(self.titleLabel.frame.size.width, 0, self.frame.size.width-self.titleLabel.frame.size.width-10, self.frame.size.height)];
}
@end
