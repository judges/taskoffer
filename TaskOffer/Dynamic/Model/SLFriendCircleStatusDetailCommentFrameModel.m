//
//  SLFriendCircleStatusDetailCommentFrameModel.m
//  XMPPIM
//
//  Created by wshaolin on 14/12/27.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import "SLFriendCircleStatusDetailCommentFrameModel.h"
#import "NSString+Conveniently.h"
#import "SLFriendCircleFont.h"

@implementation SLFriendCircleStatusDetailCommentFrameModel

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
    CGFloat margin = 10.0;
    CGFloat screen_W = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat iconView_W = 40.0;
    CGFloat iconView_H = iconView_W;
    CGFloat iconView_Y = margin * 0.5;
    CGFloat iconView_X = margin;
    _iconViewFrame = CGRectMake(iconView_X, iconView_Y, iconView_W, iconView_H);
    
    CGFloat date_W = 80.0;
    CGFloat date_H = iconView_H * 0.5;
    CGFloat date_Y = iconView_Y;
    CGFloat date_X = screen_W - date_W - margin;
    _dateTimeFrame = CGRectMake(date_X, date_Y, date_W, date_H);
    
    CGFloat nickName_H = date_H;
    CGFloat nickName_X = CGRectGetMaxX(_iconViewFrame) + margin;
    CGFloat nickName_W = date_X - nickName_X - margin;
    CGFloat nickName_Y = iconView_Y;
    _nickNameFrame = CGRectMake(nickName_X, nickName_Y, nickName_W, nickName_H);
    
    CGFloat content_W = screen_W - CGRectGetMaxX(_iconViewFrame) - margin * 2;
    CGFloat content_X = nickName_X;
    CGFloat content_Y = CGRectGetMaxY(_nickNameFrame);
    NSString *content = _friendCircleStatusCommentModel.commentContent;
    if(_friendCircleStatusCommentModel.messageType == SLFriendCircleStatusCommentModelMessageTypeReply){
        content = [NSString stringWithFormat:@"回复%@：%@", _friendCircleStatusCommentModel.recipientUserModel.displayName, content];
    }
    CGFloat content_H = [content emojiSizDefaultLineSpacingeWithFont:SLFriendCircleStatusDetailCommentContentFont maximumWidth:content_W].height;
    _contentFrame = CGRectMake(content_X, content_Y, content_W, content_H);
    
    _rowHeight = MAX(CGRectGetMaxY(_iconViewFrame), CGRectGetMaxY(_contentFrame)) + margin * 0.5;
}

@end
