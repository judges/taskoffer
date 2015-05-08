//
//  UIView+Conveniently.h
//  AppFramework
//
//  Created by wshaolin on 14/11/21.
//  Copyright (c) 2014年 wshaolin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Conveniently)

@end

@interface UIView (Frame)

@property (nonatomic, assign) CGFloat x;

@property (nonatomic, assign) CGFloat y;

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) CGFloat height;

@end


@interface UIView (Image)

- (UIImage *)image;

- (UIImage *)imageWithRect:(CGRect)rect;

@end

@interface UIView (Animation)

- (void)shakeAnimationWithRadian:(CGFloat)radian;

@end
