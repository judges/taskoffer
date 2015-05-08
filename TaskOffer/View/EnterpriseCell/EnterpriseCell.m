//
//  EnterpriseCell.m
//  TaskOffer
//
//  Created by BourbonZ on 15/3/17.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "EnterpriseCell.h"
#import "HexColor.h"
#import "UIImageView+WebCache.h"
#import "SLTagView.h"
#import "SLTagFrameModel.h"
#import "MJPhotoBrowser.h"
@implementation EnterpriseCell
{
    SLTagView *tagView;
    UIImageView *iconV;
    UILabel *company;
}
@synthesize enterpriseCategoryLabel;
@synthesize enterpriseCaseLabel;
@synthesize enterpriseIcon;
@synthesize enterpriseNameLabel;
@synthesize info = _info;
@synthesize enterpriseContentLabel;
@synthesize enterpriseTagLabel1;
@synthesize enterpriseTagLabel2;
@synthesize enterpriseTagLabel3;
@synthesize enterpriseTagLabel4;
@synthesize enterpriseTagLabel5;
@synthesize enterpriseCategoryImage;

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
        enterpriseIcon = [[UIImageView alloc] init];
        enterpriseIcon.layer.masksToBounds = NO;
        enterpriseIcon.layer.cornerRadius = 10.0f;
        enterpriseIcon.userInteractionEnabled = YES;
        [enterpriseIcon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickIcon)]];
        [self.contentView addSubview:enterpriseIcon];
        
        ///名称
        enterpriseNameLabel = [[UILabel alloc] init];
        [enterpriseNameLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
        [self.contentView addSubview:enterpriseNameLabel];
        
        ///类别
        enterpriseCategoryImage = [[UIImageView alloc] init];
        [enterpriseCategoryImage setImage:[UIImage imageNamed:@"案例背景"]];
//        [self.contentView addSubview:enterpriseCategoryImage];

        enterpriseCategoryLabel = [[UILabel alloc] init];
        [enterpriseCategoryLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [enterpriseCategoryLabel setTextColor:[UIColor grayColor]];
        [self.contentView addSubview:enterpriseCategoryLabel];
    
        ///案例
        enterpriseCaseLabel = [[UILabel alloc] init];
//        [enterpriseCaseLabel setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"案例背景"]]];
        [enterpriseCaseLabel setTextColor:[UIColor whiteColor]];
        [enterpriseCaseLabel setFont:[UIFont systemFontOfSize:13.0f]];
//        [self.contentView addSubview:enterpriseCaseLabel];
        
        ///标签
        tagView = [[SLTagView alloc] init];
        [self.contentView addSubview:tagView];
//        enterpriseTagLabel1 = [[UILabel alloc] init];
//        [enterpriseTagLabel1 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"标签背景"]]];
//        [enterpriseTagLabel1 setTextAlignment:NSTextAlignmentCenter];
//        [enterpriseTagLabel1 setTextColor:[UIColor whiteColor]];
//        [enterpriseTagLabel1 setFont:[UIFont systemFontOfSize:14.0f]];
//        [enterpriseTagLabel1 setTag:9000];
//        [enterpriseTagLabel1 setHidden:YES];
//        enterpriseTagLabel1.layer.masksToBounds = YES;
//        enterpriseTagLabel1.layer.cornerRadius = 3.0f;
//        enterpriseTagLabel1.adjustsFontSizeToFitWidth = YES;
//        [self.contentView addSubview:enterpriseTagLabel1];
//        
//        enterpriseTagLabel2 = [[UILabel alloc] init];
//        [enterpriseTagLabel2 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"标签背景"]]];
//        [enterpriseTagLabel2 setTextAlignment:NSTextAlignmentCenter];
//        [enterpriseTagLabel2 setTextColor:[UIColor whiteColor]];
//        [enterpriseTagLabel2 setFont:[UIFont systemFontOfSize:14.0f]];
//        [enterpriseTagLabel2 setTag:9001];
//        [enterpriseTagLabel2 setHidden:YES];
//        enterpriseTagLabel2.layer.masksToBounds = YES;
//        enterpriseTagLabel2.layer.cornerRadius = 3.0f;
//        enterpriseTagLabel2.adjustsFontSizeToFitWidth = YES;
//        [self.contentView addSubview:enterpriseTagLabel2];
//        
//        enterpriseTagLabel3 = [[UILabel alloc] init];
//        [enterpriseTagLabel3 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"标签背景"]]];
//        [enterpriseTagLabel3 setTextAlignment:NSTextAlignmentCenter];
//        [enterpriseTagLabel3 setTextColor:[UIColor whiteColor]];
//        [enterpriseTagLabel3 setFont:[UIFont systemFontOfSize:14.0f]];
//        [enterpriseTagLabel3 setTag:9002];
//        [enterpriseTagLabel3 setHidden:YES];
//        enterpriseTagLabel3.layer.masksToBounds = YES;
//        enterpriseTagLabel3.layer.cornerRadius = 3.0f;
//        enterpriseTagLabel3.adjustsFontSizeToFitWidth = YES;
//        [self.contentView addSubview:enterpriseTagLabel3];
//        
//        enterpriseTagLabel4 = [[UILabel alloc] init];
//        [enterpriseTagLabel4 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"标签背景"]]];
//        [enterpriseTagLabel4 setTextAlignment:NSTextAlignmentCenter];
//        [enterpriseTagLabel4 setTextColor:[UIColor whiteColor]];
//        [enterpriseTagLabel4 setFont:[UIFont systemFontOfSize:14.0f]];
//        [enterpriseTagLabel4 setTag:9003];
//        [enterpriseTagLabel4 setHidden:YES];
//        enterpriseTagLabel4.layer.masksToBounds = YES;
//        enterpriseTagLabel4.layer.cornerRadius = 3.0f;
//        enterpriseTagLabel4.adjustsFontSizeToFitWidth = YES;
////        [self.contentView addSubview:enterpriseTagLabel4];
//        
//        enterpriseTagLabel5 = [[UILabel alloc] init];
//        [enterpriseTagLabel5 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"标签背景"]]];
//        [enterpriseTagLabel5 setTextAlignment:NSTextAlignmentCenter];
//        [enterpriseTagLabel5 setTextColor:[UIColor whiteColor]];
//        [enterpriseTagLabel5 setFont:[UIFont systemFontOfSize:14.0f]];
//        [enterpriseTagLabel5 setTag:9004];
//        [enterpriseTagLabel5 setHidden:YES];
//        enterpriseTagLabel5.layer.masksToBounds = YES;
//        enterpriseTagLabel5.layer.cornerRadius = 3.0f;
//        enterpriseTagLabel5.adjustsFontSizeToFitWidth = YES;
////        [self.contentView addSubview:enterpriseTagLabel5];
        
        
        ///简介
        enterpriseContentLabel = [[UILabel alloc] init];
        [enterpriseContentLabel setTextColor:[UIColor grayColor]];
        [enterpriseContentLabel setNumberOfLines:0];
        [enterpriseContentLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [enterpriseContentLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        [self.contentView addSubview:enterpriseContentLabel];
        
        [self setBackgroundColor:[UIColor colorWithHexString:kDefaultBackColor]];
        
        
        
        iconV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"connection_user_authentication"]];
        iconV.hidden = YES;
        [self.contentView addSubview:iconV];
        
        company = [[UILabel alloc] init];
        [company setTextColor:[UIColor colorWithHexString:kDefaultOrgangeColor]];
        [company setFont:[UIFont systemFontOfSize:11.0f]];
        [company setText:@"认证企业"];
        company.hidden = YES;

        [self.contentView addSubview:company];
    

        
        
        
        
        [self setSelectionStyle:(UITableViewCellSelectionStyleNone)];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [enterpriseIcon setFrame:CGRectMake(10, 10, 45, 45)];
    CGSize nameSize = [enterpriseNameLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f]}];
//    [enterpriseNameLabel setFrame:CGRectMake(enterpriseIcon.frame.size.width+enterpriseIcon.frame.origin.x*2, enterpriseIcon.frame.origin.y, self.frame.size.width-enterpriseIcon.frame.size.width-enterpriseIcon.frame.origin.x*2-10,25)];
    [enterpriseNameLabel setFrame:CGRectMake(enterpriseIcon.frame.size.width+enterpriseIcon.frame.origin.x*2, enterpriseIcon.frame.origin.y, nameSize.width,25)];
    [enterpriseCategoryLabel setFrame:CGRectMake(enterpriseIcon.frame.size.width+enterpriseIcon.frame.origin.x*2, enterpriseNameLabel.frame.size.height+enterpriseNameLabel.frame.origin.y, 200, 20)];
    
    [enterpriseCaseLabel setFrame:CGRectMake(self.frame.size.width-65, 12, 65, 18)];
    [enterpriseCategoryImage setFrame:CGRectMake(self.frame.size.width-75, 12, 75, 18)];
    
//    CGFloat tagWidth = (self.frame.size.width-60)/5;
//    [enterpriseTagLabel1 setFrame:CGRectMake(10*1 + tagWidth * 0, 65, tagWidth, 20)];
//    [enterpriseTagLabel2 setFrame:CGRectMake(10*2 + tagWidth * 1, 65, tagWidth, 20)];
//    [enterpriseTagLabel3 setFrame:CGRectMake(10*3 + tagWidth * 2, 65, tagWidth, 20)];
//    [enterpriseTagLabel4 setFrame:CGRectMake(10*4 + tagWidth * 3, 65, tagWidth, 20)];
//    [enterpriseTagLabel5 setFrame:CGRectMake(10*5 + tagWidth * 4, 65, tagWidth, 20)];
    tagView.frame = CGRectMake(0, enterpriseCategoryImage.frame.origin.y * 2 + enterpriseCategoryImage.frame.size.height + 15, 0, 0);
    [enterpriseContentLabel setFrame:CGRectMake(10, 90, self.frame.size.width - 20, 40)];
//    [enterpriseContentLabel setFrame:CGRectMake(10, tagView.tagFrameModel.tagViewHeight +  enterpriseCategoryImage.frame.origin.y * 2 + enterpriseCategoryImage.frame.size.height+10, self.frame.size.width - 20, 40)];
    
    [iconV setFrame:CGRectMake(enterpriseNameLabel.frame.size.width+enterpriseNameLabel.frame.origin.x+10, enterpriseNameLabel.frame.origin.y+6, 12, 12)];
    CGSize size = [company.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.0]}];
    float width = self.frame.size.width-enterpriseNameLabel.frame.size.width - enterpriseNameLabel.frame.origin.x-17;
    [company setFrame:CGRectMake(self.frame.size.width-width+12-5, enterpriseNameLabel.frame.origin.y+6, size.width, 12)];
}

-(void)setInfo:(EnterpriseInfo *)info
{
    NSString *tmpIcon = [NSString stringWithFormat:@"%@%@/%@",kTOHOSt,kTOCompanyPicPath,info.enterpriseIcon];
    [enterpriseIcon sd_setImageWithURL:[NSURL URLWithString:tmpIcon] placeholderImage:kDefaultIcon];
    enterpriseNameLabel.text     = info.enterpriseName;
    enterpriseCaseLabel.text     = [NSString stringWithFormat:@"共%@个案例",info.enterpriseCase];
//    for (int i = 0; i < info.enterpriseTagArray.count; i++)
//    {
//        UILabel *enterpriseTagLabel = (UILabel *)[self.contentView viewWithTag:9000+i];
//        [enterpriseTagLabel setHidden:NO];
//        [enterpriseTagLabel setText:[info.enterpriseTagArray objectAtIndex:i]];
//    }
    
    if (info.companyStatus.intValue == 1)
    {
        iconV.hidden = NO;
        if ((self.frame.size.width-iconV.frame.origin.x-iconV.frame.size.width)>=14)
        {
            company.hidden = NO;
        }
    }
    else
    {
        iconV.hidden = YES;
        company.hidden = YES;
    }
    
    NSArray *array = info.enterpriseTagArray;
    if (info.enterpriseTagArray.count > 3)
    {
        array = [info.enterpriseTagArray subarrayWithRange:NSMakeRange(0, 3)];
    }
    SLTagFrameModel *model = [[SLTagFrameModel alloc] initWithTags:array];
    tagView.tagFrameModel = model;
    
    enterpriseCategoryLabel.hidden = NO;
    if([info.enterpriseCategory isEqualToString:@"0"]){
        enterpriseCategoryLabel.text = @"项目发布方";
    }else if([info.enterpriseCategory isEqualToString:@"1"]){
        enterpriseCategoryLabel.text = @"项目承接方";
    }else{
        enterpriseCategoryLabel.text = @"其他";
    }
    
    [enterpriseContentLabel setText:[info enterpriseContent]];
}
-(void)clickIcon
{
    MJPhoto *photo = [[MJPhoto alloc] init];
    NSString *icon = [NSString stringWithFormat:@"%@%@/%@",kTOHOSt,kTOCompanyPicPath,_info.enterpriseIcon];
    photo.url = [NSURL URLWithString:icon];
    
    photo.srcImageView = enterpriseIcon;
    photo.index = 0;
    
    MJPhotoBrowser *photoBrowser = [[MJPhotoBrowser alloc] init];
    photoBrowser.photos = @[photo];
    photoBrowser.currentPhotoIndex = 0;
    [photoBrowser show];
}

@end
