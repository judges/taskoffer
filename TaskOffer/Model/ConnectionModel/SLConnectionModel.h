//
//  SLConnectionModel.h
//  TaskOffer
//
//  Created by wshaolin on 15/3/19.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLEnterpriseInformationFrameModel.h"
#import "SLCaseDetailModel.h"

typedef NS_ENUM(NSInteger, SLConnectionModelSex){ // 性别
    SLConnectionModelSexUnknown, // 未知
    SLConnectionModelSexMale, // 男
    SLConnectionModelSexFemale // 女
};

@interface SLConnectionModel : NSObject

@property (nonatomic, copy, readonly) NSString *userID;
@property (nonatomic, copy, readonly) NSString *imageURL; // 头像
@property (nonatomic, copy, readonly) NSString *displayName; // 显示的名字
@property (nonatomic, assign, readonly) BOOL isAuthenticated; // 是否已认证
@property (nonatomic, assign, readonly) NSInteger caseCount; // 案例数量
@property (nonatomic, copy, readonly) NSString *companyAndJob; // 公司和职位
@property (nonatomic, strong, readonly) NSArray *tags; // 所有标签
@property (nonatomic, copy, readonly) NSString *tag1; // 标签1
@property (nonatomic, copy, readonly) NSString *tag2; // 标签2
@property (nonatomic, copy, readonly) NSString *tag3; // 标签3
@property (nonatomic, copy, readonly) NSString *email; // 电子邮箱
@property (nonatomic, copy, readonly) NSString *introduction; // 简介
@property (nonatomic, assign, readonly) SLConnectionModelSex sex; // 性别

@property (nonatomic, copy, readonly) NSString *authenticatedTime; // 认证时间
@property (nonatomic, copy, readonly) NSString *mobile; // 手机
@property (nonatomic, assign, readonly) BOOL isPerfectInfo; //资料是否完善

@property (nonatomic, copy, readonly) NSString *city; // 所在城市

/*************************未认证用户使用****************************/
@property (nonatomic, copy, readonly) NSString *companyName; // 公司名称
@property (nonatomic, copy, readonly) NSString *companyID; // 公司ID
@property (nonatomic, copy, readonly) NSString *companyStaffSize; // 公司规模
@property (nonatomic, copy, readonly) NSString *companyIntroduction; // 公司简介
@property (nonatomic, copy, readonly) NSString *companyEnterpriseName; // 公司企业号名称

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (BOOL)isEqualConnection:(SLConnectionModel *)connectionModel;

@end
