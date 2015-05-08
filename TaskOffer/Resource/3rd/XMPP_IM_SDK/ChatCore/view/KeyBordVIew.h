//
//  KeyBordVIew.h
//  气泡
//
//  Created by zzy on 14-5-13.
//  Copyright (c) 2014年 zzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KeyBordVIew;

@protocol KeyBordVIewDelegate <NSObject>

-(void)KeyBordView:(KeyBordVIew *)keyBoardView textFiledReturn:(UITextField *)textFiled;
-(void)KeyBordView:(KeyBordVIew *)keyBoardView textFiledBegin:(UITextField *)textFiled;
-(void)KeyBordView:(KeyBordVIew *)keyBoardView addButtonClick:(UIButton *)addButton;
-(void)KeyBordView:(KeyBordVIew *)keyBoardView faceButtonClick:(UIButton *)faceButton;
-(void)KeyBordView:(KeyBordVIew *)keyBoardView voiceButtonClick:(UIButton *)voice;
-(void)KeyBordViewDelButtonClick:(KeyBordVIew *)keyBoardView;
-(void)beginRecord;
-(void)finishRecord;
@end

@interface KeyBordVIew : UIView<UITextFieldDelegate>
@property (nonatomic,weak) id<KeyBordVIewDelegate>delegate;
@property (nonatomic,strong) UIButton *voiceBtn;
@property (nonatomic,strong) UIButton *imageBtn;
@property (nonatomic,strong) UIButton *addBtn;
@property (nonatomic,strong) UIButton *speakBtn;
@property (nonatomic,strong) UITextField *textField;

@end
