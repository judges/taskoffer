//
//  SLFriendCircleMessageFrameModel.h
//  XMPPIM
//
//  Created by wshaolin on 14/12/27.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLFriendCircleMessageModel.h"

@interface SLFriendCircleMessageFrameModel : NSObject

@property (nonatomic, strong, readonly) SLFriendCircleMessageModel *friendCircleMessageModel;
@property (nonatomic, assign, readonly) CGFloat rowHeight;

@property (nonatomic, assign, readonly) CGRect iconFrame;
@property (nonatomic, assign, readonly) CGRect nicknameFrame;
@property (nonatomic, assign, readonly) CGRect messageFrame;
@property (nonatomic, assign, readonly) CGRect dateFrame;
@property (nonatomic, assign, readonly) CGRect statusContentFrame;

- (instancetype)initWithFriendCircleMessageModel:(SLFriendCircleMessageModel *)friendCircleMessageModel;

+ (instancetype)modelWithFriendCircleMessageModel:(SLFriendCircleMessageModel *)friendCircleMessageModel;

@end
