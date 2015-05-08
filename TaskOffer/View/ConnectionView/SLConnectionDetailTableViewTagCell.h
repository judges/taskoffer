//
//  SLConnectionDetailTableViewTagCell.h
//  TaskOffer
//
//  Created by wshaolin on 15/3/19.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLRootTableViewCell.h"

@class SLTagFrameModel;

@interface SLConnectionDetailTableViewTagCell : SLRootTableViewCell

@property (nonatomic, strong) SLTagFrameModel *tagFrameModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
