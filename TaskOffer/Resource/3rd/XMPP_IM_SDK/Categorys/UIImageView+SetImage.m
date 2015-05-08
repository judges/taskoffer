//
//  UIImageView+SetImage.m
//  AppFramework
//
//  Created by wshaolin on 14/11/24.
//  Copyright (c) 2014年 wshaolin. All rights reserved.
//

#import "UIImageView+SetImage.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (SetImage)

- (void)setImageWithURL:(NSString *)url{
    [self sd_setImageWithURL:[NSURL URLWithString:[url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
}

- (void)setImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholder{
    [self sd_setImageWithURL:[NSURL URLWithString:[url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:placeholder];
}

@end
