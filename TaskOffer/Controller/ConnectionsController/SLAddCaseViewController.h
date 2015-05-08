//
//  SLAddCaseViewController.h
//  TaskOffer
//
//  Created by wshaolin on 15/3/21.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLRootViewController.h"

@class SLAddCaseViewController, SLCaseDetailModel;

@protocol SLAddCaseViewControllerDelegate <NSObject>

@optional

- (void)addCaseViewController:(SLAddCaseViewController *)addCaseViewController didPublishCaseSuccess:(SLCaseDetailModel *)caseDetailModel;

@end

@interface SLAddCaseViewController : SLRootViewController

@property (nonatomic, weak) id<SLAddCaseViewControllerDelegate> delegate;

@end
