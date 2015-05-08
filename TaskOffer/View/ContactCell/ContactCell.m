//
//  ContactCell.m
//  XMPPIM
//
//  Created by BourbonZ on 15/1/9.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "ContactCell.h"

@implementation ContactCell
@synthesize iconView;
@synthesize nameLabel;
@synthesize haveRedView;
@synthesize redView;
@synthesize selectView;
@synthesize isSelected = _isSelected;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
   // [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.iconView = [[UIImageView alloc] init];
        self.iconView.layer.masksToBounds = NO;
        self.iconView.layer.cornerRadius = 10.0f;
        [self.contentView addSubview:self.iconView];
        
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.font = [UIFont systemFontOfSize:16.0f];
        [self.contentView addSubview:self.nameLabel];
        
//        if (self.haveRedView)
//        {
            self.redView = [[UIView alloc] initWithFrame:CGRectMake(200, 10, 20, 20)];
            self.redView.layer.masksToBounds = NO;
            self.redView.layer.cornerRadius = 7 ;
            self.redView.backgroundColor = [UIColor redColor];
            [self.contentView addSubview:self.redView];
//        }
        
        selectView = [[UIImageView alloc] init];
        [self.contentView addSubview:selectView];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.iconView setFrame:CGRectMake(10, 11, 40, 40)];
//    [self.nameLabel setFrame:CGRectMake(70, 6, self.frame.size.width-142, 25)];
    [self.nameLabel setBounds:CGRectMake(0, 0, self.frame.size.width-142, 25)];
    [self.nameLabel setCenter:CGPointMake(self.iconView.frame.size.width + self.iconView.frame.origin.x * 2 + self.nameLabel.frame.size.width/2, self.frame.size.height/2)];
    [self.redView setFrame:CGRectMake(self.frame.size.width-30, 20, 14, 14)];
    [selectView setFrame:CGRectMake(self.frame.size.width-50, (self.frame.size.height-21)/2, 21, 15.5f)];
}
-(void)setIsSelected:(BOOL)isSelected
{
    if (isSelected)
    {
        selectView.image = [UIImage imageNamed:@"选中"];
        _isSelected = YES;
    }
    else
    {
        selectView.image = [UIImage imageNamed:@"未选中"];
        _isSelected = NO;
    }

}
@end
