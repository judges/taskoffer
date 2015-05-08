//
//  FriendSelectViewController.h
//  TaskOffer
//
//  Created by BourbonZ on 15/3/31.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

typedef NS_ENUM(NSUInteger, itemType) {

    ///项目推荐
    projectRecommend = 0,
    
    ///交换名片
    exchangeCards = 1,
    
    ///企业号推荐
    enterpriseRecommend = 2,
    
    ///案例推荐
    caseRecommend = 3,
    
};


#import "BaseViewController.h"
#import "ProjectInfo.h"
#import "EnterpriseInfo.h"
#import "SLCaseDetailModel.h"
@interface FriendSelectViewController : BaseViewController

///进入类型，必填项
@property (nonatomic,assign) itemType selectType;

///从哪个界面进入的,必填项
@property (nonatomic,strong) UIViewController *controller;

///被推荐项目
@property (nonatomic,strong) ProjectInfo *projectInfo;

///被推荐的企业号
@property (nonatomic,strong) EnterpriseInfo *enterpriseInfo;

///被发送的案例
@property (nonatomic,strong) SLCaseDetailModel *caseInfo;

///被发送的对象
@property (nonatomic,strong) NSMutableDictionary *cardDict;
@end
