//
//  SLMineTableViewCell.h
//  TaskOffer
//
//  Created by wshaolin on 15/4/28.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLRootTableViewCell.h"

@class SLSettingModel;

@interface SLMineTableViewCell : SLRootTableViewCell

@property (nonatomic, strong) SLSettingModel *settingModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
