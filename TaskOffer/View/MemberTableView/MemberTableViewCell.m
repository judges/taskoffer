//
//  MemberTableViewCell.m
//  TaskOffer
//
//  Created by BourbonZ on 15/4/8.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "MemberTableViewCell.h"
#import "ProjectTagView.h"
#import "UIImageView+WebCache.h"
@implementation MemberTableViewCell
{
    UIImageView *headIcon;
    UILabel *nameLabel;
    ProjectTagView *tagView;
    UIImageView *selectView;
}
@synthesize isSelected = _isSelected;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        headIcon = [[UIImageView alloc] init];
        [self.contentView addSubview:headIcon];
        
        nameLabel = [[UILabel alloc] init];
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.font = [UIFont systemFontOfSize:15.0f];
        [self.contentView addSubview:nameLabel];
        
        tagView = [[ProjectTagView alloc] init];
        [self.contentView addSubview:tagView];
        
        selectView = [[UIImageView alloc] init];
        [self.contentView addSubview:selectView];
        selectView.image = [UIImage imageNamed:@"未选中"];


    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [headIcon setFrame:CGRectMake(10, 10, 40, 40)];
    [nameLabel setFrame:CGRectMake(60, 10, self.frame.size.width-60-60, 40)];
    [tagView setFrame:CGRectMake(0, 55, self.frame.size.width, 30)];
    [selectView setFrame:CGRectMake(self.frame.size.width-50, 18, 21, 15.5f)];

}
-(void)setFriendInfo:(UserInfo *)friendInfo
{
    NSString *string = [NSString stringWithFormat:@"%@%@/%@",kTOHOSt,kTOUploadUserIcon,friendInfo.userHeadPicture];
    [headIcon sd_setImageWithURL:[NSURL URLWithString:string] placeholderImage:kDefaultIcon];
    
    [nameLabel setText:friendInfo.userName];
    tagView.tagArray = [friendInfo.userTags componentsSeparatedByString:@","];
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
