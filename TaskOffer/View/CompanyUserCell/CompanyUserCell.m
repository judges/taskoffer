//
//  CompanyUserCell.m
//  TaskOffer
//
//  Created by BourbonZ on 15/3/25.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "CompanyUserCell.h"
#import "HexColor.h"
#import "UIImageView+WebCache.h"
@implementation CompanyUserCell
@synthesize iconView;
@synthesize nameLabel;
@synthesize certifyImage;
@synthesize certifyLabel;
@synthesize tagArray;
@synthesize descLabel;
@synthesize tagView;
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
        self.backgroundColor = [UIColor colorWithHexString:kDefaultBackColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        iconView = [[TouchImageView alloc] init];
        [self.contentView addSubview:iconView];
        
        nameLabel = [[UILabel alloc] init];
        [nameLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
        nameLabel.numberOfLines = 0;
        nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
        nameLabel.backgroundColor = [UIColor colorWithHexString:kDefaultBackColor];
        [self.contentView addSubview:nameLabel];
        
        certifyImage = [[TouchImageView alloc] initWithImage:[UIImage imageNamed:@"connection_user_authentication"]];
        [self.contentView addSubview:certifyImage];
        
        certifyLabel = [[UILabel alloc] init];
        certifyLabel.text = @"认证用户";
        certifyLabel.textColor = [UIColor colorWithHexString:kDefaultOrgangeColor];
        certifyLabel.font = [UIFont systemFontOfSize:12.0f];
        certifyLabel.backgroundColor = [UIColor colorWithHexString:kDefaultBackColor];
        [self.contentView addSubview:certifyLabel];
        
        descLabel = [[UILabel alloc] init];
        [descLabel setBackgroundColor:[UIColor colorWithHexString:kDefaultBackColor]];
        [descLabel setTextColor:[UIColor grayColor]];
        [descLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [self.contentView addSubview:descLabel];
        
        tagView = [[ProjectTagView alloc] init];
        [self.contentView addSubview:tagView];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [iconView setFrame:CGRectMake(10, 10, 40, 40)];
    CGSize nameSize = [nameLabel sizeThatFits:CGSizeMake(self.frame.size.width-20, 30)];
    [nameLabel setFrame:CGRectMake(60, 10,nameSize.width, nameSize.height)];
    [certifyImage setFrame:CGRectMake(nameLabel.frame.size.width + nameLabel.frame.origin.x+5, 12, 12, 12)];
    [certifyLabel setFrame:CGRectMake(certifyImage.frame.size.width + certifyImage.frame.origin.x + 5, 13, 50, 12)];
    
    float nameY = nameLabel.frame.size.height + nameLabel.frame.origin.y;
    float certifyImageY = certifyImage.frame.size.height + certifyImage.frame.origin.y;
    float descHeight = nameY > certifyImageY ? nameY : certifyImageY;
    
    [descLabel setFrame:CGRectMake(60, descHeight+10, self.frame.size.width-80, 20)];
    [tagView setFrame:CGRectMake(0, 50, self.frame.size.width, 44)];

}
-(void)setUserDict:(NSDictionary *)userDict
{
    NSString *iconString = [NSString stringWithFormat:@"%@%@/%@",kTOHOSt,kTOUploadUserIcon,[self checkString:[userDict objectForKey:@"userHeadPicture"]]];
    [iconView sd_setImageWithURL:[NSURL URLWithString:iconString] placeholderImage:kUserDefaultIcon];
    nameLabel.text = [self checkString:[userDict objectForKey:@"userName"]];
    BOOL certificate = [[NSNumber numberWithInt:[[userDict objectForKey:@"userCertificateStatus"] intValue]] boolValue];
    if (certificate)
    {
        certifyImage.hidden = NO;
        certifyLabel.hidden = NO;
    }
    else
    {
        certifyLabel.hidden = YES;
        certifyImage.hidden = YES;
    }
    descLabel.text = [self checkString:[userDict objectForKey:@"userDescibe"]];
    NSString *tagString = [self checkString:[userDict objectForKey:@"userTags"]];
    if (tagString.length > 0)
    {
        tagView.tagArray = [tagString componentsSeparatedByString:@","];
    }
    else
    {
        tagView.tagArray = [NSArray array];
    }
}
-(NSString *)checkString:(id)sender
{
    if ([sender isKindOfClass:[NSNull class]])
    {
        return @"";
    }
    return sender;
}
@end
