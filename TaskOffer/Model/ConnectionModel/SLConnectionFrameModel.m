//
//  SLConnectionFrameModel.m
//  TaskOffer
//
//  Created by wshaolin on 15/3/19.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLConnectionFrameModel.h"
#import "NSString+Conveniently.h"

@implementation SLConnectionFrameModel

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
    CGFloat screen_W = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat margin = 10.0;
    
    CGFloat image_W = 40.0;
    CGFloat image_H = image_W;
    CGFloat image_X = margin;
    CGFloat image_Y = margin;
    _iconFrame = CGRectMake(image_X, image_Y, image_W, image_H);
    
    // CGFloat caseCount_W = 65.0;
    CGFloat caseCount_W = 0.0;
    CGFloat caseCount_H = 18.0;
    CGFloat caseCount_X = screen_W - caseCount_W;
    CGFloat caseCount_Y = image_Y;
    _caseCountFrame = CGRectMake(caseCount_X, caseCount_Y, caseCount_W, caseCount_H);
    
    CGFloat authenticationFlag_W = 0;
    if(self.connectionModel.isAuthenticated){
        authenticationFlag_W = 65.0;
    }
    CGFloat authenticationFlag_H = 12.0;
    
    CGFloat sex_H = 16.0;
    CGFloat sex_W = 0;
    if(self.connectionModel.sex != SLConnectionModelSexUnknown){
        //sex_W = sex_H;
    }
    
    CGFloat displayName_H = 20.0;
    CGFloat displayName_X = CGRectGetMaxX(_iconFrame) + margin;
    CGFloat displayName_W = screen_W - displayName_X - margin * 2 - caseCount_W - sex_W;
    CGFloat displayName_Y = image_Y;
    displayName_W = [self.connectionModel.displayName sizeWithFont:[UIFont boldSystemFontOfSize:16.0] limitSize:CGSizeMake(displayName_W, displayName_H)].width;
    _displayNameFrame = CGRectMake(displayName_X, displayName_Y, displayName_W, displayName_H);
    
    CGFloat sex_Y = displayName_Y + (displayName_H - sex_H) * 0.5;
    CGFloat sex_X = CGRectGetMaxX(_displayNameFrame) + margin * 0.5;
    _sexFrame = CGRectMake(sex_X, sex_Y, sex_W, sex_H);
    
    CGFloat authenticationFlag_X = CGRectGetMaxX(_sexFrame);
    CGFloat authenticationFlag_Y = displayName_Y + (displayName_H - authenticationFlag_H) * 0.5;
    _authenticationFrame = CGRectMake(authenticationFlag_X, authenticationFlag_Y, authenticationFlag_W, authenticationFlag_H);
    
    CGFloat companyAndJob_X = displayName_X;
    CGFloat companyAndJob_Y = CGRectGetMaxY(_displayNameFrame);
    CGFloat companyAndJob_H = image_H - displayName_H;
    CGFloat companyAndJob_W = screen_W - companyAndJob_X - margin;
    _companyAndJobFrame = CGRectMake(companyAndJob_X, companyAndJob_Y, companyAndJob_W, companyAndJob_H);
    
    CGFloat TAG_MAX_WIDTH = screen_W - margin * 2;
    
    CGFloat tag1_X = image_X;
    CGFloat tag1_Y = CGRectGetMaxY(_iconFrame) + margin;
    CGFloat tag1_H = 20.0;
    CGFloat tag1_W = 0;
    if(self.connectionModel.tag1.length > 0){
        tag1_W = [self.connectionModel.tag1 sizeWithFont:[UIFont systemFontOfSize:14.0] limitSize:CGSizeMake(TAG_MAX_WIDTH, tag1_H)].width + margin;
    }
    _tag1Frame = CGRectMake(tag1_X, tag1_Y, tag1_W, tag1_H);
    
    CGFloat tag2_Y = tag1_Y;
    CGFloat tag2_H = tag1_H;
    CGFloat tag2_W = 0;
    if(self.connectionModel.tag2.length > 0){
        tag2_W = [self.connectionModel.tag2 sizeWithFont:[UIFont systemFontOfSize:14.0] limitSize:CGSizeMake(TAG_MAX_WIDTH, tag2_H)].width + margin;
    }
    CGFloat tag2_X = CGRectGetMaxX(_tag1Frame) + margin;
    if(self.connectionModel.tag1.length == 0){
        tag2_X -= margin;
    }
    
    if(tag2_X + tag2_W > screen_W - margin){
        tag2_X = margin;
        tag2_Y = CGRectGetMaxY(_tag1Frame) + margin * 0.5;
    }
    
    _tag2Frame = CGRectMake(tag2_X, tag2_Y, tag2_W, tag2_H);
    
    CGFloat tag3_Y = tag1_Y;
    CGFloat tag3_H = tag1_H;
    CGFloat tag3_W = 0;
    if(self.connectionModel.tag3.length > 0){
        tag3_W = [self.connectionModel.tag3 sizeWithFont:[UIFont systemFontOfSize:14.0] limitSize:CGSizeMake(TAG_MAX_WIDTH, tag3_H)].width + margin;
    }
    CGFloat tag3_X = CGRectGetMaxX(_tag2Frame) + margin;
    if(self.connectionModel.tag2.length == 0){
        tag3_X -= margin;
    }
    
    if(tag3_X + tag3_W > screen_W - margin){
        tag3_X = margin;
        tag3_Y = CGRectGetMaxY(_tag2Frame) + margin * 0.5;
    }
    
    _tag3Frame = CGRectMake(tag3_X, tag3_Y, tag3_W, tag3_H);
    
    CGFloat introduction_X = margin;
    CGFloat introduction_Y = CGRectGetMaxY(_tag3Frame) + margin;
    if(self.connectionModel.tag1.length == 0){
        introduction_Y = CGRectGetMaxY(_iconFrame) + margin;
    }
    CGFloat introduction_W = screen_W - margin * 2;
    CGFloat introduction_H = 0;
    if(self.connectionModel.introduction != nil && self.connectionModel.introduction.length > 0){
        //introduction_H = [self.connectionModel.introduction sizeWithFont:[UIFont systemFontOfSize:13.0] limitSize:CGSizeMake(introduction_W, 40.0)].height;
    }
    _introductionFrame = CGRectMake(introduction_X, introduction_Y, introduction_W, introduction_H);
    
    _cellRowHeight = CGRectGetMaxY(_introductionFrame);
    if(introduction_H > 0){
        _cellRowHeight += margin;
    }
}

@end
