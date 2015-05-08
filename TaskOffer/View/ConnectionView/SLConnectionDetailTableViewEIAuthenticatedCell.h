//
//  SLConnectionDetailTableViewEIAuthenticatedCell.h
//  TaskOffer
//
//  Created by wshaolin on 15/3/20.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLRootTableViewCell.h"

@class SLEnterpriseInformationModel;

@interface SLConnectionDetailTableViewEIAuthenticatedCell : SLRootTableViewCell

@property (nonatomic, strong) SLEnterpriseInformationModel *eiModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
