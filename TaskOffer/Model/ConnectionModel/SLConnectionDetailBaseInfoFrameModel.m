//
//  SLConnectionDetailBaseInfoFrameModel.m
//  TaskOffer
//
//  Created by wshaolin on 15/4/21.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLConnectionDetailBaseInfoFrameModel.h"
#import "NSString+Conveniently.h"

@implementation SLConnectionDetailBaseInfoFrameModel

+ (instancetype)modelWithConnectionModel:(SLConnectionModel *)connectionModel{
    return [[self alloc] initWithConnectionModel:connectionModel];
}

- (instancetype)initWithConnectionModel:(SLConnectionModel *)connectionModel{
    if(self = [super init]){
        _connectionModel = connectionModel;
        [self calculateFrame];
    }
    return self;
}

- (void)calculateFrame{
    CGFloat margin = 10.0;
    CGFloat screen_W = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat image_W = 60.0;
    CGFloat image_H = image_W;
    CGFloat image_X = margin;
    CGFloat image_Y = margin;
    _iconImageFrame = CGRectMake(image_X, image_Y, image_W, image_H);
    
    CGFloat sex_H = 16.0;
    CGFloat sex_W = 0.0;
    if(self.connectionModel.sex != SLConnectionModelSexUnknown){
        //sex_W = sex_H;
    }
    
    CGFloat authenticationFlag_W = 0;
    if(self.connectionModel.isAuthenticated){
        authenticationFlag_W = 65.0;
    }
    
    CGFloat displayName_H = 20.0;
    CGFloat displayName_X = CGRectGetMaxX(_iconImageFrame) + margin;
    CGFloat displayName_W = screen_W - displayName_X - authenticationFlag_W - sex_W - margin * 3;
    displayName_W = [self.connectionModel.displayName sizeWithFont:[UIFont boldSystemFontOfSize:16.0] limitSize:CGSizeMake(displayName_W, displayName_H)].width;
    CGFloat displayName_Y = image_Y;
    _displayNameFrame = CGRectMake(displayName_X, displayName_Y, displayName_W, displayName_H);
    
    CGFloat sex_X = CGRectGetMaxX(_displayNameFrame) + margin * 0.5;
    CGFloat sex_Y = displayName_Y + (displayName_H - sex_H) * 0.5;
    _sexFrame = CGRectMake(sex_X, sex_Y, sex_W, sex_H);
    
    CGFloat authenticationFlag_H = displayName_H;
    CGFloat authenticationFlag_X = CGRectGetMaxX(_sexFrame);
    CGFloat authenticationFlag_Y = displayName_Y;
    _authenticationFrame = CGRectMake(authenticationFlag_X, authenticationFlag_Y, authenticationFlag_W, authenticationFlag_H);
    
    CGFloat companyAndJob_X = displayName_X;
    CGFloat companyAndJob_H = displayName_H;
    CGFloat companyAndJob_Y = CGRectGetMaxY(_displayNameFrame);
    CGFloat companyAndJob_W = screen_W - companyAndJob_X - margin;
    _companyAndJobFrame = CGRectMake(companyAndJob_X, companyAndJob_Y, companyAndJob_W, companyAndJob_H);
    
    CGFloat email_X = companyAndJob_X;
    CGFloat email_Y = CGRectGetMaxY(_companyAndJobFrame);
    CGFloat email_H = companyAndJob_H;
    CGFloat email_W = companyAndJob_W;
    _emailFrame = CGRectMake(email_X, email_Y, email_W, email_H);
    
    CGFloat introduction_X = image_X;
    CGFloat introduction_Y = CGRectGetMaxY(_iconImageFrame) + margin;
    CGFloat introduction_W = screen_W - margin * 2;
    CGFloat introduction_H = 0;
    if(self.connectionModel.introduction.length > 0){
        introduction_H = [self.connectionModel.introduction sizeWithFont:[UIFont systemFontOfSize:15.0] limitSize:CGSizeMake(introduction_W, MAXFLOAT)].height;
    }
    _introductionFrame = CGRectMake(introduction_X, introduction_Y, introduction_W, introduction_H);
    
    if(self.connectionModel.introduction.length == 0){
        _cellRowHeight = introduction_Y;
    }else{
        _cellRowHeight = CGRectGetMaxY(_introductionFrame) + margin;
    }
}

@end
