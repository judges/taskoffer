//
//  ProjectDialogueInfoController.m
//  TaskOffer
//
//  Created by BourbonZ on 15/4/14.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "ProjectDialogueInfoController.h"
#import "ProjectListTable.h"
#import "SingleChatController.h"
#import "ProjectDialogueInfo.h"
#import "ProjectDialogueDataBaseHelper.h"
@interface ProjectDialogueInfoController ()<ProjectListTableDelegate>

@end

@implementation ProjectDialogueInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ProjectDialogueInfo *info = [[ProjectDialogueDataBaseHelper sharedHelper] selectProjectInfo:_projectID];
    self.title = info.projectName;
    ProjectListTable *table = [[ProjectListTable alloc] initWithFrame:self.view.frame style:(UITableViewStylePlain)];
    table.projectID = _projectID;
    [table setProjectListDelegate:self];
    [self.view addSubview:table];
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
-(void)clickProjectListTableAtIndex:(ProjectDialogue *)dialogue
{
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
@end
