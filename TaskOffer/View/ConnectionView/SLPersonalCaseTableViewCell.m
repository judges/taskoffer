//
//  SLPersonalCaseTableViewCell.m
//  TaskOffer
//
//  Created by wshaolin on 15/4/9.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLPersonalCaseTableViewCell.h"
#import "SLFriendCircleImageCollectionView.h"
#import "SLPersonalCaseFrameModel.h"
#import "UIImageView+SetImage.h"
#import "HexColor.h"

@interface SLPersonalCaseTableViewCell()

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *showNameLabel;
@property (nonatomic, strong) UIButton *editButton;

@property (nonatomic, strong) UILabel *timeNameLabel;
@property (nonatomic, strong) UILabel *timeValueLabel;
@property (nonatomic, strong) UILabel *schemeNameLabel;
@property (nonatomic, strong) UILabel *schemeValueLabel;
@property (nonatomic, strong) UILabel *priceNameLabel;
@property (nonatomic, strong) UILabel *priceValueLabel;
@property (nonatomic, strong) SLFriendCircleImageCollectionView *imageCollectionView;

@end

@implementation SLPersonalCaseTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *reuseIdentifier = @"SLPersonalCaseTableViewCell";
    SLPersonalCaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if(cell == nil){
        cell = [[self alloc] initWithReuseIdentifier:reuseIdentifier];
    }
    return cell;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithReuseIdentifier:reuseIdentifier]){
        [self.contentView addSubview:self.iconView];
        [self.contentView addSubview:self.showNameLabel];
        [self.contentView addSubview:self.editButton];
        [self.contentView addSubview:self.timeNameLabel];
        [self.contentView addSubview:self.timeValueLabel];
        [self.contentView addSubview:self.schemeNameLabel];
        [self.contentView addSubview:self.schemeValueLabel];
        [self.contentView addSubview:self.priceNameLabel];
        [self.contentView addSubview:self.priceValueLabel];
        [self.contentView addSubview:self.imageCollectionView];
        
        self.enableEditor = NO;
    }
    return self;
}

- (void)setPersonalCaseFrameModel:(SLPersonalCaseFrameModel *)personalCaseFrameModel{
    _personalCaseFrameModel = personalCaseFrameModel;
    self.iconView.frame = personalCaseFrameModel.iconFrame;
    [self.iconView setImageWithURL:personalCaseFrameModel.caseDetailModel.caseLogo placeholderImage:kDefaultIcon];
    self.showNameLabel.frame = personalCaseFrameModel.showNameFrame;
    self.showNameLabel.text = personalCaseFrameModel.caseDetailModel.caseName;
    self.editButton.frame = personalCaseFrameModel.editButtonFrame;
    
    self.timeNameLabel.frame = personalCaseFrameModel.developmentTimeNameFrame;
    self.timeValueLabel.frame = personalCaseFrameModel.developmentTimeValueFrame;
    if(personalCaseFrameModel.caseDetailModel.developmentTime.length > 0){
        self.timeValueLabel.text = [NSString stringWithFormat:@"%@个月", personalCaseFrameModel.caseDetailModel.developmentTime];
    }
    self.schemeNameLabel.frame = personalCaseFrameModel.technicalSchemeNameFrame;
    self.schemeValueLabel.frame = personalCaseFrameModel.technicalSchemeValueFrame;
    self.schemeValueLabel.text = personalCaseFrameModel.caseDetailModel.technicalScheme;
    
    self.priceNameLabel.frame = personalCaseFrameModel.referencePriceNameFrame;
    self.priceValueLabel.frame = personalCaseFrameModel.referencePriceValueFrame;
    self.priceValueLabel.text = personalCaseFrameModel.caseDetailModel.referencePrice;
    
    self.imageCollectionView.frame = personalCaseFrameModel.imageViewFrame;
    self.imageCollectionView.imgaeUrls = personalCaseFrameModel.caseDetailModel.designSchemeUrl;
}

- (void)setEnableEditor:(BOOL)enableEditor{
    _enableEditor = enableEditor;
    self.editButton.hidden = !enableEditor;
}

- (UIImageView *)iconView{
    if(_iconView == nil){
        _iconView = [[UIImageView alloc] init];
        _iconView.backgroundColor = [UIColor colorWithHexString:kDefaultGrayColor];
    }
    return _iconView;
}

- (UILabel *)showNameLabel{
    if(_showNameLabel == nil){
        _showNameLabel = [[UILabel alloc] init];
        _showNameLabel.textAlignment = NSTextAlignmentLeft;
        _showNameLabel.textColor = [UIColor darkGrayColor];
        _showNameLabel.font = [UIFont boldSystemFontOfSize:16.0];
        _showNameLabel.numberOfLines = 2;
    }
    return _showNameLabel;
}

- (UIButton *)editButton{
    if(_editButton == nil){
        _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editButton setImage:[UIImage imageNamed:@"编辑"] forState:UIControlStateNormal];
        [_editButton addTarget:self action:@selector(didClickEditButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editButton;
}

- (UILabel *)timeNameLabel{
    if(_timeNameLabel == nil){
        _timeNameLabel = [self createLabel];
        _timeNameLabel.text = @"开发周期：";
    }
    return _timeNameLabel;
}

- (UILabel *)timeValueLabel{
    if(_timeValueLabel == nil){
        _timeValueLabel = [self createLabel];
    }
    return _timeValueLabel;
}

- (UILabel *)schemeNameLabel{
    if(_schemeNameLabel == nil){
        _schemeNameLabel = [self createLabel];
        _schemeNameLabel.text = @"技术方案：";
    }
    return _schemeNameLabel;
}

- (UILabel *)schemeValueLabel{
    if(_schemeValueLabel == nil){
        _schemeValueLabel = [self createLabel];
        _schemeValueLabel.numberOfLines = 0;
    }
    return _schemeValueLabel;
}

- (UILabel *)priceNameLabel{
    if(_priceNameLabel == nil){
        _priceNameLabel = [self createLabel];
        _priceNameLabel.text = @"开发价格：";
    }
    return _priceNameLabel;
}

- (UILabel *)priceValueLabel{
    if(_priceValueLabel == nil){
        _priceValueLabel = [self createLabel];
        _priceValueLabel.numberOfLines = 0;
    }
    return _priceValueLabel;
}

- (SLFriendCircleImageCollectionView *)imageCollectionView{
    if(_imageCollectionView == nil){
        _imageCollectionView = [[SLFriendCircleImageCollectionView alloc] init];
    }
    return _imageCollectionView;
}

- (UILabel *)createLabel{
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:14.0];
    label.textColor = [UIColor darkGrayColor];
    return label;
}

- (void)didClickEditButton:(UIButton *)button{
    if(self.delegate && [self.delegate respondsToSelector:@selector(personalCaseTableViewCell:didClickEditButtonAtIndexPath:)]){
        [self.delegate personalCaseTableViewCell:self didClickEditButtonAtIndexPath:self.indexPath];
    }
}

@end
