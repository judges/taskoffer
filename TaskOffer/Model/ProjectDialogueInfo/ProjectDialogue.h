//
//  ProjectDialogue.h
//  TaskOffer
//
//  Created by BourbonZ on 15/4/10.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectDialogue : NSObject
@property (nonatomic,copy) NSString *projectID;
@property (nonatomic,copy) NSString *messageSender;
@property (nonatomic,copy) NSString *messageReceiver;
@property (nonatomic,copy) NSString *messageTime;
@end
