//
//  SLTagFrameModel.h
//  TaskOffer
//
//  Created by wshaolin on 15/4/25.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLTagFrameModel : NSObject

@property (nonatomic, strong, readonly) NSArray *tags;

@property (nonatomic, strong, readonly) NSArray *tagFrames;
@property (nonatomic, assign, readonly) CGFloat tagViewHeight;

+ (instancetype)modelWithTags:(NSArray *)tags;
- (instancetype)initWithTags:(NSArray *)tags;

@end
