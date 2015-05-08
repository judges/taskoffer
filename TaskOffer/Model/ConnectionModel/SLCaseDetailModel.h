//
//  SLCaseDetailModel.h
//  TaskOffer
//
//  Created by wshaolin on 15/3/21.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SLCaseType){
    SLCaseTypeEnterprise, // 企业
    SLCaseTypePersonal // 个人
};

@interface SLCaseDetailModel : NSObject

@property (nonatomic, copy, readonly) NSString *createUser; // 如果是自己的，在列表才显示编辑按钮
@property (nonatomic, copy, readonly) NSString *caseID;
@property (nonatomic, copy, readonly) NSString *caseName; // 案例名称
@property (nonatomic, copy, readonly) NSString *caseLogoName; // logo的图片名
@property (nonatomic, copy, readonly) NSString *caseLogo; // 案例logo完整URL
@property (nonatomic, strong, readonly) NSArray *tags; // 标签
@property (nonatomic, assign, readonly) SLCaseType caseType; // 案例类型

/***********************基本信息***************************/
@property (nonatomic, copy, readonly) NSString *industry; // 行业
@property (nonatomic, copy, readonly) NSString *projectDesc; // 项目描述
@property (nonatomic, copy, readonly) NSString *referencePrice; // 参考报价

/***********************技术信息***************************/
@property (nonatomic, copy, readonly) NSString *developmentTime; // 开发周期
@property (nonatomic, copy, readonly) NSString *technicalScheme; // 技术方案
@property (nonatomic, copy, readonly) NSString *schemeDesc; // 方案描述

/***********************下载信息***************************/
@property (nonatomic, assign, readonly) BOOL isOnline; // 是否已上线
@property (nonatomic, copy, readonly) NSString *downloadLink; // 查看地址
@property (nonatomic, assign, readonly) BOOL isValidURL; // 查看地址是否有效

@property (nonatomic, copy) NSString *designSchemeImageNames; //设计方案（图片名）
@property (nonatomic, strong, readonly) NSArray *designSchemeUrl; // 设计方案（图片完整URL）

/***********************收藏信息***************************/
@property (nonatomic, copy, readonly) NSString *collectId;
@property (nonatomic, assign, readonly) BOOL isCollected;

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (void)setCollectId:(NSString *)collectId;
- (void)setCollected:(BOOL)isCollected;

@end
