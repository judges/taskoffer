//
//  SLConnectionDetailBaseInfoFrameModel.h
//  TaskOffer
//
//  Created by wshaolin on 15/4/21.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLConnectionModel.h"

@interface SLConnectionDetailBaseInfoFrameModel : NSObject

@property (nonatomic, strong, readonly) SLConnectionModel *connectionModel;

@property (nonatomic, assign, readonly) CGRect iconImageFrame;
@property (nonatomic, assign, readonly) CGRect displayNameFrame;
@property (nonatomic, assign, readonly) CGRect authenticationFrame;
@property (nonatomic, assign, readonly) CGRect companyAndJobFrame;
@property (nonatomic, assign, readonly) CGRect emailFrame;
@property (nonatomic, assign, readonly) CGRect sexFrame;
@property (nonatomic, assign, readonly) CGRect introductionFrame;

@property (nonatomic, assign, readonly) CGFloat cellRowHeight;

+ (instancetype)modelWithConnectionModel:(SLConnectionModel *)connectionModel;
- (instancetype)initWithConnectionModel:(SLConnectionModel *)connectionModel;

@end
