//
//  SLEditCaseViewController.m
//  TaskOffer
//
//  Created by wshaolin on 15/4/3.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLEditCaseViewController.h"
#import "SLAddCaseFormView.h"
#import "SLAddCaseLogoView.h"
#import "UIBarButtonItem+Image.h"
#import "SLAddCaseSelectImageView.h"
#import "ZYQAssetPickerController.h"
#import "SLAddCaseDeleteView.h"
#import "SLConnectionHTTPHandler.h"
#import "MBProgressHUD+Conveniently.h"
#import "SLOptionPickerView.h"
#import "SLOptionModel.h"
#import "SLCaseDetailModel.h"
#import "UIImage+GWebP.h"

#define SLEditCaseViewControllerAlertViewTag_Upload 8888
#define SLEditCaseViewControllerAlertViewTag_Remove 9999

@interface SLEditCaseViewController ()<
            SLAddCaseLogoViewDelegate,
            SLAddCaseSelectImageViewDelegate,
            SLAddCaseDeleteViewDelegate,
            UIImagePickerControllerDelegate,
            UINavigationControllerDelegate,
            ZYQAssetPickerControllerDelegate,
            UIAlertViewDelegate,
            SLOptionPickerViewDelegate,
            SLAddCaseFormViewDelegate
            >

@property (nonatomic, strong) UIScrollView *contentView;
@property (nonatomic, strong) SLAddCaseFormView *addCaseFormView;
@property (nonatomic, strong) SLAddCaseLogoView *addCaseLogoView;
@property (nonatomic, strong) SLAddCaseDeleteView *addCaseDeleteView;
@property (nonatomic, strong) SLAddCaseSelectImageView *addCaseSelectImageView;
@property (nonatomic, strong) SLOptionPickerView *optionPickerView;

@property (nonatomic, strong) NSMutableArray *selectedImages;
@property (nonatomic, strong) NSMutableArray *uploadedImageURLs;
@property (nonatomic, strong) UIImage *selectedLogo;
@property (nonatomic, copy) NSString *uploadLogoFileName;
@property (nonatomic, copy) NSString *uploadImageFileNames;
@property (nonatomic, strong) SLOptionModel *optionModel;
@property (nonatomic, strong) NSArray *optionArray;

@property (nonatomic, strong) ZYQAssetPickerController *logoAssetPickerController;
@property (nonatomic, strong) ZYQAssetPickerController *imageAssetPickerController;

@property (nonatomic, assign, getter = isLogoUploadSuccess) BOOL logoUploadSuccess;
@property (nonatomic, assign, getter = isImageUploadSuccess) BOOL imageUploadSuccess;

@property (nonatomic, assign, getter = isNeedSettingData) BOOL needSettingData;

@end

@implementation SLEditCaseViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if(self.caseDetailModel != nil && self.needSettingData){
        self.needSettingData = NO;
        self.addCaseFormView.projectName = self.caseDetailModel.caseName;
        self.addCaseFormView.developmentTime = self.caseDetailModel.developmentTime;
        self.addCaseFormView.technicalScheme = self.caseDetailModel.technicalScheme;
        self.addCaseLogoView.caseLogoOrURL = self.caseDetailModel.caseLogo;
        self.addCaseSelectImageView.selectedImages = self.caseDetailModel.designSchemeUrl;
            
        [self.selectedImages addObjectsFromArray:self.caseDetailModel.designSchemeUrl];
        self.uploadLogoFileName = self.caseDetailModel.caseLogoName;
        self.uploadImageFileNames = self.caseDetailModel.designSchemeImageNames;
        self.logoUploadSuccess = YES;
        self.imageUploadSuccess = YES;
        
        if(self.optionArray != nil && self.optionArray.count > 0){
            for(SLOptionModel *optionModel in self.optionArray){
                if([optionModel.optionValue isEqualToString:self.caseDetailModel.referencePrice]){
                    self.optionPickerView.selectedOptionModel = optionModel;
                    self.optionModel = optionModel;
                    break;
                }
            }
        }
    }
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
        self.title = @"修改案例";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.needSettingData = YES;
    
    self.view.backgroundColor = [UIColor colorWithRed:244.0 / 255.0 green:249.0 / 255.0 blue:251.0 / 255.0 alpha:1.0];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"保存" target:self action:@selector(didClickSaveBarButtonItem:)];
    
    [self.view addSubview:self.contentView];
    [self.view addSubview:self.addCaseDeleteView];
    
    [self loadPriceDictionaryOption];
}

- (void)setOptionArray:(NSArray *)optionArray{
    _optionArray = optionArray;
    self.optionPickerView = [[SLOptionPickerView alloc] initWithOptionArray:optionArray];
    self.optionPickerView.delegate = self;
    
    if(self.caseDetailModel != nil){
        for(SLOptionModel *optionModel in optionArray){
            if([optionModel.optionValue isEqualToString:self.caseDetailModel.referencePrice]){
                self.optionPickerView.selectedOptionModel = optionModel;
                self.optionModel = optionModel;
                break;
            }
        }
    }
}

- (void)loadPriceDictionaryOption{
    __block typeof(self) bself = self;
    [SLConnectionHTTPHandler POSTSystemDictionaryOptionWithOptionType:kSLSystemDictionaryOptionTypePrice showProgressInView:self.view success:^(NSArray *dataArray) {
        bself.optionArray = dataArray;
    } failure:^(NSString *errorMessage) {
        
    }];
}

- (void)setOptionModel:(SLOptionModel *)optionModel{
    _optionModel = optionModel;
    self.addCaseFormView.developmentPrice = optionModel.optionValue;
}

- (NSMutableArray *)selectedImages{
    if(_selectedImages == nil){
        _selectedImages = [NSMutableArray array];
    }
    return _selectedImages;
}

- (NSMutableArray *)uploadedImageURLs{
    if(_uploadedImageURLs == nil){
        _uploadedImageURLs = [NSMutableArray array];
    }
    return _uploadedImageURLs;
}

- (SLAddCaseFormView *)addCaseFormView{
    if(_addCaseFormView == nil){
        _addCaseFormView = [[SLAddCaseFormView alloc] init];
        _addCaseFormView.delegate = self;
    }
    return _addCaseFormView;
}

- (SLAddCaseLogoView *)addCaseLogoView{
    if(_addCaseLogoView == nil){
        _addCaseLogoView = [[SLAddCaseLogoView alloc] init];
        _addCaseLogoView.frame = CGRectMake(0, CGRectGetMaxY(self.addCaseFormView.frame) + 5.0, 0, 0);
        _addCaseLogoView.delegate = self;
    }
    return _addCaseLogoView;
}

- (SLAddCaseSelectImageView *)addCaseSelectImageView{
    if(_addCaseSelectImageView == nil){
        _addCaseSelectImageView = [[SLAddCaseSelectImageView alloc] init];
        _addCaseSelectImageView.delegate = self;
        _addCaseSelectImageView.title = @"案例截图";
        _addCaseSelectImageView.frame = CGRectMake(0, CGRectGetMaxY(self.addCaseLogoView.frame) + 5.0, 0, 0);
    }
    return _addCaseSelectImageView;
}

- (SLAddCaseDeleteView *)addCaseDeleteView{
    if(_addCaseDeleteView == nil){
        _addCaseDeleteView = [[SLAddCaseDeleteView alloc] init];
        _addCaseDeleteView.delegate = self;
        _addCaseDeleteView.frame = CGRectMake(0, self.view.bounds.size.height - _addCaseDeleteView.bounds.size.height, 0, 0);
    }
    return _addCaseDeleteView;
}

- (UIScrollView *)contentView{
    if(_contentView == nil){
        CGRect contentViewFrame = self.view.bounds;
        contentViewFrame.size.height -= self.addCaseDeleteView.bounds.size.height;
        _contentView = [[UIScrollView alloc] initWithFrame:contentViewFrame];
        _contentView.showsHorizontalScrollIndicator = NO;
        _contentView.showsVerticalScrollIndicator = NO;
        _contentView.backgroundColor = [UIColor clearColor];
        [_contentView addSubview:self.addCaseFormView];
        [_contentView addSubview:self.addCaseLogoView];
        [_contentView addSubview:self.addCaseSelectImageView];
        _contentView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.addCaseSelectImageView.frame));
    }
    return _contentView;
}

- (ZYQAssetPickerController *)logoAssetPickerController{
    if(_logoAssetPickerController == nil){
        _logoAssetPickerController = [[ZYQAssetPickerController alloc] init];
        _logoAssetPickerController.delegate = self;
        _logoAssetPickerController.assetsFilter = [ALAssetsFilter allPhotos];
        _logoAssetPickerController.showEmptyGroups = NO;
        _logoAssetPickerController.maximumNumberOfSelection = 1;
    }
    return _logoAssetPickerController;
}

- (ZYQAssetPickerController *)imageAssetPickerController{
    if(_imageAssetPickerController == nil){
        _imageAssetPickerController = [[ZYQAssetPickerController alloc] init];
        _imageAssetPickerController.delegate = self;
        _imageAssetPickerController.assetsFilter = [ALAssetsFilter allPhotos];
        _imageAssetPickerController.showEmptyGroups = NO;
        _imageAssetPickerController.maximumNumberOfSelection = 9;
    }
    return _imageAssetPickerController;
}

- (void)addCaseLogoViewDidClickAddButton:(SLAddCaseLogoView *)addCaseLogoView{
    [self presentViewController:self.logoAssetPickerController animated:YES completion:nil];
}

- (void)addCaseLogoViewDidClickCancelButton:(SLAddCaseLogoView *)addCaseLogoView{
    self.selectedLogo = nil;
    self.uploadLogoFileName = nil;
    self.logoUploadSuccess = NO;
    [self.logoAssetPickerController removeSelectedAssetAtIndex:0];
}

- (void)addCaseSelectImageViewDidClickAddButton:(SLAddCaseSelectImageView *)addCaseSelectImageView{
    [self presentViewController:self.imageAssetPickerController animated:YES completion:nil];
}

- (void)addCaseSelectImageView:(SLAddCaseSelectImageView *)addCaseSelectImageView didClickCancelButtonWithIndex:(NSUInteger)index{
    NSMutableArray *tempArray = [NSMutableArray array];
    for(id object in self.selectedImages){
        if([object isKindOfClass:[UIImage class]]){
            [tempArray addObject:object];
        }
    }
    
    id object = self.selectedImages[index];
    if([object isKindOfClass:[UIImage class]]){
        for(NSInteger i = 0; i < tempArray.count; i ++){
            if(object == self.selectedImages[i]){
                [self.imageAssetPickerController removeSelectedAssetAtIndex:i];
                break;
            }
        }
    }
    
    [self.selectedImages removeObjectAtIndex:index];
    self.imageUploadSuccess = NO;
    self.addCaseSelectImageView.selectedImages = [self.selectedImages copy];
}

- (void)addCaseSelectImageView:(SLAddCaseSelectImageView *)addCaseSelectImageView didChangeHeight:(CGFloat)height{
    self.contentView.contentSize = CGSizeMake(0, CGRectGetMaxY(addCaseSelectImageView.frame));
}

- (void)assetPickerController:(ZYQAssetPickerController *)assetPickerController didFinishPickingAssets:(NSArray *)assets{
    if(assetPickerController == self.logoAssetPickerController){
        UIImage *imgae = [UIImage imageWithData:[assets firstObject]];
        self.addCaseLogoView.caseLogoOrURL = imgae;
        self.selectedLogo = imgae;
        self.logoUploadSuccess = NO;
    }else{
        NSMutableArray *tempArray = [self.selectedImages mutableCopy];
        for(id object in tempArray){
            if([object isKindOfClass:[UIImage class]]){
                [self.selectedImages removeObject:object];
            }
        }
            
        for(NSData *data in assets){
            UIImage *imgae = [UIImage imageWithData:data];
            [self.selectedImages addObject:imgae];
        }
        self.imageUploadSuccess = NO;
        self.addCaseSelectImageView.selectedImages = [self.selectedImages copy];
    }
}

- (void)assetPickerControllerDidMaximum:(ZYQAssetPickerController *)assetPickerController{
    UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"您最多只能选择%ld张照片", (long)assetPickerController.maximumNumberOfSelection] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"我知道了", nil];
    [alertView show];
}

- (void)didClickSaveBarButtonItem:(UIBarButtonItem *)barButtonItem{
    if([self validateData]){
        if(!self.isLogoUploadSuccess){
            [self uploadCaseLogo];
        }else if(!self.isImageUploadSuccess){
            [self uploadCaseImage];
        }else{
            [self modifyCase];
        }
    }
}

- (BOOL)validateData{
    if(self.addCaseFormView.projectName.length == 0){
        [self showAlertViewWithMessage:@"请填写案例名称！"];
        return NO;
    }else if(self.addCaseFormView.projectName.length > 50){
        [self showAlertViewWithMessage:@"案例名称不能超过50个字符！"];
        return NO;
    }
    
    if(self.addCaseFormView.developmentTime.length == 0){
        [self showAlertViewWithMessage:@"请填写开发周期！"];
        return NO;
    }else if ([self.addCaseFormView.developmentTime integerValue] == 0){
        [self showAlertViewWithMessage:@"开发周期填写错误，请填写大于0的整数（单位：月）！"];
        return NO;
    }else if (self.addCaseFormView.developmentTime.length > 10){
        [self showAlertViewWithMessage:@"开发周期填写错误，值太大！"];
        return NO;
    }
    
    if(self.addCaseFormView.technicalScheme.length == 0){
        [self showAlertViewWithMessage:@"请填写技术方案！"];
        return NO;
    }else if(self.addCaseFormView.technicalScheme.length > 100){
        [self showAlertViewWithMessage:@"技术方案不能超过100个字符！"];
        return NO;
    }
    
    if(self.optionModel == nil){
        [self showAlertViewWithMessage:@"请填写开发价格！"];
        return NO;
    }
    
    if((self.uploadLogoFileName == nil || self.uploadLogoFileName.length == 0) && self.selectedLogo == nil){
        [self showAlertViewWithMessage:@"请上传一张图片作为该案例的LOGO！"];
        return NO;
    }
    return YES;
}

- (void)modifyCase{
    if(self.uploadImageFileNames == nil){
        self.uploadImageFileNames = @"";
    }
    
    NSDictionary *parameters = @{@"id" : self.caseDetailModel.caseID,
                                 @"casePublishId" : [UserInfo sharedInfo].userID,
                                 @"casePublishName" : [UserInfo sharedInfo].userName,
                                 @"caseName" : self.addCaseFormView.projectName,
                                 @"caseDescibe" : @"",
                                 @"casePrice" : self.optionModel.optionKey,
                                 @"caseTimes" : @([self.addCaseFormView.developmentTime integerValue]),
                                 @"caseLogo" : self.uploadLogoFileName,
                                 @"casePicture" : self.uploadImageFileNames,
                                 @"caseTechnical" : self.addCaseFormView.technicalScheme,
                                 @"caseType" : @"1"};
    __block typeof(self) bself = self;
    [SLConnectionHTTPHandler POSTModifyCaseWithParameters:parameters showProgressInView:self.view success:^(SLCaseDetailModel *caseDetailModel){
        if(bself.delegate && [bself.delegate respondsToSelector:@selector(editCaseViewController:didEditCaseSuccess:forIndexPath:)]){
            [bself.delegate editCaseViewController:bself didEditCaseSuccess:caseDetailModel forIndexPath:bself.indexPath];
        }
        [MBProgressHUD showWithSuccess:@"案例修改成功！"];
        [bself.navigationController popViewControllerAnimated:YES];
    } failure:^(NSString *errorMessage) {
        [self showAlertViewWithContinueMessage:@"案例修改失败！是否继续修改？"];
    }];
}

- (void)removeCaseFromServer{
    NSDictionary *parameters = @{@"id" : self.caseDetailModel.caseID,
                                 @"caseIsDelete" : @"1"
                                 };
    __block typeof(self) bself = self;
    [SLConnectionHTTPHandler POSTModifyCaseWithParameters:parameters showProgressInView:nil success:^(SLCaseDetailModel *caseDetailModel){
        if(bself.delegate && [bself.delegate respondsToSelector:@selector(editCaseViewController:didRemoveCaseSuccessForIndexPath:)]){
            [bself.delegate editCaseViewController:bself didRemoveCaseSuccessForIndexPath:bself.indexPath];
        }
        [MBProgressHUD showWithSuccess:@"案例删除成功！"];
        [bself.navigationController popViewControllerAnimated:YES];
    } failure:^(NSString *errorMessage) {
        [self showAlertViewWithContinueMessage:@"案例删除失败！"];
    }];
}

- (void)uploadCaseLogo{
    SLHTTPFileData *data = [[SLHTTPFileData alloc] initWithData:[UIImage imageToWebP:self.selectedLogo] fileName:@"logo.webp" mimeType:kMimeType_Image_WEBP parameterName:@"logo"];
    
    __block typeof(self) bself = self;
    [SLConnectionHTTPHandler POSTUploadImageWithUploadImageKind:SLHTTPServerImageKindCaseLogo imgaeDatas:@[data] showProgressInView:nil success:^(NSString *imageNames) {
        bself.logoUploadSuccess = YES;
        bself.uploadLogoFileName = imageNames;
        [bself uploadCaseImage];
    } failure:^(NSString *errorMessage) {
        [self showAlertViewWithContinueMessage:@"LOGO上传失败！是否继续上传？"];
    }];
}

- (void)uploadCaseImage{
    NSMutableArray *datas = [NSMutableArray array];
    NSMutableString *uploadImageFileNames = [NSMutableString string];
    
    NSInteger index = 0;
    for(id object in self.selectedImages){
        if([object isKindOfClass:[UIImage class]]){
            SLHTTPFileData *data = [[SLHTTPFileData alloc] initWithData:[UIImage imageToWebP:(UIImage *)object] fileName:[NSString stringWithFormat:@"image_%ld.webp", (long)index] mimeType:kMimeType_Image_WEBP parameterName:[NSString stringWithFormat:@"image_%ld", (long)index]];
            [datas addObject:data];
            index ++;
        }else if([object isKindOfClass:[NSString class]]){
            NSString *imageURL = (NSString *)object;
            NSString *imageName = [[imageURL componentsSeparatedByString:@"/"] lastObject];
            [uploadImageFileNames appendFormat:@"%@,", imageName];
        }
    }
    
    if(uploadImageFileNames.length > 0){
        [uploadImageFileNames deleteCharactersInRange:NSMakeRange(uploadImageFileNames.length - 1, 1)];
        self.uploadImageFileNames = [uploadImageFileNames copy];
    }else{
        self.uploadImageFileNames = @"";
    }
    
    if(datas.count > 0){
        __block typeof(self) bself = self;
        [SLConnectionHTTPHandler POSTUploadImageWithUploadImageKind:SLHTTPServerImageKindCasePicture imgaeDatas:[datas copy] showProgressInView:nil success:^(NSString *imageNames) {
            bself.imageUploadSuccess = YES;
            if(bself.uploadImageFileNames.length > 0){
                bself.uploadImageFileNames = [NSString stringWithFormat:@"%@,%@", bself.uploadImageFileNames, imageNames];
            }else{
                bself.uploadImageFileNames = imageNames;
            }
            [bself modifyCase];
        } failure:^(NSString *errorMessage) {
            [self showAlertViewWithContinueMessage:@"截图上传失败！是否继续上传？"];
        }];
    }else{
        self.imageUploadSuccess = YES;
        [self modifyCase];
    }
}

- (void)showAlertViewWithMessage:(NSString *)message{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (void)showAlertViewWithContinueMessage:(NSString *)message{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消", @"继续", nil];
    alertView.tag = SLEditCaseViewControllerAlertViewTag_Upload;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        if(alertView.tag == SLEditCaseViewControllerAlertViewTag_Remove){
            [self removeCaseFromServer];
        }else{
            [self didClickSaveBarButtonItem:nil];
        }
    }
}

- (void)addCaseFormViewDevelopmentPriceDidBeginSelect:(SLAddCaseFormView *)addCaseFormView{
    [self.optionPickerView showOptionPicker];
}

- (void)optionPickerView:(SLOptionPickerView *)optionPickerView didSelectOptionComplete:(SLOptionModel *)optionModel{
    self.optionModel = optionModel;
}

- (void)addCaseDeleteViewDidClickDeleteButton:(SLAddCaseDeleteView *)addCaseDeleteView{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"是否确定删除此案例？" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消", @"确定", nil];
    alertView.tag = SLEditCaseViewControllerAlertViewTag_Remove;
    [alertView show];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
