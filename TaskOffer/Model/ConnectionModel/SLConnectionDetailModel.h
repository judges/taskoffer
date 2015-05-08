//
//  SLConnectionDetailModel.h
//  TaskOffer
//
//  Created by wshaolin on 15/3/24.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLConnectionModel.h"
#import "SLEnterpriseInformationFrameModel.h"
#import "SLConnectionDetailBaseInfoFrameModel.h"
#import "SLCaseDetailModel.h"
#import "SLProjectModel.h"
#import "EnterpriseInfo.h"
#import "SLTagFrameModel.h"
#import "SLConnectionDynamicModel.h"

typedef NS_ENUM(NSInteger, SLConnectionDetailSectionType){
    SLConnectionDetailSectionTypeBaseInfo = 101, // 基本信息
    SLConnectionDetailSectionTypeTag, // 标签
    SLConnectionDetailSectionTypeEnterpriseInfo, // 企业资料
    SLConnectionDetailSectionTypeCaseLibrary, // 案例库
    SLConnectionDetailSectionTypeProjectLibrary, // 项目库
    SLConnectionDetailSectionTypeDynamic // 动态
};

@interface SLConnectionDetailModel : NSObject

@property (nonatomic, strong, readonly) SLConnectionModel *connectionModel; // 人的资料
@property (nonatomic, strong, readonly) SLConnectionDetailBaseInfoFrameModel *connectionDetailBaseInfoFrameModel; // 详情基本信息cell的frame模型
@property (nonatomic, strong, readonly) SLTagFrameModel *tagFrameModel; // 标签

@property (nonatomic, strong, readonly) SLEnterpriseInformationFrameModel *eiFrameModel; // 企业资料
@property (nonatomic, strong, readonly) SLCaseDetailModel *caseDetailModel; // 发布的案例资料
@property (nonatomic, strong, readonly) SLProjectModel *projectModel; // 发布的项目资料
@property (nonatomic, strong, readonly) EnterpriseInfo *enterpriseInfo; // 企业资料（所有字段）
@property (nonatomic, strong, readonly) SLConnectionDynamicModel *dynamicModel; // 动态

@property (nonatomic, strong, readonly) NSArray *sectionTypes; // section对应的数据类型
@property (nonatomic, strong, readonly) NSArray *sectionTitles; // section的title
@property (nonatomic, strong, readonly) NSArray *sectionCellRowHeight; // section对应的cell的高度
@property (nonatomic, assign, readonly) CGFloat sectionHeight; // section的高度

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
