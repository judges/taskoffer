//
//  SLBiddingProjectTableViewCell.h
//  TaskOffer
//
//  Created by wshaolin on 15/3/20.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLRootTableViewCell.h"

@class SLProjectModel;

@interface SLBiddingProjectTableViewCell : SLRootTableViewCell

@property (nonatomic, strong) SLProjectModel *projectModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
