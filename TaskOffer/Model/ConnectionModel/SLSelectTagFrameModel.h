//
//  SLSelectTagFrameModel.h
//  TaskOffer
//
//  Created by wshaolin on 15/4/28.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLTagModel.h"

@interface SLSelectTagFrameModel : NSObject

@property (nonatomic, strong, readonly) NSArray *tagModels;

@property (nonatomic, strong, readonly) NSArray *tagFrames;
@property (nonatomic, assign, readonly) CGFloat tagViewHeight;

+ (instancetype)modelTagModels:(NSArray *)tagModels;
- (instancetype)initWithTagModels:(NSArray *)tagModels;

@end
