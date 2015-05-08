//
//  SLConnectionDetailTableViewBaseInfoCell.h
//  TaskOffer
//
//  Created by wshaolin on 15/4/21.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLRootTableViewCell.h"

@class SLConnectionDetailBaseInfoFrameModel;

@interface SLConnectionDetailTableViewBaseInfoCell : SLRootTableViewCell

@property (nonatomic, strong) SLConnectionDetailBaseInfoFrameModel *baseInfoFrameModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
