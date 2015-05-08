//
//  EnterpriseInfo.h
//  TaskOffer
//
//  Created by BourbonZ on 15/3/17.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//
///企业号
#import <Foundation/Foundation.h>

@interface EnterpriseInfo : NSObject

@property (nonatomic,strong) NSDictionary *enterpriseDict;

@property (nonatomic,copy) NSString *enterpriseIcon;        ///companyLogo
@property (nonatomic,copy) NSString *enterpriseName;        //companyName
// 0：项目发布方；1：项目承接方；2：其他
@property (nonatomic,copy) NSString *enterpriseCategory;    ///companyType
@property (nonatomic,copy) NSString *enterpriseCase;        ///companyCases
@property (nonatomic,strong) NSArray *enterpriseTagArray;   ///companyTags
@property (nonatomic,copy) NSString *enterpriseContent;     ///companyDescibe

@property (nonatomic,copy) NSString *companyAddress;
@property (nonatomic,copy) NSString *companyBanStatus;
@property (nonatomic,copy) NSString *companyCases;
@property (nonatomic,copy) NSString *companyCity;
@property (nonatomic,copy) NSString *companyContactWay;
@property (nonatomic,assign) BOOL companyIsDelete;
@property (nonatomic,copy) NSString *companyLicenceCode;
@property (nonatomic,copy) NSString *companyLicencePicture;
@property (nonatomic,copy) NSString *companyPassword;
@property (nonatomic,copy) NSString *companyRegisterMail;
@property (nonatomic,copy) NSString *companyRegisterName;
@property (nonatomic,copy) NSString *companyRegisterPhone;
@property (nonatomic,copy) NSString *companySize;
@property (nonatomic,copy) NSString *companyStatus;
@property (nonatomic,copy) NSString *createUser;
@property (nonatomic,copy) NSString *companyId;
@property (nonatomic,copy) NSString *modifyTime;
@property (nonatomic,copy) NSString *modifyUser;
@property (nonatomic,copy) NSString *organizationCode;
@property (nonatomic,copy) NSString *organizationPicture;
@property (nonatomic,copy) NSString *attentionId;
@end
