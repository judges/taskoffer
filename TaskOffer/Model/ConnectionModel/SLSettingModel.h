//
//  SLSettingModel.h
//  TaskOffer
//
//  Created by wshaolin on 15/4/28.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLSettingModel : NSObject

@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, copy) NSString *title;

- (instancetype)initWithIcon:(UIImage *)icon title:(NSString *)title;
+ (instancetype)modelWithIcon:(UIImage *)icon title:(NSString *)title;

@end
