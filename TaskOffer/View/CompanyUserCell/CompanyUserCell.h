//
//  CompanyUserCell.h
//  TaskOffer
//
//  Created by BourbonZ on 15/3/25.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectTagView.h"

@interface CompanyUserCell : UITableViewCell

@property (nonatomic,strong) NSDictionary *userDict;

@property (nonatomic,strong) UIImageView *iconView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UIImageView *certifyImage;
@property (nonatomic,strong) UILabel *certifyLabel;
@property (nonatomic,strong) UILabel *descLabel;
@property (nonatomic,strong) NSArray *tagArray;
@property (nonatomic,strong) ProjectTagView *tagView;
@end
