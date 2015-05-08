//
//  SLFriendCircleSendStatusViewController.m
//  XMPPIM
//
//  Created by wshaolin on 14/12/19.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import "SLFriendCircleSendStatusViewController.h"
#import "UIBarButtonItem+Image.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "SLFriendCircleSelectedImageView.h"
#import "SLTextView.h"
#import "SLRootTableView.h"
#import "SLFriendCircleSendStatusTableViewModel.h"
#import "SLFriendCircleSendStatusViewCell.h"
#import "ZYQAssetPickerController.h"
#import "SLFriendCirclePostionViewController.h"
#import "SLPostionModel.h"
#import "SLDynamicHTTPHandler.h"
#import "MBProgressHUD+Conveniently.h"
#import "SLHTTPFileData.h"
#import "SLActionSheet.h"
#import "NSString+Conveniently.h"
#import "UIImage+GWebP.h"

@interface SLFriendCircleSendStatusViewController()<
        UITableViewDataSource,
        UITableViewDelegate,
        SLFriendCircleSelectedImageViewDelegate,
        ZYQAssetPickerControllerDelegate,
        UINavigationControllerDelegate,
        SLActionSheetDelegate,
        UIImagePickerControllerDelegate,
        SLFriendCirclePostionViewControllerDelegate
        >

@property (nonatomic, strong) NSArray *selectedImages;
@property (nonatomic, strong) SLTextView *textView;
@property (nonatomic, strong) UIView *textBackgroundView;
@property (nonatomic, strong) SLFriendCircleSelectedImageView *selectedImageView;
@property (nonatomic, strong) SLRootTableView *tableView;
@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong, readonly) SLPostionModel *currentPostion;

@end

@implementation SLFriendCircleSendStatusViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if(self.assetPickerController.delegate == nil || self.assetPickerController.delegate != self){
        self.assetPickerController.delegate = self;
    }
}

- (NSArray *)dataArray{
    if(_dataArray == nil){
        // SLFriendCircleSendStatusTableViewModel *tableViewModel = [SLFriendCircleSendStatusTableViewModel modelWithTitle:@"所在位置" iconName:@"friendcircle_position"];
        // _dataArray = @[tableViewModel];
        _dataArray = @[];
    }
    return _dataArray;
}

- (SLTextView *)textView{
    if(_textView == nil){
        _textView = [[SLTextView alloc] init];
        _textView.placeholder = @"这一刻的想法...";
        _textView.placeholderOffset = CGPointMake(5.0, 8.0);
    }
    return _textView;
}

- (UIView *)textBackgroundView{
    if(_textBackgroundView == nil){
        _textBackgroundView = [[UIView alloc] init];
        _textBackgroundView.backgroundColor = [UIColor whiteColor];
        _textBackgroundView.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.2].CGColor;
        _textBackgroundView.layer.borderWidth = 0.5;
        [_textBackgroundView addSubview:self.textView];
    }
    return _textBackgroundView;
}

- (SLRootTableView *)tableView{
    if(_tableView == nil){
        _tableView = [[SLRootTableView alloc] initWithDefaultFrameStyle:UITableViewStylePlain dataSource:self delegate:self];
        _tableView.tableHeaderView = self.tableHeaderView;
    }
    return _tableView;
}

- (UIView *)tableHeaderView{
    if(_tableHeaderView == nil){
        _tableHeaderView = [[UIView alloc] init];
        [_tableHeaderView addSubview:self.textBackgroundView];
        [_tableHeaderView addSubview:self.selectedImageView];
    }
    return _tableHeaderView;
}

- (SLFriendCircleSelectedImageView *)selectedImageView{
    if(_selectedImageView == nil){
        _selectedImageView = [[SLFriendCircleSelectedImageView alloc] init];
        _selectedImageView.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.2].CGColor;
        _selectedImageView.layer.borderWidth = 0.5;
        _selectedImageView.delegate = self;
    }
    return _selectedImageView;
}

- (ZYQAssetPickerController *)assetPickerController{
    if(_assetPickerController == nil){
        _assetPickerController = [[ZYQAssetPickerController alloc] init];
        _assetPickerController.maximumNumberOfSelection = SLFriendCircleSendStatusWithImageCount;
        _assetPickerController.assetsFilter = [ALAssetsFilter allPhotos];
        _assetPickerController.showEmptyGroups = NO;
        _assetPickerController.delegate = self;
    }
    return _assetPickerController;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
        self.title = @"发布动态";
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"发布" target:self action:@selector(sendButtonClick)];
    
    [self.view addSubview:self.tableView];
    
    CGRect textBackgroundViewFrame = self.view.bounds;
    textBackgroundViewFrame.size.height = 158.0;
    self.textBackgroundView.frame = textBackgroundViewFrame;
    
    CGFloat textView_X = 5.0;
    CGFloat textView_Y = 5.0;
    CGFloat textView_W = textBackgroundViewFrame.size.width - textView_X * 2;
    CGFloat textView_H = textBackgroundViewFrame.size.height - textView_Y * 2;
    self.textView.frame = CGRectMake(textView_X, textView_Y, textView_W, textView_H);
    
    CGRect selectedImageViewFrame = self.view.bounds;
    selectedImageViewFrame.origin.y = CGRectGetMaxY(self.textBackgroundView.frame) + 5.0;
    selectedImageViewFrame.size.height = ([UIScreen mainScreen].bounds.size.width - 5 * 10.0) / 4+ 45.0;
    self.selectedImageView.frame = selectedImageViewFrame;
    
    CGRect tableHeaderViewFrame = self.view.bounds;
    tableHeaderViewFrame.size.height = CGRectGetMaxY(self.selectedImageView.frame);
    self.tableHeaderView.frame = tableHeaderViewFrame;
    
    self.tableHeaderView.backgroundColor = self.view.backgroundColor;
}

- (void)sendButtonClick{
    [self.view endEditing:YES];
    NSString *content = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (content.length == 0 && self.selectedImages.count == 0) {
        [MBProgressHUD showWithError:@"请输入动态内容或者上传喜欢的图片！"];
        return;
    }else if (content.length > 250){
        [MBProgressHUD showWithError:@"输入的动态内容请控制在250个字符以内！"];
        return;
    }
    
    [MBProgressHUD showWithText:nil];
    
    NSDictionary *parameters = @{@"username" : [UserInfo sharedInfo].userID,
                                 @"content" : content,
                                 @"ishidden" : @"1"};
    if(self.selectedImages.count > 0){
        __block typeof(self) bself = self;
        [MBProgressHUD showWithText:nil];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSMutableArray *imageDatas = [NSMutableArray array];
            for(NSInteger index = 0; index < bself.selectedImages.count; index ++){
                NSData *webPData = [UIImage imageToWebP:bself.selectedImages[index]];
                SLHTTPFileData *httpFileData = [[SLHTTPFileData alloc] initWithData:webPData fileName:[NSString stringWithFormat:@"image_%ld.webp", (long)index] mimeType:kMimeType_Image_WEBP parameterName:[NSString stringWithFormat:@"image_%ld", (long)index]];
                [imageDatas addObject:httpFileData];
            }
            [MBProgressHUD hide];
            [bself sendDataWithParameters:parameters imageDatas:[imageDatas copy]];
        });
    }else{
        [self sendDataWithParameters:parameters imageDatas:nil];
    }
}

- (void)sendDataWithParameters:(NSDictionary *)parameters imageDatas:(NSArray *)imageDatas{
    __block typeof(self) bself = self;
    [MBProgressHUD showWithText:nil];
    [SLDynamicHTTPHandler POSTFriendCircleSendMessageWithParameters:parameters imageDatas:[imageDatas copy] showProgressInView:nil success:^(void) {
        [MBProgressHUD hideAll];
        if(bself.delegate && [bself.delegate respondsToSelector:@selector(friendCircleSendStatusViewControllerSendMessageCompleted:)]){
            [bself.delegate friendCircleSendStatusViewControllerSendMessageCompleted:bself];
        }
        [bself.navigationController popViewControllerAnimated:YES];
    } failure:^(NSString *errorMessage) {
        [MBProgressHUD hideAll];
        NSString *failureMessage = errorMessage;
        if(failureMessage == nil || failureMessage.length > 0){
            failureMessage = @"发布失败！";
        }
        
        [MBProgressHUD showWithError:failureMessage];
    }];
}

- (void)setAssets:(NSArray *)assets{
    _assets = assets;
    NSMutableArray *selectedImages = [NSMutableArray array];
    if(self.takeImages.count > 0){
        [selectedImages addObjectsFromArray:self.takeImages];
    }
    
    for(NSData *data in assets){
        [selectedImages addObject:[UIImage imageWithData:data]];
    }
    
    self.selectedImages = [selectedImages copy];
}

- (void)setTakeImages:(NSArray *)takeImages{
    _takeImages = takeImages;
    self.selectedImages = [takeImages copy];
}

- (void)setSelectedImages:(NSArray *)selectedImages{
    _selectedImages = selectedImages;
    self.selectedImageView.selectedImages = selectedImages;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SLFriendCircleSendStatusViewCell *cell = [SLFriendCircleSendStatusViewCell cellWithTableView:tableView];
    cell.tableViewModel = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SLFriendCirclePostionViewController *friendCirclePostionViewController = [[SLFriendCirclePostionViewController alloc] init];
    friendCirclePostionViewController.delegate = self;
    [self.navigationController pushViewController:friendCirclePostionViewController animated:YES];
}

- (void)friendCircleSelectedImageView:(SLFriendCircleSelectedImageView *)friendCircleSelectedImageView didChangeHeight:(CGFloat)height{
    CGRect tableHeaderViewFrame = self.tableHeaderView.frame;
    tableHeaderViewFrame.size.height = self.textBackgroundView.frame.size.height + height + 5.0;
    self.tableHeaderView.frame = tableHeaderViewFrame;
    
    self.tableView.tableHeaderView = self.tableHeaderView;
}

- (void)friendCircleSelectedImageView:(SLFriendCircleSelectedImageView *)friendCircleSelectedImageView didCancelImageAtIndex:(NSInteger)index{
    if(index >= 0 && index < self.selectedImages.count){
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.selectedImages];
        [tempArray removeObjectAtIndex:index];
        [self.assetPickerController removeSelectedAssetAtIndex:index];
        self.selectedImages = [tempArray copy];
    }
}

- (void)friendCircleSelectedImageViewDidClickAddButton:(SLFriendCircleSelectedImageView *)friendCircleSelectedImageView{
    [self.view endEditing:YES];
    
    SLActionSheet *actionSheet = [[SLActionSheet alloc] initWithOtherButtonTitles:@"从手机相册选择", @"拍照", nil];
    actionSheet.delegate = self;
    [actionSheet show];
}

- (void)actionSheet:(SLActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{ // 从相册中选择发送
            [self presentViewController:_assetPickerController animated:YES completion:nil];
            break;
        }
        case 1:{ // 拍照并发送
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                [self imagePickerControllerWithSourceType:UIImagePickerControllerSourceTypeCamera];
            }
            break;
        }
        default:
            break;
    }
}

- (void)imagePickerControllerWithSourceType:(UIImagePickerControllerSourceType)sourceType{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.editing = YES;
    imagePickerController.allowsEditing = YES;
    imagePickerController.delegate = self;
    imagePickerController.sourceType = sourceType;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)dictionary{
    UIImage *image = dictionary[UIImagePickerControllerEditedImage];
    // 保持图片到相册
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    
    // 存入拍照的数组中
    NSMutableArray *takeImages = [NSMutableArray arrayWithArray:self.takeImages];
    [takeImages addObject:image];
    // 此处不能调用set方法
    _takeImages = [takeImages copy];
    
    // 将照片加入到选择的数组中，此处必须这么实现
    NSMutableArray *selectedImages = [NSMutableArray arrayWithArray:self.selectedImages];
    [selectedImages addObject:image];
    self.selectedImages = [selectedImages copy];
    
    // 计算可以从相册选择的照片数量
    self.assetPickerController.maximumNumberOfSelection = SLFriendCircleSendStatusWithImageCount - self.takeImages.count;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)assetPickerControllerDidMaximum:(ZYQAssetPickerController *)assetPickerController{
    UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"您最多只能选择%ld张照片", (long)assetPickerController.maximumNumberOfSelection] delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    self.assets = assets;
}

- (void)friendCirclePostionViewController:(SLFriendCirclePostionViewController *)friendCirclePostionViewController didSelectedPostion:(SLPostionModel *)postion{
    _currentPostion = postion;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
