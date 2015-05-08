//
//  SystemMessageCell.m
//  TaskOffer
//
//  Created by BourbonZ on 15/3/26.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SystemMessageCell.h"
#import "HexColor.h"
#import "UIImageView+WebCache.h"
@implementation SystemMessageCell
{
    UIImageView *iconView;
    UILabel *contentLabel;
    UILabel *timeLabel;

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
        
        iconView = [[TouchImageView alloc] init];
        [self addSubview:iconView];
        
        contentLabel = [[UILabel alloc] init];
        [contentLabel setTextColor:[UIColor colorWithHexString:kDefaultTextColor]];
        [contentLabel setFont:[UIFont systemFontOfSize:15.0f]];
        [self addSubview:contentLabel];
        
        timeLabel = [[UILabel alloc] init];
        [timeLabel setTextColor:[UIColor grayColor]];
        [timeLabel setFont:[UIFont systemFontOfSize:10.0f]];
        [timeLabel setTextAlignment:NSTextAlignmentRight];
        [self addSubview:timeLabel];
        
        [self setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [iconView setFrame:CGRectMake(10, 10, 40, 40)];
    [contentLabel setFrame:CGRectMake(60, 10, self.frame.size.width-60-120, 40)];
    [timeLabel setFrame:CGRectMake(self.frame.size.width-120, 10, 100, 40)];
}
-(void)setDict:(NSDictionary *)dict
{
    NSString *iconStr = [NSString stringWithFormat:@"%@%@/%@",kTOHOSt,kTOUploadUserIcon,[dict objectForKey:@"messagePicture"]];
    [iconView sd_setImageWithURL:[NSURL URLWithString:iconStr] placeholderImage:kDefaultIcon];
    
    [contentLabel setText:[dict objectForKey:@"messageContent"]];
    
    NSString *timeStr = [dict objectForKey:@"messageCreateTime"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSTimeInterval time = timeStr.doubleValue/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    timeLabel.text = [formatter stringFromDate:date];
}

@end
