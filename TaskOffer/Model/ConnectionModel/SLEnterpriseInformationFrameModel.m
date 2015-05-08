//
//  SLEnterpriseInformationFrameModel.m
//  TaskOffer
//
//  Created by wshaolin on 15/3/20.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLEnterpriseInformationFrameModel.h"
#import "NSString+Conveniently.h"
#import "NSString+Conveniently.h"

@implementation SLEnterpriseInformationFrameModel

+ (instancetype)modelWithEIModel:(SLEnterpriseInformationModel *)eiModel{
    return [[self alloc] initWithEIModel:eiModel];
}

- (instancetype)initWithEIModel:(SLEnterpriseInformationModel *)eiModel{
    if(self = [super init]){
        _eiModel = eiModel;
        [self calculateFrame];
    }
    return self;
}

- (void)calculateFrame{
    CGFloat margin = 10.0;
    CGFloat screen_W = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat staffSize_H = 25.0;
    
    CGFloat department_X = margin;
    CGFloat department_Y = margin * 0.5;
    CGFloat department_H = staffSize_H;
    CGFloat department_W = screen_W - margin * 2;
    _departmentFrame = CGRectMake(department_X, department_Y, department_W, department_H);
    
    CGFloat staffSize_X = margin;
    CGFloat staffSize_Y = CGRectGetMaxY(_departmentFrame);
    CGFloat staffSize_W = department_W;
    _staffSizeFrame = CGRectMake(staffSize_X, staffSize_Y, staffSize_W, staffSize_H);
    
    CGFloat address_X = department_X;
    CGFloat address_H = staffSize_H;
    CGFloat address_W = screen_W - margin * 2;
    CGFloat address_Y = CGRectGetMaxY(_staffSizeFrame);
    if(self.eiModel.address.length > 0){
        address_H = [self.eiModel.address sizeWithFont:[UIFont systemFontOfSize:15.0] limitSize:CGSizeMake(address_W, MAXFLOAT)].height;
        if(address_H < staffSize_H){
            address_H = staffSize_H;
        }
    }
    _addressFrame = CGRectMake(address_X, address_Y, address_W, address_H);
    
    CGFloat introduction_X = address_X;
    CGFloat introduction_W = address_W;
    CGFloat introduction_Y = CGRectGetMaxY(_addressFrame);
    CGFloat introduction_H = 0;
    if(self.eiModel.introduction.length > 0){
        introduction_H = [self.eiModel.introduction sizeWithFont:[UIFont systemFontOfSize:15.0] limitSize:CGSizeMake(introduction_W, MAXFLOAT)].height;
    }
    _introductionFrame = CGRectMake(introduction_X, introduction_Y, introduction_W, introduction_H);
    
    _cellRowHeight = CGRectGetMaxY(_introductionFrame) + margin * 0.5;
    if(self.eiModel.introduction.length > 0){
        _cellRowHeight += margin * 0.5;
    }
}

@end
