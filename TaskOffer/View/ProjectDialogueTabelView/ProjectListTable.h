//
//  ProjectListTable.h
//  TaskOffer
//
//  Created by BourbonZ on 15/4/13.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectDialogue.h"
@protocol ProjectListTableDelegate <NSObject>

-(void)clickProjectListTableAtIndex:(ProjectDialogue *)dialogue;

@end

@interface ProjectListTable : UITableView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,weak) id <ProjectListTableDelegate>projectListDelegate;

@property (nonatomic,copy) NSString *projectID;
@end
