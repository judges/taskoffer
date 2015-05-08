//
//  SLConnectionDynamicModel.h
//  TaskOffer
//
//  Created by wshaolin on 15/4/25.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLConnectionDynamicModel : NSObject

@property (nonatomic, copy, readonly) NSString *dynamicID;
@property (nonatomic, copy, readonly) NSString *imageURL;
@property (nonatomic, copy, readonly) NSString *content;

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
