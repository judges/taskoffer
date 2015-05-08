//
//  FriendInfoController.h
//  XMPPIM
//
//  Created by BourbonZ on 15/1/15.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "BaseViewController.h"
typedef enum
{
    searchFriend,
    friendInfo
}friendInfoType;
@interface FriendInfoController : BaseViewController

@property (nonatomic,copy) NSString *friendName;
@property (nonatomic,assign) friendInfoType friendType;
@property (nonatomic,assign) BOOL isFriend;
@end
