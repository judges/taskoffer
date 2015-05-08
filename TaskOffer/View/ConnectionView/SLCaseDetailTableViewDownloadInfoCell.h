//
//  SLCaseDetailTableViewDownloadInfoCell.h
//  TaskOffer
//
//  Created by wshaolin on 15/3/21.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLRootTableViewCell.h"

@class SLCaseDetailModel, SLCaseDetailTableViewDownloadInfoCell;

@protocol SLCaseDetailTableViewDownloadInfoCellDelegate <NSObject>

@optional
- (void)caseDetailTableViewDownloadInfoCell:(SLCaseDetailTableViewDownloadInfoCell *)downloadInfoCell didClickDownloadURL:(NSURL *)url;

@end

@interface SLCaseDetailTableViewDownloadInfoCell : SLRootTableViewCell

@property (nonatomic, strong) SLCaseDetailModel *caseDetailModel;
@property (nonatomic, weak) id<SLCaseDetailTableViewDownloadInfoCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
