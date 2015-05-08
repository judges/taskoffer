//
//  DialogueModel.h
//  XMPPIM
//
//  Created by BourbonZ on 14/12/26.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DialogueModel : NSManagedObject

@property (nonatomic, retain) NSString * iconStr;
@property (nonatomic, retain) NSString * contentStr;
@property (nonatomic, retain) NSString * nameStr;
@property (nonatomic, retain) NSString * timeStr;
@property (nonatomic, retain) NSNumber * hasRed;
@property (nonatomic, retain) NSString * myJidStr;
@property (nonatomic, retain) NSString * otherJidStr;

///向最近联系人加入相应聊天
+(void)checkIfHaveInDialogue:(NSString *)name content:(NSString *)content isGroupChat:(BOOL)groupChat;

///选取所有最近联系人
+(NSMutableArray *)allDialogue;

@end
