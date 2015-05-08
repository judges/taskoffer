//
//  SLConnectionDetailModel.m
//  TaskOffer
//
//  Created by wshaolin on 15/3/24.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLConnectionDetailModel.h"
#import "NSDictionary+NullFilter.h"

@implementation SLConnectionDetailModel

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary{
    return [[self alloc] initWithDictionary:dictionary];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    if(self = [super init]){
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}

- (void)setValuesForKeysWithDictionary:(NSDictionary *)dictionary{
    NSDictionary *connectionDictionary = [dictionary dictionaryForKey:@"ServerAppUser"];
    NSDictionary *eiDictionary = [dictionary dictionaryForKey:@"ServerCompany"];
    NSDictionary *caseDictionary = [dictionary dictionaryForKey:@"ServerCases"];
    NSDictionary *projectDictionary = [dictionary dictionaryForKey:@"ServerProject"];
    NSDictionary *dynamicDictionary = [dictionary dictionaryForKey:@"serverDynamic"];
    
    _connectionModel = [[SLConnectionModel alloc] initWithDictionary:connectionDictionary];
    
    NSMutableArray *tempSectionTypes = [NSMutableArray array];
    NSMutableArray *tempSectionTitles = [NSMutableArray array];
    NSMutableArray *tempSectionCellRowHeight = [NSMutableArray array];
    
    _connectionDetailBaseInfoFrameModel = [[SLConnectionDetailBaseInfoFrameModel alloc] initWithConnectionModel:_connectionModel];
    
    [tempSectionTypes addObject:@(SLConnectionDetailSectionTypeBaseInfo)];
    [tempSectionTitles addObject:@"基本信息"];
    [tempSectionCellRowHeight addObject:@(_connectionDetailBaseInfoFrameModel.cellRowHeight)];
    
    // 是否有标签
    if(_connectionModel.tags != nil && _connectionModel.tags.count > 0){
        [tempSectionTypes addObject:@(SLConnectionDetailSectionTypeTag)];
        [tempSectionTitles addObject:@"行业标签"];
        
        _tagFrameModel = [[SLTagFrameModel alloc] initWithTags:_connectionModel.tags];
        
        [tempSectionCellRowHeight addObject:@(_tagFrameModel.tagViewHeight)];
    }
    
    // 构造未认证用户的企业资料
    if(!_connectionModel.isAuthenticated){
        // 未认证用户的企业资料需要从人上取
        eiDictionary = @{@"companyName" : _connectionModel.companyName,
                         @"companySize" : _connectionModel.companyStaffSize,
                         @"companyAddress" : _connectionModel.city,
                         @"companyDescibe" : _connectionModel.companyIntroduction,
                         @"id" : _connectionModel.companyID,
                         @"enterpriseName" : _connectionModel.companyEnterpriseName,
                         @"companyLogo" : @""};
    }
    
    // 是否有企业资料
    if(eiDictionary != nil && eiDictionary.count > 0){
        SLEnterpriseInformationModel *eiModel = [[SLEnterpriseInformationModel alloc] initWithDictionary:eiDictionary];
        _eiFrameModel = [[SLEnterpriseInformationFrameModel alloc] initWithEIModel:eiModel];
        [tempSectionTypes addObject:@(SLConnectionDetailSectionTypeEnterpriseInfo)];
        [tempSectionTitles addObject:@"企业资料"];
        if(_connectionModel.isAuthenticated){ // 已认证
            [tempSectionCellRowHeight addObject:@(40.0)];
        }else{ // 未认证
            [tempSectionCellRowHeight addObject:@(_eiFrameModel.cellRowHeight)];
        }
        _enterpriseInfo = [[EnterpriseInfo alloc] init];
        _enterpriseInfo.enterpriseDict = eiDictionary;
    }
    
    // 是否有案例
    if(caseDictionary != nil && caseDictionary.count > 0){
        _caseDetailModel = [[SLCaseDetailModel alloc] initWithDictionary:caseDictionary];
        [tempSectionTypes addObject:@(SLConnectionDetailSectionTypeCaseLibrary)];
        [tempSectionTitles addObject:@"案例库"];
        [tempSectionCellRowHeight addObject:@(50.0)];
    }
    
    // 是否有项目
    if(projectDictionary != nil && projectDictionary.count > 0){
        _projectModel = [[SLProjectModel alloc] initWithDictionary:projectDictionary];
        [tempSectionTypes addObject:@(SLConnectionDetailSectionTypeProjectLibrary)];
        [tempSectionTitles addObject:@"项目库"];
        [tempSectionCellRowHeight addObject:@(50.0)];
    }
    
    // 是否有动态
    if(dynamicDictionary != nil && dynamicDictionary.count > 0){
        _dynamicModel = [[SLConnectionDynamicModel alloc] initWithDictionary:dynamicDictionary];
        [tempSectionTypes addObject:@(SLConnectionDetailSectionTypeDynamic)];
        [tempSectionTitles addObject:@"个人动态"];
        [tempSectionCellRowHeight addObject:@(50.0)];
    }
    
    _sectionTypes = [tempSectionTypes copy];
    _sectionTitles = [tempSectionTitles copy];
    _sectionCellRowHeight = [tempSectionCellRowHeight copy];
    _sectionHeight = 36.0;
}

@end
