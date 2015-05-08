//
//  ApplyCell.h
//  TaskOffer
//
//  Created by BourbonZ on 15/4/1.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnterpriseInfo.h"
@interface ApplyCell : UITableViewCell

///企业号
@property (nonatomic,strong) EnterpriseInfo *info;
///头像
@property (nonatomic,strong) UIImageView *enterpriseIcon;
///名称
@property (nonatomic,strong) UILabel *enterpriseNameLabel;
///类别
@property (nonatomic,strong) UILabel *enterpriseCategoryLabel;
@property (nonatomic,strong) UIImageView *enterpriseCategoryImage;
///案例
@property (nonatomic,strong) UILabel *enterpriseCaseLabel;
///标签
@property (nonatomic,strong) UILabel *enterpriseTagLabel1;
@property (nonatomic,strong) UILabel *enterpriseTagLabel2;
@property (nonatomic,strong) UILabel *enterpriseTagLabel3;
@property (nonatomic,strong) UILabel *enterpriseTagLabel4;
@property (nonatomic,strong) UILabel *enterpriseTagLabel5;
///简介
@property (nonatomic,strong) UILabel *enterpriseContentLabel;

@end
