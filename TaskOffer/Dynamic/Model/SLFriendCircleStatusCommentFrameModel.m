//
//  SLFriendCircleStatusCommentFrameModel.m
//  XMPPIM
//
//  Created by wshaolin on 14/12/19.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import "SLFriendCircleStatusCommentFrameModel.h"
#import "SLFriendCircleFont.h"
#import "NSString+Conveniently.h"

@implementation SLFriendCircleStatusCommentFrameModel

+ (instancetype)modelWithFriendCircleStatusCommentModel:(SLFriendCircleStatusCommentModel *)friendCircleStatusCommentModel{
    return [[self alloc] initWithFriendCircleStatusCommentModel:friendCircleStatusCommentModel];
}

- (instancetype)initWithFriendCircleStatusCommentModel:(SLFriendCircleStatusCommentModel *)friendCircleStatusCommentModel{
    if(self = [super init]){
        _friendCircleStatusCommentModel = friendCircleStatusCommentModel;
        
        [self calculateFrame];
    }
    return self;
}

- (void)calculateFrame{
    NSString *showContent = nil;
    if(_friendCircleStatusCommentModel.messageType == SLFriendCircleStatusCommentModelMessageTypeComment){
        showContent = [NSString stringWithFormat:@"%@：%@", _friendCircleStatusCommentModel.senderUserModel.displayName, _friendCircleStatusCommentModel.commentContent];
    }else{
        showContent = [NSString stringWithFormat:@"%@回复%@：%@", _friendCircleStatusCommentModel.senderUserModel.displayName, _friendCircleStatusCommentModel.recipientUserModel.displayName, _friendCircleStatusCommentModel.commentContent];
    }
    
    CGFloat margin = 5.0;
    CGFloat showContent_X = margin;
    CGFloat showContent_Y = margin * 0.5;
    CGFloat showContent_W = [UIScreen mainScreen].bounds.size.width - 70.0 - margin * 2;
    CGFloat showContent_H = [showContent emojiSizDefaultLineSpacingeWithFont:SLFriendCircleCommentContentFont maximumWidth:showContent_W].height;
    
    _statusCommentFrame = CGRectMake(showContent_X, showContent_Y, showContent_W, showContent_H);
    _statusCommentCellHeight = CGRectGetMaxY(_statusCommentFrame) + margin * 0.5;
}

@end
