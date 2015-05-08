//
//  UIImage+Conveniently.m
//  AppFramework
//
//  Created by wshaolin on 14/11/21.
//  Copyright (c) 2014年 wshaolin. All rights reserved.
//

#import "UIImage+Conveniently.h"

@implementation UIImage (Conveniently)

@end

@implementation UIImage (Resizable)

+ (UIImage *)resizableImageWithName:(NSString *)name{
    return [self resizableImageWithName:name left:0.5 top:0.5];
}

+ (UIImage *)resizableImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top{
    UIImage *image = [UIImage imageNamed:name];
    if(image != nil){
        CGFloat w = image.size.width * left;
        CGFloat h = image.size.height * top;
        return [image resizableImageWithCapInsets:UIEdgeInsetsMake(h, w, h, w) resizingMode:UIImageResizingModeStretch];
    }
    return nil;
}

@end

@implementation UIImage (Size)

- (UIImage *)imageWithSize:(CGSize)size{
    CGFloat imageX = (self.size.width - size.width) * 0.5;
    CGFloat imageY = (self.size.height - size.height) * 0.5;
    CGRect rect = CGRectMake(imageX, imageY, size.width, size.height);
    CGImageRef image = CGImageCreateWithImageInRect(self.CGImage, rect);
    return [[UIImage alloc] initWithCGImage:image];
}

- (UIImage *)imageWithScale:(CGFloat)scale{
    CGSize size = CGSizeMake(self.size.width * scale, self.size.height * scale);
    return [self imageWithSize:size];
}

@end

@implementation UIImage (Thumbnail)

- (UIImage *)thumbnailWithScale:(CGFloat)scale{
    CGSize size = CGSizeMake(self.size.width * scale, self.size.height * scale);
    return [self thumbnailWithSize:size];
}

- (UIImage *)thumbnailWithSize:(CGSize)size{
    if(self == nil){
        return nil;
    }
    
    if(MIN(self.size.width, self.size.height) < 1.0 ||
       MIN(size.width, size.height) < 1.0 ||
       CGSizeEqualToSize(self.size, size)){
        return self;
    }
    
    CGSize oldSize = self.size;
    CGFloat width = 0;
    CGFloat height = 0;
    CGFloat x = 0;
    CGFloat y = 0;
    
    if (size.width / size.height > oldSize.width / oldSize.height) {
        width = size.height * oldSize.width / oldSize.height;
        height = size.height;
        x = (size.width - width) * 0.5;
    }else{
        width = size.width;
        height = size.width * oldSize.height / oldSize.width;
        y = (size.height - height) * 0.5;
    }
    CGRect rect = CGRectMake(x, y, width, height);
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    [self drawInRect:rect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end

@implementation UIImage (StorageSzie)

- (CGFloat)storageSize{
    NSUInteger storageLength = [UIImagePNGRepresentation(self) length];
    return (CGFloat)storageLength / 1024.0;
}

@end
