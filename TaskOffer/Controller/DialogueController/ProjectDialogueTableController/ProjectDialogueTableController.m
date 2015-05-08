//
//  ProjectDialogueTableController.m
//  TaskOffer
//
//  Created by BourbonZ on 15/4/10.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "ProjectDialogueTableController.h"
#import "ProjectDialogueTable.h"
#import "SingleChatController.h"
#import "ProjectDialogueDataBaseHelper.h"
#import "ProjectDialogueInfoController.h"
@interface ProjectDialogueTableController ()<ProjectDialogueTableDelegate>

@end

@implementation ProjectDialogueTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"项目聊天列表";
    
    ProjectDialogueTable *projectTable = [[ProjectDialogueTable alloc] initWithFrame:self.view.frame style:(UITableViewStylePlain)];
    [projectTable setProjectDialogueDelegate:self];
    [self.view addSubview:projectTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark 点击项目接包的某一行
-(void)clickProjectDialogueTable:(ProjectDialogue *)dialogue
{
    ProjectDialogueInfo *project = [[ProjectDialogueDataBaseHelper sharedHelper] selectProjectInfo:dialogue.projectID];
    
    if ([project.projectCreaterID isEqualToString:[[UserInfo sharedInfo] userID]])
    {
        ///我发的包
        ProjectDialogueInfoController *info = [[ProjectDialogueInfoController alloc] init];
        info.projectID = dialogue.projectID;
        [self.navigationController pushViewController:info animated:YES];
    }
    else
    {
        ///我接的包
        SingleChatController *single = [[SingleChatController alloc] init];
        NSString *currentUserName = dialogue.messageReceiver;
        if ([currentUserName isEqualToString:kDefaultJID.user])
        {
            currentUserName = dialogue.messageSender;
        }
        single.currentUserName = currentUserName;
        single.projectOwner = dialogue.messageReceiver;
        single.projectName = dialogue.messageSender;
        single.projectID = dialogue.projectID;
        [self.navigationController pushViewController:single animated:YES];

    }
    

}
@end
