//
//  SLFriendCircleSelectedImageView.m
//  XMPPIM
//
//  Created by wshaolin on 14/12/19.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import "SLFriendCircleSelectedImageView.h"
#import "SLFriendCircleFont.h"
#import "SLSelectImageButton.h"

#define SLFriendCircleSelectedImageViewCount 9
#define SLFriendCircleSelectedImageViewAddNormalImage @"friendcircle_add_image_normal"
#define SLFriendCircleSelectedImageViewAddHighlightedImage @"friendcircle_add_image_highlighted"

@interface SLFriendCircleSelectedImageView()<SLSelectImageButtonDelegate>

@property (nonatomic, strong) NSArray *buttons;

@end

@implementation SLFriendCircleSelectedImageView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self setupImageViews];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setupImageViews{
    NSMutableArray *buttons = [NSMutableArray array];
    for(NSInteger index = 0; index < SLFriendCircleSelectedImageViewCount; index ++){
        SLSelectImageButton *button = [[SLSelectImageButton alloc] init];
        button.tag = index;
        button.hidden = index != 0;
        button.delegate = self;
        [buttons addObject:button];
        [self addSubview:button];
        
        if(index == 0){
            [button setButtonNormalImage:SLFriendCircleSelectedImageViewAddNormalImage highlightedImage:SLFriendCircleSelectedImageViewAddHighlightedImage];
       }
    }
    self.buttons = [buttons copy];
}

- (void)setSelectedImages:(NSArray *)selectedImages{
    _selectedImages = selectedImages;
    for(NSInteger index = 0; index < self.buttons.count; index ++){
        SLSelectImageButton *button = self.buttons[index];
        button.hidden = index > selectedImages.count;
        if(index < selectedImages.count){
            button.imageOrURL = selectedImages[index];
        }else  if(index == selectedImages.count){
            [button setButtonNormalImage:SLFriendCircleSelectedImageViewAddNormalImage highlightedImage:SLFriendCircleSelectedImageViewAddHighlightedImage];
        }
    }
    
    NSInteger row = (selectedImages.count + 1) / 4 + 1;
    if((selectedImages.count + 1) % 4 == 0){
        row --;
    }
    CGFloat height = 20.0 + (([UIScreen mainScreen].bounds.size.width - 5 * 10.0) / 4 + 25.0) * row;
    if(height != self.frame.size.height){
        CGRect frame = self.frame;
        frame.size.height = height;
        [self setFrame:frame];
        if(self.delegate && [self.delegate respondsToSelector:@selector(friendCircleSelectedImageView:didChangeHeight:)]){
            [self.delegate friendCircleSelectedImageView:self didChangeHeight:height];
        }
    }
}

- (void)selectImageButtonDidClickAddImageButton:(SLSelectImageButton *)selectImageButton{
    if(selectImageButton.tag == self.selectedImages.count){
        if(self.delegate && [self.delegate respondsToSelector:@selector(friendCircleSelectedImageViewDidClickAddButton:)]){
            [self.delegate friendCircleSelectedImageViewDidClickAddButton:self];
        }
    }
}

- (void)selectImageButtonDidClickCancelImageButton:(SLSelectImageButton *)selectImageButton{
    if(self.delegate && [self.delegate respondsToSelector:@selector(friendCircleSelectedImageView:didCancelImageAtIndex:)]){
        [self.delegate friendCircleSelectedImageView:self didCancelImageAtIndex:selectImageButton.tag];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat margin = 10.0;
    CGFloat imageSpacing = margin;
    CGFloat image_W = ([UIScreen mainScreen].bounds.size.width - 5 * margin) / 4;
    CGFloat image_H = image_W + 25.0;
    
    for(NSInteger index = 0; index < self.buttons.count; index ++){
        UIButton *button = self.buttons[index];
        CGFloat image_X = margin + (image_W + imageSpacing) * (index % 4);
        CGFloat image_Y = margin + image_H * (index / 4);
        button.frame = CGRectMake(image_X, image_Y, image_W, image_H);
    }
}

@end

