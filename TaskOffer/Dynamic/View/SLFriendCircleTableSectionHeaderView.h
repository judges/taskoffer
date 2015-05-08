//
//  SLFriendCircleTableSectionHeaderView.h
//  XMPPIM
//
//  Created by wshaolin on 14/12/19.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SLFriendCircleTableSectionHeaderView, SLFriendCircleStatusFrameModel;

@protocol SLFriendCircleTableSectionHeaderViewDelegate <NSObject>

@optional
- (void)friendCircleTableSectionHeaderView:(SLFriendCircleTableSectionHeaderView *)friendCircleTableSectionHeaderView didTapIconForSection:(NSInteger)section;

- (void)friendCircleTableSectionHeaderView:(SLFriendCircleTableSectionHeaderView *)friendCircleTableSectionHeaderView didTapDisplayNameForSection:(NSInteger)section;

- (void)friendCircleTableSectionHeaderView:(SLFriendCircleTableSectionHeaderView *)friendCircleTableSectionHeaderView didTapCommentForSection:(NSInteger)section;

- (void)friendCircleTableSectionHeaderView:(SLFriendCircleTableSectionHeaderView *)friendCircleTableSectionHeaderView didTapApplaudForSection:(NSInteger)section isCancel:(BOOL)cancel;

- (void)friendCircleTableSectionHeaderView:(SLFriendCircleTableSectionHeaderView *)friendCircleTableSectionHeaderView didTapDeleteForSection:(NSInteger)section;

@end

@interface SLFriendCircleTableSectionHeaderView : UITableViewHeaderFooterView

@property (nonatomic, weak) id<SLFriendCircleTableSectionHeaderViewDelegate> delegate;
@property (nonatomic, strong) SLFriendCircleStatusFrameModel *friendCircleStatusFrameModel;
@property (nonatomic, assign) BOOL showTopLine;
@property (nonatomic, assign) BOOL showDeleteButton; // 默认NO
@property (nonatomic, assign) NSInteger section;

+ (instancetype)sectionHeaderViewWithTableView:(UITableView *)tableView;

@end
