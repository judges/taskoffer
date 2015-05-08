//
//  UIScrollView+TouchEvent.m
//  AppFramework
//
//  Created by wshaolin on 14-8-23.
//  Copyright (c) 2014年 rnd. All rights reserved.
//

#import "UIScrollView+TouchEvent.h"

@implementation UIScrollView (TouchEvent)

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if(!self.dragging){
        [[self nextResponder]  touchesBegan:touches withEvent:event];
    }
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    if(!self.dragging){
        [[self nextResponder] touchesCancelled:touches withEvent:event];
    }
    [super touchesCancelled:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if(!self.dragging){
        [[self nextResponder] touchesEnded:touches withEvent:event];
    }
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if(!self.dragging){
        [[self nextResponder] touchesMoved:touches withEvent:event];
    }
    [super touchesMoved:touches withEvent:event];
}

@end
