//
//  SLFriendCircleStatusCommentFrameModel.h
//  XMPPIM
//
//  Created by wshaolin on 14/12/19.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLFriendCircleStatusCommentModel.h"

@interface SLFriendCircleStatusCommentFrameModel : NSObject

@property (nonatomic, strong, readonly) SLFriendCircleStatusCommentModel *friendCircleStatusCommentModel;
@property (nonatomic, assign, readonly) CGFloat statusCommentCellHeight;
@property (nonatomic, assign, readonly) CGRect statusCommentFrame;

- (instancetype)initWithFriendCircleStatusCommentModel:(SLFriendCircleStatusCommentModel *)friendCircleStatusCommentModel;
+ (instancetype)modelWithFriendCircleStatusCommentModel:(SLFriendCircleStatusCommentModel *)friendCircleStatusCommentModel;

@end
