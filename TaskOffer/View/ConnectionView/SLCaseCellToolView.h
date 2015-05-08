//
//  SLCaseCellToolView.h
//  TaskOffer
//
//  Created by wshaolin on 15/3/20.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SLCaseCellToolViewButtonType){
    SLCaseCellToolViewButtonTypeDownload, // 下载连接
    SLCaseCellToolViewButtonTypeAttachment, // 合同附件
    SLCaseCellToolViewButtonTypePackage // 安装包
};

@class SLCaseCellToolView;

@protocol SLCaseCellToolViewDelegate <NSObject>

@optional
- (void)caseCellToolView:(SLCaseCellToolView *)toolView didClickButtonWithType:(SLCaseCellToolViewButtonType)buttonType;

@end

@interface SLCaseCellToolView : UIView

@property (nonatomic, weak) id<SLCaseCellToolViewDelegate> delegate;

@end
