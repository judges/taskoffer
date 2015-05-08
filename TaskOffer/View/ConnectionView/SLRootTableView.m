//
//  SLRootTableView.m
//  TaskOffer
//
//  Created by wshaolin on 15/3/19.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLRootTableView.h"

@implementation SLRootTableView

- (instancetype)initWithDefaultFrameStyle:(UITableViewStyle)style dataSource:(id<UITableViewDataSource>)dataSource delegate:(id<UITableViewDelegate>)delegate{
    if([self initWithFrame:[UIScreen mainScreen].bounds style:style]){
        self.dataSource = dataSource;
        self.delegate = delegate;
    }
    return self;
}

- (instancetype)initWithDefaultFrameDataSource:(id<UITableViewDataSource>)dataSource delegate:(id<UITableViewDelegate>)delegate{
    return [self initWithDefaultFrameStyle:UITableViewStyleGrouped dataSource:dataSource delegate:delegate];
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if(self = [super initWithFrame:frame style:style]){
        
        self.backgroundView = nil;
        self.backgroundColor = [UIColor clearColor];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.showsHorizontalScrollIndicator = NO;
    }
    return self;
}

@end
