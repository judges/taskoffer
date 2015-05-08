//
//  ProjectInfo.m
//  TaskOffer
//
//  Created by BourbonZ on 15/3/17.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "ProjectInfo.h"
#import "NSDictionary+NullFilter.h"

@implementation ProjectInfo
@synthesize projectDict = _projectDict;
-(void)setProjectDict:(NSDictionary *)projectDict
{
    
    NSDictionary *tmpDict = projectDict;
    if ([projectDict objectForKey:@"serverProject"] != nil)
    {
        tmpDict = [projectDict objectForKey:@"serverProject"];
    }
    self.projectIcon = [[tmpDict objectForKey:@"projectLogo"] isKindOfClass:[NSNull class]] == YES ? @"" : [tmpDict objectForKey:@"projectLogo"];
    self.projectName = [[tmpDict objectForKey:@"projectName"] isKindOfClass:[NSNull class]] == YES ? @"" : [tmpDict objectForKey:@"projectName"];
    NSString *endDateString = [NSString stringWithFormat:@"%@",[tmpDict objectForKey:@"projectEndTime"]];
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:endDateString.doubleValue/1000];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy.MM.dd"];
    NSString *endString = [formatter stringFromDate:endDate];
    
    self.projectDeadLine = endString;
    NSString *projectPublishName = [tmpDict stringForKey:@"projectPublishName"];
    NSString *projectPublishCompanyName = [tmpDict stringForKey:@"projectPublishCompanyName"];
    
    self.projectPublish = [NSString stringWithFormat:@"%@   %@", projectPublishName, projectPublishCompanyName];
    
    self.projectPrice = [[tmpDict objectForKey:@"projectPrice"] isKindOfClass:[NSNull class]] == YES ? @"" : [tmpDict objectForKey:@"projectPrice"];
    self.projectCloseDate = endString;
    self.projectContent = [[tmpDict objectForKey:@"projectDescibe"] isKindOfClass:[NSNull class]] == YES ? @"" : [tmpDict objectForKey:@"projectDescibe"];

    NSString *creatTimeString = [NSString stringWithFormat:@"%@",[tmpDict objectForKey:@"projectPublishTime"]];
    NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:creatTimeString.doubleValue/1000];
    self.createTime = [formatter stringFromDate:createDate];
    
    self.createUser = [[tmpDict objectForKey:@"createUser"] isKindOfClass:[NSNull class]] == YES ? @"" : [tmpDict objectForKey:@"createUser"];
    self.projectID = [tmpDict objectForKey:@"id"];
    self.modifyUser = [[tmpDict objectForKey:@"modifyUser"] isKindOfClass:[NSNull class]] == YES ? @"" : [tmpDict objectForKey:@"modifyUser"];
    
    NSString *modifyTimeString = [NSString stringWithFormat:@"%@",[tmpDict objectForKey:@"modifyTime"]];
    NSDate *modifyTimeDate = [NSDate dateWithTimeIntervalSince1970:modifyTimeString.doubleValue/1000];
    self.modifyTime = [formatter stringFromDate:modifyTimeDate];
    
    self.projectConverse = [[NSNumber numberWithInt:[[tmpDict objectForKey:@"projectConverse"] intValue]] intValue];
    self.projectDescibe = [[tmpDict objectForKey:@"projectDescibe"] isKindOfClass:[NSNull class]] == YES ? @"" : [tmpDict objectForKey:@"projectDescibe"];
    self.projectIsDelete = [NSNumber numberWithInt:[[tmpDict objectForKey:@"projectIsDelete"] intValue]];
    self.projectPlace = [[tmpDict objectForKey:@"projectPlace"] isKindOfClass:[NSNull class]] == YES ? @"" : [tmpDict objectForKey:@"projectPlace"];
    self.projectProfessionType = [[tmpDict objectForKey:@"projectProfessionType"] isKindOfClass:[NSNull class]] == YES ? @"" : [tmpDict objectForKey:@"projectProfessionType"];
    self.projectPublishId = [[tmpDict objectForKey:@"projectPublishId"] isKindOfClass:[NSNull class]] == YES ? @"" : [tmpDict objectForKey:@"projectPublishId"];
    self.projectPublishName = [[tmpDict objectForKey:@"projectPublishName"] isKindOfClass:[NSNull class]] == YES ? @"" : [tmpDict objectForKey:@"projectPublishName"];
    self.projectPublishPosition = [[tmpDict objectForKey:@"projectPublishPosition"] isKindOfClass:[NSNull class]] == YES ? @"" : [tmpDict objectForKey:@"projectPublishPosition"];
    self.projectStatus = [[tmpDict objectForKey:@"projectStatus"] isKindOfClass:[NSNull class]] == YES ? @"" : [tmpDict objectForKey:@"projectStatus"];
    self.projectTags = [[tmpDict objectForKey:@"projectTags"] isKindOfClass:[NSNull class]] == YES ? @"" : [tmpDict objectForKey:@"projectTags"];
    self.projectType = [[tmpDict objectForKey:@"projectType"] isKindOfClass:[NSNull class]] == YES ? @"" : [tmpDict objectForKey:@"projectType"];
    self.projectPicture = [[tmpDict objectForKey:@"projectPicture"] isKindOfClass:[NSNull class]] == YES ? @"" :[tmpDict objectForKey:@"projectPicture"];
    self.collectId = [[tmpDict objectForKey:@"collectId"] isKindOfClass:[NSNull class]] == YES ? @"" :[tmpDict objectForKey:@"collectId"];
    
    self.projectLeadId = [[tmpDict objectForKey:@"projectLeadId"] isKindOfClass:[NSNull class]] == YES ? @"" :[tmpDict objectForKey:@"projectLeadId"];
}

@end
