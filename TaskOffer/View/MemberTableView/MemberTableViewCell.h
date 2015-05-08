//
//  MemberTableViewCell.h
//  TaskOffer
//
//  Created by BourbonZ on 15/4/8.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserInfo;
@interface MemberTableViewCell : UITableViewCell

@property (nonatomic,strong) UserInfo *friendInfo;
@property (nonatomic,assign) BOOL isSelected;
@end
