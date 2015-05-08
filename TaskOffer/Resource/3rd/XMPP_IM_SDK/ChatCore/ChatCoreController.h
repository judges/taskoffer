//
//  ChatCoreController.h
//  rndIM
//
//  Created by BourbonZ on 14/12/4.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import "BaseViewController.h"
#import "KeyBordVIew.h"
#import "ChartMessage.h"
#import "ChartCellFrame.h"
#import "ChartCell.h"
#import "KeyBordVIew.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "XMPPHelper.h"
#import "ZYQAssetPickerController.h"
#import "TimeHelper.h"

@interface ChatCoreController : BaseViewController<UITableViewDataSource,UITableViewDelegate,KeyBordVIewDelegate,ChartCellDelegate,AVAudioPlayerDelegate,UITextFieldDelegate,ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) KeyBordVIew *keyBordView;
@property (nonatomic,strong) NSMutableArray *cellFrames;
@property (nonatomic,assign) BOOL recording;
@property (nonatomic,strong) NSString *fileName;
@property (nonatomic,weak) NSString *amrFile;
@property (nonatomic,strong) AVAudioRecorder *recorder;
@property (nonatomic,strong) AVAudioPlayer *player;
@property (nonatomic,strong) UIImageView *voiceImageView;


@property (nonatomic,assign) BOOL popToRoot;
@property (nonatomic,weak) NSIndexPath *currendIndex;
@property (nonatomic,strong) NSMutableArray *itemMessageArray;

-(void)KeyBordView:(KeyBordVIew *)keyBoardView textFiledReturn:(UITextField *)textFiled;
-(void)tableViewScrollCurrentIndexPath;
-(void)initwithData;
-(void)clickChatRightButton:(UIButton *)button;
///选择完照片
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets;
///发送消息
-(void)sendMessageWithChatMessage:(ChartMessage *)message;
///停止录音
-(void)finishRecord;
///表情键盘上的发送按钮
-(void)faceViewSendButton;
-(void)finalSend;
-(void)finalSendImage:(NSArray *)imageArray;

///点击的是对方的头像
-(void)clickOtherIcon:(ChartCell *)cell;
///点击的是自己的头像
-(void)clickMyIcon:(ChartCell *)cell;
-(void)beginRecord;
///多选删除数据
-(void)deleteMessagesWithTags;
@end
