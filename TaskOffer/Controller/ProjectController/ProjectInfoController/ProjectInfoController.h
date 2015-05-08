//
//  ProjectInfoController.h
//  TaskOffer
//
//  Created by BourbonZ on 15/3/18.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "BaseViewController.h"

@interface ProjectInfoController : BaseViewController
///项目ID
@property (nonatomic,copy) NSString *projectID;
///是否是自己的项目
@property (nonatomic,assign) BOOL ifMyProject;
@end
