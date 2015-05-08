//
//  SetInfoViewController.m
//  TaskOffer
//
//  Created by BourbonZ on 15/4/3.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SetInfoViewController.h"
#import "ViewController.h"
@interface SetInfoViewController ()

@end

@implementation SetInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake(0, 10 + 64, self.view.frame.size.width, 40)];
    [textfield setTag:6001];
    [textfield setBackgroundColor:[UIColor whiteColor]];
    textfield.placeholder = self.controllerTitle;
    [textfield setLeftViewMode:(UITextFieldViewModeAlways)];
    textfield.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [textfield becomeFirstResponder];
    [self.view addSubview:textfield];

    
//    self.title = self.controllerTitle;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:(UIBarButtonItemStylePlain) target:self action:@selector(clickDoneButton)];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
-(void)clickDoneButton
{
    UITextField *textField = (UITextField *)[self.view viewWithTag:6001];
    if (textField.text == nil || textField.text.length == 0)
    {
        [HUDView showHUDWithText:@"输入信息不能为空"];
        return;
    }
    
    if (textField.text.length > 25)
    {
        [HUDView showHUDWithText:@"输入内容不能多于25个字"];
        return;

    }

    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(setInfoSuccess:withTag:)])
    {
        [self.delegate setInfoSuccess:textField.text withTag:self.tagTmp];
    }
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(setInfoSuccess:withKey:)])
    {
        [self.delegate setInfoSuccess:textField.text withKey:self.tmpKey];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
