//
//  SLConnectionMoreView.h
//  TaskOffer
//
//  Created by wshaolin on 15/3/20.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    SLConnectionMoreViewHorizontalPositionLeft,
    SLConnectionMoreViewHorizontalPositionCenter,
    SLConnectionMoreViewHorizontalPositionRight
}SLConnectionMoreViewHorizontalPosition;

@class SLConnectionMoreView;

@protocol SLConnectionMoreViewDelegate <NSObject>

@optional

- (void)connectionMoreView:(SLConnectionMoreView *)connectionMoreView didClickButtonItemAtIndex:(NSInteger)buttonItemIndex;

- (void)connectionMoreView:(SLConnectionMoreView *)connectionMoreView willShowWithAnimated:(BOOL)animated;
- (void)connectionMoreView:(SLConnectionMoreView *)connectionMoreView didShowWithAnimated:(BOOL)animated;
- (void)connectionMoreView:(SLConnectionMoreView *)connectionMoreView willHideWithAnimated:(BOOL)animated;
- (void)connectionMoreView:(SLConnectionMoreView *)connectionMoreView didHideWithAnimated:(BOOL)animated;

@end

@interface SLConnectionMoreView : UIView

@property (nonatomic, weak) id<SLConnectionMoreViewDelegate> delegate;

// 横向所在的位置，默认SLConnectionMoreViewHorizontalPositionRight
@property (nonatomic, assign) SLConnectionMoreViewHorizontalPosition horizontalPosition;
@property (nonatomic, assign, readonly) NSInteger buttonItemCount;
@property (nonatomic, assign, readonly) BOOL isDisplaying;

- (instancetype)initWithButtonItemTitles:(NSArray *)buttonItemTitles;
- (instancetype)initWithFrame:(CGRect)frame buttonItemTitles:(NSArray *)buttonItemTitles;

- (void)addButtonItemWithTitle:(NSString *)title;
- (void)removeButtonItemWithTitle:(NSString *)title;
- (void)removeButtonItemWithIndex:(NSInteger)index;

- (void)replaceButtonItemTitle:(NSString *)title withIndex:(NSInteger)index;

- (NSString *)buttonItemTitleWithIndex:(NSInteger)index;
- (NSInteger)buttonItemIndexWithTitle:(NSString *)title;

- (void)showInView:(UIView *)view;
- (void)hide;

@end
