//
//  ProjectTagView.m
//  TaskOffer
//
//  Created by BourbonZ on 15/3/19.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "ProjectTagView.h"

@implementation ProjectTagView
@synthesize enterpriseTagLabel1;
@synthesize enterpriseTagLabel2;
@synthesize enterpriseTagLabel3;
@synthesize enterpriseTagLabel4;
@synthesize enterpriseTagLabel5;
@synthesize tagArray = _tagArray;
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
        ///标签
        enterpriseTagLabel1 = [[UILabel alloc] init];
        [enterpriseTagLabel1 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"标签背景"]]];
        [enterpriseTagLabel1 setTextAlignment:NSTextAlignmentCenter];
        [enterpriseTagLabel1 setTextColor:[UIColor whiteColor]];
        [enterpriseTagLabel1 setFont:[UIFont systemFontOfSize:14.0f]];
        [enterpriseTagLabel1 setTag:5000];
        [enterpriseTagLabel1 setHidden:YES];
        enterpriseTagLabel1.numberOfLines = 1;
        enterpriseTagLabel1.layer.masksToBounds = YES;
        enterpriseTagLabel1.layer.cornerRadius = 3.0f;
        enterpriseTagLabel1.adjustsFontSizeToFitWidth = YES;
        [self addSubview:enterpriseTagLabel1];
        
        enterpriseTagLabel2 = [[UILabel alloc] init];
        [enterpriseTagLabel2 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"标签背景"]]];
        [enterpriseTagLabel2 setTextAlignment:NSTextAlignmentCenter];
        [enterpriseTagLabel2 setTextColor:[UIColor whiteColor]];
        [enterpriseTagLabel2 setFont:[UIFont systemFontOfSize:14.0f]];
        [enterpriseTagLabel2 setTag:5001];
        [enterpriseTagLabel2 setHidden:YES];
        enterpriseTagLabel2.numberOfLines = 1;
        enterpriseTagLabel2.layer.masksToBounds = YES;
        enterpriseTagLabel2.layer.cornerRadius =  3.0f;
        enterpriseTagLabel2.adjustsFontSizeToFitWidth = YES;
        [self addSubview:enterpriseTagLabel2];
        
        enterpriseTagLabel3 = [[UILabel alloc] init];
        [enterpriseTagLabel3 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"标签背景"]]];
        [enterpriseTagLabel3 setTextAlignment:NSTextAlignmentCenter];
        [enterpriseTagLabel3 setTextColor:[UIColor whiteColor]];
        [enterpriseTagLabel3 setFont:[UIFont systemFontOfSize:14.0f]];
        [enterpriseTagLabel3 setTag:5002];
        [enterpriseTagLabel3 setHidden:YES];
        enterpriseTagLabel3.numberOfLines = 1;
        enterpriseTagLabel3.layer.masksToBounds = YES;
        enterpriseTagLabel3.layer.cornerRadius = 3.0f;
        enterpriseTagLabel3.adjustsFontSizeToFitWidth = YES;
        [self addSubview:enterpriseTagLabel3];
        
        enterpriseTagLabel4 = [[UILabel alloc] init];
        [enterpriseTagLabel4 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"标签背景"]]];
        [enterpriseTagLabel4 setTextAlignment:NSTextAlignmentCenter];
        [enterpriseTagLabel4 setTextColor:[UIColor whiteColor]];
        [enterpriseTagLabel4 setFont:[UIFont systemFontOfSize:14.0f]];
        [enterpriseTagLabel4 setTag:5003];
        [enterpriseTagLabel4 setHidden:YES];
        enterpriseTagLabel4.numberOfLines = 1;
        enterpriseTagLabel4.layer.masksToBounds = YES;
        enterpriseTagLabel4.layer.cornerRadius = 3.0f;
        enterpriseTagLabel4.adjustsFontSizeToFitWidth = YES;
        [self addSubview:enterpriseTagLabel4];
        
        enterpriseTagLabel5 = [[UILabel alloc] init];
        [enterpriseTagLabel5 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"标签背景"]]];
        [enterpriseTagLabel5 setTextAlignment:NSTextAlignmentCenter];
        [enterpriseTagLabel5 setTextColor:[UIColor whiteColor]];
        [enterpriseTagLabel5 setFont:[UIFont systemFontOfSize:14.0f]];
        [enterpriseTagLabel5 setTag:5004];
        [enterpriseTagLabel5 setHidden:YES];
        enterpriseTagLabel5.numberOfLines = 1;
        enterpriseTagLabel5.layer.masksToBounds = YES;
        enterpriseTagLabel5.layer.cornerRadius = 3.0f;
        enterpriseTagLabel5.adjustsFontSizeToFitWidth = YES;
        [self addSubview:enterpriseTagLabel5];

    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat tagWidth = (self.frame.size.width-60)/5;
    [enterpriseTagLabel1 setFrame:CGRectMake(10*1 + tagWidth * 0, 5, tagWidth, 20)];
    [enterpriseTagLabel2 setFrame:CGRectMake(10*2 + tagWidth * 1, 5, tagWidth, 20)];
    [enterpriseTagLabel3 setFrame:CGRectMake(10*3 + tagWidth * 2, 5, tagWidth, 20)];
    [enterpriseTagLabel4 setFrame:CGRectMake(10*4 + tagWidth * 3, 5, tagWidth, 20)];
    [enterpriseTagLabel5 setFrame:CGRectMake(10*5 + tagWidth * 4, 5, tagWidth, 20)];
}
-(void)setTagArray:(NSArray *)tagArray
{
    for (int i = 0; i < tagArray.count; i++)
    {
        UILabel *enterpriseTagLabel = (UILabel *)[self viewWithTag:5000+i];
        [enterpriseTagLabel setHidden:NO];
        [enterpriseTagLabel setText:[tagArray objectAtIndex:i]];
    }

}
@end
