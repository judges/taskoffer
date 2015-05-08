//
//  SLCaseDetailFrameModel.m
//  TaskOffer
//
//  Created by wshaolin on 15/3/21.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLCaseDetailFrameModel.h"
#import "NSString+Conveniently.h"

@implementation SLCaseDetailFrameModel

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
    UIFont *font = [UIFont systemFontOfSize:14.0];
    CGFloat screen_W = [UIScreen mainScreen].bounds.size.width;
    CGFloat margin = 10.0;
    
    // CGFloat industryName_H = 20.0;
    CGFloat industryName_H = 0.0;
    CGFloat industryName_X = margin;
    CGFloat industryName_Y = margin * 0.5;
    CGFloat industryName_W = [@"行业类别：" sizeWithFont:font limitSize:CGSizeZero].width;
    _industryNameFrame = CGRectMake(industryName_X, industryName_Y, industryName_W, industryName_H);
    
    CGFloat industryValue_X = CGRectGetMaxX(_industryNameFrame);
    CGFloat industryValue_Y = industryName_Y;
    CGFloat industryValue_H = industryName_H;
    CGFloat industryValue_W = screen_W - industryValue_X - margin;
    _industryValueFrame = CGRectMake(industryValue_X, industryValue_Y, industryValue_W, industryValue_H);
    
    CGFloat projectDescName_X = industryName_X;
    // CGFloat projectDescName_H = industryName_H;
    CGFloat projectDescName_H = 20.0;
    CGFloat projectDescName_Y = CGRectGetMaxY(_industryNameFrame);
    CGFloat projectDescName_W = industryName_W;
    _projectDescNameFrame = CGRectMake(projectDescName_X, projectDescName_Y, projectDescName_W, projectDescName_H);
    
    CGFloat projectDescValue_X = CGRectGetMaxX(_projectDescNameFrame);
    CGFloat projectDescValue_Y = projectDescName_Y;
    CGFloat projectDescValue_W = industryValue_W;
    CGFloat projectDescValue_H = [self.caseDetailModel.projectDesc sizeWithFont:font limitSize:CGSizeMake(projectDescValue_W, MAXFLOAT)].height + margin;
    _projectDescValueFrame = CGRectMake(projectDescValue_X, projectDescValue_Y, projectDescValue_W, projectDescValue_H);
    
    CGFloat referencePriceName_X = projectDescName_X;
    CGFloat referencePriceName_Y = MAX(CGRectGetMaxY(_projectDescNameFrame), CGRectGetMaxY(_projectDescValueFrame));
    CGFloat referencePriceName_H = projectDescName_H;
    CGFloat referencePriceName_W = projectDescName_W;
    _referencePriceNameFrame = CGRectMake(referencePriceName_X, referencePriceName_Y, referencePriceName_W, referencePriceName_H);
    
    CGFloat referencePriceValue_X = CGRectGetMaxX(_referencePriceNameFrame);
    CGFloat referencePriceValue_Y = referencePriceName_Y;
    CGFloat referencePriceValue_H = referencePriceName_H;
    CGFloat referencePriceValue_W = industryValue_W;
    _referencePriceValueFrame = CGRectMake(referencePriceValue_X, referencePriceValue_Y, referencePriceValue_W, referencePriceValue_H);
    
    _basicInfoCellRowHeight = CGRectGetMaxY(_referencePriceNameFrame) + margin;
    
    CGFloat developmentTimeName_X = industryName_X;
    CGFloat developmentTimeName_H = projectDescName_H;
    CGFloat developmentTimeName_W = industryName_W;
    CGFloat developmentTimeName_Y = industryName_Y;
    _developmentTimeNameFrame = CGRectMake(developmentTimeName_X, developmentTimeName_Y, developmentTimeName_W, developmentTimeName_H);
    
    CGFloat developmentTimeValue_X = industryValue_X;
    CGFloat developmentTimeValue_Y = industryValue_Y;
    CGFloat developmentTimeValue_W = industryValue_W;
    CGFloat developmentTimeValue_H = developmentTimeName_H;
    _developmentTimeValueFrame = CGRectMake(developmentTimeValue_X, developmentTimeValue_Y, developmentTimeValue_W, developmentTimeValue_H);
    
    _technicalSchemeNameFrame = _projectDescNameFrame;
    _technicalSchemeNameFrame.origin.y = CGRectGetMaxY(_developmentTimeNameFrame);
    
    CGFloat technicalSchemeValue_X = CGRectGetMaxX(_technicalSchemeNameFrame);
    CGFloat technicalSchemeValue_Y = _technicalSchemeNameFrame.origin.y;
    CGFloat technicalSchemeValue_W = _developmentTimeValueFrame.size.width;
    CGFloat technicalSchemeValue_H = _technicalSchemeNameFrame.size.height;
    _technicalSchemeValueFrame = CGRectMake(technicalSchemeValue_X, technicalSchemeValue_Y, technicalSchemeValue_W, technicalSchemeValue_H);
    
    CGFloat schemeDescName_X = _developmentTimeNameFrame.origin.x;
    CGFloat schemeDescName_Y = CGRectGetMaxY(_technicalSchemeNameFrame);
    CGFloat schemeDescName_H = _technicalSchemeNameFrame.size.height;
    CGFloat schemeDescName_W = _technicalSchemeNameFrame.size.width;
    _schemeDescNameFrame = CGRectMake(schemeDescName_X, schemeDescName_Y, schemeDescName_W, schemeDescName_H);
    
    CGFloat schemeDescValue_X = CGRectGetMaxX(_schemeDescNameFrame);
    CGFloat schemeDescValue_Y = schemeDescName_Y;
    CGFloat schemeDescValue_W = technicalSchemeValue_W;
    CGFloat schemeDescValue_H = 0;
    if(self.caseDetailModel.schemeDesc.length > 0){
        schemeDescValue_H = [self.caseDetailModel.schemeDesc sizeWithFont:font limitSize:CGSizeMake(schemeDescValue_W, MAXFLOAT)].height;
        if(schemeDescValue_H < schemeDescName_H){
            schemeDescValue_H = schemeDescName_H;
        }else{
            schemeDescValue_H += schemeDescName_H - font.lineHeight;
        }
    }
    _schemeDescValueFrame = CGRectMake(schemeDescValue_X, schemeDescValue_Y, schemeDescValue_W, schemeDescValue_H);
    
    _technicalInfoCellRowHeight = MAX(CGRectGetMaxY(_schemeDescNameFrame), CGRectGetMaxY(_schemeDescValueFrame)) + margin;
    
    _tagFrameModel = [[SLTagFrameModel alloc] initWithTags:self.caseDetailModel.tags];
    _tagsCellRowHeight = _tagFrameModel.tagViewHeight;
    if(_tagsCellRowHeight < 40.0){
        _tagsCellRowHeight = 40.0;
    }
    _downloadInfoCellRowHeight = 50.0;
    _designSchemeCellRowHeight = 110.0;
}

@end
