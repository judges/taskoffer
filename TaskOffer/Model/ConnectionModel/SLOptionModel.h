//
//  SLOptionModel.h
//  TaskOffer
//
//  Created by wshaolin on 15/4/2.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLOptionModel : NSObject

@property (nonatomic, copy, readonly) NSString *optionKey;
@property (nonatomic, copy, readonly) NSString *optionValue;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
+ (instancetype)optionModelWithDictionary:(NSDictionary *)dictionary;

@end
