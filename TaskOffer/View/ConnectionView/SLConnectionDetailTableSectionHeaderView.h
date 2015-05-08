//
//  SLConnectionDetailTableSectionHeaderView.h
//  TaskOffer
//
//  Created by wshaolin on 15/3/19.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SLConnectionDetailTableSectionHeaderView;

@protocol SLConnectionDetailTableSectionHeaderViewDelegate <NSObject>

@optional
- (void)connectionDetailTableSectionHeaderView:(SLConnectionDetailTableSectionHeaderView *)tableSectionHeaderView didClickMoreButtonAtSection:(NSInteger)section;

@end

@interface SLConnectionDetailTableSectionHeaderView : UITableViewHeaderFooterView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign, getter = isHideMoreButton) BOOL hideMoreButton; // 默认YES
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, assign, getter = isHideTopLine) BOOL hideTopLine;
@property (nonatomic, assign, getter = isHideBottomLine) BOOL hideBottomLine;

@property (nonatomic, weak) id<SLConnectionDetailTableSectionHeaderViewDelegate> delegate;

+ (instancetype)sectionHeaderViewWithTableView:(UITableView *)tableView;

@end
