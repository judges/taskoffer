//
//  SLFriendCircleStatusDetailSectionView.h
//  XMPPIM
//
//  Created by wshaolin on 14/12/28.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLFriendCircleStatusDetailSectionView : UITableViewHeaderFooterView

@property (nonatomic, strong) NSString *applaudNicknameString;
@property (nonatomic, assign, getter = isHideLine) BOOL hideLine;

+ (instancetype)statusDetailSectionViewWithTableView:(UITableView *)tableView;

@end
