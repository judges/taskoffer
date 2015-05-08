//
//  SLEnterpriseInformationModel.h
//  TaskOffer
//
//  Created by wshaolin on 15/3/20.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLEnterpriseInformationModel : NSObject

@property (nonatomic, copy, readonly) NSString *companyName; // 公司名称
@property (nonatomic, copy, readonly) NSString *department; // 部门名称
@property (nonatomic, copy, readonly) NSString *staffSize; // 公司规模
@property (nonatomic, copy, readonly) NSString *address; // 公司地址
@property (nonatomic, copy, readonly) NSString *introduction; // 公司介绍
@property (nonatomic, copy, readonly) NSString *companyID; // 公司id
@property (nonatomic, copy, readonly) NSString *enterpriseName; // 企业号名称
@property (nonatomic, copy, readonly) NSString *companyLogo; // 公司logo

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
