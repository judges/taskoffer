//
//  SLFriendCircleImageCollectionView.m
//  XMPPIM
//
//  Created by wshaolin on 14/12/17.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import "SLFriendCircleImageCollectionView.h"
#import "UIImageView+SetImage.h"
#import "MJPhotoBrowser.h"
#import "SLFriendCircleConstant.h"
#import "HexColor.h"
#import "SLTaskImageView.h"
#import "SLHTTPServerHandler.h"

#define SLFriendCirceImageCollectionViewMaxImageCount 9

@interface SLFriendCircleImageCollectionView()

@property (nonatomic, strong) NSArray *imageViews;

@end

@implementation SLFriendCircleImageCollectionView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self setupImageViews];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setupImageViews{
    NSMutableArray *tempArray = [NSMutableArray array];
    for(NSInteger index = 0; index < SLFriendCirceImageCollectionViewMaxImageCount; index ++){
        SLTaskImageView *imageView = [[SLTaskImageView alloc] init];
        imageView.userInteractionEnabled = YES;
        imageView.tag = index;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTap:)]];
        imageView.backgroundColor = [UIColor colorWithHexString:kDefaultGrayColor];
        [self addSubview:imageView];
        [tempArray addObject:imageView];
    }
    self.imageViews = [tempArray copy];
}

- (void)setImgaeUrls:(NSArray *)imgaeUrls{
    _imgaeUrls = imgaeUrls;
    for(NSInteger index = 0; index < imgaeUrls.count; index ++ ){
        if(index < self.imageViews.count){
            SLTaskImageView *subImageView = self.imageViews[index];
            NSString *imageUrl = imgaeUrls[index];
            if(imageUrl.length > 0){
                [subImageView setImageWithURL:imageUrl];
            }
        }
    }
    
    CGFloat subImageViewMargin = 5.0;
    CGFloat subImageView_W = ([UIScreen mainScreen].bounds.size.width - 80.0) / 3;
    if(self.imgaeUrls.count == 1){
        subImageView_W = subImageView_W * 2 + subImageViewMargin;
    }
    
    CGFloat subImageView_H = subImageView_W;
    
    for(NSInteger index = 0; index < self.imageViews.count; index ++){
        SLTaskImageView *subImageView = self.imageViews[index];
        subImageView.hidden = index >= self.imgaeUrls.count;
        if(index < self.imgaeUrls.count){
            CGFloat subImageView_X = 0;
            CGFloat subImageView_Y = 0;
            if(self.imgaeUrls.count == 4){
                subImageView_X = (index % 2) * (subImageView_W + subImageViewMargin);
                subImageView_Y = (index / 2) * (subImageView_H + subImageViewMargin);
            }else{
                subImageView_X = (index % 3) * (subImageView_W + subImageViewMargin);
                subImageView_Y = (index / 3) * (subImageView_H + subImageViewMargin);
            }
            
            subImageView.frame = CGRectMake(subImageView_X, subImageView_Y, subImageView_W, subImageView_H);
        }
    }
}

- (void)imageViewTap:(UITapGestureRecognizer *)tapGestureRecognizer{
    NSMutableArray *tempArray = [NSMutableArray array];
    for(NSInteger index = 0; index < self.imgaeUrls.count; index ++ ){
        NSString *url = self.imgaeUrls[index];
        if(index < self.imageViews.count && url.length > 0){
            MJPhoto *photo = [[MJPhoto alloc] init];
            // 处理大图的url
            photo.url = [NSURL URLWithString:SLHTTPServerLargeImageURL(url)];
            photo.srcImageView = self.imageViews[index];
            photo.index = (int)index;
            [tempArray addObject:photo];
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kSLFriendCircleStatusImageDidClickNotification object:self userInfo:@{@"kImageIndex" : @(tapGestureRecognizer.view.tag)}];
    NSInteger currentIndex = tapGestureRecognizer.view.tag;
    if(tempArray.count > 0){
        if(currentIndex > tempArray.count - 1){
            currentIndex = 0;
        }
        MJPhotoBrowser *photoBrowser = [[MJPhotoBrowser alloc] init];
        photoBrowser.photos = [tempArray copy];
        photoBrowser.currentPhotoIndex = currentIndex;
        [photoBrowser show];
    }
}

@end
