//
//  SLFriendCircleStatusFrameModel.h
//  XMPPIM
//
//  Created by wshaolin on 14/12/18.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLFriendCircleStatusModel.h"

@interface SLFriendCircleStatusFrameModel : NSObject

@property (nonatomic, strong, readonly) SLFriendCircleStatusModel *friendCircleStatusModel;
@property (nonatomic, assign, readonly) CGFloat statusSectionHeight;

@property (nonatomic, assign, readonly) CGRect iconFrame;
@property (nonatomic, assign, readonly) CGRect nickNameFrame;
@property (nonatomic, assign, readonly) CGRect dataTimeFrame;
@property (nonatomic, assign, readonly) CGRect companyAndJobFrame;
@property (nonatomic, assign, readonly) CGRect contentFrame;
@property (nonatomic, assign, readonly) CGRect imageCollectionFrame;
@property (nonatomic, assign, readonly) CGRect applaudButtonFrame;
@property (nonatomic, assign, readonly) CGRect commentButtonFrame;
@property (nonatomic, assign, readonly) CGRect deleteButtonFrame;

- (instancetype)initWithFriendCircleStatusModel:(SLFriendCircleStatusModel *)friendCircleStatusModel;
+ (instancetype)modelWithFriendCircleStatusModel:(SLFriendCircleStatusModel *)friendCircleStatusModel;

- (void)recalculateFrame;

@end