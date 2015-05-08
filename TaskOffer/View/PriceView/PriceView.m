//
//  PriceView.m
//  TaskOffer
//
//  Created by BourbonZ on 15/3/19.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "PriceView.h"
#import "HexColor.h"
#import <CoreText/CoreText.h>
@implementation PriceView
@synthesize lowPriceLabel;
@synthesize highPriceLabel;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.layer.borderColor = [[UIColor colorWithHexString:kDefaultOrgangeColor] CGColor];


        lowPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 48, 19)];
        [lowPriceLabel setBackgroundColor:[UIColor whiteColor]];
        [lowPriceLabel setTextColor:[UIColor colorWithHexString:kDefaultOrgangeColor]];
        [lowPriceLabel setTextAlignment:NSTextAlignmentCenter];
        lowPriceLabel.numberOfLines = 1;
        lowPriceLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:lowPriceLabel];
        
        highPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 29, 48, 19)];
        [highPriceLabel setBackgroundColor:[UIColor whiteColor]];
        [highPriceLabel setTextColor:[UIColor colorWithHexString:kDefaultOrgangeColor]];
        [highPriceLabel setTextAlignment:NSTextAlignmentCenter];
        highPriceLabel.numberOfLines = 1;
        highPriceLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:highPriceLabel];
            
        self.layer.borderWidth = 1.0f;
        self.layer.masksToBounds = NO;
        self.layer.cornerRadius = 29;
        [self setBounds:CGRectMake(0, 0, 58, 58)];
        
        
        ///旋转一定角度
        self.transform = CGAffineTransformMakeRotation(-15*M_PI/180);
    }
    return self;
}
@end
