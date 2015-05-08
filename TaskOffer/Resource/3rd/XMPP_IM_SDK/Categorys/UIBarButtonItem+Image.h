//
//  UIBarButtonItem+Image.h
//  AppFramework
//
//  Created by wshaolin on 14-8-15.
//  Copyright (c) 2014年 rnd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Image)

/**
 *  根据图片名称和事件创建一个按钮
 *
 *  @param normalImageName      按钮普通状态下的图片名称
 *  @param highlightedImageName 按钮高亮状态下的图片名称
 *  @param target               target
 *  @param action               点击执行的方法
 *
 *  @return UIBarButtonItem实例对象
 */
+ (instancetype)itemWithNormalImageName:(NSString *)normalImageName highlightedImageName:(NSString *)highlightedImageName target:(id)target action:(SEL)action;

+ (instancetype)backItemWithNormalImageName:(NSString *)normalImageName highlightedImageName:(NSString *)highlightedImageName target:(id)target action:(SEL)action;

+ (instancetype)itemWithTitle:(NSString *)title target:(id)target action:(SEL)action;

+ (instancetype)itemWithImageName:(NSString *)imageName target:(id)target action:(SEL)action;

/**
 *  创建一个占位item
 *
 */
+ (instancetype)placeholderItem;

@end
