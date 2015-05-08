//
//  SLSelectTagsViewController.h
//  TaskOffer
//
//  Created by wshaolin on 15/4/28.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLRootViewController.h"

@class SLSelectTagsViewController;

@protocol SLSelectTagsViewControllerDelegate <NSObject>

@optional
- (void)selectTagsViewController:(SLSelectTagsViewController *)selectTagsViewController didSelectedTags:(NSArray *)selectedTags;

@end

@interface SLSelectTagsViewController : SLRootViewController

@property (nonatomic, weak) id<SLSelectTagsViewControllerDelegate> delegate;

@property (nonatomic, strong) NSArray *selectedTags;

@end
