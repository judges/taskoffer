//
//  SLConnectionDetailTableViewEIAuthenticatedCell.m
//  TaskOffer
//
//  Created by wshaolin on 15/3/20.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLConnectionDetailTableViewEIAuthenticatedCell.h"
#import "HexColor.h"
#import "NSString+Conveniently.h"
#import "SLEnterpriseInformationModel.h"

@interface SLConnectionDetailTableViewEIAuthenticatedCell()

@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *authenticationButton;

@end

@implementation SLConnectionDetailTableViewEIAuthenticatedCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *reuseIdentifier = @"SLConnectionDetailTableViewEIAuthenticatedCell";
    SLConnectionDetailTableViewEIAuthenticatedCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if(cell == nil){
        cell = [[self alloc] initWithReuseIdentifier:reuseIdentifier];
    }
    return cell;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithReuseIdentifier:reuseIdentifier]){
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.authenticationButton];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.hideTopLine = YES;
        self.hideBottomLine = NO;
    }
    return self;
}

- (void)setEiModel:(SLEnterpriseInformationModel *)eiModel{
    _eiModel = eiModel;
    self.contentLabel.text = eiModel.companyName;
}

- (UILabel *)contentLabel{
    if(_contentLabel == nil){
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = [UIColor blackColor];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.font = [UIFont boldSystemFontOfSize:16.0];
    }
    return _contentLabel;
}

- (UIButton *)authenticationButton{
    if(_authenticationButton == nil){
        _authenticationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _authenticationButton.userInteractionEnabled = NO;
        [_authenticationButton setImage:[UIImage imageNamed:@"connection_user_authentication"] forState:UIControlStateNormal];
        [_authenticationButton setTitle:@"认证企业" forState:UIControlStateNormal];
        [_authenticationButton setTitleColor:[UIColor colorWithHexString:kDefaultOrgangeColor] forState:UIControlStateNormal];
        _authenticationButton.titleLabel.font = [UIFont systemFontOfSize:11.0];
        _authenticationButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5.0, 0, 0);
    }
    return _authenticationButton;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat authenticationButton_W = 65.0;
    CGFloat authenticationButton_H = 20.0;
    
    CGFloat contentLabel_X = 10.0;
    CGFloat contentLabel_H = 35.0;
    CGFloat contentLabel_Y = (self.bounds.size.height - contentLabel_H) * 0.5;
    CGFloat contentLabel_W = self.bounds.size.width - contentLabel_X * 1.5 - authenticationButton_W - 25.0;
    contentLabel_W = [self.contentLabel.text sizeWithFont:self.contentLabel.font limitSize:CGSizeMake(contentLabel_W, contentLabel_H)].width;
    self.contentLabel.frame = CGRectMake(contentLabel_X, contentLabel_Y, contentLabel_W, contentLabel_H);
    
    CGFloat authenticationButton_X = CGRectGetMaxX(self.contentLabel.frame) + contentLabel_X * 0.5;
    CGFloat authenticationButton_Y = (self.bounds.size.height - authenticationButton_H) * 0.5;
    self.authenticationButton.frame = CGRectMake(authenticationButton_X, authenticationButton_Y, authenticationButton_W, authenticationButton_H);
}

@end
