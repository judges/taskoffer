//
//  LBorderHelper.m
//  TaskOffer
//
//  Created by BourbonZ on 15/3/19.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "LBorderHelper.h"

@implementation LBorderHelper
+(CAShapeLayer *)getLayerWithColor:(UIColor *)color withBounds:(CGRect)bounds
{
    CAShapeLayer *border = [CAShapeLayer layer];
    CGMutablePathRef path = CGPathCreateMutable();
    CGRect frame = bounds;
    CGFloat cornerRadius = 0;
    
    CGPathMoveToPoint(path, NULL, 0, frame.size.height - cornerRadius);
    CGPathAddLineToPoint(path, NULL, 0, cornerRadius);
    CGPathAddArc(path, NULL, cornerRadius, cornerRadius, cornerRadius, M_PI, -M_PI_2, NO);
    CGPathAddLineToPoint(path, NULL, frame.size.width - cornerRadius, 0);
    CGPathAddArc(path, NULL, frame.size.width - cornerRadius, cornerRadius, cornerRadius, -M_PI_2, 0, NO);
    CGPathAddLineToPoint(path, NULL, frame.size.width, frame.size.height - cornerRadius);
    CGPathAddArc(path, NULL, frame.size.width - cornerRadius, frame.size.height - cornerRadius, cornerRadius, 0, M_PI_2, NO);
    CGPathAddLineToPoint(path, NULL, cornerRadius, frame.size.height);
    CGPathAddArc(path, NULL, cornerRadius, frame.size.height - cornerRadius, cornerRadius, M_PI_2, M_PI, NO);
    
    border.path = path;
    CGPathRelease(path);
    border.frame = frame;
    border.borderColor = [color CGColor];
    border.masksToBounds = NO;
    [border setValue:[NSNumber numberWithBool:NO] forKey:@"isCircle"];
    border.fillColor = [[UIColor clearColor] CGColor];
    border.strokeColor =[color CGColor];
    border.lineWidth = 1.0f;
    border.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:4], [NSNumber numberWithInt:2], nil];
    border.lineCap = kCALineCapRound;
    
    return border;

}
@end
