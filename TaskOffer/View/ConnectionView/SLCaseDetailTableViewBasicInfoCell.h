//
//  SLCaseDetailTableViewBasicInfoCell.h
//  TaskOffer
//
//  Created by wshaolin on 15/3/21.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLRootTableViewCell.h"

@class SLCaseDetailFrameModel;

@interface SLCaseDetailTableViewBasicInfoCell : SLRootTableViewCell

@property (nonatomic, strong) SLCaseDetailFrameModel *caseDetailFrameModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
