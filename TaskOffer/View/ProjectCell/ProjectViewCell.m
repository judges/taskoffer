//
//  ProjectViewCell.m
//  TaskOffer
//
//  Created by BourbonZ on 15/3/17.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "ProjectViewCell.h"
#import "HexColor.h"
#import "UIImageView+WebCache.h"
#import "MJPhotoBrowser.h"
@implementation ProjectViewCell
@synthesize projectCloseDateImage;
@synthesize projectCloseDateLabel;
@synthesize projectContentLabel;
@synthesize projectDeadLineLabel;
@synthesize projectIconView;
@synthesize projectNameLabel;
@synthesize projectPriceImage;
@synthesize projectPriceLabel;
@synthesize projectPublishLabel;
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
        ///头像
        projectIconView = [[UIImageView alloc] init];
        projectIconView.layer.masksToBounds = NO;
        projectIconView.layer.cornerRadius = 10.0f;
        projectIconView.userInteractionEnabled = YES;
        [projectIconView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickIcon)]];
        [self.contentView addSubview:projectIconView];
        
        ///名称
        projectNameLabel = [[UILabel alloc] init];
        [projectNameLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
        [self.contentView addSubview:projectNameLabel];
        
        ///发布者
        projectPublishLabel = [[UILabel alloc] init];
        [projectPublishLabel setTextColor:[UIColor grayColor]];
        [projectPublishLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [self.contentView addSubview:projectPublishLabel];
        
        ///到期时间
        projectDeadLineLabel = [[UILabel alloc] init];
        [projectDeadLineLabel setTextColor:[UIColor grayColor]];
        [projectDeadLineLabel setTextAlignment:NSTextAlignmentRight];
        [projectDeadLineLabel setFont:[UIFont systemFontOfSize:13.0f]];
        [self.contentView addSubview:projectDeadLineLabel];
        
        ///价格背景
        projectPriceImage = [[TouchImageView alloc] initWithImage:[UIImage imageNamed:@"金额"]];
//        [self.contentView addSubview:projectPriceImage];
        
        ///价格
        projectPriceLabel = [[UILabel alloc] init];
        [projectPriceLabel setTextAlignment:NSTextAlignmentCenter];
        [projectPriceLabel setTextColor:[UIColor whiteColor]];
        [projectPriceLabel setBackgroundColor:[UIColor colorWithHexString:kDefaultTextColor]];
        [projectPriceLabel setFont:[UIFont systemFontOfSize:13.0f]];
        projectPriceLabel.layer.masksToBounds = YES;
        projectPriceLabel.layer.cornerRadius = 3.0f;
        [self.contentView addSubview:projectPriceLabel];
        
        ///截止日期背景
        projectCloseDateImage = [[TouchImageView alloc] initWithImage:[UIImage imageNamed:@"截止日期"]];
//        [self.contentView addSubview:projectCloseDateImage];
        
        ///截止日期
        projectCloseDateLabel = [[UILabel alloc] init];
        [projectCloseDateLabel setTextAlignment:NSTextAlignmentRight];
        [projectCloseDateLabel setTextColor:[UIColor colorWithHexString:kDefaultTextColor]];
        [projectCloseDateLabel setFont:[UIFont systemFontOfSize:13.0f]];
        [self.contentView addSubview:projectCloseDateLabel];
        
        ///项目简介
        projectContentLabel = [[UILabel alloc] init];
        [projectContentLabel setTextColor:[UIColor grayColor]];
        [projectContentLabel setFont:[UIFont systemFontOfSize:14.0f]];
        projectContentLabel.numberOfLines = 0;
        projectContentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
//        projectPriceLabel setTextAlignment:(NSTextAlignment)
        [self.contentView addSubview:projectContentLabel];
        [self setSelectionStyle:(UITableViewCellSelectionStyleNone)];
        [self setBackgroundColor:[UIColor colorWithHexString:kDefaultBackColor]];
        
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [projectIconView setFrame:CGRectMake(10, 10, 45, 45)];
    CGSize size = [projectPriceLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]}];
    
    [projectPriceImage setFrame:CGRectMake(0, projectIconView.frame.origin.y*2 + projectIconView.frame.size.height, size.width+10, 20)];
    [projectPriceLabel setFrame:CGRectMake(10, projectPriceImage.frame.origin.y, projectPriceImage.frame.size.width, projectPriceImage.frame.size.height)];
    [projectNameLabel setFrame:CGRectMake(projectIconView.frame.size.width+projectIconView.frame.origin.x*2, projectIconView.frame.origin.y, self.frame.size.width-projectIconView.frame.size.width-projectIconView.frame.origin.x*2-10, 25)];
    [projectPublishLabel setFrame:CGRectMake(projectIconView.frame.size.width+projectIconView.frame.origin.x*2, projectNameLabel.frame.size.height + projectNameLabel.frame.origin.y, self.frame.size.width - 10 - (projectIconView.frame.size.width + projectIconView.frame.origin.x)-10 , 20)];
    [projectDeadLineLabel setFrame:CGRectMake(self.frame.size.width-80-10, 14, 80, 15)];
    [projectCloseDateImage setFrame:CGRectMake(self.frame.size.width/2+45, projectIconView.frame.origin.y*2 + projectIconView.frame.size.height, self.frame.size.width/2-45, 18)];
    [projectCloseDateLabel setFrame:CGRectMake(projectCloseDateImage.frame.origin.x, projectCloseDateImage.frame.origin.y, projectCloseDateImage.frame.size.width-10, projectCloseDateImage.frame.size.height)];
    
    CGSize labelSize = [projectContentLabel sizeThatFits:CGSizeMake(self.frame.size.width-20, 30)];
    [projectContentLabel setFrame:CGRectMake(10, projectPriceImage.frame.size.height + projectPriceImage.frame.origin.y + 5.0, self.frame.size.width - 20, 40.0)];
}
-(void)setInfo:(ProjectInfo *)info
{
    ///0是企业号发布，1是个人发布
    if (info.projectType.intValue == 0)
    {
        NSString *icon = [NSString stringWithFormat:@"%@%@/%@",kTOHOSt,kTOCompanyPicPath,info.projectIcon];
        [projectIconView sd_setImageWithURL:[NSURL URLWithString:icon] placeholderImage:kDefaultIcon];
    }
    else
    {
        NSString *icon = [NSString stringWithFormat:@"%@%@/%@",kTOHOSt,kTOUploadUserIcon,info.projectIcon];
        [projectIconView sd_setImageWithURL:[NSURL URLWithString:icon] placeholderImage:kDefaultIcon];
    }

    
    
    projectNameLabel.text = [info.projectName isKindOfClass:[NSNull class]] == YES ? @"" : info.projectName;
    projectPublishLabel.text = [info.projectPublishName isKindOfClass:[NSNull class]] == YES ? @"" :[@"发布人:" stringByAppendingString:info.projectPublish];
//    projectDeadLineLabel.text = info.projectDeadLine;
    projectPriceLabel.text = [info.projectPrice isKindOfClass:[NSNull class]] == YES ? @"" : info.projectPrice;
    projectCloseDateLabel.text = [info.projectCloseDate isKindOfClass:[NSNull class]] == YES ? @"" : [info.projectCloseDate stringByAppendingString:@" 截止"];
    projectContentLabel.text = [info.projectContent isKindOfClass:[NSNull class]] == YES ? @"" : info.projectContent;

}
-(void)clickIcon
{
    MJPhoto *photo = [[MJPhoto alloc] init];
    ///0是企业号发布，1是个人发布
//    if (_info.projectType.intValue == 0)
//    {
//        NSString *icon = [NSString stringWithFormat:@"%@%@/%@",kTOHOSt,kTOCompanyPicPath,_info.projectIcon];
//        photo.url = [NSURL URLWithString:icon];
//    }
//    else
//    {
//        NSString *icon = [NSString stringWithFormat:@"%@%@/%@",kTOHOSt,kTOUploadUserIcon,_info.projectIcon];
//        photo.url = [NSURL URLWithString:icon];
//    }
    photo.srcImageView = projectIconView;
    photo.index = 0;
    
    MJPhotoBrowser *photoBrowser = [[MJPhotoBrowser alloc] init];
    photoBrowser.photos = @[photo];
    photoBrowser.currentPhotoIndex = 0;
    [photoBrowser show];
}
@end
