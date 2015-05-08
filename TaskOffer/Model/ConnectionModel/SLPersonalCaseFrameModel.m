//
//  SLPersonalCaseFrameModel.m
//  TaskOffer
//
//  Created by wshaolin on 15/4/9.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLPersonalCaseFrameModel.h"
#import "NSString+Conveniently.h"

@implementation SLPersonalCaseFrameModel

+ (instancetype)modelWithCaseDetailModel:(SLCaseDetailModel *)caseDetailModel{
    return [[self alloc] initWithCaseDetailModel:caseDetailModel];
}

- (instancetype)initWithCaseDetailModel:(SLCaseDetailModel *)caseDetailModel{
    if(self = [super init]){
        _caseDetailModel = caseDetailModel;
        
        [self calculateFrame];
    }
    return self;
}

- (void)calculateFrame{
    CGFloat margin = 10.0;
    CGFloat screen_W = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat icon_X = margin;
    CGFloat icon_Y = margin;
    CGFloat icon_W = 40.0;
    CGFloat icon_H = icon_W;
    _iconFrame = CGRectMake(icon_X, icon_Y, icon_W, icon_H);
    
    CGFloat editButton_W = 40.0;
    CGFloat editButton_H = editButton_W;
    CGFloat editButton_Y = icon_Y;
    CGFloat editButton_X = screen_W - editButton_W - margin;
    _editButtonFrame = CGRectMake(editButton_X, editButton_Y, editButton_W, editButton_H);
    
    CGFloat showName_X = CGRectGetMaxX(_iconFrame) + margin;
    CGFloat showName_Y = icon_Y;
    CGFloat showName_H = icon_H;
    CGFloat showName_W = screen_W - showName_X - editButton_W - margin * 2;
    _showNameFrame = CGRectMake(showName_X, showName_Y, showName_W, showName_H);
    
    CGFloat timeName_X = icon_X;
    CGFloat timeName_Y = CGRectGetMaxY(_iconFrame) + margin;
    CGFloat timeName_H = 20.0;
    CGFloat timeName_W = 70.0;
    _developmentTimeNameFrame = CGRectMake(timeName_X, timeName_Y, timeName_W, timeName_H);
    
    CGFloat timeValue_X = CGRectGetMaxX(_developmentTimeNameFrame);
    CGFloat timeValue_Y = timeName_Y;
    CGFloat timeValue_H = timeName_H;
    CGFloat timeValue_W = screen_W - timeValue_X - editButton_W - margin * 2;
    _developmentTimeValueFrame = CGRectMake(timeValue_X, timeValue_Y, timeValue_W, timeValue_H);
    
    CGFloat priceName_X = timeName_X;
    CGFloat priceName_Y = CGRectGetMaxY(_developmentTimeValueFrame);
    CGFloat priceName_W = timeName_W;
    CGFloat priceName_H = timeName_H;
    _referencePriceNameFrame = CGRectMake(priceName_X, priceName_Y, priceName_W, priceName_H);
    
    CGFloat priceValue_X = timeValue_X;
    CGFloat priceValue_Y = priceName_Y;
    CGFloat priceValue_W = timeValue_W;
    CGFloat priceValue_H = timeValue_H;
    _referencePriceValueFrame = CGRectMake(priceValue_X, priceValue_Y, priceValue_W, priceValue_H);
    
    CGFloat schemeName_X = timeName_X;
    CGFloat schemeName_Y = CGRectGetMaxY(_referencePriceValueFrame);
    CGFloat schemeName_W = timeName_W;
    CGFloat schemeName_H = timeName_H;
    _technicalSchemeNameFrame = CGRectMake(schemeName_X, schemeName_Y, schemeName_W, schemeName_H);
    
    CGFloat schemeValue_X = timeValue_X;
    CGFloat schemeValue_Y = schemeName_Y;
    CGFloat schemeValue_W = timeValue_W;
    CGFloat schemeValue_H = timeValue_H;
    if(self.caseDetailModel.technicalScheme.length > 0){
        UIFont *font = [UIFont systemFontOfSize:14.0];
        schemeValue_H = [self.caseDetailModel.technicalScheme sizeWithFont:font limitSize:CGSizeMake(schemeValue_W, MAXFLOAT)].height;
        if(schemeValue_H < timeValue_H){
            schemeValue_H = timeValue_H;
        }else{
            schemeValue_H += timeValue_H - font.lineHeight;
        }
    }
    _technicalSchemeValueFrame = CGRectMake(schemeValue_X, schemeValue_Y, schemeValue_W, schemeValue_H);
    
    CGFloat imageView_X = priceName_X;
    CGFloat imageView_Y = CGRectGetMaxY(_technicalSchemeValueFrame) + margin;
    CGFloat imageView_W = screen_W - margin * 2;
    CGFloat imageView_H = 0;
    CGFloat imageView_M = 5.0;
    
    CGFloat image_H = ([UIScreen mainScreen].bounds.size.width - 80.0) / 3;
    NSInteger imageCount = self.caseDetailModel.designSchemeUrl.count;
    if(imageCount == 1 || imageCount == 4){
        imageView_H = image_H * 2 + imageView_M;
    }else if(imageCount > 0){
        NSInteger imageRow = (imageCount - 1) / 3 + 1;
        imageView_H = imageRow * image_H;
        if(imageRow - 1 > 0){
            imageView_H += imageView_M * (imageRow - 1);
        }
    }
    _imageViewFrame = CGRectMake(imageView_X, imageView_Y, imageView_W, imageView_H);
    
    _cellRowHeight = CGRectGetMaxY(_imageViewFrame);
    if(imageCount > 0){
        _cellRowHeight += margin;
    }
}

@end
