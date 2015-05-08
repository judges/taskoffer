//
//  SLFriendCircleSendStatusViewController.h
//  XMPPIM
//
//  Created by wshaolin on 14/12/19.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import "SLRootViewController.h"

#define SLFriendCircleSendStatusWithImageCount 9

@class ZYQAssetPickerController, SLFriendCircleSendStatusViewController;

@protocol SLFriendCircleSendStatusViewControllerDelegate <NSObject>

@optional
- (void)friendCircleSendStatusViewControllerSendMessageCompleted:(SLFriendCircleSendStatusViewController *)friendCircleSendStatusViewController;

@end

@interface SLFriendCircleSendStatusViewController : SLRootViewController

@property (nonatomic, strong) NSArray *assets; // 从相册选择的照片
@property (nonatomic, strong) NSArray *takeImages; // 调用相机拍摄的照片
@property (nonatomic, weak) id<SLFriendCircleSendStatusViewControllerDelegate> delegate;

@property (nonatomic, strong) ZYQAssetPickerController *assetPickerController;

@end
