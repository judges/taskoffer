//
//  SLCaseCellImageView.m
//  TaskOffer
//
//  Created by wshaolin on 15/3/24.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLCaseCellImageView.h"
#import "UIImageView+SetImage.h"
#import "SLTaskImageView.h"
#import "HexColor.h"

@interface SLCaseCellImageView()

@property (nonatomic, strong) NSMutableArray *imageViews;

@end

@implementation SLCaseCellImageView

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

- (void)_init{
    self.backgroundColor = [UIColor clearColor];
    _imageViews = [NSMutableArray array];
    for(NSInteger index = 0; index < 3; index ++){
        SLTaskImageView *imageView = [[SLTaskImageView alloc] init];
        imageView.backgroundColor = [UIColor colorWithHexString:kDefaultGrayColor];
        [self addSubview:imageView];
        [_imageViews addObject:imageView];
    }
}

- (void)setImgaeURLs:(NSArray *)imgaeURLs{
    _imgaeURLs = imgaeURLs;
    
    CGFloat imageView_H = ([UIScreen mainScreen].bounds.size.width - 80.0) / 3;
    CGFloat imageView_W = imageView_H;
    CGFloat imageView_M = 5.0;
    CGFloat imageView_Y = 0;
    for(NSInteger index = 0; index < imgaeURLs.count; index ++){
        if(index < self.imageViews.count){
            SLTaskImageView *imageView = self.imageViews[index];
            [imageView setImageWithURL:imgaeURLs[index] placeholderImage:kDefaultIcon];
            CGFloat imageView_X = (imageView_W + imageView_M) * index;
            imageView.frame = CGRectMake(imageView_X, imageView_Y, imageView_W, imageView_H);
        }else{
            break;
        }
    }
    
    CGRect frame = self.frame;
    frame.origin.x = 10.0;
    frame.origin.y = 130.0;
    frame.size.width = [UIScreen mainScreen].bounds.size.width - 20.0;
    frame.size.height = 0;
    if(imgaeURLs != nil && imgaeURLs.count > 0){
        frame.size.height = imageView_H;
    }
    
    [self setFrame:frame];
}

@end
