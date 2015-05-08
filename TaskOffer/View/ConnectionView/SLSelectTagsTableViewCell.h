//
//  SLSelectTagsTableViewCell.h
//  TaskOffer
//
//  Created by wshaolin on 15/4/28.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLRootTableViewCell.h"

@class SLSelectTagFrameModel, SLSelectTagsTableViewCell;

@protocol SLSelectTagsTableViewCellDelegate <NSObject>

@optional
- (void)selectTagsTableViewCell:(SLSelectTagsTableViewCell *)selectTagsTableViewCell didSelectedTags:(NSArray *)selectedTags;

@end

@interface SLSelectTagsTableViewCell : SLRootTableViewCell

@property (nonatomic, strong) SLSelectTagFrameModel *selectTagFrameModel;
@property (nonatomic, weak) id<SLSelectTagsTableViewCellDelegate> delegate;

@property (nonatomic, strong) NSArray *oldSelectedTags;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
