//
//  SingleChatController.h
//  rndIM
//
//  Created by BourbonZ on 14/12/4.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import "ChatCoreController.h"
#import "XMPPFriendInfo.h"
@interface SingleChatController : ChatCoreController
@property (nonatomic,strong) XMPPFriendInfo *currentUser;
@property (nonatomic,copy) NSString *currentUserName;

///关于项目接包部分
@property (nonatomic,copy) NSString *projectName;
@property (nonatomic,copy) NSString *projectOwner;
@property (nonatomic,copy) NSString *projectID;

//点击右上角的按钮
-(void)clickChatRightButton:(UIButton *)button;


#pragma mark 点击头像
-(void)clickOtherIcon:(ChartCell *)cell;
-(void)clickMyIcon:(ChartCell *)cell;
@end
