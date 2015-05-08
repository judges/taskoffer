//
//  KeyBordVIew.m
//  气泡
//
//  Created by zzy on 14-5-13.
//  Copyright (c) 2014年 zzy. All rights reserved.
//

#import "KeyBordVIew.h"
#import "ChartMessage.h"
#import "ChartCellFrame.h"
#import "UIImage+StrethImage.h"
@interface KeyBordVIew()<UITextFieldDelegate>
@property (nonatomic,strong) UIImageView *backImageView;
@end

@implementation KeyBordVIew

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initialData];
    }
    return self;
}

-(UIButton *)buttonWith:(NSString *)noraml hightLight:(NSString *)hightLight action:(SEL)action
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:noraml] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:hightLight] forState:UIControlStateHighlighted];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
-(void)initialData
{
    self.backImageView=[[UIImageView alloc]initWithFrame:self.bounds];
    [self addSubview:self.backImageView];
    
    self.voiceBtn=[self buttonWith:@"话筒.png" hightLight:@"话筒点击事件.png" action:@selector(voiceBtnPress:)];
    [self.voiceBtn setFrame:CGRectMake(7, 9, 30, 30)];
    [self addSubview:self.voiceBtn];
    
    self.textField=[[UITextField alloc]initWithFrame:CGRectMake(12+30, 6, self.frame.size.width - 14-20-30-14-7-35, self.frame.size.height*0.8)];
    self.textField.delegate = self;
    [self.textField setLeftViewMode:(UITextFieldViewModeAlways)];
    self.textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    self.textField.returnKeyType=UIReturnKeySend;
    self.textField.font=[UIFont fontWithName:@"HelveticaNeue" size:14];
    self.textField.placeholder=@"请输入...";
    self.textField.background = [UIImage strethImageWith:@"对话时用的输入框按住说话框.png"];
    self.textField.delegate=self;
    [self addSubview:self.textField];
    
    self.imageBtn=[self buttonWith:@"表情.png" hightLight:@"表情点击事件.png" action:@selector(imageBtnPress:)];
    [self.imageBtn setFrame:CGRectMake(self.frame.size.width - 60 - 14, 9, 30, 30)];
    [self addSubview:self.imageBtn];
    
    self.addBtn=[self buttonWith:@"更多.png" hightLight:@"更多点击事件.png" action:@selector(addBtnPress:)];
    [self.addBtn setFrame:CGRectMake(self.frame.size.width - 7 - 30, 9, 30, 30)];
    [self addSubview:self.addBtn];
    
    self.speakBtn = [self buttonWith:nil hightLight:nil action:@selector(speakBtnPress:)];
    [self.speakBtn setBackgroundImage:[UIImage strethImageWith:@"对话时用的输入框按住说话框.png"] forState:(UIControlStateNormal)];
    [self.speakBtn setTitle:@"按住说话" forState:UIControlStateNormal];
    [self.speakBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.speakBtn addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    [self.speakBtn setTitleColor:[UIColor redColor] forState:(UIControlState)UIControlEventTouchDown];
    [self.speakBtn setBackgroundColor:[UIColor whiteColor]];
    [self.speakBtn setFrame:self.textField.frame];
    self.speakBtn.hidden=YES;
    [self addSubview:self.speakBtn];
}
-(void)touchDown:(UIButton *)voice
{
    //开始录音
    if([self.delegate respondsToSelector:@selector(beginRecord)]){
    
        [self.delegate beginRecord];
    }
    NSLog(@"开始录音");
}
-(void)speakBtnPress:(UIButton *)voice
{
   //结束录音
    
    if([self.delegate respondsToSelector:@selector(finishRecord)]){
    
        [self.delegate finishRecord];
    }
    NSLog(@"结束录音");
}
-(void)voiceBtnPress:(UIButton *)voice
{
    NSString *normal,*hightLight;
    if(self.speakBtn.hidden==YES){
        
        self.speakBtn.hidden=NO;
        self.textField.hidden=YES;
        [self.textField resignFirstResponder];
       normal=@"键盘.png";
       hightLight=@"键盘点击事件.png";
    
    }else{
    
        self.speakBtn.hidden=YES;
        self.textField.hidden=NO;
        [self.textField becomeFirstResponder];
        normal=@"话筒.png";
        hightLight=@"话筒点击事件.png";
    
    }
    [voice setImage:[UIImage imageNamed:normal] forState:UIControlStateNormal];
    [voice setImage:[UIImage imageNamed:hightLight] forState:UIControlStateHighlighted];
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(KeyBordView:voiceButtonClick:)])
    {
        [self.delegate KeyBordView:self voiceButtonClick:voice];
    }
    voice.selected = voice.selected == YES ? NO : YES;
}
-(void)imageBtnPress:(UIButton *)image
{
    NSString *normal,*hightLight;
    self.speakBtn.hidden=YES;
    self.textField.hidden=NO;
    [self.textField becomeFirstResponder];
    normal=@"表情.png";
    hightLight=@"表情点击事件.png";
    
    [self.voiceBtn setImage:[UIImage imageNamed:normal] forState:UIControlStateNormal];
    [self.voiceBtn setImage:[UIImage imageNamed:hightLight] forState:UIControlStateHighlighted];

    [self.textField resignFirstResponder];
    if ([self.delegate respondsToSelector:@selector(KeyBordView:faceButtonClick:)])
    {
        [self.delegate KeyBordView:self faceButtonClick:image];
    }
    
    image.selected = image.selected == YES ? NO : YES;
}
-(void)addBtnPress:(UIButton *)image
{
    NSString *normal,*hightLight;
    self.speakBtn.hidden=YES;
    self.textField.hidden=NO;
    [self.textField becomeFirstResponder];
    normal=@"更多.png";
    hightLight=@"更多点击事件.png";
    
    [self.voiceBtn setImage:[UIImage imageNamed:normal] forState:UIControlStateNormal];
    [self.voiceBtn setImage:[UIImage imageNamed:hightLight] forState:UIControlStateHighlighted];

    [self.textField resignFirstResponder];
    
    
    if ([self.delegate respondsToSelector:@selector(KeyBordView:addButtonClick:)])
    {
        [self.delegate KeyBordView:self addButtonClick:image];
    }
    
    image.selected = image.selected == YES ? NO :YES;

}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if([self.delegate respondsToSelector:@selector(KeyBordView:textFiledBegin:)]){
        
        [self.delegate KeyBordView:self textFiledBegin:textField];
    }
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([self.delegate respondsToSelector:@selector(KeyBordView:textFiledReturn:)]){
    
        [self.delegate KeyBordView:self textFiledReturn:textField];
    }
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length == 0)
    {
        if ([self.delegate respondsToSelector:@selector(KeyBordViewDelButtonClick:)])
        {
            [self.delegate KeyBordViewDelButtonClick:self];
        }
    }
    return YES;
}
@end
