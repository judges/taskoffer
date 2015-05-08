//
//  UserInfo.h
//  TaskOffer
//
//  Created by BourbonZ on 15/3/20.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject
@property (nonatomic,weak) NSDictionary *infoDict;

@property (nonatomic,copy) NSString *createTime;
@property (nonatomic,copy) NSString *createUser;
@property (nonatomic,copy) NSString *userID;
@property (nonatomic,copy) NSString *modifyTime;
@property (nonatomic,copy) NSString *modifyUser;
@property (nonatomic,copy) NSString *userBanStatus;
@property (nonatomic,copy) NSString *userCases;
@property (nonatomic,copy) NSString *userCertificateStatus; ///企业号认证状态
@property (nonatomic,copy) NSString *userCertificateTime;
@property (nonatomic,copy) NSString *userCity;
@property (nonatomic,copy) NSString *userCompanyDefinedName;
@property (nonatomic,copy) NSString *userCompanyId;
@property (nonatomic,copy) NSString *userCompanyName;
@property (nonatomic,copy) NSString *userCompanyPosition;
@property (nonatomic,copy) NSString *userCompanySize;
@property (nonatomic,copy) NSString *userDescibe;
@property (nonatomic,copy) NSString *userHeadPicture;
@property (nonatomic,assign) BOOL userInfoIntegrity;    ///个人信息是否完善
@property (nonatomic,copy) NSString *userIsDelete;
@property (nonatomic,copy) NSString *userMail;
@property (nonatomic,copy) NSString *userName;
@property (nonatomic,copy) NSString *userPassword;
@property (nonatomic,copy) NSString *userPhone;
@property (nonatomic,copy) NSString *userTags;
@property (nonatomic,copy) NSString *userSex;

+(UserInfo *)sharedInfo;

@end
