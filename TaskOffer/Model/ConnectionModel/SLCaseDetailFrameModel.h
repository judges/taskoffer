//
//  SLCaseDetailFrameModel.h
//  TaskOffer
//
//  Created by wshaolin on 15/3/21.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLCaseDetailModel.h"
#import "SLTagFrameModel.h"

@interface SLCaseDetailFrameModel : NSObject

@property (nonatomic, strong, readonly) SLCaseDetailModel *caseDetailModel;
@property (nonatomic, strong, readonly) SLTagFrameModel *tagFrameModel;

@property (nonatomic, assign, readonly) CGRect industryNameFrame;
@property (nonatomic, assign, readonly) CGRect industryValueFrame;
@property (nonatomic, assign, readonly) CGRect projectDescNameFrame;
@property (nonatomic, assign, readonly) CGRect projectDescValueFrame;
@property (nonatomic, assign, readonly) CGRect referencePriceNameFrame;
@property (nonatomic, assign, readonly) CGRect referencePriceValueFrame;

@property (nonatomic, assign, readonly) CGRect developmentTimeNameFrame;
@property (nonatomic, assign, readonly) CGRect developmentTimeValueFrame;
@property (nonatomic, assign, readonly) CGRect technicalSchemeNameFrame;
@property (nonatomic, assign, readonly) CGRect technicalSchemeValueFrame;
@property (nonatomic, assign, readonly) CGRect schemeDescNameFrame;
@property (nonatomic, assign, readonly) CGRect schemeDescValueFrame;

@property (nonatomic, assign, readonly) CGFloat tagsCellRowHeight;
@property (nonatomic, assign, readonly) CGFloat basicInfoCellRowHeight;
@property (nonatomic, assign, readonly) CGFloat technicalInfoCellRowHeight;
@property (nonatomic, assign, readonly) CGFloat downloadInfoCellRowHeight;
@property (nonatomic, assign, readonly) CGFloat designSchemeCellRowHeight;

+ (instancetype)modelWithCaseDetailModel:(SLCaseDetailModel *)caseDetailModel;
- (instancetype)initWithCaseDetailModel:(SLCaseDetailModel *)caseDetailModel;

@end