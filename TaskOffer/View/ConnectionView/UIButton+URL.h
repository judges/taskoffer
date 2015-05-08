//
//  UIButton+URL.h
//  TaskOffer
//
//  Created by wshaolin on 15/3/23.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (URL)

- (void)setImage:(UIImage *)image;

- (void)setImageWithURL:(NSString *)url;
- (void)setImageWithURL:(NSString *)url forState:(UIControlState)state;

- (void)setImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholder;
- (void)setImageWithURL:(NSString *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder;

@end
