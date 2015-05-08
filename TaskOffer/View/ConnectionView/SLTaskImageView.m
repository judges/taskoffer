//
//  SLTaskImageView.m
//  TaskOffer
//
//  Created by wshaolin on 15/4/3.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLTaskImageView.h"

@implementation SLTaskImageView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self _init];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        [self _init];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image{
    if(self = [super initWithImage:image]){
        [self _init];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage{
    if(self = [super initWithImage:image highlightedImage:highlightedImage]){
        [self _init];
    }
    return self;
}

- (void)_init{
    self.clipsToBounds = YES;
    self.contentMode = UIViewContentModeScaleAspectFill;
}

@end
