//
//  ZizhiCell.m
//  TaskOffer
//
//  Created by BourbonZ on 15/3/25.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "ZizhiCell.h"
#import "HexColor.h"
#import "UIImageView+WebCache.h"
@implementation ZizhiCell
{
//    UIImageView *iconView;
    UILabel *nameLabel;
    UILabel *getTimeLabel;
    UILabel *validTimeLabel;
    UIScrollView *imageScrollView;
}
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
        
//        iconView = [[TouchImageView alloc] init];
//        [self.contentView addSubview:iconView];
        
        
        nameLabel = [[UILabel alloc] init];
        [nameLabel setFont:[UIFont systemFontOfSize:15.0f]];
        [nameLabel setBackgroundColor:[UIColor colorWithHexString:kDefaultBackColor]];
        [self.contentView addSubview:nameLabel];
        
        getTimeLabel = [[UILabel alloc] init];
        [getTimeLabel setTextColor:[UIColor grayColor]];
        [getTimeLabel setTextAlignment:NSTextAlignmentLeft];
        [getTimeLabel setFont:[UIFont systemFontOfSize:13.0f]];
        [self.contentView addSubview:getTimeLabel];
        
        validTimeLabel = [[UILabel alloc] init];
        [validTimeLabel setTextAlignment:NSTextAlignmentRight];
        [validTimeLabel setTextColor:[UIColor grayColor]];
        [validTimeLabel setFont:[UIFont systemFontOfSize:13.0f]];
        [self.contentView addSubview:validTimeLabel];
        
        imageScrollView = [[UIScrollView alloc] init];
        imageScrollView.backgroundColor = [UIColor colorWithHexString:kDefaultBackColor];
        [self.contentView addSubview:imageScrollView];
        
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
//    [iconView setFrame:CGRectMake(10, 10, 40, 40)];
    [nameLabel setFrame:CGRectMake(10, 5, self.frame.size.width, 25)];
    [getTimeLabel setFrame:CGRectMake(10, 35, self.frame.size.width/2-5, 20)];
    [validTimeLabel setFrame:CGRectMake(self.frame.size.width/2, 35, self.frame.size.width/2-10, 20)];
    [imageScrollView setFrame:CGRectMake(5, 60, self.frame.size.width-20, 80)];

}
-(void)setInfoDict:(NSDictionary *)infoDict
{
//    [iconView sd_setImageWithURL:[NSURL URLWithString:iconString] placeholderImage:kDefaultIcon];
    [nameLabel setText:[infoDict objectForKey:@"qualificationName"]];
    

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSTimeInterval time = [[infoDict objectForKey:@"qualificationTime"] doubleValue]/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    getTimeLabel.text = [NSString stringWithFormat:@"认证取得时间:%@",[formatter stringFromDate:date]];
    validTimeLabel.text = [NSString stringWithFormat:@"认证有效期:%ld年",(long)[[infoDict objectForKey:@"qualificationValidityTime"] integerValue]];

    NSString *zizhiString = [infoDict objectForKey:@"companyPicture"];
    if (zizhiString.length > 0)
    {
        NSArray *array = [zizhiString componentsSeparatedByString:@","];
        imageScrollView.contentSize = CGSizeMake(70 * array.count, 80);
        for (int i = 0; i < array.count; i++)
        {
            UIImageView *imageView = [[TouchImageView alloc] initWithFrame:CGRectMake(10*(i+1) + 60*i, 10, 60, 60)];
            NSString *string = [array objectAtIndex:i];
            NSString *iconString = [NSString stringWithFormat:@"%@%@/%@",kTOHOSt,kTOQualificationPicPath,string];
            [imageView sd_setImageWithURL:[NSURL URLWithString:iconString] placeholderImage:kDefaultIcon];
            [imageScrollView addSubview:imageView];
        }
    }
    else
    {
        imageScrollView.contentSize = CGSizeMake(0, 0);
    }
    
}
@end
