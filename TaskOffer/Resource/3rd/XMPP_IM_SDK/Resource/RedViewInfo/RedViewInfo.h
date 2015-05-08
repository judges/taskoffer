//
//  RedViewInfo.h
//  XMPPIM
//
//  Created by BourbonZ on 15/1/19.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface RedViewInfo : NSManagedObject

@property (nonatomic, retain) NSNumber * showRed;
@property (nonatomic, retain) NSString * bardJidStr;
@property (nonatomic, retain) NSString * streamJidStr;


/**
 
 type 表示红点类型，1代表聊天信息,2代表好友请求
 
 */

@property (nonatomic, retain) NSNumber * type;

@end
