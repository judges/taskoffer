//
//  EnterpriseInfo.m
//  TaskOffer
//
//  Created by BourbonZ on 15/3/17.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "EnterpriseInfo.h"

@implementation EnterpriseInfo
@synthesize enterpriseDict= _enterpriseDict;
-(void)setEnterpriseDict:(NSDictionary *)enterpriseDict
{
    NSDictionary *tmpDict = enterpriseDict;
    if ([enterpriseDict objectForKey:@"companyInfo"] != nil)
    {
        tmpDict = [enterpriseDict objectForKey:@"companyInfo"];
    }
    
    self.enterpriseIcon = [[tmpDict objectForKey:@"companyLogo"] isKindOfClass:[NSNull class]] == YES ? @"" :[tmpDict objectForKey:@"companyLogo"];
    self.enterpriseName = [[tmpDict objectForKey:@"companyName"] isKindOfClass:[NSNull class]] == YES ? @"" :[tmpDict objectForKey:@"companyName"];
    self.enterpriseCategory = [[tmpDict objectForKey:@"companyType"] isKindOfClass:[NSNull class]] == YES ? @"" :[[tmpDict objectForKey:@"companyType"] stringValue];

    self.enterpriseCase = [[tmpDict objectForKey:@"companyCases"] isKindOfClass:[NSNull class]] == YES ? @"0" :[[tmpDict objectForKey:@"companyCases"] stringValue];
    NSString *tagString = [[tmpDict objectForKey:@"companyTags"] isKindOfClass:[NSNull class]] == YES ? @"" :[tmpDict objectForKey:@"companyTags"];
    if (tagString.length > 0)
    {
        if ([tagString rangeOfString:@","].location == NSNotFound)
        {
            self.enterpriseTagArray = [NSArray arrayWithObject:tagString];
        }
        else
        {
            self.enterpriseTagArray = [tagString componentsSeparatedByString:@","];
        }
    }
    else
    {
        self.enterpriseTagArray = [NSArray array];
    }
    self.enterpriseContent = [[tmpDict objectForKey:@"companyDescibe"] isKindOfClass:[NSNull class]] == YES ? @"0" :[tmpDict objectForKey:@"companyDescibe"];

    
    self.companyAddress = [self checkString:[tmpDict objectForKey:@"companyAddress"]];
    self.companyBanStatus = [self checkString:[tmpDict objectForKey:@"companyBanStatus"]];
    self.companyCases = [self checkString:[tmpDict objectForKey:@"companyCases"]];
    self.companyCity = [self checkString:[tmpDict objectForKey:@"companyCity"]];
    self.companyContactWay = [self checkString:[tmpDict objectForKey:@"companyContactWay"]];
    self.companyIsDelete = [[NSNumber numberWithInt:[[tmpDict objectForKey:@"companyIsDelete"] intValue]] boolValue];
    self.companyLicenceCode = [self checkString:[tmpDict objectForKey:@"companyLicenceCode"]];
    self.companyLicencePicture = [self checkString:[tmpDict objectForKey:@"companyLicencePicture"]];
    self.companyPassword = [self checkString:[tmpDict objectForKey:@"companyPassword"]];
    self.companyRegisterMail = [self checkString:[tmpDict objectForKey:@"companyRegisterMail"]];
    self.companyRegisterName = [self checkString:[tmpDict objectForKey:@"companyRegisterName"]];
    self.companyRegisterPhone = [self checkString:[tmpDict objectForKey:@"companyRegisterPhone"]];
    self.companySize = [self checkString:[tmpDict objectForKey:@"companySize"]];
    self.companyStatus = [self checkString:[tmpDict objectForKey:@"companyStatus"]];
    self.createUser = [self checkString:[tmpDict objectForKey:@"createUser"]];
    self.companyId = [self checkString:[tmpDict objectForKey:@"id"]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSTimeInterval time = [[tmpDict objectForKey:@"modifyTime"] doubleValue]/1000;
    NSDate *modifyDate = [NSDate dateWithTimeIntervalSince1970:time];
    self.modifyTime = [formatter stringFromDate:modifyDate];
    self.modifyUser = [self checkString:[tmpDict objectForKey:@"modifyUser"]];
    self.organizationCode = [self checkString:[tmpDict objectForKey:@"organizationCode"]];
    self.organizationPicture = [self checkString:[tmpDict objectForKey:@"organizationPicture"]];
    
    self.attentionId = [self checkString:[enterpriseDict objectForKey:@"attentionId"]];
}

-(NSString *)checkString:(id)string
{
    if ([string isKindOfClass:[NSNull class]])
    {
        return @"";
    }
    return [NSString stringWithFormat:@"%@",string];
}

@end
