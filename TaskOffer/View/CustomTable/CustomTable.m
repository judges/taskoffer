//
//  CustomTable.m
//  TaskOffer
//
//  Created by BourbonZ on 15/5/6.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "CustomTable.h"

@implementation CustomTable

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)layoutSubviews
{
    [super layoutSubviews];
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        [self setSeparatorInset:UIEdgeInsetsMake(0,10,0,0)];
    }
    
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        [self setLayoutMargins:UIEdgeInsetsMake(0,10,0,0)];
    }

}
@end
