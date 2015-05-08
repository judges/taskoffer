//
//  SLAddCaseDeleteView.h
//  TaskOffer
//
//  Created by wshaolin on 15/3/23.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SLAddCaseDeleteView;

@protocol SLAddCaseDeleteViewDelegate <NSObject>

@optional
- (void)addCaseDeleteViewDidClickDeleteButton:(SLAddCaseDeleteView *)addCaseDeleteView;

@end

@interface SLAddCaseDeleteView : UIView

@property (nonatomic, weak) id<SLAddCaseDeleteViewDelegate> delegate;

@end
