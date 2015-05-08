//
//  SLTagModel.h
//  TaskOffer
//
//  Created by wshaolin on 15/4/28.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLTagModel : NSObject

@property (nonatomic, copy, readonly) NSString *tagID;
@property (nonatomic, copy, readonly) NSString *tagCode;
@property (nonatomic, copy, readonly) NSString *tagName;
@property (nonatomic, assign, readonly) NSInteger tagType;
@property (nonatomic, assign, readonly) NSInteger tagStatus;

@property (nonatomic, assign, getter = isSelected) BOOL selected;

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end