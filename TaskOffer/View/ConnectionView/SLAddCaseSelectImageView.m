//
//  SLAddCaseSelectImageView.m
//  TaskOffer
//
//  Created by wshaolin on 15/3/23.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLAddCaseSelectImageView.h"
#import "SLSelectImageButton.h"
#import "HexColor.h"

#define SLAddCaseSelectImageViewCount 9
#define SLAddCaseSelectImageViewAddNormalImageName @"add_image_normal"
#define SLAddCaseSelectImageViewAddHighlightedImageName @"add_image_highlighted"

@interface SLAddCaseSelectImageView()<SLSelectImageButtonDelegate>

@property (nonatomic, strong) NSArray *buttons;
@property (nonatomic, strong) UIView *topTitleView;
@property (nonatomic, strong) UILabel *topTitleLabel;
@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) UIView *middleLineView;
@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation SLAddCaseSelectImageView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self setupImageViews];
        [self addSubview:self.topLineView];
        [self addSubview:self.topTitleView];
        [self addSubview:self.middleLineView];
        [self addSubview:self.bottomLineView];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (UIView *)topTitleView{
    if(_topTitleView == nil){
        _topTitleView = [[UIView alloc] init];
        [_topTitleView addSubview:self.topTitleLabel];
        [_topTitleView addSubview:self.countLabel];
    }
    return _topTitleView;
}

- (UILabel *)topTitleLabel{
    if(_topTitleLabel == nil){
        _topTitleLabel = [[UILabel alloc] init];
        _topTitleLabel.textAlignment = NSTextAlignmentLeft;
        _topTitleLabel.textColor = [UIColor colorWithRed:43.0 / 255.0 green:82.0 / 255.0 blue:123.0 / 255.0 alpha:1.0];
        _topTitleLabel.font = [UIFont systemFontOfSize:16.0];
    }
    return _topTitleLabel;
}

- (UILabel *)countLabel{
    if(_countLabel == nil){
        _countLabel = [[UILabel alloc] init];
        _countLabel.textAlignment = NSTextAlignmentRight;
        _countLabel.textColor = [UIColor darkGrayColor];
        _countLabel.font = [UIFont systemFontOfSize:14.0];
        _countLabel.text = [NSString stringWithFormat:@"0/%ld", (long)SLAddCaseSelectImageViewCount];
    }
    return _countLabel;
}

- (UIView *)topLineView{
    if(_topLineView == nil){
        _topLineView = [[UIView alloc] init];
        //_topLineView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        _topLineView.backgroundColor = [UIColor clearColor];
    }
    return _topLineView;
}

- (UIView *)middleLineView{
    if(_middleLineView == nil){
        _middleLineView = [[UIView alloc] init];
        _middleLineView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    }
    return _middleLineView;
}

- (UIView *)bottomLineView{
    if(_bottomLineView == nil){
        _bottomLineView = [[UIView alloc] init];
        //_bottomLineView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        _bottomLineView.backgroundColor = [UIColor clearColor];
    }
    return _bottomLineView;
}

- (void)setupImageViews{
    NSMutableArray *buttons = [NSMutableArray array];
    for(NSInteger index = 0; index < SLAddCaseSelectImageViewCount; index ++){
        SLSelectImageButton *button = [[SLSelectImageButton alloc] init];
        button.delegate = self;
        button.tag = index;
        button.hidden = index != 0;
        [buttons addObject:button];
        [self addSubview:button];
        
        if(index == 0){
            [button setButtonNormalImage:SLAddCaseSelectImageViewAddNormalImageName highlightedImage:SLAddCaseSelectImageViewAddHighlightedImageName];
        }
    }
    self.buttons = [buttons copy];
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.topTitleLabel.text = title;
}

- (void)setSelectedImages:(NSArray *)selectedImages{
    _selectedImages = selectedImages;
    self.countLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)selectedImages.count, (long)SLAddCaseSelectImageViewCount];
    for(NSInteger index = 0; index < self.buttons.count; index ++){
        SLSelectImageButton *button = self.buttons[index];
        button.hidden = index > selectedImages.count;
        if(index < selectedImages.count){
            button.imageOrURL = selectedImages[index];
        }else  if(index == selectedImages.count){
            [button setButtonNormalImage:SLAddCaseSelectImageViewAddNormalImageName highlightedImage:SLAddCaseSelectImageViewAddHighlightedImageName];
        }
    }
    
    NSInteger row = (selectedImages.count + 1) / 4 + 1;
    if((selectedImages.count + 1) % 4 == 0){
        row --;
    }
    
    SLSelectImageButton *button = [self.buttons firstObject];
    CGFloat height = 55.5 + button.frame.size.height * row;
    
    if(height != self.frame.size.height){
        CGRect frame = self.frame;
        frame.size.height = height;
        [self setFrame:frame];
        if(self.delegate && [self.delegate respondsToSelector:@selector(addCaseSelectImageView:didChangeHeight:)]){
            [self.delegate addCaseSelectImageView:self didChangeHeight:height];
        }
    }
}

- (void)setFrame:(CGRect)frame{
    frame.origin.x = 0;
    frame.size.width = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat minHeight = (frame.size.width - 10.0 * 5) / 4 + 75.5;
    
    if(frame.size.height < minHeight){
        frame.size.height = minHeight;
    }
    
    [super setFrame:frame];
}

- (void)selectImageButtonDidClickAddImageButton:(SLSelectImageButton *)selectImageButton{
    if(selectImageButton.tag >= self.selectedImages.count){
        if(self.delegate && [self.delegate respondsToSelector:@selector(addCaseSelectImageViewDidClickAddButton:)]){
            [self.delegate addCaseSelectImageViewDidClickAddButton:self];
        }
    }
}

- (void)selectImageButtonDidClickCancelImageButton:(SLSelectImageButton *)selectImageButton{
    if(selectImageButton.tag < self.selectedImages.count){
        if(self.delegate && [self.delegate respondsToSelector:@selector(addCaseSelectImageView:didClickCancelButtonWithIndex:)]){
            [self.delegate addCaseSelectImageView:self didClickCancelButtonWithIndex:selectImageButton.tag];
        }
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat margin = 10.0;
    
    CGFloat topTitleView_W = self.bounds.size.width;
    CGFloat topTitleView_X = 0;
    CGFloat topTitleView_H = 35.0;
    CGFloat topTitleView_Y = 0;
    self.topTitleView.frame = CGRectMake(topTitleView_X, topTitleView_Y, topTitleView_W, topTitleView_H);
    
    CGFloat topTitleLabel_X = margin;
    CGFloat topTitleLabel_H = 20.0;
    CGFloat topTitleLabel_Y = (topTitleView_H - topTitleLabel_H) * 0.5;
    CGFloat topTitleLabel_W = (topTitleView_W - margin * 3) * 0.5;
    self.topTitleLabel.frame = CGRectMake(topTitleLabel_X, topTitleLabel_Y, topTitleLabel_W, topTitleLabel_H);
    
    CGRect countLabelFrame = self.topTitleLabel.frame;
    countLabelFrame.origin.x = CGRectGetMaxX(self.topTitleLabel.frame) + margin;
    self.countLabel.frame = countLabelFrame;
    
    CGFloat middleLineView_X = 0;
    CGFloat middleLineView_H = 0.5;
    CGFloat middleLineView_W = self.bounds.size.width;
    CGFloat middleLineView_Y = CGRectGetMaxY(self.topTitleView.frame);
    self.middleLineView.frame = CGRectMake(middleLineView_X, middleLineView_Y, middleLineView_W, middleLineView_H);
    
    for(NSInteger index = 0; index < self.buttons.count; index ++){
        SLSelectImageButton *button = self.buttons[index];
        CGFloat image_X = margin + (button.frame.size.width + margin) * (index % 4);
        CGFloat image_Y = CGRectGetMaxY(self.middleLineView.frame) + 10.0 + button.frame.size.height * (index / 4);
        button.frame = CGRectMake(image_X, image_Y, 0, 0);
    }
    
    CGRect topLineViewFrame = self.bounds;
    topLineViewFrame.size.height = 0.5;
    self.topLineView.frame = topLineViewFrame;
    
    CGRect bottomLineViewFrame = topLineViewFrame;
    bottomLineViewFrame.origin.y = self.bounds.size.height - bottomLineViewFrame.size.height;
    self.bottomLineView.frame = bottomLineViewFrame;
}

@end
