//
//  SLConnectionDetailTableViewBaseInfoCell.m
//  TaskOffer
//
//  Created by wshaolin on 15/4/21.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLConnectionDetailTableViewBaseInfoCell.h"
#import "HexColor.h"
#import "UIImageView+SetImage.h"
#import "SLTaskImageView.h"
#import "SLConnectionDetailBaseInfoFrameModel.h"
#import "MJPhotoBrowser.h"
#import "SLHTTPServerHandler.h"

@interface SLConnectionDetailTableViewBaseInfoCell()

@property (nonatomic, strong) SLTaskImageView *iconImageView;
@property (nonatomic, strong) UIImageView *sexImageView;
@property (nonatomic, strong) UILabel *displayNameLabel;
@property (nonatomic, strong) UIButton *authenticationButton;
@property (nonatomic, strong) UILabel *companyAndJobLabel;
@property (nonatomic, strong) UILabel *emailLabel;
@property (nonatomic, strong) UILabel *introductionLabel;

@end

@implementation SLConnectionDetailTableViewBaseInfoCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *reuseIdentifier = @"SLConnectionDetailTableViewBaseInfoCell";
    SLConnectionDetailTableViewBaseInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
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
        [self.contentView addSubview:self.companyAndJobLabel];
        [self.contentView addSubview:self.emailLabel];
        [self.contentView addSubview:self.introductionLabel];
    }
    return self;
}

- (void)setBaseInfoFrameModel:(SLConnectionDetailBaseInfoFrameModel *)baseInfoFrameModel{
    _baseInfoFrameModel = baseInfoFrameModel;
    
    self.iconImageView.frame = baseInfoFrameModel.iconImageFrame;
    [self.iconImageView setImageWithURL:baseInfoFrameModel.connectionModel.imageURL placeholderImage:kUserDefaultIcon];
    
    self.sexImageView.frame = baseInfoFrameModel.sexFrame;
    self.sexImageView.hidden = baseInfoFrameModel.connectionModel.sex == SLConnectionModelSexUnknown;
    if(baseInfoFrameModel.connectionModel.sex == SLConnectionModelSexMale){
        self.sexImageView.image = [UIImage imageNamed:@"sex_male"];
    }else if (baseInfoFrameModel.connectionModel.sex == SLConnectionModelSexFemale){
        self.sexImageView.image = [UIImage imageNamed:@"sex_female"];
    }
    
    self.displayNameLabel.frame = baseInfoFrameModel.displayNameFrame;
    self.displayNameLabel.text = baseInfoFrameModel.connectionModel.displayName;
    
    self.authenticationButton.frame = baseInfoFrameModel.authenticationFrame;
    self.authenticationButton.hidden = !baseInfoFrameModel.connectionModel.isAuthenticated;
    
    self.companyAndJobLabel.frame = baseInfoFrameModel.companyAndJobFrame;
    self.companyAndJobLabel.text = baseInfoFrameModel.connectionModel.companyAndJob;
    
    self.emailLabel.frame = baseInfoFrameModel.emailFrame;
    self.emailLabel.text = [NSString stringWithFormat:@"邮箱：%@", baseInfoFrameModel.connectionModel.email];
    
    self.introductionLabel.frame = baseInfoFrameModel.introductionFrame;
    self.introductionLabel.text = baseInfoFrameModel.connectionModel.introduction;
}

- (SLTaskImageView *)iconImageView{
    if(_iconImageView == nil){
        _iconImageView = [[SLTaskImageView alloc] init];
        _iconImageView.backgroundColor = [UIColor colorWithHexString:kDefaultGrayColor];
        _iconImageView.userInteractionEnabled = YES;
        [_iconImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconImageViewTap:)]];
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

- (UILabel *)companyAndJobLabel{
    if(_companyAndJobLabel == nil){
        _companyAndJobLabel = [[UILabel alloc] init];
        _companyAndJobLabel.textAlignment = NSTextAlignmentLeft;
        _companyAndJobLabel.textColor = [UIColor grayColor];
        _companyAndJobLabel.font = [UIFont systemFontOfSize:15.0];
    }
    return _companyAndJobLabel;
}

- (UILabel *)emailLabel{
    if(_emailLabel == nil){
        _emailLabel = [[UILabel alloc] init];
        _emailLabel.textAlignment = NSTextAlignmentLeft;
        _emailLabel.textColor = [UIColor grayColor];
        _emailLabel.font = [UIFont systemFontOfSize:15.0];
    }
    return _emailLabel;
}

- (UILabel *)introductionLabel{
    if(_introductionLabel == nil){
        _introductionLabel = [[UILabel alloc] init];
        _introductionLabel.font = [UIFont systemFontOfSize:15.0];
        _introductionLabel.textColor = [UIColor darkGrayColor];
        _introductionLabel.numberOfLines = 0;
    }
    return _introductionLabel;
}

- (void)iconImageViewTap:(UITapGestureRecognizer *)tapGestureRecognizer{
    MJPhoto *photo = [[MJPhoto alloc] init];
    photo.url = [NSURL URLWithString:SLHTTPServerLargeImageURL(self.baseInfoFrameModel.connectionModel.imageURL)];
    photo.srcImageView = self.iconImageView;
    photo.index = 0;
    
    MJPhotoBrowser *photoBrowser = [[MJPhotoBrowser alloc] init];
    photoBrowser.photos = @[photo];
    photoBrowser.currentPhotoIndex = 0;
    [photoBrowser show];
}

@end
