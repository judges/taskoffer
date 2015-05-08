//
//  TagsViewController.h
//  TaskOffer
//
//  Created by BourbonZ on 15/3/18.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "BaseViewController.h"

@protocol TagsViewControllerDelegate <NSObject>

-(void)selectTagsSuccess:(NSMutableArray *)tagsArray;;

@end
@interface TagsViewController : BaseViewController

@property (nonatomic,weak) id <TagsViewControllerDelegate>delegate;
@property (nonatomic,assign) BOOL isCompleteInfo;
@end
