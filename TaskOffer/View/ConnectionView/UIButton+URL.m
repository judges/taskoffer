//
//  UIButton+URL.m
//  TaskOffer
//
//  Created by wshaolin on 15/3/23.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "UIButton+URL.h"
#import "UIButton+WebCache.h"

@implementation UIButton (URL)

- (void)setImage:(UIImage *)image{
    [self setImage:image forState:UIControlStateNormal];
}

- (void)setImageWithURL:(NSString *)url{
    if(url != nil && url.length > 0){
        [self sd_setImageWithURL:[NSURL URLWithString:[url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] forState:UIControlStateNormal];
    }
}

- (void)setImageWithURL:(NSString *)url forState:(UIControlState)state{
    if(url != nil && url.length > 0){
        [self sd_setImageWithURL:[NSURL URLWithString:[url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] forState:state];
    }
}

- (void)setImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholder{
    if(url != nil && url.length > 0){
        [self sd_setImageWithURL:[NSURL URLWithString:[url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] forState:UIControlStateNormal placeholderImage:placeholder];
    }
}

- (void)setImageWithURL:(NSString *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder{
    if(url != nil && url.length > 0){
        [self sd_setImageWithURL:[NSURL URLWithString:[url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] forState:state placeholderImage:placeholder];
    }
}

@end
