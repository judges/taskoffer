//
//  SLFriendCircleStatusDetailCommentFrameModel.h
//  XMPPIM
//
//  Created by wshaolin on 14/12/27.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLFriendCircleStatusCommentModel.h"

@interface SLFriendCircleStatusDetailCommentFrameModel : NSObject

@property (nonatomic, strong, readonly) SLFriendCircleStatusCommentModel *friendCircleStatusCommentModel;

@property (nonatomic, assign, readonly) CGFloat rowHeight;
@property (nonatomic, assign, readonly) CGRect iconViewFrame;
@property (nonatomic, assign, readonly) CGRect nickNameFrame;
@property (nonatomic, assign, readonly) CGRect dateTimeFrame;
@property (nonatomic, assign, readonly) CGRect contentFrame;

- (instancetype)initWithFriendCircleStatusCommentModel:(SLFriendCircleStatusCommentModel *)friendCircleStatusCommentModel;
+ (instancetype)modelWithFriendCircleStatusCommentModel:(SLFriendCircleStatusCommentModel *)friendCircleStatusCommentModel;

@end
