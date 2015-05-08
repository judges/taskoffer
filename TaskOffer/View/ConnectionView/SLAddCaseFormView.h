//
//  SLAddCaseFormView.h
//  TaskOffer
//
//  Created by wshaolin on 15/3/21.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SLAddCaseFormView;

@protocol SLAddCaseFormViewDelegate <NSObject>

@optional

- (void)addCaseFormViewDevelopmentPriceDidBeginSelect:(SLAddCaseFormView *)addCaseFormView;

@end

@interface SLAddCaseFormView : UIView

@property (nonatomic, weak) id<SLAddCaseFormViewDelegate> delegate;

@property (nonatomic, copy) NSString *projectName;
@property (nonatomic, copy) NSString *developmentTime;
@property (nonatomic, copy) NSString *technicalScheme;
@property (nonatomic, copy) NSString *developmentPrice;

@end
