//
//  ProjectInfo.h
//  TaskOffer
//
//  Created by BourbonZ on 15/3/17.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectInfo : NSObject
@property (nonatomic,assign) NSDictionary *projectDict;

@property (nonatomic,copy) NSString *projectIcon;
@property (nonatomic,copy) NSString *projectName;
@property (nonatomic,copy) NSString *projectPublish;
@property (nonatomic,copy) NSString *projectDeadLine;
@property (nonatomic,copy) NSString *projectPrice;
@property (nonatomic,copy) NSString *projectCloseDate;
@property (nonatomic,copy) NSString *projectContent;

@property (nonatomic,copy) NSString *createTime;
@property (nonatomic,copy) NSString *createUser;
@property (nonatomic,copy) NSString *projectID;
@property (nonatomic,copy) NSString *modifyTime;        ///更新时间
@property (nonatomic,copy) NSString *modifyUser;        ///更新人
@property (nonatomic,assign) int projectConverse;   ///项目交谈次数
@property (nonatomic,copy) NSString *projectDescibe;    ///项目描述
@property (nonatomic,assign) NSNumber *projectIsDelete;      ///项目删除标记
@property (nonatomic,copy) NSString *projectPlace;      ///项目地点
@property (nonatomic,copy) NSString *projectProfessionType;///项目行业类别
@property (nonatomic,copy) NSString *projectPublishId;  ///项目发布者ID,用这个
@property (nonatomic,copy) NSString *projectPublishName;///项目发布对象名称
@property (nonatomic,copy) NSString *projectPublishPosition;///项目发布对象职责
@property (nonatomic,copy) NSString *projectStatus;     ///项目状态
@property (nonatomic,copy) NSString *projectTags;       ///项目标签
@property (nonatomic,copy) NSString *projectType;       ///项目类型
@property (nonatomic,copy) NSString *projectPicture;    ///项目图片
@property (nonatomic,copy) NSString *collectId;         ///项目收藏ID
@property (nonatomic,copy) NSString *projectLeadId;     ///企业号或个人发布的项目负责人ID
@end
