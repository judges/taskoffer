//
//  SLConnectionTableViewCell.h
//  TaskOffer
//
//  Created by wshaolin on 15/3/19.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLRootTableViewCell.h"

@class SLConnectionFrameModel;

@interface SLConnectionTableViewCell : SLRootTableViewCell

@property (nonatomic, strong) SLConnectionFrameModel *connectionFrameModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
