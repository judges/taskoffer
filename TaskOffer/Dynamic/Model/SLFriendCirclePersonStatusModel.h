//
//  SLFriendCirclePersonStatusModel.h
//  XMPPIM
//
//  Created by wshaolin on 14/12/26.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLFriendCirclePersonStatusModel : NSObject

@property (nonatomic, copy) NSString *dateTime;
@property (nonatomic, copy) NSString *position;
@property (nonatomic, strong) NSArray *imageUrl;
@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy, readonly) NSString *dayLinkMonth;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary;

@end
