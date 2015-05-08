//
//  SLFriendCircleStatusDetailSectionApplaudImageView.m
//  XMPPIM
//
//  Created by wshaolin on 14/12/28.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import "SLFriendCircleStatusDetailSectionApplaudImageView.h"
#import "SLFriendCircleUserModel.h"
#import "HexColor.h"

@interface SLFriendCircleStatusDetailSectionApplaudImageView()

@end

@implementation SLFriendCircleStatusDetailSectionApplaudImageView

- (instancetype)initWithFrame:(CGRect)frame applaudArray:(NSArray *)applaudArray{
    if(self = [super initWithFrame:frame]){
        _applaudArray = applaudArray;
        
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    NSInteger colunm = 8;
    CGFloat width = 240.0;
    CGFloat image_W = 27.0;
    CGFloat image_H = image_W;
    CGFloat image_M = (width - colunm * image_W) / (colunm - 1);
    NSInteger row = _applaudArray.count / colunm;
    if(_applaudArray.count % colunm != 0){
        row ++;
    }
    for(NSInteger index = 0; index < _applaudArray.count; index ++ ){
        // SLFriendCircleUserModel *friendCircleUserModel = _applaudArray[index];
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.backgroundColor = [UIColor colorWithHexString:kDefaultGrayColor];
        imageView.userInteractionEnabled = YES;
        imageView.tag = index;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTap:)]];
        
        [self addSubview:imageView];
        //imageView.image =  friendCircleUserModel.icon;
        
        CGFloat image_X = (index % colunm) * (image_W + image_M);
        CGFloat image_Y = (index / colunm) * (image_H + image_M);
        imageView.frame = CGRectMake(image_X, image_Y, image_W, image_H);
    }
    
    CGFloat height = row * image_H + (row - 1) * image_M;
    
    CGRect frame = self.frame;
    frame.size.width = width;
    frame.size.height = height;
    [super setFrame:frame];
}

- (void)setFrame:(CGRect)frame{
    frame.size.width = self.frame.size.width;
    frame.size.height = self.frame.size.height;
    [super setFrame:frame];
}

- (void)imageViewTap:(UITapGestureRecognizer *)tapGestureRecognizer{
    if(self.delegate && [self.delegate respondsToSelector:@selector(statusDetailSectionApplaudImageView:didTapApplaudUser:)]){
        [self.delegate statusDetailSectionApplaudImageView:self didTapApplaudUser:self.applaudArray[tapGestureRecognizer.view.tag]];
    }
}

@end
