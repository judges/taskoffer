//
//  UIView+Conveniently.m
//  AppFramework
//
//  Created by wshaolin on 14/11/21.
//  Copyright (c) 2014年 wshaolin. All rights reserved.
//

#import "UIView+Conveniently.h"

@implementation UIView (Conveniently)

@end

@implementation UIView (Frame)

- (void)setX:(CGFloat)x{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y{
    return self.frame.origin.y;
}

- (void)setWidth:(CGFloat)width{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height{
    return self.frame.size.height;
}

@end

@implementation UIView (Image)

- (UIImage *)image{
    if([self isKindOfClass:[UIScrollView class]]
       || [self isKindOfClass:[UIWebView class]]){
        return [self scrollViewCapture];
    }
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)scrollViewCapture{
    UIScrollView *scrollView = nil;
    if([self isKindOfClass:[UIScrollView class]]){
        scrollView = (UIScrollView *)self;
    }else{
        UIWebView *webView = (UIWebView *)self;
        scrollView = webView.scrollView;
    }
    if(scrollView == nil){
        return nil;
    }

    CGSize size = scrollView.contentSize;
    if(CGSizeEqualToSize(size, CGSizeZero)){
        size = scrollView.frame.size;
    }
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    // 保存旧的偏移量
    CGPoint oldContentOffset = scrollView.contentOffset;
    // 保存旧的frame
    CGRect oldFrame = scrollView.frame;
    // 设置scrollView的偏移量为0
    scrollView.contentOffset = CGPointZero;
    // 设置scrollViewframe的高度和宽度为scrollView内容大小的高度和宽度
    scrollView.frame = CGRectMake(0, 0, size.width, size.height);
    
    [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 还原scrollView的偏移量
    scrollView.contentOffset = oldContentOffset;
    // 还原scrollView的frame
    scrollView.frame = oldFrame;
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)imageWithRect:(CGRect)rect{
    UIImage *image = [self image];
    if(image != nil){
        CGImageRef imageRefRect =CGImageCreateWithImageInRect(image.CGImage, rect);
        return [[UIImage alloc] initWithCGImage:imageRefRect];
    }
    return nil;
}

@end

@implementation UIView (Animation)

- (void)shakeAnimationWithRadian:(CGFloat)radian{
    CALayer *layer = self.layer;
    CGPoint position = layer.position;
    CGPoint x = CGPointMake(position.x + radian, position.y);
    CGPoint y = CGPointMake(position.x - radian, position.y);
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    [animation setAutoreverses:YES];
    [animation setDuration:0.06];
    [animation setRepeatCount:3];
    [layer addAnimation:animation forKey:nil];
}

@end
