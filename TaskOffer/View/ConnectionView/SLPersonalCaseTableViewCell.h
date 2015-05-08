//
//  SLPersonalCaseTableViewCell.h
//  TaskOffer
//
//  Created by wshaolin on 15/4/9.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLRootTableViewCell.h"

@class SLPersonalCaseTableViewCell, SLPersonalCaseFrameModel;

@protocol SLPersonalCaseTableViewCellDelegate <NSObject>

@optional
- (void)personalCaseTableViewCell:(SLPersonalCaseTableViewCell *)personalCaseTableViewCell didClickEditButtonAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface SLPersonalCaseTableViewCell : SLRootTableViewCell

@property (nonatomic, strong) SLPersonalCaseFrameModel *personalCaseFrameModel;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id<SLPersonalCaseTableViewCellDelegate> delegate;

@property (nonatomic, assign, getter = isEnableEditor) BOOL enableEditor;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
