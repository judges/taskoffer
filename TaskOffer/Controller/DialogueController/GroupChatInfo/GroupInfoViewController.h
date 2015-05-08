//
//  ZWGroupInfoViewController.h
//  XMPPIM
//
//  Created by BourbonZ on 14/12/17.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import "BaseViewController.h"
#import "XMPPRoomMemberInfo.h"
@interface GroupInfoViewController : BaseViewController

@property (nonatomic,strong) XMPPJID *roomJID;
///详细信息数组
@property (nonatomic,strong) NSArray *infoArray;

@end
