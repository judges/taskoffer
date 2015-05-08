//
//  SLTextView.m
//  XMPPIM
//
//  Created by wshaolin on 14/12/19.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import "SLTextView.h"

@interface SLTextView()

@property (nonatomic, strong) UILabel *placeholderLabel;

@end

@implementation SLTextView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder{
    if(self = [super initWithCoder:coder]){
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews{
    self.backgroundColor = [UIColor whiteColor];
    
    self.font = [UIFont systemFontOfSize:16.0];
    self.textColor = [UIColor blackColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewValueDidChange) name:UITextViewTextDidChangeNotification object:self];
    
    [self insertSubview:self.placeholderLabel atIndex:0]; // 保证光标在文字的上面
    
    self.placeholderOffset = CGPointMake(5.0, 5.0);
    self.placeholderPosition = SLTextViewPlaceholderPositionTop;
}

- (UILabel *)placeholderLabel{
    if(_placeholderLabel == nil){
        _placeholderLabel = [[UILabel alloc] init];
        _placeholderLabel.numberOfLines = 0;
        _placeholderLabel.textColor = [UIColor colorWithRed:200.0 / 255.0 green:200.0 / 255.0 blue:200.0 / 255.0 alpha:1.0];
    }
    return _placeholderLabel;
}

- (void)setPlaceholderOffset:(CGPoint)placeholderOffset{
    _placeholderOffset = placeholderOffset;
    [self calculatePlaceholderFrame];
}

- (void)setFont:(UIFont *)font{
    self.placeholderLabel.font = font;
    [super setFont:font];
}

- (void)setPlaceholder:(NSString *)placeholder{
    _placeholder = [placeholder copy];
    self.placeholderLabel.text = placeholder;
    self.placeholderLabel.hidden = (placeholder.length == 0 || self.text.length != 0);

    [self calculatePlaceholderFrame];
}

- (void)textViewValueDidChange{
    self.placeholderLabel.hidden = (self.text.length != 0);
}

- (void)setText:(NSString *)text{
    [super setText:text];
    self.placeholderLabel.hidden = (text != nil && text.length > 0);
}

- (CGFloat)placeholderTextHeightWithLimitSize:(CGSize)size{
    return [self.placeholderLabel.text boundingRectWithSize:CGSizeMake(size.width, size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.placeholderLabel.font} context:nil].size.height;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self calculatePlaceholderFrame];
}

- (void)calculatePlaceholderFrame{
    CGFloat placeholderLabelX = self.placeholderOffset.x;
    CGFloat placeholderLabelW = self.bounds.size.width - placeholderLabelX * 2;
    CGFloat placeholderLabelH = [self.placeholderLabel.text boundingRectWithSize:CGSizeMake(placeholderLabelW, self.bounds.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.placeholderLabel.font} context:nil].size.height;
    CGFloat placeholderLabelY = 0;
    switch (self.placeholderPosition) {
        case SLTextViewPlaceholderPositionTop:
            placeholderLabelY = self.placeholderOffset.y;
            break;
        case SLTextViewPlaceholderPositionMiddle:
            placeholderLabelY = (self.bounds.size.height - placeholderLabelH) * 0.5;
            break;
        case SLTextViewPlaceholderPositionBottom:
            placeholderLabelY = self.bounds.size.height - placeholderLabelH;
            break;
        default:
            break;
    }
    
    self.placeholderLabel.frame = CGRectMake(placeholderLabelX, placeholderLabelY, placeholderLabelW, placeholderLabelH);
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
