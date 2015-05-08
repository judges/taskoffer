//
//  UIColor+Equalable.m
//  XMPPIM
//
//  Created by wshaolin on 14/12/29.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import "UIColor+Equalable.h"

@implementation UIColor (Equalable)

- (BOOL)isEqualColor:(UIColor *)aColor{
    CGColorSpaceRef colorSpaceRGB = CGColorSpaceCreateDeviceRGB();
    UIColor *(^EAConvertColorToRGBSpace)(UIColor*) = ^(UIColor *color) {
        if(CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) == kCGColorSpaceModelMonochrome) {
            const CGFloat *oldComponents = CGColorGetComponents(color.CGColor);
            CGFloat components[4] = {oldComponents[0], oldComponents[0], oldComponents[0], oldComponents[1]};
            CGColorRef colorRef = CGColorCreate(colorSpaceRGB, components);
            UIColor *oneColor = [UIColor colorWithCGColor:colorRef];
            CGColorRelease(colorRef);
            return oneColor;
        }else{
            return color;
        }
    };
    
    UIColor *currentColor = EAConvertColorToRGBSpace(self);
    UIColor *otherColor = EAConvertColorToRGBSpace(aColor);
    CGColorSpaceRelease(colorSpaceRGB);
    
    return [currentColor isEqual:otherColor];
}

@end
