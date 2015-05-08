//
//  SLCaseDetailTableViewBasicInfoCell.m
//  TaskOffer
//
//  Created by wshaolin on 15/3/21.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLCaseDetailTableViewBasicInfoCell.h"
#import "SLCaseDetailFrameModel.h"
#import "HexColor.h"
@interface SLCaseDetailTableViewBasicInfoCell()

@property (nonatomic, strong) UILabel *industryCategoryNameLabel;
@property (nonatomic, strong) UILabel *industryCategoryValueLabel;

@property (nonatomic, strong) UILabel *projectDescriptionNameLabel;
@property (nonatomic, strong) UILabel *projectDescriptionValueLabel;

@property (nonatomic, strong) UILabel *referencePriceNameLabel;
@property (nonatomic, strong) UILabel *referencePriceValueLabel;

@end

@implementation SLCaseDetailTableViewBasicInfoCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *reuseIdentifier = @"SLCaseDetailTableViewBasicInfoCell";
    SLCaseDetailTableViewBasicInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if(cell == nil){
        cell = [[self alloc] initWithReuseIdentifier:reuseIdentifier];
    }
    return cell;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithReuseIdentifier:reuseIdentifier]){
        [self.contentView addSubview:self.industryCategoryNameLabel];
        [self.contentView addSubview:self.industryCategoryValueLabel];
        [self.contentView addSubview:self.projectDescriptionNameLabel];
        [self.contentView addSubview:self.projectDescriptionValueLabel];
        [self.contentView addSubview:self.referencePriceNameLabel];
        [self.contentView addSubview:self.referencePriceValueLabel];
        
        self.hideTopLine = YES;
        self.hideBottomLine = NO;
    }
    return self;
}

- (void)setCaseDetailFrameModel:(SLCaseDetailFrameModel *)caseDetailFrameModel{
    _caseDetailFrameModel = caseDetailFrameModel;
    self.industryCategoryNameLabel.frame = caseDetailFrameModel.industryNameFrame;
    self.industryCategoryNameLabel.text = @"行业类别：";
    
    self.industryCategoryValueLabel.frame = caseDetailFrameModel.industryValueFrame;
    self.industryCategoryValueLabel.text = caseDetailFrameModel.caseDetailModel.industry;
    
    self.projectDescriptionNameLabel.frame = caseDetailFrameModel.projectDescNameFrame;
    self.projectDescriptionNameLabel.text = @"项目描述：";
    
    self.projectDescriptionValueLabel.frame = caseDetailFrameModel.projectDescValueFrame;
    self.projectDescriptionValueLabel.text = caseDetailFrameModel.caseDetailModel.projectDesc;
    
    self.referencePriceNameLabel.frame = caseDetailFrameModel.referencePriceNameFrame;
    self.referencePriceNameLabel.text = @"参考报价：";
    
    self.referencePriceValueLabel.frame = caseDetailFrameModel.referencePriceValueFrame;
    self.referencePriceValueLabel.text = caseDetailFrameModel.caseDetailModel.referencePrice;
}

- (UILabel *)createLabel{
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor darkGrayColor];
    label.font = [UIFont systemFontOfSize:14.0];
    return label;
}

- (UILabel *)industryCategoryNameLabel{
    if(_industryCategoryNameLabel == nil){
        _industryCategoryNameLabel = [self createLabel];
        _industryCategoryNameLabel.hidden = YES;
    }
    return _industryCategoryNameLabel;
}

- (UILabel *)industryCategoryValueLabel{
    if(_industryCategoryValueLabel == nil){
        _industryCategoryValueLabel = [self createLabel];
        _industryCategoryValueLabel.adjustsFontSizeToFitWidth = YES;
        _industryCategoryValueLabel.hidden = YES;
    }
    return _industryCategoryValueLabel;
}

- (UILabel *)projectDescriptionNameLabel{
    if(_projectDescriptionNameLabel == nil){
        _projectDescriptionNameLabel = [self createLabel];
    }
    return _projectDescriptionNameLabel;
}

- (UILabel *)projectDescriptionValueLabel{
    if(_projectDescriptionValueLabel == nil){
        _projectDescriptionValueLabel = [self createLabel];
        _projectDescriptionValueLabel.numberOfLines = 0;
    }
    return _projectDescriptionValueLabel;
}

- (UILabel *)referencePriceNameLabel{
    if(_referencePriceNameLabel == nil){
        _referencePriceNameLabel = [self createLabel];
    }
    return _referencePriceNameLabel;
}

- (UILabel *)referencePriceValueLabel{
    if(_referencePriceValueLabel == nil){
        _referencePriceValueLabel = [self createLabel];
        _referencePriceValueLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _referencePriceValueLabel;
}

@end
