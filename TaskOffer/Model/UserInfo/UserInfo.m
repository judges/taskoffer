//
//  UserInfo.m
//  TaskOffer
//
//  Created by BourbonZ on 15/3/20.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "UserInfo.h"
static UserInfo *userInfo = nil;
@implementation UserInfo
@synthesize infoDict = _infoDict;
@synthesize createTime;
@synthesize createUser;
@synthesize userID;
@synthesize modifyTime;
@synthesize modifyUser;
@synthesize userBanStatus;
@synthesize userCases;
@synthesize userCertificateStatus;
@synthesize userCertificateTime;
@synthesize userCity;
@synthesize userCompanyDefinedName;
@synthesize userCompanyId;
@synthesize userCompanyName;
@synthesize userCompanyPosition;
@synthesize userCompanySize;
@synthesize userDescibe;
@synthesize userHeadPicture;
@synthesize userInfoIntegrity;
@synthesize userIsDelete;
@synthesize userMail;
@synthesize userName;
@synthesize userPassword;
@synthesize userPhone;
@synthesize userTags;
@synthesize userSex;
-(void)setInfoDict:(NSDictionary *)infoDict
{
    createTime = [self checkString:[infoDict objectForKey:@"createTime"]];
    createUser = [self checkString:[infoDict objectForKey:@"createUser"]];
    modifyTime = [self checkString:[infoDict objectForKey:@"modifyTime"]];
    modifyUser = [self checkString:[infoDict objectForKey:@"modifyUser"]];
    userID = [self checkString:[infoDict objectForKey:@"id"]];
    userBanStatus = [self checkString:[infoDict objectForKey:@"userBanStatus"]];
    userCases = [self checkString:[infoDict objectForKey:@"userCases"]];
    userCertificateStatus = [self checkString:[infoDict objectForKey:@"userCertificateStatus"]];
    userCertificateTime = [self checkString:[infoDict objectForKey:@"userCertificateTime"]];
    userCompanyDefinedName = [self checkString:[infoDict objectForKey:@"userCompanyDefinedName"]];
    userCompanyId = [self checkString:[infoDict objectForKey:@"userCompanyId"]];
    userCompanyName = [self checkString:[infoDict objectForKey:@"userCompanyName"]];
    userCompanySize = [self checkString:[infoDict objectForKey:@"userCompanySize"]];
    
    if ([infoDict objectForKey:@"userCity"])
    {
        userCity = [self checkString:[infoDict objectForKey:@"userCity"]];
    }
    
    if ([infoDict objectForKey:@"userCompanyPosition"])
    {
        userCompanyPosition = [self checkString:[infoDict objectForKey:@"userCompanyPosition"]];
    }
    
    userDescibe = [self checkString:[infoDict objectForKey:@"userDescibe"]];
    userHeadPicture = [self checkString:[infoDict objectForKey:@"userHeadPicture"]];
    userInfoIntegrity = [[infoDict objectForKey:@"userInfoIntegrity"] integerValue] == 1 ? YES : NO;
    userIsDelete = [self checkString:[infoDict objectForKey:@"userIsDelete"]];
    userMail = [self checkString:[infoDict objectForKey:@"userMail"]];
    userName = [self checkString:[infoDict objectForKey:@"userName"]];
    userPassword = [self checkString:[infoDict objectForKey:@"userPassword"]];
    userTags = [self checkString:[infoDict objectForKey:@"userTags"]];
    if ([infoDict objectForKey:@"userPhone"])
    {
        userPhone = [self checkString:[infoDict objectForKey:@"userPhone"]];
    }
    
    userSex = [self checkString:[infoDict objectForKey:@"userSex"]];
    
    [[NSUserDefaults standardUserDefaults] setObject:userID forKey:@"tmpUserID"];
    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"tmpUserName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(UserInfo *)sharedInfo
{
    @synchronized(self)
    {
        if (userInfo == nil)
        {
            userInfo = [[UserInfo alloc] init];
        }
        return userInfo;
    }
}
-(NSString *)checkString:(id)sender
{
    if ([sender isKindOfClass:[NSNull class]])
    {
        return @"";
    }
    return [NSString stringWithFormat:@"%@",sender];
}
-(NSString *)userID
{
    if (userID == nil)
    {
        NSString *infoID = [[NSUserDefaults standardUserDefaults] objectForKey:@"tmpUserID"];
        if (infoID != nil && ![infoID isEqualToString:@""])
        {
            return infoID;
        }
        return @"";
    }
    return userID;
}
-(NSString *)userMail
{
    if ([userMail isEqualToString:@"(null)"])
    {
        return @"";
    }
    return userMail;
}
-(NSString *)userDescibe
{
    if ([userDescibe isEqualToString:@"(null)"])
    {
        return @"";
    }
    return userDescibe;
}
-(NSString *)userName
{
    if ([userName isEqualToString:@""] || userName == nil)
    {
        NSString *infoName = [[NSUserDefaults standardUserDefaults] objectForKey:@"tmpUserName"];
        if (infoName != nil && ![infoName isEqualToString:@""])
        {
            return infoName;
        }

        return @"未设置名称,请先设置名称";
    }
    return userName;
}
@end
