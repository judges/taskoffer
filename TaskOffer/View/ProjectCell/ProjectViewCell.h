//
//  ProjectViewCell.h
//  TaskOffer
//
//  Created by BourbonZ on 15/3/17.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectInfo.h"
@interface ProjectViewCell : UITableViewCell
///项目头像
@property (nonatomic,strong) UIImageView *projectIconView;
///项目名称
@property (nonatomic,strong) UILabel *projectNameLabel;
///项目发布者
@property (nonatomic,strong) UILabel *projectPublishLabel;
///项目到期时间
@property (nonatomic,strong) UILabel *projectDeadLineLabel;
///项目价格
@property (nonatomic,strong) UILabel *projectPriceLabel;
///项目价格背景图片
@property (nonatomic,strong) UIImageView *projectPriceImage;
///项目截止时间
@property (nonatomic,strong) UILabel *projectCloseDateLabel;
///项目截止时间背景图片
@property (nonatomic,strong) UIImageView *projectCloseDateImage;
///项目简介
@property (nonatomic,strong) UILabel *projectContentLabel;

///项目
@property (nonatomic,assign) ProjectInfo *info;
@end
