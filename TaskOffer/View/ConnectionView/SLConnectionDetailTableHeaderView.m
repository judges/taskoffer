//
//  SLConnectionDetailTableHeaderView.m
//  TaskOffer
//
//  Created by wshaolin on 15/3/19.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLConnectionDetailTableHeaderView.h"
#import "SLConnectionModel.h"
#import "HexColor.h"
#import "UIImageView+SetImage.h"
#import "NSString+Conveniently.h"
#import "SLTaskImageView.h"

@interface SLConnectionDetailTableHeaderView()

@property (nonatomic, strong) SLTaskImageView *iconImageView;
@property (nonatomic, strong) UILabel *displayNameLabel;
@property (nonatomic, strong) UIButton *authenticationButton;
@property (nonatomic, strong) UILabel *companyAndJobLabel;
@property (nonatomic, strong) UILabel *emailLabel;
@property (nonatomic, strong) UILabel *introductionLabel;

@end

@implementation SLConnectionDetailTableHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self addSubview:self.iconImageView];
        [self addSubview:self.displayNameLabel];
        [self addSubview:self.authenticationButton];
        [self addSubview:self.companyAndJobLabel];
        [self addSubview:self.emailLabel];
        [self addSubview:self.introductionLabel];
    }
    return self;
}

- (void)setConnectionModel:(SLConnectionModel *)connectionModel{
    _connectionModel = connectionModel;
    
    CGFloat margin = 10.0;
    CGFloat screen_W = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat image_W = 60.0;
    CGFloat image_H = image_W;
    CGFloat image_X = margin;
    CGFloat image_Y = margin;
    self.iconImageView.frame = CGRectMake(image_X, image_Y, image_W, image_H);
    if(connectionModel.imageURL.length > 0){
        [self.iconImageView setImageWithURL:connectionModel.imageURL placeholderImage:kUserDefaultIcon];
    }
    
    CGFloat authenticationFlag_W = 0;
    if(connectionModel.isAuthenticated){
        authenticationFlag_W = 65.0;
    }
    
    CGFloat displayName_H = 20.0;
    CGFloat displayName_X = CGRectGetMaxX(self.iconImageView.frame) + margin;
    CGFloat displayName_W = screen_W - displayName_X - authenticationFlag_W - margin * 2;
    displayName_W = [connectionModel.displayName sizeWithFont:self.displayNameLabel.font limitSize:CGSizeMake(displayName_W, displayName_H)].width;
    CGFloat displayName_Y = image_Y;
    self.displayNameLabel.frame = CGRectMake(displayName_X, displayName_Y, displayName_W, displayName_H);
    self.displayNameLabel.text = connectionModel.displayName;
    
    CGFloat authenticationFlag_H = displayName_H;
    CGFloat authenticationFlag_X = CGRectGetMaxX(self.displayNameLabel.frame) + margin;
    CGFloat authenticationFlag_Y = displayName_Y;
    self.authenticationButton.frame = CGRectMake(authenticationFlag_X, authenticationFlag_Y, authenticationFlag_W, authenticationFlag_H);
    self.authenticationButton.hidden = !connectionModel.isAuthenticated;
    
    CGFloat companyAndJob_X = displayName_X;
    CGFloat companyAndJob_H = displayName_H;
    CGFloat companyAndJob_Y = CGRectGetMaxY(self.displayNameLabel.frame);
    CGFloat companyAndJob_W = screen_W - companyAndJob_X - margin;
    self.companyAndJobLabel.frame = CGRectMake(companyAndJob_X, companyAndJob_Y, companyAndJob_W, companyAndJob_H);
    self.companyAndJobLabel.text = connectionModel.companyAndJob;
    
    CGFloat email_X = companyAndJob_X;
    CGFloat email_Y = CGRectGetMaxY(self.companyAndJobLabel.frame);
    CGFloat email_H = companyAndJob_H;
    CGFloat email_W = companyAndJob_W;
    self.emailLabel.frame = CGRectMake(email_X, email_Y, email_W, email_H);
    self.emailLabel.text = [NSString stringWithFormat:@"邮箱：%@", connectionModel.email];
    
    CGFloat introduction_X = image_X;
    CGFloat introduction_Y = CGRectGetMaxY(self.iconImageView.frame) + margin;
    CGFloat introduction_W = screen_W - margin * 2;
    CGFloat introduction_H = [connectionModel.introduction sizeWithFont:self.introductionLabel.font limitSize:CGSizeMake(introduction_W, MAXFLOAT)].height;
    self.introductionLabel.frame = CGRectMake(introduction_X, introduction_Y, introduction_W, introduction_H);
    self.introductionLabel.text = connectionModel.introduction;
    
    CGRect frame = [UIScreen mainScreen].bounds;
    frame.size.height = CGRectGetMaxY(self.introductionLabel.frame) + margin;
    [super setFrame:frame];
}

- (void)setFrame:(CGRect)frame{
    
}

- (SLTaskImageView *)iconImageView{
    if(_iconImageView == nil){
        _iconImageView = [[SLTaskImageView alloc] init];
        _iconImageView.backgroundColor = [UIColor colorWithHexString:kDefaultGrayColor];
    }
    return _iconImageView;
}

- (UILabel *)displayNameLabel{
    if(_displayNameLabel == nil){
        _displayNameLabel = [[UILabel alloc] init];
        _displayNameLabel.textAlignment = NSTextAlignmentLeft;
        _displayNameLabel.textColor = [UIColor blackColor];
        _displayNameLabel.font = [UIFont boldSystemFontOfSize:16.0];
        //_displayNameLabel.adjustsFontSizeToFitWidth = YES;
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
        //_companyAndJobLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _companyAndJobLabel;
}

- (UILabel *)emailLabel{
    if(_emailLabel == nil){
        _emailLabel = [[UILabel alloc] init];
        _emailLabel.textAlignment = NSTextAlignmentLeft;
        _emailLabel.textColor = [UIColor grayColor];
        _emailLabel.font = [UIFont systemFontOfSize:15.0];
        //_emailLabel.adjustsFontSizeToFitWidth = YES;
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

@end
