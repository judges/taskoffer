//
//  SLProjectModel.h
//  TaskOffer
//
//  Created by wshaolin on 15/3/24.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLProjectModel : NSObject

@property (nonatomic, copy, readonly) NSString *projectID;
@property (nonatomic, copy, readonly) NSString *projectName;
@property (nonatomic, copy, readonly) NSString *projectDesc;
@property (nonatomic, copy, readonly) NSString *projectLogo;
@property (nonatomic, copy, readonly) NSString *projectPrice;
@property (nonatomic, strong, readonly) NSArray *projectTag;
@property (nonatomic, copy, readonly) NSString *projectType;
@property (nonatomic, copy, readonly) NSString *projectEndTime;
@property (nonatomic, copy, readonly) NSString *projectPublisher;

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end