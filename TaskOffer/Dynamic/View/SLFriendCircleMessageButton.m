//
//  SLFriendCircleMessageButton.m
//  XMPPIM
//
//  Created by wshaolin on 15/1/8.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLFriendCircleMessageButton.h"

@implementation SLFriendCircleMessageButton

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor darkGrayColor];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.layer.masksToBounds = NO;
        self.layer.cornerRadius = 5.0;
        self.imageView.layer.masksToBounds = NO;
        self.imageView.layer.cornerRadius = 2.0;
        self.imageView.contentMode = UIViewContentModeCenter;
    }
    
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat margin = 5.0;
    CGFloat image_H = contentRect.size.height - margin * 2;
    CGFloat image_W = image_H;
    CGFloat image_X = margin;
    CGFloat image_Y = margin;
    return CGRectMake(image_X, image_Y, image_W, image_H);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat margin = 5.0;
    CGFloat title_X = CGRectGetMaxX([self imageRectForContentRect:contentRect]) + margin;
    CGFloat title_W = contentRect.size.width - title_X - margin;
    CGFloat title_H = contentRect.size.height;
    CGFloat title_Y = 0;
    return CGRectMake(title_X, title_Y, title_W, title_H);
}

@end
