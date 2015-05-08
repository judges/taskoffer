//
//  SLSelectImageButton.h
//  TaskOffer
//
//  Created by wshaolin on 15/3/23.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SLSelectImageButton;

@protocol SLSelectImageButtonDelegate <NSObject>

@optional
- (void)selectImageButtonDidClickAddImageButton:(SLSelectImageButton *)selectImageButton;
- (void)selectImageButtonDidClickCancelImageButton:(SLSelectImageButton *)selectImageButton;

@end

@interface SLSelectImageButton : UIView

@property (nonatomic, weak) id<SLSelectImageButtonDelegate> delegate;
@property (nonatomic, strong) id imageOrURL; // UIImage对象或者图片的URL

- (void)setButtonNormalImage:(NSString *)normalImageName highlightedImage:(NSString *)highlightedImageName;

@end
