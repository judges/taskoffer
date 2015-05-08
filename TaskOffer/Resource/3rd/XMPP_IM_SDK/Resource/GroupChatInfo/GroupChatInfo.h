//
//  GroupChatInfo.h
//  XMPPIM
//
//  Created by BourbonZ on 15/1/7.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface GroupChatInfo : NSManagedObject

@property (nonatomic, retain) NSString * groupChatID;
@property (nonatomic, retain) NSString * groupChatSubject;

@end
