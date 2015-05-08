//
//  SLPersonalCaseFrameModel.h
//  TaskOffer
//
//  Created by wshaolin on 15/4/9.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLCaseDetailModel.h"

@interface SLPersonalCaseFrameModel : NSObject

@property (nonatomic, strong, readonly) SLCaseDetailModel *caseDetailModel;

@property (nonatomic, assign, readonly) CGRect iconFrame;
@property (nonatomic, assign, readonly) CGRect showNameFrame;
@property (nonatomic, assign, readonly) CGRect editButtonFrame;

@property (nonatomic, assign, readonly) CGRect developmentTimeNameFrame;
@property (nonatomic, assign, readonly) CGRect developmentTimeValueFrame;
@property (nonatomic, assign, readonly) CGRect technicalSchemeNameFrame;
@property (nonatomic, assign, readonly) CGRect technicalSchemeValueFrame;
@property (nonatomic, assign, readonly) CGRect referencePriceNameFrame;
@property (nonatomic, assign, readonly) CGRect referencePriceValueFrame;

@property (nonatomic, assign, readonly) CGRect imageViewFrame;

@property (nonatomic, assign, readonly) CGFloat cellRowHeight;

+ (instancetype)modelWithCaseDetailModel:(SLCaseDetailModel *)caseDetailModel;
- (instancetype)initWithCaseDetailModel:(SLCaseDetailModel *)caseDetailModel;

@end
