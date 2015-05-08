//
//  ContactCell.h
//  XMPPIM
//
//  Created by BourbonZ on 15/1/9.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactCell : UITableViewCell

@property (nonatomic,strong) UIImageView *iconView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,assign) BOOL haveRedView;
@property (nonatomic,strong) UIView *redView;
@property (nonatomic,strong) UIImageView *selectView;
@property (nonatomic,assign) BOOL isSelected;
@end
