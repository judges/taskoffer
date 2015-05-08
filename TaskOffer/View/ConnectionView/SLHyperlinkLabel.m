//
//  SLHyperlinkLabel.m
//  TaskOffer
//
//  Created by wshaolin on 15/3/23.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLHyperlinkLabel.h"

@interface SLHyperlinkLabel()

@property (nonatomic, strong) UIColor *textNormalColor;

@end

@implementation SLHyperlinkLabel

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        self.userInteractionEnabled = YES;
        self.textNormalColor = self.textColor;
    }
    return self;
}

- (void)setText:(NSString *)text{
    if(text != nil && text.length > 0){
        _url = [NSURL URLWithString:text];
        if(_url.host != nil){
            [self setLineBreakMode:NSLineBreakByCharWrapping];
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text];
            [attributedText addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, text.length)];
            self.attributedText = attributedText;
        }
    }
    
    if(_url.host == nil){
        [super setText:text];
    }
}

- (void)setTextColor:(UIColor *)textColor{
    self.textNormalColor = textColor;
    [super setTextColor:textColor];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if(self.url.host != nil && self.textHighlightColor != nil){
        [super setTextColor:self.textHighlightColor];
    }else{
        [super touchesBegan:touches withEvent:event];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    if(self.url.host != nil && self.textHighlightColor != nil){
        [super setTextColor:self.textNormalColor];
    }else{
        [super touchesCancelled:touches withEvent:event];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if(self.url.host != nil && self.textHighlightColor != nil){
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        if (!CGRectContainsPoint(self.bounds, point)){
            [super setTextColor:self.textNormalColor];
        }
    }else{
        [super touchesMoved:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if(self.url.host != nil && self.textHighlightColor != nil){
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        [super setTextColor:self.textNormalColor];
        if (CGRectContainsPoint(self.bounds, point)){
            if(self.hyperlinkLHandler){
                self.hyperlinkLHandler(self.url);
            }
        }
    }else{
        [super touchesEnded:touches withEvent:event];
    }
}

@end
