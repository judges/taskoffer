//
//  FeedBackViewController.m
//  TaskOffer
//
//  Created by BourbonZ on 15/3/16.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "FeedBackViewController.h"
#import "SLTextView.h"
#import "TOHttpHelper.h"
@interface FeedBackViewController ()
{
    SLTextView *feedView;
}
@end

@implementation FeedBackViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification  object:nil];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"意见反馈";
    
    ///发送按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:(UIBarButtonItemStylePlain) target:self action:@selector(clickFeedBackButton)];
    
    ///反馈界面
    CGRect textViewFrame = self.view.bounds;
    textViewFrame.size.height = 240;
    feedView = [[SLTextView alloc] initWithFrame:textViewFrame];
    feedView.placeholder = @"请输入您的意见……";
    [self.view addSubview:feedView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewValueDidChange:) name:UITextViewTextDidChangeNotification object:feedView];
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
#pragma mark 反馈界面
- (void)textViewValueDidChange:(NSNotification *)notification{
    
}

- (void)keyboardDidChangeFrame:(NSNotification *)notification{
//    CGRect rect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    CGRect textViewFrame = feedView.frame;
//    textViewFrame.size.height = rect.origin.y - 64.0;
//    feedView.frame = textViewFrame;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark 发送意见反馈按钮
-(void)clickFeedBackButton
{
    if (feedView.text.length > 200)
    {
        [HUDView showHUDWithText:@"输入内容要不大于200个字"];
        
        return;
    }
    
    if (feedView.text.length > 0)
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:[[UserInfo sharedInfo] userID] forKey:@"userId"];
        [dict setObject:[[UserInfo sharedInfo] userName] forKey:@"userName"];
        [dict setObject:feedView.text forKey:@"feedbackContent"];
        [dict setObject:@"0" forKey:@"relationWayType"];
        [dict setObject:[[UserInfo sharedInfo] userPhone] forKey:@"relationWay"];
        [TOHttpHelper postUrl:kTOfeedbackInfo parameters:dict showHUD:YES success:^(NSDictionary *dataDictionary) {
            
            [HUDView showHUDWithText:@"感谢您的反馈"];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        } failure:^(NSError *error) {
            
        }];
    }
    else
    {
        [HUDView showHUDWithText:@"请先输入内容"];
        
    }
    
}
@end
