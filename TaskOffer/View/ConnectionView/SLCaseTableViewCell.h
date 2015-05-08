//
//  SLCaseTableViewCell.h
//  TaskOffer
//
//  Created by wshaolin on 15/3/20.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLRootTableViewCell.h"
#import "SLCaseCellToolView.h"

@class SLCaseTableViewCell, SLCaseDetailModel;

@protocol SLCaseTableViewCellDelegate <NSObject>

@optional
- (void)caseTableViewCell:(SLCaseTableViewCell *)caseTableViewCell didClickEditButtonAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface SLCaseTableViewCell : SLRootTableViewCell

@property (nonatomic, weak) id<SLCaseTableViewCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) SLCaseDetailModel *caseDetailModel;
@property (nonatomic, assign, getter = isEnableEditor) BOOL enableEditor;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
