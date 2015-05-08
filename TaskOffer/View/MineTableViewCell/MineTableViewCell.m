//
//  MineTableViewCell.m
//  TaskOffer
//
//  Created by BourbonZ on 15/3/16.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "MineTableViewCell.h"
#import "HexColor.h"
@implementation MineTableViewCell
@synthesize titleLabel;
@synthesize titleImage;
@synthesize redView;
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        titleImage = [[TouchImageView alloc] init];
        [self.contentView addSubview:titleImage];
        
        titleLabel = [[UILabel alloc] init];
        [titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
        [self.contentView addSubview:titleLabel];
        
        redView = [[UIView alloc] init];
        redView.backgroundColor = [UIColor redColor];
        redView.hidden = YES;
        redView.layer.masksToBounds = NO;
        redView.layer.cornerRadius = 5.0f;
        [self.contentView addSubview:redView];
        
        [self setAccessoryType:(UITableViewCellAccessoryDisclosureIndicator)];

    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat imageHeight = self.frame.size.height-20;
    
    [titleImage setFrame:CGRectMake(10, 10, imageHeight, imageHeight)];
    [titleLabel setFrame:CGRectMake(imageHeight + 20, 10, self.frame.size.width-imageHeight - 20, imageHeight)];
    [redView setBounds:CGRectMake(0, 0, 10, 10)];
    [redView setCenter:CGPointMake(self.frame.size.width-40, self.frame.size.height/2)];
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
