//
//  SLBiddingProjectTableViewCell.m
//  TaskOffer
//
//  Created by wshaolin on 15/3/20.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLBiddingProjectTableViewCell.h"
#import "SLProjectModel.h"
#import "UIImageView+SetImage.h"
#import "SLTaskImageView.h"
#import "HexColor.h"
#import "NSString+Conveniently.h"

@interface SLBiddingProjectTableViewCell()

@property (nonatomic, weak) IBOutlet SLTaskImageView *projectLogoView;
@property (nonatomic, weak) IBOutlet UILabel *projectNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *projectPublisherLabel;
@property (nonatomic, weak) IBOutlet UILabel *projectPriceLabel;
@property (nonatomic, weak) IBOutlet UILabel *projectEndTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *projectDescLabel;

@end

@implementation SLBiddingProjectTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *reuseIdentifier = @"SLBiddingProjectTableViewCell";
    SLBiddingProjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SLBiddingProjectTableViewCell class]) owner:self options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.projectPriceLabel.backgroundColor = [UIColor colorWithHexString:kDefaultTextColor];
    self.projectPriceLabel.layer.masksToBounds = YES;
    self.projectPriceLabel.layer.cornerRadius = 3.0;
}

- (void)setProjectModel:(SLProjectModel *)projectModel{
    _projectModel = projectModel;
    if(projectModel.projectLogo.length > 0){
        [self.projectLogoView setImageWithURL:projectModel.projectLogo];
    }
    
    self.projectNameLabel.text = projectModel.projectName;
    self.projectPublisherLabel.text = projectModel.projectPublisher;
    self.projectPriceLabel.text = projectModel.projectPrice;
    
    CGFloat projectPrice_W = [projectModel.projectPrice sizeWithFont:self.projectPriceLabel.font limitSize:self.projectPriceLabel.frame.size].width + 10.0;
    CGRect projectPriceLabelFrame = self.projectPriceLabel.frame;
    projectPriceLabelFrame.size.width = projectPrice_W;
    self.projectPriceLabel.frame = projectPriceLabelFrame;
    
    self.projectEndTimeLabel.text = [NSString stringWithFormat:@"%@截止", projectModel.projectEndTime];
    self.projectDescLabel.text = projectModel.projectDesc;
}

@end
