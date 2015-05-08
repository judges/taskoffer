//
//  UIScrollView+TouchEvent.h
//  AppFramework
//
//  Created by wshaolin on 14-8-23.
//  Copyright (c) 2014年 rnd. All rights reserved.
//  UIScrollView的触摸事件

#import <UIKit/UIKit.h>

@interface UIScrollView (TouchEvent)

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;

@end
