//
//  SLFriendCircleUserModel.h
//  XMPPIM
//
//  Created by wshaolin on 15/1/9.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLFriendCircleUserModel : NSObject

@property (nonatomic, copy, readonly) NSString *username;
@property (nonatomic, copy, readonly) NSString *displayName;
@property (nonatomic, copy, readonly) NSString *iconURL;

@property (nonatomic, assign, readonly) BOOL isCurrentUser;

- (instancetype)initWithUsername:(NSString *)username displayName:(NSString *)displayName iconURL:(NSString *)iconURL;
+ (instancetype)modelWithUsername:(NSString *)username displayName:(NSString *)displayName iconURL:(NSString *)iconURL;

@end
