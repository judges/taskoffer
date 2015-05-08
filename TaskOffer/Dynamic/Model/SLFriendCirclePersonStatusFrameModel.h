//
//  SLFriendCirclePersonStatusFrameModel.h
//  XMPPIM
//
//  Created by wshaolin on 14/12/26.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLFriendCircleStatusModel.h"

@interface SLFriendCirclePersonStatusFrameModel : NSObject

@property (nonatomic, strong, readonly) SLFriendCircleStatusModel *friendCircleStatusModel;
@property (nonatomic, strong, readonly) NSMutableAttributedString *dateAttributedString;
@property (nonatomic, assign, readonly) CGFloat rowHeight;

@property (nonatomic, assign, readonly) CGRect leftViewFrame;
@property (nonatomic, assign, readonly) CGRect rightViewFrame;
@property (nonatomic, assign, readonly) CGRect dateLabelFrame;
@property (nonatomic, assign, readonly) CGRect positionLabelFrame;
@property (nonatomic, assign, readonly) CGRect imageViewFrame;
@property (nonatomic, assign, readonly) CGRect contentViewFrame;
@property (nonatomic, assign, readonly) CGRect contentLabelFrame;
@property (nonatomic, assign, readonly) CGRect imageCountLabelFrame;

- (instancetype)initWithFriendCircleStatusModel:(SLFriendCircleStatusModel *)friendCircleStatusModel;

+ (instancetype)modelWithFriendCircleStatusModel:(SLFriendCircleStatusModel *)friendCircleStatusModel;

@end
