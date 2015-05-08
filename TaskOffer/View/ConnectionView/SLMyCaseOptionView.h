//
//  SLMyCaseOptionView.h
//  TaskOffer
//
//  Created by wshaolin on 15/4/1.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SLMyCaseOptionView;

@protocol SLMyCaseOptionViewDelegate <NSObject>

@optional

- (void)myCaseOptionView:(SLMyCaseOptionView *)myCaseOptionView didChangeSelectedIndex:(NSInteger)selectedIndex;

@end

@interface SLMyCaseOptionView : UIView

@property (nonatomic, weak) id<SLMyCaseOptionViewDelegate> delegate;
@property (nonatomic, assign, readwrite) NSInteger selectedIndex;

@end
