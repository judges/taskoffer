//
//  SLFriendCircleSendStatusTableViewModel.h
//  XMPPIM
//
//  Created by wshaolin on 14/12/25.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLFriendCircleSendStatusTableViewModel : NSObject

@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, copy) NSString *title;

- (instancetype)initWithTitle:(NSString *)title iconName:(NSString *)iconName;

+ (instancetype)modelWithTitle:(NSString *)title iconName:(NSString *)iconName;

@end
