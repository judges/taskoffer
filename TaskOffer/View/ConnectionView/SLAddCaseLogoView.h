//
//  SLAddCaseLogoView.h
//  TaskOffer
//
//  Created by wshaolin on 15/3/21.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SLAddCaseLogoView;

@protocol SLAddCaseLogoViewDelegate <NSObject>

@optional
- (void)addCaseLogoViewDidClickAddButton:(SLAddCaseLogoView *)addCaseLogoView;
- (void)addCaseLogoViewDidClickCancelButton:(SLAddCaseLogoView *)addCaseLogoView;

@end

@interface SLAddCaseLogoView : UIView

@property (nonatomic, weak) id<SLAddCaseLogoViewDelegate> delegate;
@property (nonatomic, strong) id caseLogoOrURL;

@end
