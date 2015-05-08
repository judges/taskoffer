//
//  UIImageView+SetImage.h
//  AppFramework
//
//  Created by wshaolin on 14/11/24.
//  Copyright (c) 2014年 wshaolin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (SetImage)

- (void)setImageWithURL:(NSString *)url;
- (void)setImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholder;

@end
