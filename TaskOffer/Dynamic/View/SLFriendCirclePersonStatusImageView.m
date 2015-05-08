//
//  SLFriendCirclePersonStatusImageView.m
//  XMPPIM
//
//  Created by wshaolin on 14/12/26.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import "SLFriendCirclePersonStatusImageView.h"
#import "UIImageView+SetImage.h"
#import "HexColor.h"
#import "SLTaskImageView.h"

#define SLFriendCirclePersonStatusImageCount 4

@interface SLFriendCirclePersonStatusImageView()

@property (nonatomic, strong) NSArray *imageView;

@end

@implementation SLFriendCirclePersonStatusImageView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self setupImageViews];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setupImageViews{
    NSMutableArray *tempArray = [NSMutableArray array];
    for(NSInteger index = 0; index < SLFriendCirclePersonStatusImageCount; index ++){
        SLTaskImageView *imageView = [[SLTaskImageView alloc] init];
        imageView.backgroundColor = [UIColor colorWithHexString:kDefaultGrayColor];
        [tempArray addObject:imageView];
        [self addSubview:imageView];
    }
    self.imageView = [tempArray copy];
}

- (void)setFrame:(CGRect)frame{
    frame.size.width = 82.0;
    frame.size.height = frame.size.width;
    [super setFrame:frame];
}

- (void)setImageUrl:(NSArray *)imageUrl{
    _imageUrl = imageUrl;
    CGFloat margin = 2.0;
    CGFloat image_W = 0;
    CGFloat image_H = 0;
    CGFloat image_X = 0;
    CGFloat image_Y = 0;
    for(NSInteger index = 0; index < self.imageView.count; index ++){
        SLTaskImageView *imageView = self.imageView[index];
        imageView.hidden = index >= imageUrl.count;
        if(imageUrl.count == 1){
            if(index < imageUrl.count){
                image_W = self.bounds.size.width;
                image_H = image_W;
            }
        }else if(imageUrl.count == 2){
            if(index < imageUrl.count){
                image_H = self.bounds.size.width;
                image_W = (self.bounds.size.width - margin) * 0.5;
                image_X = index * (image_W + margin);
            }
        }else if(imageUrl.count == 3){
            if(index < imageUrl.count){
                if(index == 0){
                    image_H = self.bounds.size.width;
                    image_W = (self.bounds.size.width - margin) * 0.5;
                }else{
                    image_H = (self.bounds.size.width - margin) * 0.5;
                    image_W = image_H;
                    image_X = image_W + margin;
                    image_Y = (image_H + margin) * ((index - 1) % 2);
                }
            }
        }else if(imageUrl.count >= 4){
            image_W = (self.bounds.size.width - margin) * 0.5;
            image_H = image_W;
            image_X = (image_W + margin) * (index % 2);
            image_Y = (image_H + margin) * (index / 2);
        }
        
        imageView.frame = CGRectMake(image_X, image_Y, image_W, image_H);
        if(index < imageUrl.count){
            [imageView setImageWithURL:imageUrl[index]];
        }
    }
}

@end
