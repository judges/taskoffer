//
//  SLConnectionButton.m
//  TaskOffer
//
//  Created by wshaolin on 15/4/21.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLConnectionButton.h"
#import "HexColor.h"

@implementation SLConnectionButton

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self _init];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        [self _init];
    }
    return self;
}

- (void)_init{
    self.fontSize = 18.0;
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.75] forState:UIControlStateHighlighted];
    self.backgroundColor = [UIColor colorWithHexString:kDefaultOrgangeColor];
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 6.0;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    [self setTitle:title forState:UIControlStateNormal];
}

- (void)setFontSize:(NSInteger)fontSize{
    _fontSize = fontSize;
    self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
}

- (void)addTarget:(id)target action:(SEL)action{
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    
    if(highlighted){
        self.alpha = 0.75;
    }else{
        self.alpha = 1.0;
    }
}

@end
