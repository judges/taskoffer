//
//  SLConnectionDetailTableViewLibraryCell.h
//  TaskOffer
//
//  Created by wshaolin on 15/3/19.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLRootTableViewCell.h"

@interface SLConnectionDetailTableViewLibraryCell : SLRootTableViewCell

@property (nonatomic, copy) NSString *iconURL;
@property (nonatomic, copy) NSString *content;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
