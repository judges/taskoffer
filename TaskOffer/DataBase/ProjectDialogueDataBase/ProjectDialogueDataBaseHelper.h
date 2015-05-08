//
//  ProjectDialogueDataBaseHelper.h
//  TaskOffer
//
//  Created by BourbonZ on 15/4/10.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProjectDialogueInfo.h"
#import "ProjectDialogue.h"
@interface ProjectDialogueDataBaseHelper : NSObject

+(ProjectDialogueDataBaseHelper *)sharedHelper;

-(void)createDatabase;

-(void)addProjectInfo:(ProjectDialogueInfo *)info;
-(ProjectDialogueInfo *)selectProjectInfo:(NSString *)projectID;

-(NSMutableArray *)allDialogueArrayWithProjectID:(NSString *)projectID;

-(void)addProjectDialogue:(ProjectDialogue *)info;
-(NSMutableArray *)selectProjectDialogueWithReceiver:(NSString *)receiver andSender:(NSString *)sender andProjectID:(NSString *)projectID;
-(void)deleteProjectDialogueWithReceiver:(NSString *)receiver andSender:(NSString *)sender andProjectID:(NSString *)projectID;



@end
