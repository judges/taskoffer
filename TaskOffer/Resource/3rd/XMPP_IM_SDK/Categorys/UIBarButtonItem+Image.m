//
//  UIBarButtonItem+Image.m
//  AppFramework
//
//  Created by wshaolin on 14-8-15.
//  Copyright (c) 2014年 rnd. All rights reserved.
//

#import "UIBarButtonItem+Image.h"

@implementation UIBarButtonItem (Image)

+ (instancetype)itemWithNormalImageName:(NSString *)normalImageName highlightedImageName:(NSString *)highlightedImageName target:(id)target action:(SEL)action{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if(normalImageName != nil && normalImageName.length > 0){
        UIImage *normalImage = [UIImage imageNamed:normalImageName];
        [button setBackgroundImage:normalImage forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 0, normalImage.size.width, normalImage.size.height);
    }
    if(highlightedImageName != nil && highlightedImageName.length > 0){
        UIImage *highlightedImage = [UIImage imageNamed:highlightedImageName];
        [button setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
    }
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (instancetype)backItemWithNormalImageName:(NSString *)normalImageName highlightedImageName:(NSString *)highlightedImageName target:(id)target action:(SEL)action{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if(normalImageName != nil && normalImageName.length > 0){
        UIImage *normalImage = [UIImage imageNamed:normalImageName];
        [button setImage:normalImage forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 0, normalImage.size.width, normalImage.size.height);
    }
    if(highlightedImageName != nil && highlightedImageName.length > 0){
        UIImage *highlightedImage = [UIImage imageNamed:highlightedImageName];
        [button setImage:highlightedImage forState:UIControlStateHighlighted];
    }
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (instancetype)itemWithTitle:(NSString *)title target:(id)target action:(SEL)action{
    return [[self alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
}

+ (instancetype)itemWithImageName:(NSString *)imageName target:(id)target action:(SEL)action{
    return [[self alloc] initWithImage:[UIImage imageNamed:imageName] style:UIBarButtonItemStylePlain target:target action:action];
}

+ (instancetype)placeholderItem{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 20.0, 30.0);
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

@end
