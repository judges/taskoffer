//
//  SLConnectionDetailTableViewEIUnrecognizedCell.h
//  TaskOffer
//
//  Created by wshaolin on 15/3/20.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLRootTableViewCell.h"

@class SLEnterpriseInformationFrameModel;

@interface SLConnectionDetailTableViewEIUnrecognizedCell : SLRootTableViewCell

@property (nonatomic, strong) SLEnterpriseInformationFrameModel *frameModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
