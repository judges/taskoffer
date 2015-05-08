//
//  SLFriendRequestValidateViewController.m
//  TaskOffer
//
//  Created by wshaolin on 15/3/23.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLFriendRequestValidateViewController.h"
#import "UIBarButtonItem+Image.h"
#import "MBProgressHUD+Conveniently.h"
#import "SLTaskHandler.h"

@interface SLFriendRequestValidateViewController ()

@property (nonatomic, strong) UITextField *textField;

@end

@implementation SLFriendRequestValidateViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
        self.title = @"好友验证";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"发送" target:self action:@selector(didClickSendBarButtonItem:)];
    
    [self.view addSubview:self.textField];
    
    [self.textField becomeFirstResponder];
}

- (UITextField *)textField{
    if(_textField == nil){
        _textField = [[UITextField alloc] init];
        _textField.placeholder = @"请输入验证信息...";
        _textField.frame = CGRectMake(0, 80.0, self.view.bounds.size.width, 50.0);
        _textField.layer.borderWidth = 0.5;
        _textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.font = [UIFont systemFontOfSize:16.0];
        
        UIView *leftView = [[UIView alloc] init];
        leftView.frame = CGRectMake(0, 0, 10.0, 0);
        _textField.leftView = leftView;
        _textField.leftViewMode = UITextFieldViewModeAlways;
        
        UIView *rightView = [[UIView alloc] init];
        rightView.frame = leftView.frame;
        _textField.rightView = rightView;
        _textField.rightViewMode = UITextFieldViewModeAlways;
    }
    return _textField;
}

- (void)didClickSendBarButtonItem:(UIBarButtonItem *)barButtonItem{
    [SLTaskHandler addFriendWithUserID:self.userID andSendRequestContent:self.textField.text];
    
    [MBProgressHUD showWithMessage:nil inView:self.view];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideForView:self.view];
        [MBProgressHUD showWithSuccess:@"请求已发送！" durationTimeInterval:1.0];
        [self.navigationController popViewControllerAnimated:YES];
    });
}


@end
