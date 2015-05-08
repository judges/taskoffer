//
//  SLEnterpriseInformationFrameModel.h
//  TaskOffer
//
//  Created by wshaolin on 15/3/20.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLEnterpriseInformationModel.h"

@interface SLEnterpriseInformationFrameModel : NSObject

@property (nonatomic, strong, readonly) SLEnterpriseInformationModel *eiModel;
@property (nonatomic, assign, readonly) CGRect departmentFrame;
@property (nonatomic, assign, readonly) CGRect staffSizeFrame;
@property (nonatomic, assign, readonly) CGRect addressFrame;
@property (nonatomic, assign, readonly) CGRect introductionFrame;
@property (nonatomic, assign, readonly) CGFloat cellRowHeight;

+ (instancetype)modelWithEIModel:(SLEnterpriseInformationModel *)eiModel;
- (instancetype)initWithEIModel:(SLEnterpriseInformationModel *)eiModel;

@end
