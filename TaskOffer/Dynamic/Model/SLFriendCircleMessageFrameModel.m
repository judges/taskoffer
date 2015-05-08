//
//  SLFriendCircleMessageFrameModel.m
//  XMPPIM
//
//  Created by wshaolin on 14/12/27.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import "SLFriendCircleMessageFrameModel.h"
#import "NSString+Conveniently.h"
#import "SLFriendCircleFont.h"

@implementation SLFriendCircleMessageFrameModel

+ (instancetype)modelWithFriendCircleMessageModel:(SLFriendCircleMessageModel *)friendCircleMessageModel{
    return [[self alloc] initWithFriendCircleMessageModel:friendCircleMessageModel];
}

- (instancetype)initWithFriendCircleMessageModel:(SLFriendCircleMessageModel *)friendCircleMessageModel{
    if(self = [super init]){
        _friendCircleMessageModel = friendCircleMessageModel;
        
        [self calculateFrame];
    }
    return self;
}

- (void)calculateFrame{
    CGFloat margin = 10.0;
    CGFloat icon_W = 65.0;
    CGFloat icon_H = icon_W;
    CGFloat icon_X = margin;
    CGFloat icon_Y = margin;
    _iconFrame = CGRectMake(icon_X, icon_Y, icon_W, icon_H);
    
    CGFloat statusContent_W = icon_W;
    CGFloat statusContent_H = statusContent_W;
    CGFloat statusContent_Y = icon_Y;
    CGFloat statusContent_X = [UIScreen mainScreen].bounds.size.width - statusContent_W - margin;
    _statusContentFrame = CGRectMake(statusContent_X, statusContent_Y, statusContent_W, statusContent_H);
    
    CGFloat nickName_W = [UIScreen mainScreen].bounds.size.width - icon_W - statusContent_W - margin * 3;
    CGFloat nickName_H = 20.0;
    CGFloat nickName_Y = icon_Y;
    CGFloat nickName_X = CGRectGetMaxX(_iconFrame) + margin * 0.5;
    _nicknameFrame = CGRectMake(nickName_X, nickName_Y, nickName_W, nickName_H);
    
    CGFloat messgaeContent_W = nickName_W;
    CGFloat messgaeContent_X = nickName_X;
    CGFloat messgaeContent_Y = CGRectGetMaxY(_nicknameFrame);
    CGFloat messgaeContent_H = nickName_H + margin;
    if(_friendCircleMessageModel.messageType == SLFriendCircleMessageTypeContent){
        messgaeContent_H = [_friendCircleMessageModel.messageContent emojiSizDefaultLineSpacingeWithFont:SLFriendCircleMessageContentFont maximumWidth:messgaeContent_W].height + margin;
    }
    
    _messageFrame = CGRectMake(messgaeContent_X, messgaeContent_Y, messgaeContent_W, messgaeContent_H);
    
    CGFloat date_W = messgaeContent_W;
    CGFloat date_X = messgaeContent_X;
    CGFloat date_Y = CGRectGetMaxY(_messageFrame);
    CGFloat date_H = [_friendCircleMessageModel.formatDate sizeWithFont:SLFriendCircleMessageDateFont limitSize:CGSizeMake(date_W, MAXFLOAT)].height;
    if(date_Y + date_H < CGRectGetMaxY(_iconFrame)){
        date_Y = CGRectGetMaxY(_iconFrame) - date_H;
    }
    _dateFrame = CGRectMake(date_X, date_Y, date_W, date_H);
    
    _rowHeight = CGRectGetMaxY(_dateFrame) + margin;
}

@end
