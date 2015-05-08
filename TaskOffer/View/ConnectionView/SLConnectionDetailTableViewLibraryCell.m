//
//  SLConnectionDetailTableViewLibraryCell.m
//  TaskOffer
//
//  Created by wshaolin on 15/3/19.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLConnectionDetailTableViewLibraryCell.h"
#import "UIImageView+SetImage.h"
#import "SLTaskImageView.h"
#import "HexColor.h"

@interface SLConnectionDetailTableViewLibraryCell()

@property (nonatomic, strong) SLTaskImageView *iconImageView;
@property (nonatomic, strong) UIImageView *angleView;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation SLConnectionDetailTableViewLibraryCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *reuseIdentifier = @"SLConnectionDetailTableViewLibraryCell";
    SLConnectionDetailTableViewLibraryCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if(cell == nil){
        cell = [[self alloc] initWithReuseIdentifier:reuseIdentifier];
    }
    return cell;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithReuseIdentifier:reuseIdentifier]){
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.angleView];
        [self.contentView addSubview:self.contentLabel];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.hideTopLine = YES;
        self.hideBottomLine = NO;
    }
    return self;
}

- (SLTaskImageView *)iconImageView{
    if(_iconImageView == nil){
        _iconImageView = [[SLTaskImageView alloc] init];
        _iconImageView.backgroundColor = [UIColor colorWithHexString:kDefaultGrayColor];
    }
    return _iconImageView;
}

- (UIImageView *)angleView{
    if(_angleView == nil){
        _angleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NEW"]];
        _angleView.hidden = YES;
    }
    return _angleView;
}

- (UILabel *)contentLabel{
    if(_contentLabel == nil){
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = [UIColor darkGrayColor];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.font = [UIFont systemFontOfSize:16.0];
    }
    return _contentLabel;
}

- (void)setIconURL:(NSString *)iconURL{
    _iconURL = iconURL;
    if(_iconURL != nil && _iconURL.length > 0){
        [self.iconImageView setImageWithURL:_iconURL placeholderImage:kDefaultIcon];
    }else{
        self.iconImageView.image = nil;
    }
}

- (void)setContent:(NSString *)content{
    _content = content;
    self.contentLabel.text = content;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat margin = 10.0;
    CGFloat iconImageView_X = margin;
    CGFloat iconImageView_W = 35.0;
    CGFloat iconImageView_H = iconImageView_W;
    CGFloat iconImageView_Y = (self.bounds.size.height - iconImageView_H) * 0.5;
    self.iconImageView.frame = CGRectMake(iconImageView_X, iconImageView_Y, iconImageView_W, iconImageView_H);
    
    CGFloat angleView_W = self.angleView.bounds.size.width;
    CGFloat angleView_H = self.angleView.bounds.size.height;
    CGFloat angleView_X = CGRectGetMaxX(self.iconImageView.frame) - angleView_W * 0.75;
    CGFloat angleView_Y = iconImageView_Y - angleView_H * 0.35;
    self.angleView.frame = CGRectMake(angleView_X, angleView_Y, angleView_W, angleView_H);
    
    CGFloat contentLabel_X = CGRectGetMaxX(self.iconImageView.frame) + margin * 1.5;
    if(self.angleView.isHidden){
        contentLabel_X -= margin;
    }
    CGFloat contentLabel_H = iconImageView_H;
    CGFloat contentLabel_Y = iconImageView_Y;
    CGFloat contentLabel_W = self.bounds.size.width - contentLabel_X - 30.0;
    self.contentLabel.frame = CGRectMake(contentLabel_X, contentLabel_Y, contentLabel_W, contentLabel_H);
}

@end
