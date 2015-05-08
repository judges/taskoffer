//
//  MyinfoTableViewCell.h
//  TaskOffer
//
//  Created by BourbonZ on 15/3/16.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyinfoTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImageView *logoView;
@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,copy) NSString *placeString;

@end
