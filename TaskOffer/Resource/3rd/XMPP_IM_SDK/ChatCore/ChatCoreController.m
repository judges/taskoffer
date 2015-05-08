//
//  ChatCoreController.m
//  rndIM
//
//  Created by BourbonZ on 14/12/4.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import "ChatCoreController.h"
#import "FaceView.h"
#import "AddView.h"
#import "VoiceConverter.h"
#define kFACE          9001
#define kDelete        @"faceDelete"
#define kPlaceImage    @"     "
#define kShowFace      @"faceViewShow"
#define kHideFace      @"faceViewHide"
#define kShowAdd       @"addViewShow"
#define kHideAdd       @"addViewHide"
//#import "SearchTextController.h"
#import "ToolHelper.h"
#import "SLHttpRequestHandler.h"
#import "MJPhotoBrowser.h"
#import "NSString+DocumentPath.h"
#import "XMPPFileHelper.h"
#import "MJRefresh.h"
#import "ProjectInfoController.h"
#import "EnterpriseInfoController.h"
#import "TOHttpHelper.h"
#import "SLConnectionDetailViewController.h"
#import "SLCaseDetailViewController.h"
@interface ChatCoreController ()<clickFaceViewDelegate,addViewDelegate>
{
    FaceView *face;
    AddView *addView;
    NSMutableArray *faceArray;

    NSTimer *soundTimer;
    int soundTime;
    NSTimer *spearTimer;
    UIBarButtonItem *infoButton;
    UIBarButtonItem *cancleButton;
    UIView *backView;
    
}

@end
static NSString *const cellIdentifier=@"Chart";


@implementation ChatCoreController
@synthesize popToRoot;
@synthesize itemMessageArray;
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(faceViewShow:) name:kShowFace object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(faceViewHide:) name:kHideFace object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(faceViewShow:) name:kShowAdd object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(faceViewHide:) name:kHideAdd object:nil];
    //初始化数据
    [self initwithData];
    [self.tableView reloadData];
    
    ///创建下方删除按钮
    backView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-40+64, self.view.frame.size.width, 40)];
    backView.backgroundColor = [UIColor whiteColor];
    UIButton *deleteAllButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [deleteAllButton setFrame:CGRectMake((self.view.frame.size.width-100)/2, 5, 100, 30)];
    [deleteAllButton setTitle:@"删除全部" forState:(UIControlStateNormal)];
    [deleteAllButton setBackgroundColor:[UIColor redColor]];
    deleteAllButton.layer.cornerRadius = 15.0f;
    deleteAllButton.layer.masksToBounds = NO;
    [deleteAllButton addTarget:self action:@selector(_deleteAllMessage:) forControlEvents:(UIControlEventTouchUpInside)];
    [backView addSubview:deleteAllButton];

    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.voiceImageView removeFromSuperview];
    self.voiceImageView = nil;
    [soundTimer invalidate];
    [spearTimer invalidate];
    
    
    [face removeFromSuperview];
    [addView removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kShowFace object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kHideFace object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kShowAdd object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kHideAdd object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];

    [backView removeFromSuperview];
    backView = nil;

    if (self.recording != YES)
    {
        return;
    }
    
    self.recording=NO;
    [self.recorder stop];
    self.recorder=nil;
    



}
-(void)goBackToTop
{
    if (popToRoot)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
//    else
//    {
//        [super goBackToTop];
//    }

}
///激活表格
-(void)setNewTable:(CGFloat)deltaY
{
    [self.tableView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-deltaY-64+20)];
    [self.keyBordView setFrame:CGRectMake(0, self.tableView.frame.origin.y + self.tableView.frame.size.height, self.view.frame.size.width, self.keyBordView.frame.size.height)];
}
///归为表格
-(void)setOrginTable
{
    [self.tableView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64+20)];
    [self.keyBordView setFrame:CGRectMake(0, self.tableView.frame.origin.y + self.tableView.frame.size.height, self.view.frame.size.width, self.keyBordView.frame.size.height)];}

-(void)keyboardShow:(NSNotification *)note
{
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY=keyBoardRect.size.height;
    float time = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    
    [UIView animateWithDuration:time animations:^{
        
//        self.view.transform = CGAffineTransformMakeTranslation(0, -deltaY);
        
        [self setNewTable:deltaY];
        
//        int tableHeight = self.view.frame.size.height - 44;
//        self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, tableHeight-deltaY);
//        self.keyBordView.transform = CGAffineTransformMakeTranslation(0, -deltaY);
//        [self tableViewScrollCurrentIndexPath];
        
    } completion:^(BOOL finished) {
        
        [self tableViewScrollCurrentIndexPath];
        
    }];
}
-(void)keyboardHide:(NSNotification *)note
{
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
//        self.view.transform = CGAffineTransformIdentity;
        [self setOrginTable];
        
//        self.keyBordView.transform = CGAffineTransformIdentity;
//        int tableHeight = self.view.frame.size.height - 44;
//        self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, tableHeight);

    }];
}
-(void)faceViewShow:(NSNotification *)notify
{
    
    CGRect keyBoardRect = CGRectMake(0, 352, 320, 216-80);
    CGFloat deltaY=keyBoardRect.size.height;
    
    [UIView animateWithDuration:0.25f animations:^{
        
        [self setNewTable:deltaY];
//        self.view.transform=CGAffineTransformMakeTranslation(0, -deltaY);

    } completion:^(BOOL finished) {
        if ([notify.name isEqualToString:kShowFace])
        {
            [addView removeFromSuperview];
            [self.view.window addSubview:face];
        }
        else if([notify.name isEqualToString:kShowAdd])
        {
            [face removeFromSuperview];
            [self.view.window addSubview:addView];
        }
        [self tableViewScrollCurrentIndexPath];
    }];

}
-(void)faceViewHide:(NSNotification *)notify
{
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.25f animations:^{
        
//        self.view.transform = CGAffineTransformIdentity;
        [self setOrginTable];
        [face removeFromSuperview];
        [addView removeFromSuperview];
    }];
}
-(void)_deleteAllMessage:(UIButton *)button
{
    [self deleteMessagesWithTags];
}
-(void)deleteMessagesWithTags
{

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithHexString:kDefaultBackColor];
    
    //add UItableView
//    int tableHeight = self.view.frame.size.height - 44-64;
    int tableHeight = self.view.frame.size.height-44;
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, tableHeight) style:UITableViewStylePlain];
    [self.tableView registerClass:[ChartCell class] forCellReuseIdentifier:cellIdentifier];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
    self.tableView.backgroundView = [[TouchImageView alloc] initWithImage:[UIImage imageNamed:@"chat_bg_default.jpg"]];
//    self.tableView.backgroundColor = [UIColor colorWithHexString:kDefaultBackColor];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.tableView.allowsSelectionDuringEditing = YES;
    [self.view addSubview:self.tableView];
    [self.tableView addHeaderWithTarget:self action:@selector(pullTableWithCoreData)];
    
    //add keyBorad
    
    self.keyBordView=[[KeyBordVIew alloc]initWithFrame:CGRectMake(0, tableHeight, self.view.frame.size.width, 44)];
    self.keyBordView.delegate=self;
    [self.view addSubview:self.keyBordView];
    
    face = [FaceView sharedFaceView];
    face.delegate = self;
    faceArray = [NSMutableArray array];
    addView = [AddView sharedAddView];
    addView.delegate = self;
    
    infoButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"个人"] style:(UIBarButtonItemStylePlain) target:self action:@selector(clickChatRightButton:)];
    self.navigationItem.rightBarButtonItem = infoButton;
    cancleButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemCancel) target:self action:@selector(clickCancelButton)];
}
///下拉加载
-(void)pullTableWithCoreData
{
//    [self getDataFromServerPage:0 rows:10];
    [self.tableView headerEndRefreshing];
}
-(void)clickCancelButton
{
    [self.tableView setEditing:NO animated:YES];
    self.navigationItem.rightBarButtonItem = infoButton;
    [backView removeFromSuperview];
}
-(void)clickChatRightButton:(UIButton *)button
{
    
}
-(void)clickSearchButton:(UIButton *)button
{
//    SearchTextController *search = [[SearchTextController alloc] init];
//    [self.navigationController pushViewController:search animated:YES];
}
-(void)initwithData
{
    [self tableViewScrollCurrentIndexPath];
}
#pragma mark UItableview Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellFrames.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChartCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.delegate=self;
    cell.tag = indexPath.row;
    cell.cellFrame=self.cellFrames[indexPath.row];
    [cell setChecked:cell.cellFrame.isChecked];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
   
    [TOHttpHelper getUrl:kTOgetInfo parameters:@{@"id":cell.chartView.chartMessage.userID,@"type":@"1"} showHUD:NO success:^(NSDictionary *dataDictionary) {
       
        NSString *path = [[[dataDictionary objectForKey:@"info"] objectForKey:@"ServerAppUser"] objectForKey:@"userHeadPicture"];
        path = [NSString stringWithFormat:@"%@%@/%@",kTOHOSt,kTOUploadUserIcon,path];
        [cell.icon sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:kDefaultIcon options:(SDWebImageContinueInBackground)];
        cell.nameLabel.text = [[[dataDictionary objectForKey:@"info"] objectForKey:@"ServerAppUser"] objectForKey:@"userName"];
        
    }];
    
    if (cell.chartView.chartMessage.audioDuration.intValue > 0) {
        cell.chartView.soundWaveImg.hidden = NO;
    }
    else
    {
        cell.chartView.soundWaveImg.hidden = YES;
    }
    
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChartCellFrame *frame = [self.cellFrames objectAtIndex:indexPath.row];
    return [frame cellHeight];
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableView.editing)
    {
        if (itemMessageArray == nil)
        {
            itemMessageArray = [NSMutableArray array];
        }
        if ([itemMessageArray containsObject:indexPath])
        {
            [itemMessageArray removeObject:indexPath];
        }
        else
        {
            [itemMessageArray addObject:indexPath];
        }
        
        ChartCell *cell = (ChartCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.cellFrame.isChecked = !cell.cellFrame.isChecked;
        [cell setChecked:cell.cellFrame.isChecked];
    }
}
#pragma mark
-(void)chartCell:(ChartCell *)chartCell tapContent:(NSString *)content
{
    if(self.player.isPlaying){
        
        [self.player stop];
        return;
    }
    
    if (chartCell.chartView.picView.image != nil)
    {
        ///点击的如果是图片
        MJPhoto *photo = [[MJPhoto alloc] init];
        NSString *urlStr = chartCell.chartView.chartMessage.content;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[urlStr dataUsingEncoding:NSUTF8StringEncoding] options:(NSJSONReadingMutableLeaves) error:nil];
        if (dict != nil)
        {
            urlStr = [dict objectForKey:@"content"];
        }
        
//        urlStr = [urlStr stringByReplacingOccurrencesOfString:@".jpg" withString:@"_org.jpg"];
        
        NSString *type = [urlStr substringFromIndex:urlStr.length-4];
        NSString *last = [type stringByReplacingOccurrencesOfString:@"/thumb" withString:@""];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:type withString:last];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"/thumb" withString:@""];
        photo.url = [NSURL URLWithString:urlStr];
        photo.index = 0;
        NSArray *array = @[photo];
        MJPhotoBrowser *photoBrowser = [[MJPhotoBrowser alloc] init];
        photoBrowser.photos =array;
        photoBrowser.currentPhotoIndex =0;
        [photoBrowser show];
        
    }
    else
    {
        ///如果是录音，但是可能是文字

        //播放
        NSString *filePath=[NSString documentPathWith:content];
        NSLog(@"%@",filePath);
        NSURL *fileUrl=[NSURL fileURLWithPath:filePath];
        [self initPlayer];
        NSError *error;
        self.player=[[AVAudioPlayer alloc]initWithContentsOfURL:fileUrl error:&error];
        [self.player setVolume:1];
        [self.player prepareToPlay];
        [self.player setDelegate:self];
        [self.player play];
        [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    }
    
}
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [[UIDevice currentDevice]setProximityMonitoringEnabled:NO];
    [self.player stop];
    self.player=nil;
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    [face removeFromSuperview];
    [addView removeFromSuperview];
    BOOL imageBOOL = self.keyBordView.imageBtn.selected;
    BOOL addBOOL = self.keyBordView.addBtn.selected;
    if (imageBOOL || addBOOL)
    {
        [UIView animateWithDuration:0.25f animations:^{
//            self.view.transform = CGAffineTransformIdentity;
            [self setOrginTable];
        } completion:^(BOOL finished) {
            [self.keyBordView.imageBtn setSelected:NO];
            [self.keyBordView.addBtn setSelected:NO];
        }];
    }
}
-(void)KeyBordView:(KeyBordVIew *)keyBoardView textFiledReturn:(UITextField *)textFiled
{
    
}
-(void)KeyBordView:(KeyBordVIew *)keyBoardView textFiledBegin:(UITextField *)textFiled
{
    
    [self tableViewScrollCurrentIndexPath];
    
}
-(void)KeyBordView:(KeyBordVIew *)keyBoardView addButtonClick:(UIButton *)addButton
{
    [face removeFromSuperview];
    if (self.keyBordView.addBtn.selected == NO)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kShowAdd object:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kHideAdd object:nil];
    }
    
    [self tableViewScrollCurrentIndexPath];
}
-(void)KeyBordView:(KeyBordVIew *)keyBoardView faceButtonClick:(UIButton *)faceButton
{
    [addView removeFromSuperview];
    if (self.keyBordView.imageBtn.selected == NO)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kShowFace object:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kHideFace object:nil];
    }

    [self tableViewScrollCurrentIndexPath];
}
-(void)KeyBordView:(KeyBordVIew *)keyBoardView voiceButtonClick:(UIButton *)voice
{    
    [self.keyBordView.imageBtn setSelected:NO];
    if (voice.selected)
    {
        [voice setSelected:NO];
        [self.keyBordView.textField becomeFirstResponder];
    }
    else
    {
        [UIView animateWithDuration:0.25f animations:^{
            
            self.view.transform = CGAffineTransformIdentity;
            [face removeFromSuperview];
            [addView removeFromSuperview];
            
        } completion:^(BOOL finished) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kHideFace object:nil];

        }];
 
    }
}
///表情键盘上的发送按钮
-(void)clickFaceViewSendButton
{
    [self faceViewSendButton];
}
-(void)faceViewSendButton
{

}
-(void)beginRecord
{
    if(self.recording)return;
    
    if (self.voiceImageView == nil)
    {
        self.voiceImageView = [[TouchImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-107/2, self.view.frame.size.height-195, 107, 155)];
        [self.view.window addSubview:self.voiceImageView];
    }
    
    self.recording=YES;
    
    NSDictionary *settings=[NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithFloat:8000],AVSampleRateKey,
                            [NSNumber numberWithInt:kAudioFormatLinearPCM],AVFormatIDKey,
                            [NSNumber numberWithInt:1],AVNumberOfChannelsKey,
                            [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                            [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,
                            [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                            nil];
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error: nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];

    NSString *fileName = [NSString stringWithFormat:@"%@.wav",[ToolHelper deviceUUID]];
    self.fileName=fileName;
    NSString *filePath=[NSString documentPathWith:fileName];
    NSURL *fileUrl=[NSURL fileURLWithPath:filePath];
    NSError *error;
    self.recorder=[[AVAudioRecorder alloc]initWithURL:fileUrl settings:settings error:&error];
    [self.recorder prepareToRecord];
    [self.recorder setMeteringEnabled:YES];
    [self.recorder peakPowerForChannel:0];
    [self.recorder record];
    
    ///开始录音
    soundTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(stopRecord) userInfo:nil repeats:NO];
    spearTimer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(updateVoiceImage) userInfo:nil repeats:YES];
}
-(void)stopRecord
{
    DLog(@"录音结束了");
    [self finishRecord];
}
-(void)finishRecord
{
    [self.voiceImageView removeFromSuperview];
    self.voiceImageView = nil;
    [soundTimer invalidate];
    [spearTimer invalidate];
    
    if (self.recording != YES)
    {
        return;
    }
    
    self.recording=NO;
    [self.recorder stop];
    self.recorder=nil;
    self.amrFile = [self.fileName stringByReplacingOccurrencesOfString:@".wav" withString:@".amr"];
    NSString *wav = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@",self.fileName];
    NSString *amr = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@",self.amrFile];
    [VoiceConverter wavToAmr:wav amrSavePath:amr];
}
//波动图片
-(void)updateVoiceImage
{
    [self.recorder updateMeters];//刷新音量数据
    //获取音量的平均值  [recorder averagePowerForChannel:0];
    //音量的最大值  [recorder peakPowerForChannel:0];
    
    double lowPassResults = pow(10, (0.05 * [self.recorder peakPowerForChannel:0]));
    //最大50  0
    //图片 小-》大
    if (0<lowPassResults<=0.06) {
        [self.voiceImageView setImage:[UIImage imageNamed:@"record_animate_01.png"]];
    }else if (0.06<lowPassResults<=0.13) {
        [self.voiceImageView setImage:[UIImage imageNamed:@"record_animate_02.png"]];
    }else if (0.13<lowPassResults<=0.20) {
        [self.voiceImageView setImage:[UIImage imageNamed:@"record_animate_03.png"]];
    }else if (0.20<lowPassResults<=0.27) {
        [self.voiceImageView setImage:[UIImage imageNamed:@"record_animate_04.png"]];
    }else if (0.27<lowPassResults<=0.34) {
        [self.voiceImageView setImage:[UIImage imageNamed:@"record_animate_05.png"]];
    }else if (0.34<lowPassResults<=0.41) {
        [self.voiceImageView setImage:[UIImage imageNamed:@"record_animate_06.png"]];
    }else if (0.41<lowPassResults<=0.48) {
        [self.voiceImageView setImage:[UIImage imageNamed:@"record_animate_07.png"]];
    }else if (0.48<lowPassResults<=0.55) {
        [self.voiceImageView setImage:[UIImage imageNamed:@"record_animate_08.png"]];
    }else if (0.55<lowPassResults<=0.62) {
        [self.voiceImageView setImage:[UIImage imageNamed:@"record_animate_09.png"]];
    }else if (0.62<lowPassResults<=0.69) {
        [self.voiceImageView setImage:[UIImage imageNamed:@"record_animate_10.png"]];
    }else if (0.69<lowPassResults<=0.76) {
        [self.voiceImageView setImage:[UIImage imageNamed:@"record_animate_11.png"]];
    }else if (0.76<lowPassResults<=0.83) {
        [self.voiceImageView setImage:[UIImage imageNamed:@"record_animate_12.png"]];
    }else if (0.83<lowPassResults<=0.9) {
        [self.voiceImageView setImage:[UIImage imageNamed:@"record_animate_13.png"]];
    }else {
        [self.voiceImageView setImage:[UIImage imageNamed:@"record_animate_14.png"]];
    }
}

-(void)tableViewScrollCurrentIndexPath
{
    if (self.cellFrames.count > 0)
    {
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:self.cellFrames.count-1 inSection:0];
//        float height = [self tableView:self.tableView heightForRowAtIndexPath:indexPath];
//        [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, height, 0)];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}
-(void)initPlayer{
    //初始化播放器的时候如下设置
    UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory,
                            sizeof(sessionCategory),
                            &sessionCategory);
    
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,
                             sizeof (audioRouteOverride),
                             &audioRouteOverride);
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    //默认情况下扬声器播放
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    audioSession = nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma 点击界面上的表情
-(void)clickFaceViewItem:(UIImage *)image withName:(NSString *)imageName
{
 
    if (![imageName isEqualToString:kDelete])
    {
        NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"facemap" ofType:@"json"]];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
        NSArray *array = [dict allValues];
        NSUInteger num = [array indexOfObject:imageName];
        NSString *key = [[dict allKeys] objectAtIndex:num];
        self.keyBordView.textField.text = [self.keyBordView.textField.text stringByAppendingString:key];
    }
    else
    {
//        [self deleteButtonClick];
        if(self.keyBordView.textField.text.length > 0)
        {
            self.keyBordView.textField.text = [self.keyBordView.textField.text substringToIndex:(self.keyBordView.textField.text.length -1)];
            
        }
    }
}
#pragma textFieldDelegate
-(void)KeyBordViewDelButtonClick:(KeyBordVIew *)keyBoardView
{
    [self deleteButtonClick];
}
-(void)deleteButtonClick
{
    if(self.keyBordView.textField.text.length > 0)
    {
        self.keyBordView.textField.text = [self.keyBordView.textField.text substringToIndex:(self.keyBordView.textField.text.length )];
        
    }
}
#pragma mark 发送消息
///发送消息
-(void)sendMessageWithChatMessage:(ChartMessage *)message
{
    ChartCellFrame *cellFrame=[[ChartCellFrame alloc]init];
    cellFrame.chartMessage = message;
    [self.cellFrames addObject:cellFrame];
    [self.tableView reloadData];
    [self tableViewScrollCurrentIndexPath];
}

#pragma  mark AddViewDelegat
-(void)clickAddViewWithPhoto
{
    ///点击之后进入相册
    
    if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeCamera)])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        [picker setDelegate:self];
        [picker setAllowsEditing:YES];
        [picker setSourceType:(UIImagePickerControllerSourceTypeCamera)];
        [picker setShowsCameraControls:YES];
        
        [addView removeFromSuperview];
        [self presentViewController:picker animated:YES completion:^{
            [self.keyBordView.addBtn setSelected:NO];
            [self.keyBordView.voiceBtn setSelected:YES];
            [self setOrginTable];
        }];
    }
    else
    {
        [HUDView showHUDWithText:@"相机不可用"];
        
    }
    

}
-(void)clickAddViewWithTake
{
    ///点击之后进入照相
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.maximumNumberOfSelection = 3;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups = NO;
    picker.delegate = self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([[(ALAsset *)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo])
        {
            NSTimeInterval duration = [[(ALAsset *)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 5;
        } else {
            return YES;
        }
    }];
    [addView removeFromSuperview];
    [self presentViewController:picker animated:YES completion:^{
        [self.keyBordView.addBtn setSelected:NO];
        [self setOrginTable];
    }];
}
-(void)clickAddViewWithVcard
{
    ///点击发送名片
//    [[XMPPFileHelper shared] checkServerProxy];
}
#pragma mark ImagePicker Delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *tempImg = [info objectForKey:UIImagePickerControllerEditedImage];
    NSMutableArray *tmpArray = [NSMutableArray array];
    NSData *data = UIImageJPEGRepresentation(tempImg, 1.0f);
    NSString *picName = [NSString stringWithFormat:@"%f",[NSDate timeIntervalSinceReferenceDate]];
    
    NSString *fileName = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@.jpg",picName];
    if ([data writeToFile:fileName atomically:YES])
    {
        SLHttpFileData *imageData = [[SLHttpFileData alloc] init];
        [imageData setData:data];
        NSString *name = [NSString stringWithFormat:@"%@.jpg",picName];
        [imageData setParameterName:name];
        [imageData setFileName:name];
        [imageData setMimeType:@"image/jpeg"];
        
        [tmpArray addObject:imageData];
        
        [self finalSendImage:tmpArray];
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark ZYQAssetPickerController Delegate
-(void)assetPickerControllerDidMaximum:(ZYQAssetPickerController *)picker
{
    [HUDView showHUDWithText:@"选择数目已经达到最大"];
    
}
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{    
    NSMutableArray *tmpArray = [NSMutableArray array];
    for (int i=0; i<assets.count; i++)
    {
        NSData *data = assets[i];
        NSString *picName = [NSString stringWithFormat:@"%f",[NSDate timeIntervalSinceReferenceDate]];
        
        NSString *fileName = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@.jpg",picName];
        if ([data writeToFile:fileName atomically:YES])
        {
            SLHttpFileData *imageData = [[SLHttpFileData alloc] init];
            [imageData setData:data];
            NSString *name = [NSString stringWithFormat:@"%@.jpg",picName];
            [imageData setParameterName:name];
            [imageData setFileName:name];
            [imageData setMimeType:@"image/jpeg"];
            
            [tmpArray addObject:imageData];
        }
    }
    [self finalSendImage:tmpArray];
}
-(void)assetPickerControllerDidCancel:(ZYQAssetPickerController *)picker
{

}

#pragma 图片加载完整后刷新
-(void)reloadCellInputView:(ChartCell *)chartCell
{
    NSIndexPath *index    = [self.tableView indexPathForCell:chartCell];
    if (index != nil)
    {
        ChartCellFrame *frame = [self.cellFrames objectAtIndex:index.row];
        [frame setCellHeight:chartCell.cellFrame.cellHeight];
        [self.cellFrames replaceObjectAtIndex:index.row withObject:frame];
    }
}
///最后发送文本
-(void)finalSend
{
    
}
///最后发送图片
-(void)finalSendImage:(NSArray *)imageArray
{
    
}

#pragma mark 点击头像
///点击头像
-(void)clickChatIcon:(ChartCell *)cell
{
    if (cell.cellFrame.chartMessage.messageType == kMessageFrom)
    {
        ///消息来自对方
        [self clickOtherIcon:cell];
    }
    else
    {
        ///点击的是自己的头像
        [self clickMyIcon:cell];
    }
}
-(void)clickOtherIcon:(ChartCell *)cell
{
    
}
-(void)clickMyIcon:(ChartCell *)cell
{

}
-(void)clickEditItemWithLongPress:(ChartCell *)cell
{
    [self.tableView setEditing:YES animated:YES];

    self.navigationItem.rightBarButtonItem = cancleButton;

    [self.view.window addSubview:backView];
}
///点击推荐的内容
-(void)clickChartItem:(ChartCell *)chartCell taoContentID:(NSString *)contentID andType:(NSString *)type
{
    if ([type isEqualToString:kCard])
    {
        SLConnectionDetailViewController *detail = [[SLConnectionDetailViewController alloc] init];
        detail.userID = contentID;
        [self.navigationController pushViewController:detail animated:YES];
    }
    else if ([type isEqualToString:kCompany])
    {
        
        [TOHttpHelper getUrl:kTOGetCompanyInfo parameters:@{@"companyId":contentID,@"userId":[[UserInfo sharedInfo] userID]} showHUD:YES success:^(NSDictionary *dataDictionary) {
           
            EnterpriseInfoController *info = [[EnterpriseInfoController alloc] init];
            
            EnterpriseInfo *companyInfo = [[EnterpriseInfo alloc] init];
            [companyInfo setEnterpriseDict:dataDictionary];
            info.companyInfo = companyInfo;
            info.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:info animated:YES];

            
        }];
    }
    else if ([type isEqualToString:kCase])
    {
        SLCaseDetailViewController *caseView = [[SLCaseDetailViewController alloc] init];
        caseView.caseID = contentID;
        [self.navigationController pushViewController:caseView animated:YES];
    }
    else if ([type isEqualToString:kProject])
    {
        ProjectInfoController *project = [[ProjectInfoController alloc] init];
        project.projectID = contentID;
        [self.navigationController pushViewController:project animated:YES];
    }
}

@end
