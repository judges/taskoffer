//
//  SLFriendCircleTableSectionFooterView.m
//  XMPPIM
//
//  Created by wshaolin on 14/12/19.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import "SLFriendCircleTableSectionFooterView.h"

@implementation SLFriendCircleTableSectionFooterView

+ (instancetype)sectionFoooterViewWithTableView:(UITableView *)tableView{
    static NSString *headerFooterViewReuseIdentifier = @"SLFriendCircleTableSectionFooterView";
    SLFriendCircleTableSectionFooterView *sectionFooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerFooterViewReuseIdentifier];
    if(sectionFooterView == nil){
        sectionFooterView = [[self alloc] initWithReuseIdentifier:headerFooterViewReuseIdentifier];
        sectionFooterView.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    return sectionFooterView;
}

@end
