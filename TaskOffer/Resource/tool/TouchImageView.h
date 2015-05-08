//
//  TouchImageView.h
//  TaskOffer
//
//  Created by BourbonZ on 15/3/30.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLTaskImageView.h"
@interface TouchImageView : SLTaskImageView

@property (nonatomic,copy) NSString *picUrl;
@property (nonatomic,assign) NSInteger picTag;
@property (nonatomic,weak) NSArray *picArray;

@end
