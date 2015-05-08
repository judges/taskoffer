//
//  SDWebImageManager+MJPhotoBrowser.m
//  XMPPIM
//
//  Created by wshaolin on 14/12/31.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import "SDWebImageManager+MJPhotoBrowser.h"

@implementation SDWebImageManager (MJPhotoBrowser)

+ (void)downloadWithURL:(NSURL *)url{
    // completed不能为空
    [[self sharedManager] downloadImageWithURL:url options:SDWebImageLowPriority|SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        
    }];
}

@end
