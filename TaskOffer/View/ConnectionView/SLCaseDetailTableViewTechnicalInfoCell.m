//
//  SLCaseDetailTableViewTechnicalInfoCell.m
//  TaskOffer
//
//  Created by wshaolin on 15/3/21.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLCaseDetailTableViewTechnicalInfoCell.h"
#import "SLCaseDetailFrameModel.h"
#import "HexColor.h"
@interface SLCaseDetailTableViewTechnicalInfoCell()

@property (nonatomic, strong) UILabel *developmentTimeNameLabel;
@property (nonatomic, strong) UILabel *developmentTimeValueLabel;

@property (nonatomic, strong) UILabel *technicalSchemeNameLabel;
@property (nonatomic, strong) UILabel *technicalSchemeValueLabel;

@property (nonatomic, strong) UILabel *schemeDescNameLabel;
@property (nonatomic, strong) UILabel *schemeDescValueLabel;

@end;

@implementation SLCaseDetailTableViewTechnicalInfoCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *reuseIdentifier = @"SLCaseDetailTableViewTechnicalInfoCell";
    SLCaseDetailTableViewTechnicalInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if(cell == nil){
        cell = [[self alloc] initWithReuseIdentifier:reuseIdentifier];
    }
    return cell;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithReuseIdentifier:reuseIdentifier]){
        [self.contentView addSubview:self.developmentTimeNameLabel];
        [self.contentView addSubview:self.developmentTimeValueLabel];
        [self.contentView addSubview:self.technicalSchemeNameLabel];
        [self.contentView addSubview:self.technicalSchemeValueLabel];
        [self.contentView addSubview:self.schemeDescNameLabel];
        [self.contentView addSubview:self.schemeDescValueLabel];
        
        self.hideTopLine = YES;
        self.hideBottomLine = NO;
    }
    return self;
}

- (void)setCaseDetailFrameModel:(SLCaseDetailFrameModel *)caseDetailFrameModel{
    _caseDetailFrameModel = caseDetailFrameModel;
    
    self.developmentTimeNameLabel.frame = caseDetailFrameModel.developmentTimeNameFrame;
    self.developmentTimeNameLabel.text = @"开发周期：";
    
    self.developmentTimeValueLabel.frame = caseDetailFrameModel.developmentTimeValueFrame;
    if(caseDetailFrameModel.caseDetailModel.developmentTime.length > 0){
        self.developmentTimeValueLabel.text = [NSString stringWithFormat:@"%@个月", caseDetailFrameModel.caseDetailModel.developmentTime];
    }
    
    self.technicalSchemeNameLabel.frame = caseDetailFrameModel.technicalSchemeNameFrame;
    self.technicalSchemeNameLabel.text = @"技术方案：";
    
    self.technicalSchemeValueLabel.frame = caseDetailFrameModel.technicalSchemeValueFrame;
    self.technicalSchemeValueLabel.text = caseDetailFrameModel.caseDetailModel.technicalScheme;
    
    self.schemeDescNameLabel.frame = caseDetailFrameModel.schemeDescNameFrame;
    self.schemeDescNameLabel.text = @"方案描述：";
    
    self.schemeDescValueLabel.frame = caseDetailFrameModel.schemeDescValueFrame;
    self.schemeDescValueLabel.text = caseDetailFrameModel.caseDetailModel.schemeDesc;
}

- (UILabel *)createLabel{
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor darkGrayColor];
    label.font = [UIFont systemFontOfSize:14.0];
    return label;
}

- (UILabel *)developmentTimeNameLabel{
    if(_developmentTimeNameLabel == nil){
        _developmentTimeNameLabel = [self createLabel];
    }
    return _developmentTimeNameLabel;
}

- (UILabel *)developmentTimeValueLabel{
    if(_developmentTimeValueLabel == nil){
        _developmentTimeValueLabel = [self createLabel];
        _developmentTimeValueLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _developmentTimeValueLabel;
}

- (UILabel *)technicalSchemeNameLabel{
    if(_technicalSchemeNameLabel == nil){
        _technicalSchemeNameLabel = [self createLabel];
    }
    return _technicalSchemeNameLabel;
}

- (UILabel *)technicalSchemeValueLabel{
    if(_technicalSchemeValueLabel == nil){
        _technicalSchemeValueLabel = [self createLabel];
        _technicalSchemeValueLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _technicalSchemeValueLabel;
}

- (UILabel *)schemeDescNameLabel{
    if(_schemeDescNameLabel == nil){
        _schemeDescNameLabel = [self createLabel];
    }
    return _schemeDescNameLabel;
}

- (UILabel *)schemeDescValueLabel{
    if(_schemeDescValueLabel == nil){
        _schemeDescValueLabel = [self createLabel];
        _schemeDescValueLabel.numberOfLines = 0;
    }
    return _schemeDescValueLabel;
}


@end
