//
//  FriendInfoController.m
//  XMPPIM
//
//  Created by BourbonZ on 15/1/15.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "FriendInfoController.h"
#import "MBProgressHUD.h"
#import "XMPPHelper.h"
//#import "ComplainController.h"
//#import "QRCodeController.h"
@interface FriendInfoController ()<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,xmppVcardHelperDelegate>
{
    MBProgressHUD *hud;
    UITableView *listTable;
    NSMutableArray *listArray;
    
    XMPPUserInfo *searchInfo;
    NSString *jidString;
}

@end

@implementation FriendInfoController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.friendType == friendInfo)
    {
        listTable.tableFooterView = [[UIView alloc] init];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.friendName;
    // Do any additional setup after loading the view from its nib.
    hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [hud setLabelText:@"正在加载"];
    [hud show:YES];
    [self.view addSubview:hud];
    
    XMPPVCardHelper *vCardHelper = [XMPPVCardHelper sharedHelper];
    [vCardHelper setDelegate:self];
    [vCardHelper fetchSomeBodyInfo:self.friendName];
    
    
    ///设置表格
    listTable                 = [[UITableView alloc] initWithFrame:self.view.frame style:(UITableViewStylePlain)];
    listTable.dataSource      = self;
    listTable.delegate        = self;
    UIView *delView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    UIButton *addFriendButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [addFriendButton setFrame:CGRectMake(10, 10, self.view.frame.size.width-20, 40)];
    [addFriendButton setTitle:@"添加好友" forState:(UIControlStateNormal)];
    [addFriendButton setTintColor:[UIColor whiteColor]];
    [addFriendButton setBackgroundColor:[UIColor greenColor]];
    addFriendButton.layer.cornerRadius = 10.0f;
    [delView addSubview:addFriendButton];
    [addFriendButton addTarget:self action:@selector(clickAddFriend:) forControlEvents:(UIControlEventTouchUpInside)];
    listTable.tableFooterView = delView;
    if (self.isFriend)
    {
        listTable.tableFooterView = [[UIView alloc] init];
    }
    [self.view addSubview:listTable];
    
    ///设置数组
    listArray = [NSMutableArray arrayWithObjects:@"锐达号",@"昵称",@"头像",@"二维码",@"地址区域",@"性别",@"邮箱",@"个性签名",@"手机号", nil];
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
///添加朋友按钮
- (void)clickAddFriend:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入验证信息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert setAlertViewStyle:(UIAlertViewStylePlainTextInput)];
    alert.tag = 9001;
    [alert setDelegate:self];
    [alert show];
}

#pragma mark UIAlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 9001)
    {
        NSString *message = [[alertView textFieldAtIndex:0] text];
        [XMPPHelper addFriend:self.friendName withMessage:message];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发送成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert setDelegate:self];
        [alert show];
    }
    else
    {

        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:cellID];
    }
    cell.textLabel.text = [listArray objectAtIndex:indexPath.row];
    
    if (indexPath.row == 0)
    {
        cell.detailTextLabel.text = jidString;
    }
    else if (indexPath.row == 1)
    {
        cell.detailTextLabel.text = searchInfo.nickname;
    }
    else if (indexPath.row == 2)
    {
        UIImage *image = [UIImage imageWithData:searchInfo.photo];
        if (image == nil)
        {
            image = kDefaultIcon;
        }
        cell.imageView.image = image;
    }
    else if (indexPath.row == 4)
    {
        NSArray *array = [searchInfo elementsForName:@"ADR"];
        DDXMLElement *element = [array lastObject];
        cell.detailTextLabel.text = element.stringValue;
    }
    else if (indexPath.row == 5)
    {
        cell.detailTextLabel.text = searchInfo.note;
    }
    else if (indexPath.row == 6)
    {
        NSArray *array = [searchInfo elementsForName:@"EMAIL"];
        DDXMLElement *element = [array lastObject];
        cell.detailTextLabel.text = element.stringValue;
    }
    else if (indexPath.row == 7)
    {
        cell.detailTextLabel.text = searchInfo.desc;
    }
    else if (indexPath.row == 8)
    {
        NSArray *array = [searchInfo elementsForName:@"TEL"];
        DDXMLElement *element = [array lastObject];
        cell.detailTextLabel.text = element.stringValue;
    }
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3)
    {
//        QRCodeController *qrCode = [[QRCodeController alloc] init];
//        qrCode.qrString = [kSingeChatSign stringByAppendingString:self.friendName];
//        [self.navigationController pushViewController:qrCode animated:YES];
    }
}
#pragma XMPPVCardHelper Delegate
-(void)fetchSuccessInfo:(XMPPUserInfo *)info andJID:(XMPPJID *)jid
{
    searchInfo = info;
    jidString = jid.description;

    [listTable reloadData];
}
@end

