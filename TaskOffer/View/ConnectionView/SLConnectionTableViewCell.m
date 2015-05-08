//
//  SLConnectionTableViewCell.m
//  TaskOffer
//
//  Created by wshaolin on 15/3/19.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLConnectionTableViewCell.h"
#import "SLConnectionFrameModel.h"
#import "UIImageView+SetImage.h"
#import "HexColor.h"
#import "SLTaskImageView.h"

@interface SLConnectionTableViewCell()

@property (nonatomic, strong) SLTaskImageView *iconImageView; // 头像
@property (nonatomic, strong) UIImageView *sexImageView; // 性别
@property (nonatomic, strong) UILabel *displayNameLabel; // 显示的名字
@property (nonatomic, strong) UIButton *authenticationButton; // 认证用户
@property (nonatomic, strong) UILabel *caseCountLabel; // 案例数量
@property (nonatomic, strong) UIImageView *caseCountBackgroundView;
@property (nonatomic, strong) UILabel *companyAndJobLabel; // 公司和职位
@property (nonatomic, strong) UILabel *tag1Label; // 标签1
@property (nonatomic, strong) UILabel *tag2Label; // 标签2
@property (nonatomic, strong) UILabel *tag3Label; // 标签3
@property (nonatomic, strong) UILabel *introductionLabel; // 简介

@end

@implementation SLConnectionTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *reuseIdentifier = @"SLConnectionTableViewCell";
    SLConnectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if(cell == nil){
        cell = [[self alloc] initWithReuseIdentifier:reuseIdentifier];
    }
    return cell;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithReuseIdentifier:reuseIdentifier]){
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.sexImageView];
        [self.contentView addSubview:self.displayNameLabel];
        [self.contentView addSubview:self.authenticationButton];
        [self.contentView addSubview:self.caseCountBackgroundView];
        [self.contentView addSubview:self.caseCountLabel];
        [self.contentView addSubview:self.companyAndJobLabel];
        [self.contentView addSubview:self.tag1Label];
        [self.contentView addSubview:self.tag2Label];
        [self.contentView addSubview:self.tag3Label];
        [self.contentView addSubview:self.introductionLabel];
    }
    return self;
}

- (void)setConnectionFrameModel:(SLConnectionFrameModel *)connectionFrameModel{
    _connectionFrameModel = connectionFrameModel;
    self.iconImageView.frame = connectionFrameModel.iconFrame;
    [self.iconImageView setImageWithURL:connectionFrameModel.connectionModel.imageURL placeholderImage:kUserDefaultIcon];
    
    self.sexImageView.frame = connectionFrameModel.sexFrame;
    self.sexImageView.hidden = connectionFrameModel.connectionModel.sex == SLConnectionModelSexUnknown;
    if(connectionFrameModel.connectionModel.sex == SLConnectionModelSexMale){
        self.sexImageView.image = [UIImage imageNamed:@"sex_male"];
    }else if(connectionFrameModel.connectionModel.sex == SLConnectionModelSexFemale){
        self.sexImageView.image = [UIImage imageNamed:@"sex_female"];
    }
    
    self.displayNameLabel.frame = connectionFrameModel.displayNameFrame;
    self.displayNameLabel.text = connectionFrameModel.connectionModel.displayName;
    
    self.authenticationButton.frame = connectionFrameModel.authenticationFrame;
    self.authenticationButton.hidden = !connectionFrameModel.connectionModel.isAuthenticated;
    
    self.caseCountBackgroundView.frame = connectionFrameModel.caseCountFrame;
    self.caseCountLabel.frame = connectionFrameModel.caseCountFrame;
    self.caseCountLabel.text = [NSString stringWithFormat:@"共%ld案例", (long)connectionFrameModel.connectionModel.caseCount];
    
    self.companyAndJobLabel.frame = connectionFrameModel.companyAndJobFrame;
    self.companyAndJobLabel.text = connectionFrameModel.connectionModel.companyAndJob;
    
    self.tag1Label.frame = connectionFrameModel.tag1Frame;
    self.tag1Label.text = connectionFrameModel.connectionModel.tag1;
    
    self.tag2Label.frame = connectionFrameModel.tag2Frame;
    self.tag2Label.text = connectionFrameModel.connectionModel.tag2;
    
    self.tag3Label.frame = connectionFrameModel.tag3Frame;
    self.tag3Label.text = connectionFrameModel.connectionModel.tag3;
    
    self.introductionLabel.frame = connectionFrameModel.introductionFrame;
    self.introductionLabel.text = connectionFrameModel.connectionModel.introduction;
}

- (SLTaskImageView *)iconImageView{
    if(_iconImageView == nil){
        _iconImageView = [[SLTaskImageView alloc] init];
        _iconImageView.backgroundColor = [UIColor colorWithHexString:kDefaultGrayColor];
    }
    return _iconImageView;
}

- (UIImageView *)sexImageView{
    if(_sexImageView == nil){
        _sexImageView = [[UIImageView alloc] init];
        _sexImageView.hidden = YES;
    }
    return _sexImageView;
}

- (UILabel *)displayNameLabel{
    if(_displayNameLabel == nil){
        _displayNameLabel = [[UILabel alloc] init];
        _displayNameLabel.textAlignment = NSTextAlignmentLeft;
        _displayNameLabel.textColor = [UIColor blackColor];
        _displayNameLabel.font = [UIFont boldSystemFontOfSize:16.0];
    }
    return _displayNameLabel;
}

- (UIButton *)authenticationButton{
    if(_authenticationButton == nil){
        _authenticationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _authenticationButton.userInteractionEnabled = NO;
        [_authenticationButton setImage:[UIImage imageNamed:@"connection_user_authentication"] forState:UIControlStateNormal];
        [_authenticationButton setTitle:@"认证用户" forState:UIControlStateNormal];
        [_authenticationButton setTitleColor:[UIColor colorWithHexString:kDefaultOrgangeColor] forState:UIControlStateNormal];
        _authenticationButton.titleLabel.font = [UIFont systemFontOfSize:11.0];
        _authenticationButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5.0, 0, 0);
    }
    return _authenticationButton;
}

- (UIImageView *)caseCountBackgroundView{
    if(_caseCountBackgroundView == nil){
        _caseCountBackgroundView = [[TouchImageView alloc] init];
        _caseCountBackgroundView.image = [UIImage imageNamed:@"connection_case_count"];
    }
    return _caseCountBackgroundView;
}

- (UILabel *)caseCountLabel{
    if(_caseCountLabel == nil){
        _caseCountLabel = [[UILabel alloc] init];
        _caseCountLabel.backgroundColor = [UIColor clearColor];
        _caseCountLabel.textAlignment = NSTextAlignmentCenter;
        _caseCountLabel.textColor = [UIColor whiteColor];
        _caseCountLabel.font = [UIFont boldSystemFontOfSize:12.0];
        _caseCountLabel.adjustsFontSizeToFitWidth = YES;
        _caseCountLabel.hidden = YES;
    }
    return _caseCountLabel;
}

- (UILabel *)companyAndJobLabel{
    if(_companyAndJobLabel == nil){
        _companyAndJobLabel = [[UILabel alloc] init];
        _companyAndJobLabel.textAlignment = NSTextAlignmentLeft;
        _companyAndJobLabel.textColor = [UIColor grayColor];
        _companyAndJobLabel.font = [UIFont systemFontOfSize:14.0];
    }
    return _companyAndJobLabel;
}

- (UILabel *)createTagLable{
    UILabel *tagLabel = [[UILabel alloc] init];
    tagLabel.textAlignment = NSTextAlignmentCenter;
    tagLabel.backgroundColor = [UIColor colorWithHexString:kDefaultTextColor];
    tagLabel.font = [UIFont systemFontOfSize:14.0];
    tagLabel.textColor = [UIColor whiteColor];
    tagLabel.adjustsFontSizeToFitWidth = YES;
    tagLabel.layer.masksToBounds = YES;
    tagLabel.layer.cornerRadius = 3.0;
    return tagLabel;
}

- (UILabel *)tag1Label{
    if(_tag1Label == nil){
        _tag1Label = [self createTagLable];
    }
    return _tag1Label;
}

- (UILabel *)tag2Label{
    if(_tag2Label == nil){
        _tag2Label = [self createTagLable];
    }
    return _tag2Label;
}

- (UILabel *)tag3Label{
    if(_tag3Label == nil){
        _tag3Label = [self createTagLable];
    }
    return _tag3Label;
}

- (UILabel *)introductionLabel{
    if(_introductionLabel == nil){
        _introductionLabel = [[UILabel alloc] init];
        _introductionLabel.font = [UIFont systemFontOfSize:13.0];
        _introductionLabel.textColor = [UIColor darkGrayColor];
        _introductionLabel.numberOfLines = 2;
        _introductionLabel.hidden = YES;
    }
    return _introductionLabel;
}

@end
