//
//  ProjectDialogueTable.h
//  TaskOffer
//
//  Created by BourbonZ on 15/4/10.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProjectDialogue;
@protocol ProjectDialogueTableDelegate <NSObject>

-(void)clickProjectDialogueTable:(ProjectDialogue *)dialogue;

@end
@interface ProjectDialogueTable : UITableView<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,weak) id <ProjectDialogueTableDelegate>projectDialogueDelegate;
@end
