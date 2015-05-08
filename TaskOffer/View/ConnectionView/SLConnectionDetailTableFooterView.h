//
//  SLConnectionDetailTableFooterView.h
//  TaskOffer
//
//  Created by wshaolin on 15/3/19.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SLConnectionDetailTableFooterViewButtonType) {
    SLConnectionDetailTableFooterViewButtonTypeAddFriend = 100, // 添加好友
    SLConnectionDetailTableFooterViewButtonTypeCreateChat, // 创建聊天
    SLConnectionDetailTableFooterViewButtonTypeDeleteFriend // 删除好友
};

typedef NS_ENUM(NSInteger, SLConnectionRelationship){
    SLConnectionRelationshipSelf, // 自己
    SLConnectionRelationshipFriend, // 好友
    SLConnectionRelationshipStranger // 陌生人
};

@class SLConnectionDetailTableFooterView;

@protocol SLConnectionDetailTableFooterViewDeledate <NSObject>

@optional
- (void)connectionDetailTableFooterView:(SLConnectionDetailTableFooterView *)tableFooterView didClickButtonWithType:(SLConnectionDetailTableFooterViewButtonType)buttonType;

- (void)connectionDetailTableFooterView:(SLConnectionDetailTableFooterView *)tableFooterView didChangeFrame:(CGRect)frame;

@end

@interface SLConnectionDetailTableFooterView : UIView

@property (nonatomic, weak) id<SLConnectionDetailTableFooterViewDeledate> delegate;

@property (nonatomic, assign) SLConnectionRelationship connectionRelationship;

@end
