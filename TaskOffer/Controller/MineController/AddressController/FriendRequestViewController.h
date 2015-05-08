//
//  FriendRequestViewController.h
//  rndIM
//
//  Created by BourbonZ on 14/12/6.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import "BaseViewController.h"

@interface FriendRequestViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *listTable;
    NSArray *requestArray;
}

@end
