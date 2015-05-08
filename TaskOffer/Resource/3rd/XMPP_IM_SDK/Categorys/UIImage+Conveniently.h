//
//  UIImage+Conveniently.h
//  AppFramework
//
//  Created by wshaolin on 14/11/21.
//  Copyright (c) 2014年 wshaolin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Conveniently)

@end

@interface UIImage (Resizable)

+ (UIImage *)resizableImageWithName:(NSString *)name;

+ (UIImage *)resizableImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top;

@end

@interface UIImage (Size)

- (UIImage *)imageWithSize:(CGSize)size;

- (UIImage *)imageWithScale:(CGFloat)scale;

@end

@interface UIImage (Thumbnail)

- (UIImage *)thumbnailWithSize:(CGSize)size;
- (UIImage *)thumbnailWithScale:(CGFloat)scale;

@end

@interface UIImage (StorageSzie)

- (CGFloat)storageSize;

@end