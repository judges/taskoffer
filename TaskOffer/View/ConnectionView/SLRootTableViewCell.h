//
//  SLRootTableViewCell.h
//  TaskOffer
//
//  Created by wshaolin on 15/3/19.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLRootTableViewCell : UITableViewCell

@property (nonatomic, assign, getter = isHideBottomLine) BOOL hideBottomLine;
@property (nonatomic, assign, getter = isHideTopLine) BOOL hideTopLine;

@property (nonatomic, strong) UIColor *bottomLineColor;
@property (nonatomic, strong) UIColor *topLineColor;

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
