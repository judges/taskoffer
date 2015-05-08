//
//  SLEditCaseViewController.h
//  TaskOffer
//
//  Created by wshaolin on 15/4/3.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLRootViewController.h"

@class SLEditCaseViewController, SLCaseDetailModel;

@protocol SLEditCaseViewControllerDelegate <NSObject>

@optional

- (void)editCaseViewController:(SLEditCaseViewController *)editCaseViewController didEditCaseSuccess:(SLCaseDetailModel *)caseDetailModel forIndexPath:(NSIndexPath *)indexPath;

- (void)editCaseViewController:(SLEditCaseViewController *)editCaseViewController didRemoveCaseSuccessForIndexPath:(NSIndexPath *)indexPath;

@end

@interface SLEditCaseViewController : SLRootViewController

@property (nonatomic, weak) id<SLEditCaseViewControllerDelegate> delegate;
@property (nonatomic, strong) SLCaseDetailModel *caseDetailModel;

@property (nonatomic, strong) NSIndexPath *indexPath;

@end
