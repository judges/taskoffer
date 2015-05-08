//
//  SLSelectImageButton.m
//  TaskOffer
//
//  Created by wshaolin on 15/3/23.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLSelectImageButton.h"
#import "UIButton+URL.h"
#import "HexColor.h"

@interface SLSelectImageButton()

@property (nonatomic, strong) UIButton *addImageButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UILabel *addDescLabel;

@end

@implementation SLSelectImageButton

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self addSubview:self.addImageButton];
        [self addSubview:self.cancelButton];
        [self addSubview:self.addDescLabel];
    }
    return self;
}

- (UIButton *)addImageButton{
    if(_addImageButton == nil){
        _addImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addImageButton addTarget:self action:@selector(didClickAddImageButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addImageButton;
}

- (UIButton *)cancelButton{
    if(_cancelButton == nil){
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setImage:[UIImage imageNamed:@"删除"] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(didClickCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UILabel *)addDescLabel{
    if(_addDescLabel == nil){
        _addDescLabel = [[UILabel alloc] init];
        _addDescLabel.textAlignment = NSTextAlignmentCenter;
        _addDescLabel.textColor = [UIColor darkGrayColor];
        _addDescLabel.font = [UIFont systemFontOfSize:14.0];
        _addDescLabel.text = @"添加图片";
    }
    return _addDescLabel;
}

- (void)setFrame:(CGRect)frame{
    frame.size.width = ([UIScreen mainScreen].bounds.size.width - 10.0 * 5) / 4;
    frame.size.height = frame.size.width + 25.0;
    [super setFrame:frame];
}

- (void)setImageOrURL:(id)imageOrURL{
    _imageOrURL = imageOrURL;
    if(imageOrURL != nil){
        if([imageOrURL isKindOfClass:[UIImage class]]){
            [self.addImageButton setImage:(UIImage *)imageOrURL];
        }else if([imageOrURL isKindOfClass:[NSString class]]){
            [self.addImageButton setImageWithURL:(NSString *)imageOrURL];
        }
        
        _addImageButton.backgroundColor = [UIColor colorWithHexString:kDefaultGrayColor];
        [self.addImageButton setBackgroundImage:nil forState:UIControlStateNormal];
        [self.addImageButton setBackgroundImage:nil forState:UIControlStateHighlighted];
        
        self.cancelButton.hidden = NO;
        self.addDescLabel.hidden = YES;
    }
}

- (void)setButtonNormalImage:(NSString *)normalImageName highlightedImage:(NSString *)highlightedImageName{
    [self.addImageButton setImage:nil forState:UIControlStateNormal];
    _addImageButton.backgroundColor = [UIColor clearColor];
    
    [self.addImageButton setBackgroundImage:[UIImage imageNamed:normalImageName] forState:UIControlStateNormal];
    [self.addImageButton setBackgroundImage:[UIImage imageNamed:highlightedImageName] forState:UIControlStateHighlighted];
    
    self.cancelButton.hidden = YES;
    self.addDescLabel.hidden = NO;
    self.imageOrURL = nil;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat addImageButton_H = self.bounds.size.width;
    CGFloat addImageButton_W = addImageButton_H;
    CGFloat addImageButton_X = 0;
    CGFloat addImageButton_Y = 0;
    self.addImageButton.frame = CGRectMake(addImageButton_X, addImageButton_Y, addImageButton_W, addImageButton_H);
    
    CGFloat cancelButton_Y = CGRectGetMaxY(self.addImageButton.frame);
    CGFloat cancelButton_W = self.bounds.size.height - cancelButton_Y;
    CGFloat cancelButton_H = cancelButton_W;
    CGFloat cancelButton_X = (self.bounds.size.width - cancelButton_W) * 0.5;
    self.cancelButton.frame = CGRectMake(cancelButton_X, cancelButton_Y, cancelButton_W, cancelButton_H);
    
    CGRect addDescLabelFrame = self.addImageButton.frame;
    addDescLabelFrame.origin.y = cancelButton_Y;
    addDescLabelFrame.size.height = cancelButton_H;
    self.addDescLabel.frame = addDescLabelFrame;
}

- (void)didClickCancelButton:(UIButton *)button{
    if(self.delegate && [self.delegate respondsToSelector:@selector(selectImageButtonDidClickCancelImageButton:)]){
        [self.delegate selectImageButtonDidClickCancelImageButton:self];
    }
}

- (void)didClickAddImageButton:(UIButton *)button{
    if(self.delegate && [self.delegate respondsToSelector:@selector(selectImageButtonDidClickAddImageButton:)]){
        [self.delegate selectImageButtonDidClickAddImageButton:self];
    }
}

@end

